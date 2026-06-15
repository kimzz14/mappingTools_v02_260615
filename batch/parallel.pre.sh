############################################################################################
prefix=$1
parallelN=$2
############################################################################################
# ----------------------------
# Check arguments
# ----------------------------
if [ -z ${prefix} ]; then
    echo "prefix is empty."
    echo "bash ./batch/parallel.pre.sh run0001 24"
    exit 1
fi

if [ -z ${parallelN} ]; then
    echo "parallelN is empty."
    echo "bash ./batch/parallel.pre.sh run0001 24"
    exit 1
fi

# ----------------------------
# Set paths
# ----------------------------
inputFile="${prefix}.sh"
workDir="./jobs.${prefix}.parallel"
parallelScript="${prefix}.parallel.sh"

# Check if the folder exists and exit if it does
if [ -d "$workDir" ]; then
    echo "The folder already exists.: $workDir"
    exit 1
fi

mkdir -p "$workDir"
> "$parallelScript"

#create jobFile
lineCount=0
while IFS= read -r line; do
    if (( lineCount % parallelN == 0)); then
        jobID=$((lineCount / parallelN))
        jobFile="$workDir/job_${jobID}"
        > "$jobFile"
        echo "bash $jobFile" >> "$parallelScript"
    fi
    
    echo "$line &" >> "$jobFile"
    
    lineCount=$((lineCount + 1))
done < "$inputFile"

for jobFile in "$workDir"/job_*; do
    echo "wait" >> "$jobFile"
done

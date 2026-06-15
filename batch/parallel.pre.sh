prefix=$1
jobSize=$2

if [ -z ${prefix} ]; then
    echo "prefix is empty."
    echo "bash ./pipe/parallel.pre.sh run0001 24"
    exit 1
fi

if [ -z ${jobSize} ]; then
    echo "jobSize is empty."
    echo "bash ./pipe/parallel.pre.sh run0001 24"
    exit 1
fi

workDir="./jobs.${prefix}.parallel"

# Check if the folder exists and exit if it does
if [ -d "$workDir" ]; then
    echo "The folder already exists. Exiting the program."
    exit 1
fi

# Create working directories
mkdir -p "$workDir"

# Initialize the parallel execution script
parallelScript="${prefix}.parallel.sh"
> "$parallelScript"

# 입력 파일 줄 단위 처리
lineCount=0
jobID=0
while IFS= read -r line; do
    if (( lineCount % jobSize == 0)); then
        jobID=$((lineCount / jobSize))
        jobFile="$workDir/job_${jobID}"
        > "$jobFile"
        echo "bash ./batch/parallel.sh $prefix $jobID" >> "$parallelScript"
    fi
    echo "$line" >> "$jobFile"
    
    lineCount=$((lineCount + 1))
done < "${prefix}.sh"

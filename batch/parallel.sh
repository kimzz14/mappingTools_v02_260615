prefix=$1
jobID=$2

if [ -z ${prefix} ]; then
    echo "prefix is empty."
    echo "bash ./pipe/parallel.sh run0001 0"
    exit 1
fi

if [ -z ${jobID} ]; then
    echo "jobID is empty."
    echo "bash ./pipe/parallel.sh run0001 0"
    exit 1
fi


while IFS= read -r command; do
    $command &
done < "./jobs.${prefix}.parallel/job_$jobID"
wait

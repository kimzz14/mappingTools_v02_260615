#!/bin/bash

prefix=$1
if [ -z ${prefix} ]; then
    echo "prefix is empty."
    exit 1
fi

SLEEP_TIME=$(( RANDOM % 60 + 1 ))
echo "Sleeping for $SLEEP_TIME seconds..."
sleep "$SLEEP_TIME"

while true; do
    #get job_id
    job_id=$(bash batch/manager.sh ${prefix} --assign)

    if [ "$job_id" == "-1" ]; then
        echo "cmd is None. Breaking."
        break
    fi

    #get command
    command=$(bash batch/manager.sh ${prefix} --cmd ${job_id})

    #run command
    $command

    #mark done
    $(bash batch/manager.sh ${prefix} --done ${job_id})
done

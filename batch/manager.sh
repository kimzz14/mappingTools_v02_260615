#!/bin/bash

version='2.0.0'

PREFIX="$1"
ACTION="$2"
JOB_ID="$3"

COMMANDS_FILE="${PREFIX}.sh"

LOCKDIR="./jobs.${PREFIX}.lock"
STATUS_DIR="./jobs.${PREFIX}.status"
RUNNING_DIR="${STATUS_DIR}/running"
COMPLETE_DIR="${STATUS_DIR}/complete"

acquire_lock() {
    for i in $(seq 1 10000); do
        if mkdir "$LOCKDIR" 2>/dev/null; then return 0; fi
        sleep 2
    done
    return 1
}

release_lock() {
    rmdir "$LOCKDIR" 2>/dev/null
}

init_status_dir() {
    mkdir -p "$RUNNING_DIR" "$COMPLETE_DIR"
}

assign_job() {
    init_status_dir
    total_lines=$(wc -l < "$COMMANDS_FILE")
    for job_id in $(seq 0 $((total_lines - 1))); do
        if [ ! -f "$RUNNING_DIR/$job_id" ] && [ ! -f "$COMPLETE_DIR/$job_id" ]; then
            cmd=$(sed -n "$(($job_id + 1))p" "$COMMANDS_FILE")
            echo "$cmd" > "$RUNNING_DIR/$job_id"
            echo "["$(date "+%Y-%m-%d %H:%M:%S")"]" "$cmd" >> "${STATUS_DIR}/assign.log"

            echo $job_id
            return
        fi
    done
    echo -1
}

get_cmd() {
    init_status_dir

    cmd=$(sed -n "$(($JOB_ID + 1))p" "$COMMANDS_FILE")
    echo $cmd
}

mark_done() {
    init_status_dir
    if [ -f "$RUNNING_DIR/$JOB_ID" ]; then

        mv "$RUNNING_DIR/$JOB_ID" "$COMPLETE_DIR/$JOB_ID"
        echo "["$(date "+%Y-%m-%d %H:%M:%S")"]" "$(cat $COMPLETE_DIR/$JOB_ID)" >> "${STATUS_DIR}/complete.log"    
        echo "true"
    else
        echo "false"
    fi
}

clear_status() {
    rm -rf "$STATUS_DIR"
    release_lock
    echo "Cleaned $STATUS_DIR"
}

# Main execution
if [ "$#" -lt 2 ]; then
    echo "version: ${version}"
    echo "  Usage: $0 prefix [--assign |--cmd | --done ID | --clear]"
    exit 1
fi

case "$ACTION" in
    --assign)
        acquire_lock && assign_job && release_lock
        ;;
    --cmd)
        acquire_lock && get_cmd && release_lock
        ;;
    --done)
        if [ -z "$JOB_ID" ]; then echo "Missing job ID"; exit 1; fi
        acquire_lock && mark_done && release_lock
        ;;
    --clear)
        clear_status
        ;;
    *)
        echo "Unknown option: $ACTION"
        exit 1
        ;;
esac

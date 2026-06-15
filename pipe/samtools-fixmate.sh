############################################################################################
threadN=$1
readID=$2
fileExt=$3
############################################################################################
#check
if [ -z ${readID} ]; then
    echo "readID is empty."
    exit 1
fi

if [ -z ${threadN} ]; then
    echo "threadN is empty."
    exit 1
fi

if [ -z ${fileExt} ]; then
    echo "fileExt is empty."
    exit 1
fi

#set samtools
if [[ -x /s3/opt/bin/samtools ]]; then
    SAMTOOLS="/s3/opt/bin/samtools"
elif command -v samtools >/dev/null 2>&1; then
    SAMTOOLS="$(command -v samtools)"
else
    echo "ERROR: samtools not found." >&2
    exit 1
fi

#command
${SAMTOOLS} fixmate \
    --threads ${threadN} \
    -m \
    result/${readID}.${fileExt} \
    result/${readID}.fixmate.bam \
    1> result/${readID}.fixmate.bam.log \
    2> result/${readID}.fixmate.bam.err

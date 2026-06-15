############################################################################################
threadN=$1
readID=$2
fileExt=$3
############################################################################################
#check
if [ -z ${threadN} ]; then
    echo "threadN is empty."
    exit 1
fi

if [ -z ${readID} ]; then
    echo "readID is empty."
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
${SAMTOOLS} sort \
    --threads ${threadN} \
    -o result/${readID}.sorted.bam \
       result/${readID}.${fileExt} \
    1> result/${readID}.sorted.bam.log \
    2> result/${readID}.sorted.bam.err

bash pipe/samtools-index.sh ${threadN} ${readID}.sorted

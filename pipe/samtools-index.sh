############################################################################################
threadN=$1
readID=$2
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
${SAMTOOLS} index \
    --threads ${threadN} \
    -c  result/${readID}.bam \
    1>  result/${readID}.bam.csi.log \
    2>  result/${readID}.bam.csi.err

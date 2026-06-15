############################################################################################
threadN=$1
readDir=$2
readID=$3
tLen=$4 #mean, std, max, min #445,97,800,100
############################################################################################
#check
if [ -z ${threadN} ]; then
    echo "threadN is empty."
    exit 1
fi

if [ -z ${readDir} ]; then
    echo "readDir is empty."
    exit 1
fi

if [ -z ${readID} ]; then
    echo "readID is empty."
    exit 1
fi

if [ -z ${tLen} ]; then
    echo "tLen is empty."
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

bwa mem \
    -t ${threadN} \
    -I ${tLen} \
    db/bwaDB/ref.fa \
    ${readDir}/${readID}_1.fastq.gz \
    ${readDir}/${readID}_2.fastq.gz \
    2>  result/${readID}.bwa-memT003.bam.log \
    | ${SAMTOOLS} view --threads ${threadN} -bS \
    -o  result/${readID}.bwa-memT003.bam

bash pipe/samtools-flagstat.sh ${threadN} ${readID}.bwa-memT003 bam

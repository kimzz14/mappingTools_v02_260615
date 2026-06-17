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
mkdir -p result/${readID}.byChrom

${SAMTOOLS} view -@ ${threadN} -b -F 2 result/${readID}.bam > result/${readID}.byChrom/${readID}.unproperly.bam &
${SAMTOOLS} view -@ ${threadN} -b -f 4 result/${readID}.bam > result/${readID}.byChrom/${readID}.unmapped.bam &

#command
while read -r chrom chromLen rest; do
    ${SAMTOOLS} view -@ ${threadN} -b -F 2048 result/${readID}.bam ${chrom} > result/${readID}.byChrom/${readID}.${chrom}.bam &
done < "db/ref.fa.fai"
wait

while read -r chrom chromLen rest; do
    bash pipe/samtools-index.sh ${threadN} ${readID}.byChrom/${readID}.${chrom} bam &
done < "db/ref.fa.fai"
wait

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
while read -r chrom chromLen rest; do
    ${SAMTOOLS} depth -@ ${threadN} -a result/${readID}.byChrom/${readID}.${chrom}.bam -r ${chrom} | awk '$3 >=  1 {sum++} END {print sum}' > result/${readID}.byChrom/${readID}.${chrom}.depth_01 &
done < "db/ref.fa.fai"
wait

while read -r chrom chromLen rest; do
    ${SAMTOOLS} depth -@ ${threadN} -a result/${readID}.byChrom/${readID}.${chrom}.bam -r ${chrom} | awk '$3 >=  5 {sum++} END {print sum}' > result/${readID}.byChrom/${readID}.${chrom}.depth_05 &
done < "db/ref.fa.fai"
wait

while read -r chrom chromLen rest; do
    ${SAMTOOLS} depth -@ ${threadN} -a result/${readID}.byChrom/${readID}.${chrom}.bam -r ${chrom} | awk '$3 >= 10 {sum++} END {print sum}' > result/${readID}.byChrom/${readID}.${chrom}.depth_10 &
done < "db/ref.fa.fai"
wait

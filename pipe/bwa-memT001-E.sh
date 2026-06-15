############################################################################################
threadN=$1
readDir=$2
readID=$3
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

#command
bash pipe/bwa-memT001.sh      ${threadN} ${readDir} ${readID}
bash pipe/samtools-fixmate.sh ${threadN} ${readID}.bwa-memT001 bam
bash pipe/samtools-sort.sh    ${threadN} ${readID}.bwa-memT001.fixmate bam
bash pipe/samtools-split.sh   ${threadN} ${readID}.bwa-memT001.fixmate.sorted
bash pipe/samtools-depth.sh   ${threadN} ${readID}.bwa-memT001.fixmate.sorted

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


pbmm2 \
    align \
    --num-threads ${threadN} \
    --preset ISOSEQ \
    --sort \
    --bam-index CSI \
    db/pbmm2DB/ref.mmi \
    ${readDir}/${readID}.fastq.gz \
    result/${readID}.pbmm2-T111.bam \
    1> result/${readID}.pbmm2-T111.bam.log \
    2> result/${readID}.pbmm2-T111.bam.err

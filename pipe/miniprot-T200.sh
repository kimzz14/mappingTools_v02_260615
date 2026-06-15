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

miniprot \
    -t ${threadN} \
    --gff \
    -G 50000 \
    db/miniprotDB/ref.mpi \
    ${readDir}/${readID}.fa \
    1> result/${readID}.miniprot-T200.gff3 \
    2> result/${readID}.miniprot-T200.gff3.log

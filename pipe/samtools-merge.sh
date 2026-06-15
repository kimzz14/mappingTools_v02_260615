############################################################################################
threadN=24
ofile=test.N09
############################################################################################
#check
if [ -z ${threadN} ]; then
    echo "threadN is empty."
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

samtools merge \
    --threads ${threadN} \
    -o result/${ofile}.bam \
    result/in1.sam \
    result/in2.sam \
    result/in3.sam \
    result/in4.sam \
1>  result/${ofile}.log \
2>  result/${ofile}.err

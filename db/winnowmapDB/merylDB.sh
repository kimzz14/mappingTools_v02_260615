############################################################################################
threadN=24
############################################################################################

meryl count k=15 output merylDB ../ref.fa \
    1> merylDB.log \
    2> merylDB.err

meryl print greater-than distinct=0.9998 merylDB \
    1> repetitive_k15.txt \
    2> repetitive_k15.log

#winnowmap -t ${threadN} -W repetitive_k15.txt -k 15 -d ref.index ref.fa \
#    1> ref.index.log \
#    2> ref.index.err

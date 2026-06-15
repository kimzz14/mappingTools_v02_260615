threadN=128
readDir=/test
bash pipe/bwa-memT001.sh ${threadN} ${readDir} ${readID}
bash pipe/bwa-memT002.sh ${threadN} ${readDir} ${readID}
bash pipe/bwa-memT003.sh ${threadN} ${readDir} ${readID} 445,97,800,100 #mean,std,max,min
bash pipe/bwa-memT011.sh ${threadN} ${readDir} ${readID}
bash pipe/bwa-memT101.sh ${threadN} ${readDir} ${readID}
bash pipe/bwa-memT111.sh ${threadN} ${readDir} ${readID}
bash pipe/hisat2-T001.sh ${threadN} ${readDir} ${readID}

hisat2-build -p 128 ref.fa ref \
    1> hisat2-build.log \
    2> hisat2-build.err

#Build HFM index
#It takes about 20 minutes(depend on HW spec) to build index, and requires at least 6GB memory.
#$ hisat2-build -p 16 genome.fa genome
#
#Build HGFM index with SNPs
#$ hisat2-build -p 16 --snp genome.snp --haplotype genome.haplotype genome.fa genome_snp
#
#Build HGFM index with transcripts
#It takes about 1 hour(depend on HW spec) to build index, and requires at least 160GB memory.
#$ hisat2-build -p 16 --exon genome.exon --ss genome.ss genome.fa genome_tran
#
#Build HGFM index with SNPs and transcripts
#$ hisat2-build -p 16 --snp genome.snp --haplotype genome.haplotype --exon genome.exon --ss genome.ss genome.fa genome_snp_tran

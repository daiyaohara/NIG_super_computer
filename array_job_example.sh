#!/bin/zsh
#$ -S /bin/zsh
#$ -t 1-10:1
#$ -l s_vmem=16G -l mem_req=16G
#$ -pe def_slot 16
#$ -cwd

seq_libs=(SRR000001 SRR000002 SRR000003 SRR000004 SRR000005 SRR000006 SRR000007 SRR000008 SRR000009 SRR000010)
seq_lib=seq_libs[$SGE_TASK_ID]

# 1. remove adapter
cutadapt -a ACTTTTTCGG $seq_lib.fastq > $seq_lib.qc1.fastq

# 2. quality filetering
perl prinsesq-lite.pl --verbos -fastq $seq_lib.qc1.fastq -trim_qual_left 20 -trim_qual_right 20 -out_good $seq_lib.qc2

# 3. mapping
bowtie2 -x INDEX -U $seq_lib.qc2.fastq -S $seq_lib.sam

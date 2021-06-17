#!/bin/sh
#$ -l s_vmem=400G -l mem_req=400G
#$ -N FastPC

cd ~/20210613_INF_CD45
which singularity
/opt/pkg/singularity/3.7.1/bin/singularity exec ~/fastpg_latest.sif Rscript NIG_rds_to_FastPG.R 

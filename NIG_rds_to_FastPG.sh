#!/bin/sh
#$ -l s_vmem=64G -l mem_req=64G
#$ -N FastPC
#$ -l short
#$ -cwd

/opt/pkg/singularity/3.7.1/bin/singularity exec ~/fastpg_latest.sif Rscript NIG_rds_to_FastPG.R 

#!/bin/sh
#$ -l s_vmem=400G -l mem_req=400G
#$ -N Infinity_flow
#$ -cwd

/home/daiyaohara/miniconda3/envs/infinityflow/bin/Rscript 20210613_NIG_infinity_flow.R 

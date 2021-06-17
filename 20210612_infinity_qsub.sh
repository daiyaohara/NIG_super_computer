#!/bin/sh
#$ -l s_vmem=480G -l mem_req=480G
#$ -N Infinity_flow
#$ -cwd

/home/daiyaohara/miniconda3/envs/infinityflow/bin/Rscript 20210612_NIG_infinity_flow.R 

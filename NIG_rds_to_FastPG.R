library(Rcpp)
library(FastPG)

data = readRDS("predictions_bgc_cbound.Rds")
rownames(data) = c(1:dim(data)[1])
data2 = data[,!(colnames(data) %in% c("PE_id","UMAP1","UMAP2","FJComp-PE-A","FJComp-PI-A","FSC-A","SSC-A","Time"))] 
data2 = as.matrix(data2)
data3 = as.data.frame(data)
out = FastPG::fastCluster(data2,k=250,num_threads=12)
data3$out = factor(out$communities)
saveRDS(data3,file="FastPG_predictions_bgc_cbound.Rds")
library(Rcpp)
library(FastPG)
library(dplyr)
library(ggplot2)
library(psych)
library(data.table)

dir = file.path("/media/kondohlab/HDJA-UT/20210613_INF_Mac")
rds_path = file.path(dir,"tmp1/rds")
cat_file_path = file.path(dir,"output1/predicted_data_background_corrected.csv")
cat_res_file_path = file.path(dir,"output1/results.csv")


data = readRDS(file.path(rds_path,"predictions_bgc_cbound.Rds"))
rownames(data) = c(1:dim(data)[1])
data2 = data[,!(colnames(data) %in% c("PE_id","UMAP1","UMAP2","FJComp-PE-A","FJComp-PI-A","FSC-A","SSC-A","Time"))] 
data2 = as.matrix(data2)
data3 = as.data.frame(data)
out = FastPG::fastCluster(data2,k=250,num_threads=12)
data3$out = factor(out$communities)
saveRDS(data3,file="FastPG_predictions_bgc_cbound.Rds")

#data = readRDS("FastPG_predictions_bgc_cbound.Rds")
down_d = sample_n(tbl=d1, size=25000)

pdf("plot.pdf", width=7, height=7)
ggplot(down_d, aes(x=UMAP1, y=UMAP2, col=out)) + geom_point(size = 1)+theme_bw()
dev.off()

# make heatmap using predicted_bgc_geometric_mean
d1 = readRDS(file.path(rds_path,"FastPG_predictions_bgc_cbound.Rds"))
d2 = fread(cat_file_path)
d2$out = d1$out

data =  d2 %>%
        dplyr::group_by(out) %>%
        dplyr::summarize_each(funs(geometric.mean),ends_with(".XGBoost_bgc"))

data2 = data %>%
        dplyr::summarize_each(funs(scale),ends_with(".XGBoost_bgc")) %>%
        select_if(lapply(.,anyNA) %>% unlist %>% !.)

mat = as.matrix(data2)

# make heatmap using predicted gMFI
d1 = readRDS(file.path(rds_path,"FastPG_predictions_bgc_cbound.Rds"))
d2 = fread(cat_res_file_path) 
d2$out = d1$out

data =  d2 %>%
        dplyr::group_by(out) %>%
        dplyr::summarize_each(funs(geometric.mean),ends_with(".XGBoost"))

data2 = data %>%
        dplyr::summarize_each(funs(scale),ends_with(".XGBoost")) %>%
        select_if(lapply(.,anyNA) %>% unlist %>% !.)

mat = as.matrix(data2)
rownames(mat) <- paste0("s", 0:nrow(mat)-1)
heatmap(t(mat))
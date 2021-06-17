library(infinityFlow)
library(Rcpp)

dir = file.path("/home/daiyaohara/20210612_INF")
input_dir = file.path(dir,"fcs")
path_to_fcs = file.path(dir,"fcs")
path_to_output = file.path(dir,"output2")
backbone_selection_file <- file.path(dir, "backbone_selection_file.csv")
annotation = read.csv(file.path(dir,"infinity_annotation.txt"),row.names=1,stringsAsFactors=FALSE,sep="\t")
targets = annotation$Infinity_target
names(targets) = rownames(annotation)
isotypes = annotation$Infinity_isotype
names(isotypes) = rownames(annotation)

input_events_downsampling <- 4000
prediction_events_downsampling <- 4000
cores = 24L
path_to_intermediary_results <- file.path(dir, "tmp2")
extra_args_export = list(FCS_export = c("split", "concatenated", "csv"))
extra_args_correct_background = list(FCS_export = c("split", "concatenated", "csv"))

imputed_data = infinity_flow(
path_to_fcs = path_to_fcs,
path_to_output = path_to_output,
path_to_intermediary_results = path_to_intermediary_results,
backbone_selection_file = backbone_selection_file,
annotation = targets,
isotype = isotypes,
input_events_downsampling = input_events_downsampling,
prediction_events_downsampling = prediction_events_downsampling,
verbose = TRUE,
cores = cores, extra_args_export = extra_args_export,
extra_args_correct_background = extra_args_correct_background
)
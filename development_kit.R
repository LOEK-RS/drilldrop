# development kit
library(stringr)
library(tidyverse)





sonden = sf::st_read("~/luenten/projekte/2025_bodensonden/bodensonden.gpkg")



path <- "~/luenten/projekte/2025_bodensonden/S11_irrimax.csv"
path_raw = "~/luenten/projekte/2025_bodensonden/S11_17122024.csv"


startdatetime = "2024-11-20 00:00:00"
enddatetime = "2024-12-20 00:00:00"
excess = 10
organic = 7





### reading multiple probe files


probe_files = list.files("~/luenten/data_raw/drillanddrop/2025-04-15_probe_data", full.names = T, pattern = ".csv")

all_probes = lapply(probe_files, function(x){
  probe_read(x,
             startdatetime = "2024-11-20 00:00:00",
             enddatetime = "2025-03-20 00:00:00",
             excess = 10,
             organic = 10)
}
)




probe_read(probe_files[4],
           startdatetime = "2024-11-20 00:00:00",
           enddatetime = "2025-03-20 00:00:00",
           excess = 10,
           organic = 10,
           raw = TRUE)





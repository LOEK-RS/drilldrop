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







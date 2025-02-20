# codeschnippsel zum plotten

# Beispiel Sonde 11

library(stringr)
library(tidyverse)
source("R/probe_calibrate.R")
source("R/probe_read.R")



# Sonde laden (irrimax)
s11 = probe_read(path = "~/luenten/projekte/2025_bodensonden/S11_irrimax.csv",
                 startdatetime = "2024-11-20 00:00:00",
                 enddatetime = "2024-12-15 00:00:00",
                 excess = 10,
                 organic = 7)

# Sonde laden (feld)
s11_raw = probe_read(path = "~/luenten/projekte/2025_bodensonden/S11_17122024.csv",
                     startdatetime = "2024-11-20 00:00:00",
                     enddatetime = "2024-12-15 00:00:00",
                     excess = 10,
                     organic = 7,
                     raw = TRUE)







# kalibrieren der moisture werte
s11$value[s11$what == "moisture"] = probe_calibrate_moisture(values = s11$value[s11$what == "moisture"],
                                                             soiltexture = "sand")

s11_raw$value[s11_raw$what == "moisture"] = probe_calibrate_moisture(values = s11_raw$value[s11_raw$what == "moisture"],
                                                                     soiltexture = "sand")
# test if both are the same
table(s11$value == s11_raw$value)





ggplot(s11 |> filter(what == "temperature"), aes(x = Date.Time, y = value, group = depth, color = as.factor(depth)))+
  geom_line()



ggplot(s11 |> filter(what == "moisture"), aes(x = depth, y = value, group = depth, color = as.factor(depth)))+
  geom_violin()

ggplot(s11 |> filter(what == "moisture"), aes(y = depth, x = value, group = depth))+
  geom_violin()

data_wide = tidyr::pivot_wider(s11, id_cols = c("Date.Time", "depth", "organic"), names_from = "what", values_from = "value")

ggplot(data_wide, aes(x = temperature, y = moisture, color = as.factor(depth)))+
  geom_point()



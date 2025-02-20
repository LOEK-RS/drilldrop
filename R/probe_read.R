#' Read Probe Data
#'
#' @description Read Drill and Drop Soil Probe data
#'
#' @param path string, filepath to csv file
#' @param startdatetime string, format: "2024-11-20 00:00:00"
#' @param enddatetime string, format: "2024-11-20 00:00:00"
#' @param excess numeric, how far the probe sticks out
#' @param organic numeric, thickness of organic layer
#' @param raw logical, default FALSE, means data is from the Errimax Portal, if TRUE data is from probe directly
#'
#'
#' @author Maiken Baumberger, Marvin Ludwig
#'
#' @return data.frame of Drill and Drop data
#'
#'
#'
#'
#' @details depth starts at the surface and increments by 10. So a depth of 20 means
#'     the chunk between 10 and 20 cm below the surface. organic denotes how much of the chunk
#'     is considered organic layer, so 10 means the whole chunk is an organic layer.
#'
#'
#'
#'
#' @import stringr, dplyr, tidyr
#'
#' @export




probe_read_raw <- function(path){

  raw_data <- readLines(path)
  # find out start of data entries in the file
  data_start = which(raw_data == "ESReadings") + 1

  # turn data vector into data.frame
  data = read.table(text = raw_data[data_start:length(raw_data)],
                    header = TRUE, as.is = TRUE, sep  = ",")


  data = dplyr::select(data, !contains("Raw"))
  colnames(data) = c("Date.Time","V1","V2","A1.5.","T1.5.","A2.15.","T2.15.",
                     "A3.25.","T3.25.","A4.35.","T4.35.","A5.45.","T5.45.",
                     "A6.55.","T6.55.","A7.65.","T7.65.","A8.75.","T8.75.",
                     "A9.85.","T9.85.","A10.95.","T10.95.", "A11.105.","T11.105.",
                     "A12.115.","T12.115.")
  return(data)

}





probe_read <- function(path, startdatetime, enddatetime, excess, organic, raw = FALSE){


  if(raw == TRUE){

    raw_data <- readLines(path)
    # find out start of data entries in the file
    data_start = which(raw_data == "ESReadings") + 1

    # turn data vector into data.frame
    data = read.table(text = raw_data[data_start:length(raw_data)],
                      header = TRUE, as.is = TRUE, sep  = ",")


    data = dplyr::select(data, !contains("Raw"))
    colnames(data) = c("Date.Time","V1","V2","A1.5.","T1.5.","A2.15.","T2.15.",
                       "A3.25.","T3.25.","A4.35.","T4.35.","A5.45.","T5.45.",
                       "A6.55.","T6.55.","A7.65.","T7.65.","A8.75.","T8.75.",
                       "A9.85.","T9.85.","A10.95.","T10.95.", "A11.105.","T11.105.",
                       "A12.115.","T12.115.")



  }else{
    data <- read.csv(path)
  }






  data$Date.Time <- as.POSIXct(strptime(data$Date.Time, "%Y/%m/%d %H:%M:%S", tz="UTC"))
  data <- subset(data,
                 Date.Time >= as.POSIXct(startdatetime,"%Y-%m-%d %H:%M:%S",tz="UTC") &
                   Date.Time <= as.POSIXct(enddatetime,"%Y-%m-%d %H:%M:%S", tz="UTC"))

  # remove battery status
  data$V1 <- NULL
  data$V2 <- NULL





  data = tidyr::pivot_longer(data, cols = !contains("Date.Time"))

  data <- tidyr::separate_wider_delim(data, cols = "name", delim = ".", names = c("what", "depth", "remove"))
  data$remove <- NULL
  data$depth <- as.numeric(data$depth) + 5


  # remove excess depths and adjust soil depth
  data = data[data$depth > excess,]
  data$depth = data$depth - excess


  # TODO ---- calculate excess means for non 10 ----


  # organic depth ----
  organic_lut = data.frame(depth = unique(data$depth),
                           organic = 0)

  organic_lut$organic[organic_lut$depth < organic] <- 10

  # at first occurrence of 0, write the remaining organic depth
  organic_lut[which(organic_lut$organic == 0)[1],"organic"] <- organic - sum(organic_lut$organic)


  data = left_join(data, organic_lut)

  data$what <- ifelse(grepl("A", data$what), "moisture", "temperature")


  # convert missing values to NA
  data$value[data$what == "temperature" & data$value == (-1000)] <- NA
  data$value[data$what == "moisture" & data$value == (-1)] <- NA


  return(data)

}
















#' Calibrate soil moisture
#'
#' @details Adjust soil moisture based on soil texture
#'
#' @param values numeric, the soil moisture values, probably from probe_read
#' @param soiltexture string, one of "sand", "loam", "clay", "heavyclay", "combinedSentek" or "custom"
#' @param A_probe numeric, calibration value in the probe, see details
#' @param B_probe numeric, calibration value in the probe, see details
#' @param C_probe numeric, calibration value in the probe, see details
#' @param A_calib numeric, only needed if soiltexture = "custom"
#' @param B_calib numeric, only needed if soiltexture = "custom"
#' @param C_calib numeric, only needed if soiltexture = "custom"
#'
#' @author Maiken Baumberger, Marvin Ludwig
#'
#'
#'
#' @return numeric vector of calibrated soil moisture
#'
#' @export
#'
#'
#'






probe_calibrate_moisture <- function(values, soiltexture = "combinedSentek",
                                     A_probe = 0.1957, B_probe = 0.404, C_probe = 0.02852,
                                     A_calib = NA, B_calib = NA, C_calib = NA){


co <- data.frame(A = c(0.092, 0.446, 1.072, 0.003, 0.232, A_calib),
                 B = c(0.555, 0.271, 0.209, 1.487, 0.410, B_calib),
                 C = c(0.189, -0.227, -1.169, 0.270, -0.021, C_calib),
                 row.names = c("sand", "loam", "clay", "heavyclay", "combinedSentek", "custom"))


uncalibrate = A_probe * values^B_probe + C_probe

calibrated_values = (- (co[soiltexture, "C"] - uncalibrate) / co[soiltexture, "A"]  ) ^ (1/co[soiltexture, "B"])

return(calibrated_values)

}


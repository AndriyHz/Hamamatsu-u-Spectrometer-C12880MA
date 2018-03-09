#
# Reset environment
#
rm(list = ls())         # Remove environemnent variables
graphics.off()          # Close any open graphics

#
# Libraries
#
library(serial)
library(magrittr)
library(stringr)
#
# Script
#

con <- serialConnection(name = "test_con",
                        port = "COM4",
                        mode = "115200,n,8,1",
                        buffering = "none",
                        newline = 1,
                        translation = "cr")

#close(con)
isOpen(con)
open(con)
isOpen(con)

### grab data from serial port
stopTime <- Sys.time() + 2
foo <- ""
textSize <- 0
while(Sys.time() < stopTime)
{
  newText <- read.serialConnection(con)
  if(0 < nchar(newText))
  {
    foo <- paste(foo, newText)
  }
}

cat("\r\n", foo, "\r\n")
# generating the proper wavelength vector according to 
#the calibration fitting parameters provided by Hamamastu (look Wavelength Conversion Factor Data Sets Calibration Data S/N: .....
# https://groupgets.com/manufacturers/hamamatsu-photonics/products/c12880ma-micro-spectrometer
pix <- seq(1:289)
A_0 <-3.152446842e+2 
B_1 <-2.688494791 
B_2 <- -8.964262020e-4
B_3 <- -1.030880174e-5
B_4 <- 2.083514791e-8
B_5 <- -1.290505933e-11
nm <- A_0+B_1*pix+B_2*pix**2+B_3*pix**3+B_4*pix**4+B_5*pix**5

#temp <- read.serialConnection(con) %>%
temp <-  str_replace_all(foo, "[^[:digit:]]+", " ") %>%
  str_split(" ", simplify = TRUE) %>%
  as.numeric()
#plot(temp, xlab="Äîâæèíà õâèë³", ylab="²íòåíñèâí³ñòü", xlim=c(0, 300))
plot (nm, temp,  type = "l", xlab="Wavelength(nm)", ylab="adu", 
      pch = 16, cex =2, lwd =3,
      panel.first = grid(6, lty = 1, lwd = 1)
      )
close(con)

#
# Reset environment
#
rm(list = ls())         # Remove environemnent variables
graphics.off()          # Close any open graphics

#
# Libraries
#
library(serial)

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
#temp <- read.serialConnection(con) %>%
temp <-  str_replace_all(foo, "[^[:digit:]]+", " ") %>%
  str_split(" ", simplify = TRUE) %>%
  as.numeric()
plot(temp, xlab="������� ����", ylab="�������������", xlim=c(0, 300))

close(con)
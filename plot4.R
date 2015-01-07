# Download and extract file 
source <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest <- "household_power_consumption"

# Download and extact the file
if (!file.exists(paste(dest, ".txt", sep=""))) {
  zipFile = paste(dest, ".zip", sep="")
  download.file(source, dest, method = "curl")
  unzip(zipfile=dest, overwrite=TRUE)
  
  sink("downloaded_at.txt")
  cat(as.character(Sys.time()))
  sink()
}

library(data.table)

# Load file to data frame
data <- fread("grep ^[1,2].2.2007 household_power_consumption.txt", sep=";", data.table=F, header = F, na.strings = "?")
names(data) <- names(fread("household_power_consumption.txt", sep=";", data.table=F, header = T, nrows=0))
data$datetime <- strptime(paste(data$Date,data$Time), format="%d/%m/%Y %H:%M:%S") 
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

par(mfrow=c(2,2))

# Active Power
main <- "Global Active Power"
with(data, plot(datetime, Global_active_power, xlab="", ylab=main, type="n"))
with(data, lines(datetime, Global_active_power, type="l"))

# Voltage
with(data, plot(datetime, Voltage, type="n"))
with(data, lines(datetime, Voltage, type="l"))

# Sub metering
with(data, plot(datetime, Sub_metering_1, ylab="energy sub metering", xlab="", type="n"))
with(data, lines(datetime, Sub_metering_1, col="black"))
with(data, lines(datetime, Sub_metering_2, col="red"))
with(data, lines(datetime, Sub_metering_3, col="blue"))
legend("topright", pch="_", border = "none",
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Global active power
with(data, plot(datetime, Global_reactive_power, type="n"))
with(data, lines(datetime, Global_reactive_power, type="l"))

# Export
dev.copy(png, file = "plot4.png")
dev.off()

# Reset graphic device
par(mfrow=c(1,1))
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

main <- "Global Active Power"
hist(data$Global_active_power, main="Global Active Power", col="red", xlab=paste(main, "(kilowatts)"))

# Export
dev.copy(png, file = "plot1.png")
dev.off()

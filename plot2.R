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

# Graph
with(data, plot(datetime, Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="n"))
with(data, lines(data$datetime, data$Global_active_power, type="l"))

# Export
dev.copy(png, file = "plot2.png")
dev.off()

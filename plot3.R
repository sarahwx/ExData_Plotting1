setwd("./Workspace/xwu")

# download data into folder
if(!file.exists("./project4_1")){dir.create("./project4_1")}
fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./project4_1/exdata-data-household_power_consumption", method = "curl")

# unzip file
library(utils)
unzip ("./project4_1/exdata-data-household_power_consumption", exdir = "./project4_1")
setwd("./project4_1")

# calculate dataset memory requirement
library(pryr)
dataset = read.table("household_power_consumption.txt", sep = ";")
object_size(dataset)

# subset dataset to only 2007-02-01 and 2007-02-02
library(dplyr)
subset = filter(dataset, V1 == "1/2/2007" | V1 == "2/2/2007")

# change column names into understandable variable names
col_names = c()
for (i in 1:ncol(dataset)) {
  col_names = append(col_names, as.character(dataset[1,i]))
}
colnames(subset) = col_names

# convert Date and Time variables to Date/Time classes
date_time = c()
for (i in 1:nrow(subset)) {
  date_time[i] = paste(subset[i,1], subset[i,2])
}
date_time2 = strptime(date_time, "%d/%m/%Y %H:%M:%S")
subset2 = cbind(subset, date_time2)

# Plot 3
subset_plot3 = mutate(subset_plot3, Sub_metering_1 = as.numeric(levels(Sub_metering_1))[Sub_metering_1], 
                      Sub_metering_2 = as.numeric(levels(Sub_metering_2))[Sub_metering_2], 
                      Sub_metering_3 = as.numeric(levels(Sub_metering_3))[Sub_metering_3])
plot(date_time2, subset_plot3$Sub_metering_1, col = "black", xlab = "", ylab = "Energy sub metering", type = "l")
lines(date_time2, subset_plot3$Sub_metering_2, col = "red")
lines(date_time2, subset_plot3$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col = c("black", "red", "blue"))
dev.copy(png, file = "plot3.png")
dev.off()
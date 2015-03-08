## This program :
## 1. looks for source dir and file (must be already unzipped in current working directory)
## 2. subsets data based on desired dates range dates (Date >= "2007-02-01" &  Date <= "2007-02-02")
## 3. opens png device for write
## 4. multiple plots for Sub metering data (Yaxis) & DateTime(Xaxis) as png file
## 5. closes the device

library(data.table)

# set working directory
rootdir = getwd()
wdir <- paste(rootdir,
              "/exdata-data-household_power_consumption", sep="")

#fail if src dir missing
print("Searching dir... ")
print(wdir)
if(!file.exists(wdir)){  
  stop("Source Dir missing, Download the data, unzip in current working dir & retry.")
  
}else{
  #set working directory
  setwd(wdir)
  
  #fail if data is missing 
  #download data file
  powerdatafile = "household_power_consumption.txt"
  print("Searching file... ")
  print(powerdatafile)
  if(!file.exists(powerdatafile)){    
    stop("Source file missing. Download the data, unzip in current working dir & retry.")
    
  }else{
    
    #read house hold power data, subset data for dates 
    pdata <- read.csv(powerdatafile,sep=";", stringsAsFactors=FALSE,
                      header = TRUE,na.strings="?") #[66637:69516,]

    dt <- data.table(pdata)
    dt$Global_active_power <- as.numeric(dt$Global_active_power)
    dt[ , DateTime := paste(Date, Time, sep=" ")]
    dt$DateTime <- as.POSIXct(dt$DateTime, format = "%d/%m/%Y %H:%M:%S")
    
    dt$Date <- as.POSIXct(dt$Date, format = "%d/%m/%Y")
    dt <- dt[Date >= "2007-02-01" &  Date <= "2007-02-02"]
    #nrow(dt)
    
    #copy to png device
    png("plot4.png",width = 480, height = 480, units = "px", bg = "white")
    
    par(mfrow=c(2,2))
    
    #plot 1,1 (plot2)- global active power
    plot(dt$DateTime, dt$Global_active_power, 
         xaxt="n",  ylab="Global Active Power",xlab="",pch=".")
    lines(dt$DateTime, dt$Global_active_power)
    axis.POSIXct(1, dt$DateTime, format ="%a")
    
    #plot 1,2 - Voltage
    plot(dt$DateTime, dt$Voltage, 
         xaxt="n",  ylab="Voltage",xlab="datetime",pch=".")
    lines(dt$DateTime, dt$Voltage)
    axis.POSIXct(1, dt$DateTime, format ="%a")
    
    #plot 2,1 (plot3) sub meterting data
    #plot sub meter 1
    plot(dt$DateTime, dt$Sub_metering_1, xaxt="n",pch=".",
         xlab="", ylab="Energy sub metering",type="n",mar=c(1,2,0.5,0.5))
    
    #plot lines for submeter 1,2 and 3
    lines(dt$DateTime, dt$Sub_metering_1)
    lines(dt$DateTime, dt$Sub_metering_2, col="red")
    lines(dt$DateTime, dt$Sub_metering_3, col="blue")
    
    #set day lables for x axis
    axis.POSIXct(1, dt$DateTime, format ="%a")
    
    #add legend
    legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
           lty=1, col=c('black', 'red', 'blue'), bty='n', cex=.75)
    
    #plot 2,2 - Global_reactive_power
    plot(dt$DateTime, dt$Global_reactive_power, 
         xaxt="n",  ylab="Global_reactive_power",xlab="datetime",pch=".")
    lines(dt$DateTime, dt$Global_reactive_power)
    axis.POSIXct(1, dt$DateTime, format ="%a")
    
    
    #close the device
    dev.off()
  }
}
#return to root dir
setwd(rootdir)

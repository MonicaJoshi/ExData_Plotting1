## This program :
## 1. looks for source dir and file (must be already unzipped in current working directory)
## 2. subsets data based on desired dates range dates (Date >= "2007-02-01" &  Date <= "2007-02-02")
## 3. opens png device for write
## 4. multiple plots for Sub metering data (Yaxis) & DateTime(Xaxis) as png file
## 5. closes the device

library(data.table)

#  set working directory
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

      #convert date data
      dt <- data.table(pdata)
      dt$Global_active_power <- as.numeric(dt$Global_active_power)
      dt[ , DateTime := paste(Date, Time, sep=" ")]
      dt$DateTime <- as.POSIXct(dt$DateTime, format = "%d/%m/%Y %H:%M:%S")
      
      dt$Date <- as.POSIXct(dt$Date, format = "%d/%m/%Y")
      dt <- dt[Date >= "2007-02-01" &  Date <= "2007-02-02"]
      #nrow(dt)
    
      #copy to png
      png("plot3.png",width = 480, height = 480, units = "px", bg = "white")
      
      #set parameters for plotting
      par(mar=c(2,2,1, 0.5),oma=c(0,2,0,0))
      
      #plot sub meter 1
      plot(dt$DateTime, dt$Sub_metering_1, xaxt="n",pch=".",ycal="", xcal="")
      
      #plot lines for submeter 1,2 and 3
      lines(dt$DateTime, dt$Sub_metering_1)
      lines(dt$DateTime, dt$Sub_metering_2, col="red")
      lines(dt$DateTime, dt$Sub_metering_3, col="blue")
      
      #set day lables for x axis
      axis.POSIXct(1, dt$DateTime, format ="%a")
      
      #add legend
      legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
             lty=1, col=c('black', 'red', 'blue'), bty='y', cex=.75)
      
      #add yaix lable, to the outer margin
      mtext("Energy sub metering",side=2,outer=TRUE)
      
      #close the device
      dev.off()
  }
}
#return to root dir
setwd(rootdir)

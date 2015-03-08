## This program :
## 1. looks for source dir and file (must be already unzipped in current working directory)
## 2. subsets data based on desired dates range dates (Date >= "2007-02-01" &  Date <= "2007-02-02")
## 3. opens png device for write
## 4. plots graph for Global_active_power(Yaxis) & DateTime(Xaxis) as png file
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
      #nrow(pdata)
      
      #fix data format for date & Global_active_power
      dt <- data.table(pdata)
      dt[ , DateTime := paste(Date, Time, sep=" ")]
      dt$DateTime <- as.POSIXct(dt$DateTime, format = "%d/%m/%Y %H:%M:%S")
      dt$Global_active_power <- as.numeric(dt$Global_active_power)
      
      dt$Date <- as.POSIXct(dt$Date, format = "%d/%m/%Y")
      dt <- dt[Date >= "2007-02-01" &  Date <= "2007-02-02"]
      #nrow(dt)
      
      #copy to png device
      png("plot2.png")
      
      #plot data
      plot(dt$DateTime, dt$Global_active_power, 
           xaxt="n",  ylab="Global Active Power (Kilowatts)",xlab="",pch=".")
      lines(dt$DateTime, dt$Global_active_power)
      axis.POSIXct(1, dt$DateTime, format ="%a")
      
      #close the device
      dev.off()
  }
}
#return to root dir
setwd(rootdir)
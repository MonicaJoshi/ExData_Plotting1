## This program sets the working director
## 1. looks for source dir and file (must be already unzipped in current working directory)
## 2. subsets data based on manual inspection of records that contain suitable dates
##    which are rows ([66637:69516,], after na/? removal) for Date range between "2007-02-01"& "2007-02-02"
## 3. opens png device for write
## 4. plots a historgram for Global_active_power as png file
## 5. closes the device

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
    
    #read house hold power data
    #manual evaulation of date was done & suitable rows were selected
    pdata <- read.csv(powerdatafile,sep=";", stringsAsFactors=FALSE, 
                      header = TRUE,na.strings="?") [66637:69516,]
    
    pdata$Global_active_power <- as.numeric(pdata$Global_active_power)
    #nrow(pdata)
    
    #copy to png device
    png("plot1.png",width = 480, height = 480, units = "px", bg = "white")
    
    #plot1
    hist(pdata$Global_active_power, xlab="Global Active Power (Kilowatts)", 
    col ="red", main="Global Active Power")
    
    
    #close the device
    dev.off()
  }
}
#return to root dir
setwd(rootdir)
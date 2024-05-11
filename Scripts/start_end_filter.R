##################################################
#Working with deer metadata
#to subset the gps points based on 
# the meta start and end dates for the collars
#################################################

start_end_filter = function(gps.data, meta){

  collars.need = unique(gps.data$ID)
  
  meta.collars = subset(meta, Collar.ID %in% collars.need)
  meta.collars.small = meta.collars[, c(19,10:11,17:18)]
  
  gps.data.subset = NULL
  
  for(i in 1:length(collars.need)){
    
    collar.start = meta.collars.small$Collar_start[which(meta.collars.small$Collar.ID == collars.need[i])]
    collar.end = meta.collars.small$Fate_date[which(meta.collars.small$Collar.ID == collars.need[i])]
    
    collar.start.date = as.POSIXct(collar.start, format="%m/%d/%Y", tz="America/Chicago") 
    collar.end.date = as.POSIXct(collar.end, format="%m/%d/%Y", tz="America/Chicago") 
    
    collar.start.datetime = strptime(paste(collar.start.date, "00:00:01"),format="%Y-%m-%d %H:%M:%S",tz = "America/Chicago") + days(1)
    collar.end.datetime = strptime(paste(collar.end.date, "23:59:59"),format="%Y-%m-%d %H:%M:%S",tz = "America/Chicago") + days(-1)
    
    collar.gps.data = subset(gps.data, ID == collars.need[i])
    
    gps.data.subset.temp = subset(collar.gps.data, DateTime >= collar.start.datetime & DateTime <= collar.end.datetime)
    
    gps.data.subset = rbind(gps.data.subset, gps.data.subset.temp)
    print(collars.need[i])
    print(collar.start.datetime)
    print(min(gps.data.subset.temp$DateTime))
    print(collar.end.datetime)
    print(max(gps.data.subset.temp$DateTime))
  } #end for loop

  return(gps.data.subset)
} #end function

setwd("C:/Users/SIU856560341/Desktop/GPS_Analysis/GPS")

meta = read.csv("SWEL_Deer_Meta.csv", header = TRUE)
gps.data = read.csv("allgpsdata_small.csv")


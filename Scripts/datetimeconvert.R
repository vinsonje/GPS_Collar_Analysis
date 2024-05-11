datetime_convert = function(allgpsdata.test, writecsv = FALSE){
  
for(i in 1:dim(allgpsdata.test)[1]){
  
  print(paste0(i, " in ", dim(allgpsdata.test)[1], " ", round(i/dim(allgpsdata.test)[1], 3)*100, "%"))
  allgpsdata.test$date[i] = paste0("20", allgpsdata.test$date[i])
}

allgpsdata.test$date = as.Date(allgpsdata.test$date, "%Y/%m/%d")


datetime = as.POSIXct(paste(allgpsdata.test$date, allgpsdata.test$time), tz = "UTC", format = "%Y-%m-%d %H:%M:%S")


allgpsdata.small = data.frame(
  ID = allgpsdata.test$collar.id,
  X = allgpsdata.test$long,
  Y = allgpsdata.test$lat,
  DateTime = datetime
)

if(writecsv == TRUE){
write.csv(allgpsdata.small, "allgpsdata_small.csv", row.names=FALSE, quote=FALSE)
}

return(allgpsdata.small)
}


# # 
# setwd("F:/GPS")
# allgpsdata.test = read.csv("allgpsdata_filtered.csv", header = TRUE)
# 
# datetime_convert.test = datetime_convert(allgpsdata.test, writecsv = TRUE)
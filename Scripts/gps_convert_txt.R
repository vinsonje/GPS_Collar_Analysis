##########################################
#Convert .txt files to .csv 
##########################################
require(stringr)

setwd("F:/GPS/Converted Text Files") #this sets it for the specific folder that is on the harddrive

all.files = list.files(path = getwd(), all.files = T, recursive = T) #get all the files in the folder

all.files.txt = all.files[str_detect(all.files, ".txt")] #subset the .lbc files; used for extracting the right DateTime metadata

all.gps.data = NULL
all.gps.data.raw = NULL

for(i in 1:length(all.files.txt)){

setwd("F:/GPS/Converted Text Files")
  
tab = read.table(all.files.txt[i], comment="", header=TRUE, fill = TRUE)

collar.id =  unlist(strsplit(all.files.txt[i], split = " "))[2]

print(collar.id)
#save the unedited file, a simple conversion to a .csv
single.file.name.raw = paste(collar.id, "gpsdata", "raw", sep = "_")
single.file.name.raw = paste0(single.file.name.raw, ".csv") #add file time extension

setwd("F:/GPS/CSV Files/Raw Unfiltered")

write.csv(tab, single.file.name.raw, row.names=FALSE, quote=FALSE)

tab.raw = cbind(collar.id = rep(collar.id, dim(tab)[1]), tab)
all.gps.data.raw = rbind(all.gps.data.raw, tab.raw)

#filter
rm.unvalid = which(tab$Status!="Valid")
tab2 = tab[-rm.unvalid,] 
tab3 = tab2[,c(6, 7, 9, 10, 11)]
names(tab3) = c("date", "time", "lat", "long", "alt")

tab4 = cbind(collar.id = rep(collar.id, dim(tab3)[1]), tab3)

single.file.name = paste(collar.id, "gpsdata", "filtered", sep = "_")
single.file.name = paste0(single.file.name, ".csv") #add file time extension

setwd("F:/GPS/CSV Files/Filtered")

write.csv(tab, single.file.name, row.names=FALSE, quote=FALSE)

all.gps.data = rbind(all.gps.data, tab4)
}


#cam 991, problem where it wasn't the same as the others
print("150991, special")
setwd("F:/GPS/CSV Files/Raw Unfiltered")
c991 = read.csv("150991_gpsdata_raw.csv")
c991.time = unlist(strsplit(c991$GMT.Time, split = " "))[seq(2,dim(c991)[1]*2, by =2)]
c991.date = unlist(strsplit(c991$GMT.Time, split = " "))[seq(1,dim(c991)[1]*2, by =2)]
c991.date = as.Date(c991.date, format = "%m/%d/%Y")
c991.date = format(c991.date, format = "%Y/%m/%d")

c991.data = data.frame(collar.id = 150991, date = c991.date, time = c991.time, lat = c991$Latitude, long = c991$Longitude, alt = c991$Altitude)

all.gps.data = rbind(all.gps.data, c991.data)

setwd("F:/GPS")
write.csv(all.gps.data, "allgpsdata_filtered.csv", row.names=FALSE, quote=FALSE)
write.csv(all.gps.data.raw, "allgpsdata_raw.csv", row.names = FALSE, quote = FALSE)
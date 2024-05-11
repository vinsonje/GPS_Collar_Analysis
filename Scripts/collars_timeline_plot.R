require(vistime)

setwd("F:/GPS")

alldata = read.csv("allgpsdata_filtered.csv")

collar.ids = unique(alldata$collar.id)

min.date = NULL
max.date = NULL

for(i in 1:length(collar.ids)){
  
  collar.sub = subset(alldata, collar.id == collar.ids[i])
  min.date = append(min.date, as.Date(paste0("20", min(collar.sub$date))))
  max.date = append(max.date, as.Date(paste0("20", max(collar.sub$date))))
  
}

collar.dates = data.frame(collar.id = collar.ids, start = min.date, end = max.date)

gg_vistime(collar.dates, col.event = "collar.id", col.group = "collar.id") + theme_cowplot()

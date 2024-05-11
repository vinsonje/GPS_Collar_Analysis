library(FedData)
library(rasterVis)
library(raster)
library(sp)
library(sf)
library(terra)
library(reshape2)
library(treemapify)
library(ggplot2)
library(kableExtra)
library(animation)
library(scales)
library(ggspatial)
library(scales)
library(tidyr)
library(ggplot2)
library(cowplot)
library(gganimate)


setwd("F:/GPS") #PC
# setwd("~/Desktop/GPS_Analysis/GPS") #MAC

allgpsdata = read.csv("allgpsdata_small.csv", header = TRUE)

#carbondale
ymin = 37.6 #bottom left
ymax = 37.7 #top right
xmax = -89.1 # top right
xmin = -89.2 #bottom left

test.extract = extract_NLCD(xmin, xmax, ymin, ymax)

outside.ymax = which(allgpsdata$Y>ymax)
outside.ymin = which(allgpsdata$Y<ymin)

outside.xmin = which(allgpsdata$X<xmin)
outside.xmax = which(allgpsdata$X>xmax)

all.outside = union(outside.xmax, outside.xmin)
all.outside = union(all.outside, outside.ymax)
all.outside = union(all.outside, outside.ymin)

allgpsdata.inrange = allgpsdata[-all.outside,]

allgpsdata.sub = subset(allgpsdata.inrange, ID %in% c("150973"))
sf_gps_sub = st_as_sf(allgpsdata.sub, coords=c("X", "Y"), crs=crs("+init=epsg:4326"))
sf_gps_sub = st_transform(sf_gps_sub, st_crs(test.extract[[1]]))

map.data = test.extract[[3]] + geom_sf(data = sf_gps_sub) + facet_grid(~ID) + theme(legend.position = "none")

map_with_animation = map.data +
  transition_time(as.POSIXct(DateTime))+
  ease_aes('linear')+
  ggtitle("DateTime: {frame_along}")

# animate(map_with_animation, nframes = 365, fps = 10)

sf_gps_inrange = st_as_sf(allgpsdata.inrange, coords=c("X", "Y"), crs=crs("+init=epsg:4326"))
sf_gps_inrange = st_transform(sf_gps_inrange, st_crs(test.extract[[1]]))

map.all.collars = test.extract[[3]] + geom_sf(data = sf_gps_inrange) + facet_wrap(~ID, nrow=4) + 
  theme(legend.position = "none", axis.text.x = element_text(angle = 90, vjust=0.5, size = 10), 
        axis.text.y = element_text(size = 10))
map.all.collars

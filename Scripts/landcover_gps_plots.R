########################################
#Landscape movement plots
########################################

# install.packages(c("FedData", "rasterVis", "raster","sp", "terra", "reshape2", "treemapify", "ggplot2", "kableExtra", "animation", "scales"))
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

setwd("F:/GPS")
allgpsdata = read.csv("allgpsdata_filtered.csv", header = TRUE)

setwd("C:/Users/SIU856560341/Desktop/landcover")

r <- raster("NLCD_2021.tiff")

r


ext <- extent(734666.5, 795961.6, 4017870, 4053632)

extent <- polygon_from_extent(raster::extent(ext), proj4string="+proj=utm +datum=NAD83 +zone=16N")

WMAtc <- get_nlcd(template = polygon_from_extent(ext, (proj4string = "+proj=utm +zone=16N ellps+NAD83")),year = 2016, dataset = "Tree_Canopy", label = "Can")

WMAtc_projected <- projectRaster(WMAtc, crs = "+proj=utm +zone=16N +datum=NAD83")

tc_df <- as.data.frame(WMAtc_projected, xy=TRUE)


legend <- pal_nlcd()
legend

vals<-unique(r.df$layer)
df<-legend[legend$ID %in% vals,]


r.pts <- rasterToPoints(r, spatial=TRUE)

r.df <- sampleRegular(r, 
                     size = 5e5, 
                     asRaster = TRUE) %>% 
  as.data.frame(xy = TRUE, 
                na.rm = TRUE) %>% 
  setNames(c("x", 
             "y", 
             "layer"))

sf_gps<-st_as_sf(allgpsdata, coords=c("long", "lat"), crs=crs("+init=epsg:4326"))
sf_gps<-st_transform(sf_gps, st_crs(r))

ggplot(data = r.df) + geom_raster(aes(x = x, y = y, fill = as.factor(layer))) +
  scale_fill_manual(values = legend$Color, limits = as.factor(legend$ID), labels = as.factor(legend$Class)) +
  labs(x = "Longitude", 
       y = "Latitude", 
       fill = "Landcover") + theme(legend.position = "bottom") +
  coord_sf() + facet_wrap(~collar.id) +
  theme_cowplot() +
  xlim(590000,605000) + ylim(1635000, 1655000) +
  geom_sf(data = sf_gps)



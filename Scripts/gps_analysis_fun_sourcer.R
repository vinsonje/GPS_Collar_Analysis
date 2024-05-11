####################################################
#GPS analysis function sourcer
#Script to load in all libraries and functions
####################################################

#all the packages that need to be loaded in
library(lubridate)
library(geosphere)
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

#source all the functions
source(paste(getwd(), "/extract_NLCD.R", sep = ''))
source(paste(getwd(), "/velocity_filter.R", sep = ''))
source(paste(getwd(), "/start_end_filter.R", sep = ''))
source(paste(getwd(), "/location_filter.R", sep = ''))
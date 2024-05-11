###########################################
#Cleaning data
###########################################

rm(list = ls())

source(paste(getwd(), "/gps_analysis_fun_sourcer.R", sep = ''))

# setwd("F:/GPS") #PC
setwd("C:/Users/SIU856560341/Desktop/GPS_Analysis/GPS")
# setwd("~/Desktop/GPS_Analysis/GPS") #MAC

allgpsdata = read.csv("allgpsdata_small.csv", header = TRUE)
meta = read.csv("SWEL_Deer_Meta.csv", header = TRUE)

#########################
#Location boundary filter
#########################

#carbondale
ymin = 37.6 #bottom left
ymax = 37.7 #top right
xmax = -89.1 # top right
xmin = -89.2 #bottom left

gpsdata.clean = location_filter(allgpsdata, xmin, xmax, ymin, ymax)

##########################
#Start-End time filter
##########################
gpsdata.clean = start_end_filter(gpsdata.clean, meta)

###########################
#Velocity filter
###########################
gpsdata.clean = velocity_filter(gpsdata.clean, vel.con = 50, output = "no vel")

write.csv(gpsdata.clean, "gpsdata_clean.csv", row.names = FALSE)




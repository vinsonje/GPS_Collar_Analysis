##################################################
#Function to extract the NLCD data given bounds
#of long and lats
#################################################

# Function to replace 'polygon_from_extent()'
my_polygon_from_extent <- function(x, my_crs){
  x <- FedData:::template_to_sf(x)
  sf::st_crs(x)<-my_crs
  x <- sf:::st_bbox(x)
  x <- sf:::st_as_sfc(x)
  return(x)
}

extract_NLCD = function(xmin, xmax, ymin, ymax, crs = 4326, datatype = "landcover", label = "extract_NLCD", year = 2021){

out.nlcd = vector(mode = "list", length = 3)
  
#create a polygon (rectangle) with 
dat = st_bbox(c(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), crs = st_crs(crs))

my_extent = raster::extent(
  as.numeric(
    sf::st_bbox(dat)[c("xmin","xmax","ymin","ymax")]
  )
)

my.polygon = my_polygon_from_extent(my_extent, crs)

my.nlcd = get_nlcd(template = my.polygon, label = label, year = year, dataset = datatype, force.redo = TRUE)

my.nlcd.df = as.data.frame(my.nlcd, xy = TRUE)


legend <- pal_nlcd()

vals = unique(my.nlcd.df$Class)
df = legend[legend$Class %in% as.vector(vals),]

my.nlcd.plot = ggplot(data = my.nlcd.df) + geom_raster(aes(x = x, y = y, fill = as.factor(Class))) +
              scale_fill_manual(values = df$Color, limits = as.factor(df$Class), labels = as.factor(df$Class)) +
              labs(x = "Longitude", 
                   y = "Latitude", 
                   fill = datatype) +
              theme_cowplot() + theme(legend.position = "bottom")

out.nlcd[[1]] = my.nlcd
out.nlcd[[2]] = my.nlcd.df
out.nlcd[[3]] = my.nlcd.plot

return(out.nlcd)
}

##########
#Test
##########

# #lexington
# ymin = 33.677478 #bottom left
# ymax = 34.119789 #top right
# xmax = -80.844693 # top right
# xmin = -81.674436 #bottom left

# #carbondale
# ymin = 37.551335 #bottom left
# ymax = 37.765837 #top right
# xmax = -88.952550 # top right
# xmin = -89.306503 #bottom left
# 
# test.extract = extract_NLCD(xmin, xmax, ymin, ymax)
# 
# test.extract[[3]]

#fort bend
# ymin =  29.268105 #top right, latitude
# ymax =  29.788582 #bottom left, latitude
# xmax = -95.368356 #top right, longitude
# xmin = -96.111219 #bottom left, longitude
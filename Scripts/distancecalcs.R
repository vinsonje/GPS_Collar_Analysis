#####################
#Distance Calculations
######################
library(geosphere)

disgps = allgpsdata.small

disgps.sub = disgps[which(disgps$ID == 150973),]

dist.vec = NA

for(i in 1:(dim(disgps.sub)[1]-1)){

dist.temp = distm(disgps.sub[i,2:3], disgps.sub[i+1,2:3], fun = distHaversine)

dist.vec = append(dist.vec, dist.temp)
}

hist(dist.vec, breaks = 1000)

sub.look = disgps.sub[6097:6100,]

sub.look.sf = st_as_sf(sub.look, coords=c("X", "Y"), crs=crs("+init=epsg:4326"))
sub.look.sf = st_transform(sub.look.sf, st_crs(test.extract[[1]]))


test.extract[[3]] + geom_sf(data = sub.look.sf) + theme(legend.position = "none")

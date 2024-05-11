##################################################
#Working with deer metadata
#to subset the gps points based on 
# the meta start and end dates for the collars
#################################################
#gps.data = dataframe with X Y long lat gps locations, DateTime
#vel.con = upper limit condition for velocity
#units = the units you want the time to be in (default is mins)
#output = do you want the filtered dataframe to include 
#the time, dist and vel calculations ("vel"),
#or not ("no vel"),
# or the default of both as a list ("both")
###################################################################

velocity_filter = function(gps.data, vel.con = 9999, units = "mins", output = "both"){

gps.data$DateTime = strptime(gps.data$DateTime,format="%Y-%m-%d %H:%M:%S",tz = "America/Chicago")

gps.out.full = NULL

collars.need = unique(gps.data$ID)

for(j in 1:length(collars.need)){
  # print(collars.need[j])
  disgps.sub = subset(gps.data, ID == collars.need[j])
  
  dist.vec = NA
  time.vec = NA
  
for(i in 1:(dim(disgps.sub)[1]-1)){
  # print(i)
  dist.temp = distm(disgps.sub[i,2:3], disgps.sub[i+1,2:3], fun = distHaversine)
  
  dist.vec = append(dist.vec, dist.temp)
  
  time.temp = as.numeric(difftime(disgps.sub$DateTime[i+1], disgps.sub$DateTime[i], units = units))
  
  time.vec = append(time.vec, time.temp)
} #end subset collar for loop

dis.gps.new = cbind(disgps.sub, dist = dist.vec, time = time.vec, vel = dist.vec/time.vec)

gps.out = subset(dis.gps.new, vel < vel.con)

gps.out.full = rbind(gps.out.full, gps.out)

} #end all collar for loop

if(output == "no vel"){return(gps.out.full[,1:4])}

if(output == "vel"){return(gps.out.full)}

if(output == "both"){return(list(gps.out.full, gps.out.full[,1:4]))}
}

##############
#Test
##############
# test.vel.fil = velocity_filter(gps.data, vel.con = 600, output = "vel")

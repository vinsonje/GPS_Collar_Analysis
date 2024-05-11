###############################
#CTMM testing
###############################

library(move)
library(ctmm)
library(sf)
library(lubridate)
library(ggplot2)
library(cowplot)

setwd("C:/Users/SIU856560341/Desktop/GPS_Analysis/GPS")

allgpsdata = read.csv("gpsdata_clean.csv")

gpsdata.sub = allgpsdata
# gpsdata.sub = subset(allgpsdata, ID == "150982")
gpsdata.sub$DateTime = as.POSIXct(gpsdata.sub$DateTime, tz = "UTC", format = "%Y-%m-%d %H:%M:%S")

collar.start.datetime = strptime(paste("2023-04-01", "00:00:01"),format="%Y-%m-%d %H:%M:%S",tz = "America/Chicago") + days(1)
collar.end.datetime = strptime(paste("2023-04-30", "23:59:59"),format="%Y-%m-%d %H:%M:%S",tz = "America/Chicago") + days(-1)
gpsdata.sub = subset(gpsdata.sub, DateTime >= collar.start.datetime & DateTime <= collar.end.datetime)

sub.move = move(x=gpsdata.sub$X, y=gpsdata.sub$Y, 
            time=as.POSIXct(gpsdata.sub$DateTime, tz = "UTC", format = "%Y-%m-%d %H:%M:%S"), 
            data=gpsdata.sub, proj=CRS("+proj=longlat +ellps=WGS84"), 
            animal=gpsdata.sub$ID, sensor="GPS")


sub.move.tele  = as.telemetry(sub.move)

for(i in 1:length(sub.move.tele)){
data.use = sub.move.tele[[i]]
var = variogram(data.use)
plot(var, main = names(sub.move.tele)[i])
var.fit = variogram.fit(var)
}

#Fitting movement model 

akde.out = list()
mm.out = list()

for(i in 1:length(sub.move.tele)){
print(i)
sub = sub.move.tele[[i]]
guess = ctmm.guess(sub, interactive=F)
mov.model = ctmm.select(sub, guess)
summary(mov.model)
mm.out[[i]] = mov.model

wAKDE = akde(sub, mov.model, weights=T)
akde.out[[i]] = wAKDE #Saving AKDE into the list 
}

ext = extent(akde.out)

plot(akde.out[[1]], xlim = ext$x, ylim = ext$y, col.grid = NA)
for(i in 2:length(akde.out)){
  plot(akde.out[[i]], add = T, col.grid = NA, col.DF = rainbow(length(akde.out))[i])
}


pred.out = list()
pred.df = NULL
for(i in 1:length(sub.move.tele)){
  print(i)
sub.move.data = sub.move.tele[[i]]
# Predict 5 minute intervals (60*5 seconds)
mint = min(sub.move.data$t)
maxt = max(sub.move.data$t)

interp_vals = seq(mint, maxt, by=60*5)

ind = (interp_vals >= mint) & (interp_vals <= maxt)
newt = interp_vals[ind]

pred = predict(mm.out[[i]], data=sub.move.data, t=newt)
pred.temp = data.frame(t = pred$t, x = pred$x, y = pred$y, ID = names(sub.move.tele)[i])
pred.out[[i]] = pred
pred.df = rbind(pred.df, pred.temp)

ggplot() + geom_path(data = pred, aes(x = x, y = y, color = t)) + 
  geom_point(data = sub.move.data, aes(x = x,  y = y, color = t))
}


ggplot() + geom_path(data = pred.df, aes(x=x, y = y, color=ID)) + theme_cowplot()

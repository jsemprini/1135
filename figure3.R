library(dplyr)

yearmeans <- table3_reg %>%
  group_by(Year) %>%
  summarise_at(vars(-abbr), funs(mean(., na.rm=TRUE)))

statemeans <- table3_reg %>%
  group_by(abbr) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

situationmeans <- table3_reg %>%
  group_by(Situation) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

disastermeans <- table3_reg2 %>%
  group_by(Situation_1) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

write.table(disastermeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/dis.txt", sep="\t")
write.table(situationmeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/sit.txt", sep="\t")
write.table(statemeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/state.txt", sep="\t")
write.table(yearmeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/year.txt", sep="\t")



library(usmap)
library(ggplot2)
library(maptools)



data <- statepop

data$pop_2015 <- NULL

waivers <- merge(data, table3_map, by="abbr", all.x=TRUE)

plot_usmap(data = waivers, values = "status", color = "black") + facet_wrap(~ Year)



plot_usmap(data = waivers, values = "status", color = "black") 

ggplot(subdata, aes(x = x, y = y, colour = fCategory)) +       
  geom_point() + 
  scale_colour_discrete(drop=TRUE,
                        limits = levels(dataset$fCategory))



wav1 <- subset(table3_map, Year<=2012)
wav2 <- subset(table3_map, Year==2017)
wav3 <- subset(table3_map, Year==2018)
wav4 <- subset(table3_map, Year==2019)
scale_colour_manual(name = "grp",values = myColors)
#One plot with all the data
p <- ggplot(dat,aes(x,y,colour = grp)) + geom_point()
p1 <- p + colScale

#A second plot with only four of the levels
p2 <- p %+% droplevels(subset(dat[4:10,])) + colScale




















wav08 <- subset(table3_map, Year==2008)
wav09 <- subset(table3_map, Year==2009)
wav11 <- subset(table3_map, Year==2011)
wav12 <- subset(table3_map, Year==2012)
wav17 <- subset(table3_map, Year==2017)
wav18 <- subset(table3_map, Year==2018)
wav19 <- subset(table3_map, Year==2019)


waivers08 <- merge(data, wav08, by="abbr", all.x=TRUE)
waivers09 <- merge(data, wav09, by="abbr", all.x=TRUE)
waivers11 <- merge(data, wav11, by="abbr", all.x=TRUE)
waivers12 <- merge(data, wav12, by="abbr", all.x=TRUE)
waivers17 <- merge(data, wav17, by="abbr", all.x=TRUE)
waivers18 <- merge(data, wav18, by="abbr", all.x=TRUE)
waivers19 <- merge(data, wav19, by="abbr", all.x=TRUE)


plot_usmap(data = waivers08, values = "N-1812", color = "black")
plot_usmap(data = waivers09, values = "N-1812", color = "black")
plot_usmap(data = waivers11, values = "N-1812", color = "black")
plot_usmap(data = waivers12, values = "N-1812", color = "black")
plot_usmap(data = waivers17, values = "N-1812", color = "black")
plot_usmap(data = waivers18, values = "N-1812", color = "black")
plot_usmap(data = waivers19, values = "N-1812", color = "black")

#create faceted maps


wav1 <- subset(table3_map, Year<=2012)
wav2 <- subset(table3_map, Year==2017)
wav3 <- subset(table3_map, Year==2018)
wav4 <- subset(table3_map, Year==2019)


waivers1 <- merge(data, wav1, by="abbr", all.x=TRUE)
waivers2 <- merge(data, wav2, by="abbr", all.x=TRUE)
waivers3 <- merge(data, wav3, by="abbr", all.x=TRUE)
waivers4 <- merge(data, wav4, by="abbr", all.x=TRUE)





plot_usmap(data = subset(), values = "status", color = "black")

ggplot(subdata, aes(x = x, y = y, colour = fCategory)) +       
  geom_point() + 
  scale_colour_discrete(drop=TRUE,
                        limits = levels(dataset$fCategory))








map2012 <- plot_usmap(data = waivers1, values = "status", color = "black")+
  geom_point(data = cap1, aes(x = lon.1, y = lat.1, size = expandcap),
             color = "black", shape=8) 

map2017 <- plot_usmap(data = waivers2, values = "status", color = "black")+
  geom_point(data = cap2, aes(x = lon.1, y = lat.1, size = expandcap),
             color = "black", shape=8) 

map2018 <- plot_usmap(data = waivers3, values = "status", color = "black")+
  geom_point(data = cap3, aes(x = lon.1, y = lat.1, size = expandcap),
             color = "black", shape=8) 

map2019 <- plot_usmap(data = waivers4, values = "status", color = "black")+
  geom_point(data = cap4, aes(x = lon.1, y = lat.1, size = expandcap),
             color = "black", shape=8) 


map2012
map2017
map2018
map2019



scale_colour_manual(name = "grp",values = myColors)


















map1 <- merge(latlong, waivers1, by="full")
map1$full <- NULL
map1$abbr <- NULL
map1$fips <- NULL

map2 <- merge(latlong, waivers2, by="full")
map2$full <- NULL
map2$abbr <- NULL
map2$fips <- NULL

map3 <- merge(latlong, waivers3, by="full")
map3$full <- NULL
map3$abbr <- NULL
map3$fips <- NULL

map4 <- merge(latlong, waivers4, by="full")
map4$full <- NULL
map4$abbr <- NULL
map4$fips <- NULL


map1_1812 <- subset(map1, select = c(lon, lat, All1812))
map2_1812 <- subset(map2, select = c(lon, lat, All1812))
map3_1812 <- subset(map3, select = c(lon, lat, All1812))
map4_1812 <- subset(map4, select = c(lon, lat, All1812))

map1_admin <- subset(map1, select = c(lon, lat, AnyAdmin))
map2_admin <- subset(map2, select = c(lon, lat, AnyAdmin))
map3_admin <- subset(map3, select = c(lon, lat, AnyAdmin))
map4_admin <- subset(map4, select = c(lon, lat, AnyAdmin))

map1_reimb <- subset(map1, select = c(lon, lat, AnyReimb))
map2_reimb <- subset(map2, select = c(lon, lat, AnyReimb))
map3_reimb <- subset(map3, select = c(lon, lat, AnyReimb))
map4_reimb <- subset(map4, select = c(lon, lat, AnyReimb))

map1_cap <- subset(map1, select = c(lon, lat, expandcap))
map2_cap <- subset(map2, select = c(lon, lat, expandcap))
map3_cap <- subset(map3, select = c(lon, lat, expandcap))
map4_cap <- subset(map4, select = c(lon, lat, expandcap))


full1 <- usmap_transform(map1_1812)
full2 <- usmap_transform(map2_1812)
full3 <- usmap_transform(map3_1812)
full4 <- usmap_transform(map4_1812)

admin1 <- usmap_transform(map1_admin)
admin2 <- usmap_transform(map2_admin)
admin3 <- usmap_transform(map3_admin)
admin4 <- usmap_transform(map4_admin)

reimb1 <- usmap_transform(map1_reimb)
reimb2 <- usmap_transform(map2_reimb)
reimb3 <- usmap_transform(map3_reimb)
reimb4 <- usmap_transform(map4_reimb)

cap1 <- usmap_transform(map1_cap)
cap2 <- usmap_transform(map2_cap)
cap3 <- usmap_transform(map3_cap)
cap4 <- usmap_transform(map4_cap)











plot_usmap(data = waivers1, values = "total", color = "black")+
geom_point(data = full1, aes(x = lon.1, y = lat.1, size = .75*All1812),
           color = "red", alpha = 0.75) +
  geom_point(data = admin1, aes(x = lon.1, y = lat.1, size = AnyAdmin),
             color = "yellow", alpha = 0.75, shape=15) + 
  geom_point(data = reimb1, aes(x = lon.1, y = lat.1, size = .5*AnyReimb),
             color = "purple", alpha = 0.75, shape=17) + 
  geom_point(data = cap1, aes(x = lon.1, y = lat.1, size = .25*expandcap),
             color = "white", alpha = 1, shape=8) 



plot_usmap(data = waivers2, values = "total", color = "black")+
  geom_point(data = full2, aes(x = lon.1, y = lat.1, size = .75*All1812),
             color = "red", alpha = 0.75) +
  geom_point(data = admin2, aes(x = lon.1, y = lat.1, size = AnyAdmin),
             color = "yellow", alpha = 0.75, shape=15) + 
  geom_point(data = reimb2, aes(x = lon.1, y = lat.1, size = .5*AnyReimb),
             color = "purple", alpha = 0.75, shape=17) + 
  geom_point(data = cap2, aes(x = lon.1, y = lat.1, size = .25*expandcap),
             color = "white", alpha = 1, shape=8) 


plot_usmap(data = waivers3, values = "total", color = "black")+
  geom_point(data = full3, aes(x = lon.1, y = lat.1, size = .75*All1812),
             color = "red", alpha = 0.75) +
  geom_point(data = admin3, aes(x = lon.1, y = lat.1, size = AnyAdmin),
             color = "yellow", alpha = 0.75, shape=15) + 
  geom_point(data = reimb3, aes(x = lon.1, y = lat.1, size = .5*AnyReimb),
             color = "purple", alpha = 0.75, shape=17) + 
  geom_point(data = cap3, aes(x = lon.1, y = lat.1, size = .25*expandcap),
             color = "white", alpha = 1, shape=8) 

plot_usmap(data = waivers4, values = "total", color = "black")+
  geom_point(data = full4, aes(x = lon.1, y = lat.1, size = .75*All1812),
             color = "red", alpha = 0.15) +
  geom_point(data = admin4, aes(x = lon.1, y = lat.1, size = AnyAdmin),
             color = "yellow", alpha = 0.75, shape=15) + 
  geom_point(data = reimb4, aes(x = lon.1, y = lat.1, size = .5*AnyReimb),
             color = "purple", alpha = 0.75, shape=17) + 
  geom_point(data = cap4, aes(x = lon.1, y = lat.1, size = .25*expandcap),
             color = "white", alpha = 1, shape=8) 





















csE <- cs
csR <- cs
cs <- NULL
csR$req <- NA
csR$req[csR$Cost_Sharing == "Required"] <- 1
csR$Cost_Sharing <- NULL
csE$ex <- NA
csE$ex[csE$Cost_Sharing == "Exempt"] <- 1
csE$Cost_Sharing <- NULL

ucc <- merge(latlong, hkm_ucc, by="full")
ucc$fips <- NULL
ucc$full <- NULL
ucc$pool <- NA
ucc$pool[ucc$UncompCarePool == 1] <- 1
ucc$UncompCarePool <- NULL
ucc$abbr <- NULL

uccp <- usmap_transform(ucc)

oth <- merge(latlong, hkm_oth, by="full")
oth$fips <- NULL
oth$full <- NULL
oth$leg <- NA
oth$leg[oth$Other_State_Activity == 1] <- 1
oth$Other_State_Activity <- NULL
oth$abbr <- NULL

other <- usmap_transform(oth)


plot_usmap(data = hkm_w, values = "Katrina_Activity", color = "black") +
  geom_point(data = csE, aes(x = lon.1, y = lat.1, size = .75*ex),
             color = "red", alpha = 0.75) +
  geom_point(data = csR, aes(x = lon.1, y = lat.1, size = .75*req),
             color = "yellow", alpha = 0.75) + 
  geom_point(data = uccp, aes(x = lon.1, y = lat.1, size = .25*pool),
             color = "black", alpha = 0.75) + 
  geom_point(data = other, aes(x = lon.1, y = lat.1, size = .25*leg),
             color = "white", alpha = 1) 


plot_usmap(data = hkm_w, values = "Katrina_Activity", color = "black") + 
  geom_point(data = csE, aes(x = lon.1, y = lat.1, size = .75*ex),
             color = "red", alpha = 0.75) +
  geom_point(data = csR, aes(x = lon.1, y = lat.1, size = .75*req),
             color = "yellow", alpha = 0.75) + 
  geom_point(data = uccp, aes(x = lon.1, y = lat.1, size = .25*pool),
             color = "black", alpha = 0.75) + 
  geom_point(data = other, aes(x = lon.1, y = lat.1, size = .25*leg),
             color = "white", alpha = 1) 





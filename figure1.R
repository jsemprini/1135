library(usmap)
library(ggplot2)
library(maptools)

data <- statepop

data$pop_2015 <- NULL


hkm_w <- merge(data, HKT1_Waiver, by="abbr", all.x=TRUE)
hkm_cs <- merge(data, HKT1_cs, by="abbr", all.x=TRUE)
hkm_oth <- merge(data, HKT1_OTH, by="abbr", all.x=TRUE)
hkm_ucc <- merge(data, HKT1_UCC, by="abbr", all.x=TRUE)


plot_usmap(data = hkm_w, values = "Katrina_Activity", color = "black")

map_cs <- merge(latlong, hkm_cs, by="full")
map_cs$full <- NULL
map_cs$abbr <- NULL
map_cs$fips <- NULL
cs <- usmap_transform(map_cs)

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





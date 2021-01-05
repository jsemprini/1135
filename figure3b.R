library(usmap)
library(ggplot2)
library(maptools)



data <- statepop

data$pop_2015 <- NULL


table3_reg$abbr <- table3_reg$State
waivers <- merge(data, table3_reg, by="abbr", all=TRUE)

write.table(data, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/waivers.txt", sep="\t")



waivers$year[waivers$year <=2012] <- 2016

plot_usmap(data = waivers2, values = "status", color = "black") + 
  theme(legend.position = "top") + facet_wrap(~ year) 

plot_usmap(data = waivers2, values = "status", color = "black") + 
 facet_wrap(~ year) 




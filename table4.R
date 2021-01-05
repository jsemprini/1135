library(dplyr)

yearmeans <- table3_reg %>%
  group_by(Year) %>%
  summarise_at(vars(-State), funs(mean(., na.rm=TRUE)))

year2means <- table3_reg %>%
  group_by(Year2) %>%
  summarise_at(vars(-State), funs(mean(., na.rm=TRUE)))

statemeans <- table3_reg %>%
  group_by(State) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

situationmeans <- table3_reg %>%
  group_by(Situation) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

disastermeans <- table3_reg %>%
  group_by(Disaster) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

disaster2means <- table3_reg %>%
  group_by(Disaster2) %>%
  summarise_at(vars(-Year), funs(mean(., na.rm=TRUE)))

write.table(disastermeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/dis.txt", sep="\t")
write.table(situationmeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/sit.txt", sep="\t")
write.table(statemeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/state.txt", sep="\t")
write.table(yearmeans, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/year.txt", sep="\t")
write.table(year2means, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/year2.txt", sep="\t")
write.table(disaster2means, "C:/Users/Jason/Desktop/Winter/Federalism/aim1obj3/Output/dis2.txt", sep="\t")


print(varlist)

models_disaster <- lapply(varlist, function(x) {
  lm(substitute(i ~ Disaster, list(i = as.name(x))), data = table3_reg)
})

models_disaster2 <- lapply(varlist, function(x) {
  lm(substitute(i ~ Disaster2, list(i = as.name(x))), data = table3_reg)
})

models_state <- lapply(varlist, function(x) {
  lm(substitute(i ~ State, list(i = as.name(x))), data = table3_reg)
})

models_year2 <- lapply(varlist, function(x) {
  lm(substitute(i ~ Year2, list(i = as.name(x))), data = table3_reg)
})

models_Year <- lapply(varlist, function(x) {
  lm(substitute(i ~ Year, list(i = as.name(x))), data = table3_reg)
})


Disasterreg <- lapply(models_disaster, summary)
Disaster2reg <- lapply(models_disaster2, summary)
Statereg <- lapply(models_state, summary)
Year2reg <- lapply(models_Year, summary)
Yearreg <- lapply(models_Year2, summary)

Disasterreg 
 


print(varlist)


library(stargazer)
stargazer(models_disaster, type = "html", out = "disaster.html")
stargazer(models_disaster2, type = "html", out = "disaster2.html")
stargazer(models_year2, type = "html", out = "year2.html")




ggplot(subcounty, aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
geom_smooth()
ggplot(subset(subcounty, state!="NY"), aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ rural)
ggplot(subcounty, aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ metro)
ggplot(subcounty, aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ count_reg)
ggplot(subcounty, aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ full1135)
ggplot(subcounty, aes(x = normdate, y = countycases_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ extra1135)




ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ rural)
ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ metro)
ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ count_reg)
ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c(0,1)))) + 
  geom_smooth() + facet_wrap(~ full1135)







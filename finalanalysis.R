library(aer)
library(rdd)
library(foreign)
library(stargazer)
library(ggplot2)
library(gridExtra)


theme_Publication <- function(base_size=14, base_family="helvetica") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(0.2, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}

scale_fill_Publication <- function(...){
  library(scales)
  discrete_scale("fill","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

scale_colour_Publication <- function(...){
  library(scales)
  discrete_scale("colour","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

library(ggthemes)



reg=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, cluster=county$fips)
summary(reg)

all<-ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c("before request","after request")))) + 
  geom_smooth(method="gam") +
  labs(
    x = "Days (centered at 1135 Waiver request date",              # x axis title
    y = "deaths per 100,000",   # y axis title
    title = "Covid-19 Deaths before and after 1135 Waiver requests",      # title of legend,
    color= ""
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



reg.rural=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$rural==1, cluster=county$fips)
summary(reg.rural)
reg.nonrural=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$rural==0, cluster=county$fips)
summary(reg.nonrural)

rural<-ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c("before request","after request")))) + 
  geom_smooth(method="gam") +facet_wrap(~ factor(rural, labels = c("non-Rural","Rural")))+
  labs(
    x = "Days (centered at 1135 Waiver request date)",              # x axis title
    y = "deaths per 100,000",   # y axis title
    title = "Covid-19 Deaths before and after 1135 Waiver requests",      # title of legend,
    color= ""
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))




reg.ruralfull=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$rural==1 & county$full1135==1, cluster=county$fips)
summary(reg.ruralfull)
reg.notruralfull=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$rural==0 & county$full1135==1, cluster=county$fips)
summary(reg.notruralfull)
reg.ruralnotfull=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$metro==1 & county$full1135==0, cluster=county$fips)
summary(reg.ruralnotfull)
reg.notruralnotfull=RDestimate(countydeaths_pc~normdate,county,cutpoint = 0, subset=county$metro==0 & county$full1135==0, cluster=county$fips)
summary(reg.notruralnotfull)

ruralfull<- ggplot(subcounty, aes(x = normdate, y = countydeaths_pc, color = factor(waiver1, labels = c("before request","after request")))) + 
  geom_smooth(method="gam") + facet_wrap(~ factor(rural, labels = c("non-Rural","Rural"))+factor(full1135, labels = c("without full request","with full request")))+
  labs(
    x = "Days (centered at 1135 Waiver request date)",              # x axis title
    y = "deaths per 100,000",   # y axis title
    title = "Covid-19 Deaths before and after 1135 Waiver requests",      # title of legend,
    color= ""
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))






tiff("fullimpact.tiff", units="in", width=10, height=5, res=1000)

grid.arrange(all +scale_colour_Publication()+ theme_Publication(),nrow=1)
dev.off()

tiff("rural.tiff", units="in", width=10, height=5, res=1000)

grid.arrange(rural +scale_colour_Publication()+ theme_Publication(),nrow=1)
dev.off()

tiff("ruralfull.tiff", units="in", width=10, height=5, res=1000)

grid.arrange(ruralfull +scale_colour_Publication()+ theme_Publication(),nrow=1)
dev.off()


library("survminer")
require("survival")

aim1test1R$group[aim1test1R$history1135==0] <-0
aim1test1R$group[aim1test1R$count1135==1] <- 1
aim1test1R$group[aim1test1R$count1135>1] <- 2

aim1test1R$multi <-0
aim1test1R$multi[aim1test1R$count1135>1] <- 1


fit <- survfit(Surv(normdate, waiver2) ~ group, data = aim1test1R)


TEST <- ggsurvplot(fit, data = aim1test1R)


fit <- survfit(Surv(normdate, waiver2) ~ history1135, data = aim1test1R)

fit2 <- survfit(Surv(normdate, waiver1) ~ multi, data = aim1test1R)

ggsurvplot(fit,
           conf.int = FALSE,
           risk.table.col = "strata", # Change risk table color by groups
           ggtheme = theme_bw(), 
           pval=TRUE,# Change ggplot2 theme
           fun = "cumhaz") 


ggsurvplot(fit,
           conf.int = FALSE,
           risk.table.col = "strata", # Change risk table color by groups
           ggtheme = theme_bw(),
           pval = TRUE,              # Add p-value
           # Change ggplot2 theme
           fun = "event") 


















ggsurvplot(
  fit, 
  data = aim1test1R, 
  size = 1,                 # change line size
  conf.int = FALSE,          # Add confidence interval
  pval = TRUE,              # Add p-value
  risk.table = FALSE,        # Add risk table
  risk.table.col = "1135 waiver History",# Risk table color by groups
  legend.labs = 
    c("None", "One", "Multiple"),    # Change legend labels
  risk.table.height = 0.25, # Useful to change when you have multiple groups
  ggtheme = theme_bw()      # Change ggplot2 theme
)

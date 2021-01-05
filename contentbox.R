#global sample
library(ggplot2)

#all health rating outcomes
ggplot(data=content_pca,
       aes(x=iv, y=effect, fill=iv, alpha=factor(sig), width = 0.5)) +
  geom_boxplot(position=position_dodge(),width = 0.5) +
  geom_crossbar(aes(ymin = effect-se, ymax = effect+se), width = 0.5,position=position_dodge()) + 
  geom_errorbar(aes(ymin=effect-2*se, ymax=effect+2*se), width=.5,position=position_dodge(), color="black") +
  scale_alpha_manual(values = c(.1, .9), guide = FALSE) + theme_minimal() + geom_hline(yintercept=0) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  facet_wrap(~ dv)

ggplot(data=subset(content_pca, content_pca$model=="reg"),
       aes(x=iv, y=abs_effect, fill=iv, alpha=factor(marg), width = 0.5)) +
  geom_boxplot(position=position_dodge(),width = 0.5) +
  geom_crossbar(aes(ymin = abs_effect-se, ymax = abs_effect+se), width = 0.5,position=position_dodge()) + 
  geom_errorbar(aes(ymin=abs_effect-2*se, ymax=abs_effect+2*se), width=.5,position=position_dodge(), color="black") +
  scale_alpha_manual(values = c(.1, .9), guide = FALSE) + theme_minimal() + geom_hline(yintercept=0) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  facet_wrap(~ dv)

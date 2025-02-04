## auto and tuning method comparison
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(ggsci)
library(gridExtra)
library(cowplot)
library(grid)
library(scales)
library(readr)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/")

# Fixed plot value
my_theme <- theme(
    plot.title = element_text(size=16, face = "bold"),
    text = element_text(size=16),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14),
    axis.title.x = element_text(size=16, face = "bold"),
    axis.title.y = element_text(size=16),
    legend.text = element_text(size=14),
    legend.title = element_text(size=16, face = "bold"),
    strip.text = element_text(face = "bold", size = 14),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey", size = 0.5),
    panel.grid.minor.y = element_line(color = "lightgrey", size = 0.25)
  )

# Continuous plot
## Data preprocessing
prs_continuous_table = fread(paste0("PRS_no_val_Xwing_r2.csv"))
prs_table = prs_continuous_table

prs_table = prs_table[,c("pop", "trait", "JointPRS_auto_2","PRScsx_auto_2","Xwing_auto_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS-auto","PRS-CSx-auto","Xwing-auto")
prs_table[prs_table == 0] <- NA

prs_relative_JointPRS = prs_table[,c("pop","trait")]
prs_relative_JointPRS$`PRS-CSx-auto` = (prs_table$`JointPRS-auto` - prs_table$`PRS-CSx-auto`) / prs_table$`PRS-CSx-auto`
prs_relative_JointPRS$`Xwing-auto` = (prs_table$`JointPRS-auto` - prs_table$`Xwing-auto`) / prs_table$`Xwing-auto`

prs_relative_Xwing = prs_table[,c("pop","trait")]
prs_relative_Xwing$`PRS-CSx-auto` = (prs_table$`Xwing-auto` - prs_table$`PRS-CSx-auto`) / prs_table$`PRS-CSx-auto`

prs_average_JointPRS <- prs_relative_JointPRS %>%
  group_by(pop) %>%
  summarize(
    `avg_PRS-CSx_auto` = mean(`PRS-CSx-auto`, na.rm = TRUE),
    avg_Xwing_auto = mean(`Xwing-auto`, na.rm = TRUE),
  )
prs_average_JointPRS$pop = factor(prs_average_JointPRS$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average_JointPRS <- prs_average_JointPRS %>% arrange(pop)
print(prs_average_JointPRS)

prs_average_Xwing <- prs_relative_Xwing %>%
  group_by(pop) %>%
  summarize(
    `avg_PRS-CSx_auto` = mean(`PRS-CSx-auto`, na.rm = TRUE),
  )
prs_average_Xwing$pop = factor(prs_average_Xwing$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average_Xwing <- prs_average_Xwing %>% arrange(pop)
print(prs_average_Xwing)

prs_relative_JointPRS[,c(3:4)] = prs_relative_JointPRS[,c(3:4)] * 100
prs_average_JointPRS[,c(2:3)] = prs_average_JointPRS[,c(2:3)] * 100

prs_relative_Xwing[,c(3:3)] = prs_relative_Xwing[,c(3:3)] * 100
prs_average_Xwing[,c(2:2)] = prs_average_Xwing[,c(2:2)] * 100

## Plot for each cohort and pop
## JointPRS improvemenet
prs_relative = prs_relative_JointPRS
prs_average = prs_average_JointPRS

## PRS-CSx-auto
EAS_auto_PRScsx_auto = prs_relative[prs_relative$pop == "EAS",c("trait","PRS-CSx-auto")]
EAS_auto_PRScsx_auto = EAS_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
EAS_auto_PRScsx_auto$trait = factor(EAS_auto_PRScsx_auto$trait, levels = unique(EAS_auto_PRScsx_auto$trait))
PRScsx_auto_EAS_JointPRS_p <- ggplot(EAS_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", `avg_PRS-CSx_auto`))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits improvement of JointPRS-auto over PRS-CSx-auto") + xlab("")

## Xwing_auto
EAS_auto_Xwing_auto = prs_relative[prs_relative$pop == "EAS",c("trait","Xwing-auto")]
EAS_auto_Xwing_auto = EAS_auto_Xwing_auto %>% arrange(`Xwing-auto`)
EAS_auto_Xwing_auto$trait = factor(EAS_auto_Xwing_auto$trait, levels = unique(EAS_auto_Xwing_auto$trait))
Xwing_auto_EAS_JointPRS_p <- ggplot(EAS_auto_Xwing_auto, aes(x = trait, y = `Xwing-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `Xwing-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 10, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_Xwing_auto))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("Xwing-auto"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits of JointPRS-auto over Xwing-auto") + xlab("")

## Xwing improvement
prs_relative = prs_relative_Xwing
prs_average = prs_average_Xwing

## PRS-CSx-auto
EAS_auto_PRScsx_auto = prs_relative[prs_relative$pop == "EAS",c("trait","PRS-CSx-auto")]
EAS_auto_PRScsx_auto = EAS_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
EAS_auto_PRScsx_auto$trait = factor(EAS_auto_PRScsx_auto$trait, levels = unique(EAS_auto_PRScsx_auto$trait))
PRScsx_auto_EAS_Xwing_p <- ggplot(EAS_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", `avg_PRS-CSx_auto`))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("Xwing-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits of Xwing-auto over PRS-CSx-auto") + xlab("")

## combined plot
combined_plot_compare <- ggarrange(PRScsx_auto_EAS_JointPRS_p, Xwing_auto_EAS_JointPRS_p, PRScsx_auto_EAS_Xwing_p, labels = c("a","b","c"), ncol = 1, nrow = 3)
print(combined_plot_compare)

# no_val_Xwing_bar_plot.png width 1600 height 1600
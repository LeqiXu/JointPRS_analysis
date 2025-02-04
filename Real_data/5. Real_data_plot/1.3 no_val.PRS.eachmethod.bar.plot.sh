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
prs_continuous_table = fread(paste0("PRS_no_val_r2.csv"))
prs_binary_table = fread("PRS_no_val_auc.csv")
prs_table = rbind(prs_continuous_table,prs_binary_table)

prs_table = prs_table[,c("pop", "trait", "JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")
prs_table[prs_table == 0] <- NA

prs_relative = prs_table[,c("pop","trait")]
prs_relative$`PRS-CSx-auto` = (prs_table$`JointPRS-auto` - prs_table$`PRS-CSx-auto`) / prs_table$`PRS-CSx-auto`
prs_relative$`SDPRX` = (prs_table$`JointPRS-auto` - prs_table$`SDPRX`) / prs_table$`SDPRX`
prs_relative$`XPASS` = (prs_table$`JointPRS-auto` - prs_table$`XPASS`) / prs_table$`XPASS`

prs_average <- prs_relative %>%
  group_by(pop) %>%
  summarize(
    `avg_PRS-CSx_auto` = mean(`PRS-CSx-auto`, na.rm = TRUE),
    avg_SDPRX = mean(SDPRX, na.rm = TRUE),
    avg_XPASS = mean(XPASS, na.rm = TRUE)
  )
prs_average$pop = factor(prs_average$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average <- prs_average %>% arrange(pop)
print(prs_average)

prs_relative[,c(3:5)] = prs_relative[,c(3:5)] * 100
prs_average[,c(2:4)] = prs_average[,c(2:4)] * 100

## Plot for each cohort and pop
## PRS-CSx-auto
EAS_auto_PRScsx_auto = prs_relative[prs_relative$pop == "EAS",c("trait","PRS-CSx-auto")]
EAS_auto_PRScsx_auto = EAS_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
EAS_auto_PRScsx_auto$trait = factor(EAS_auto_PRScsx_auto$trait, levels = unique(EAS_auto_PRScsx_auto$trait))
PRScsx_auto_EAS_p <- ggplot(EAS_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
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
  ggtitle("EAS traits") + xlab("")

AFR_auto_PRScsx_auto = prs_relative[prs_relative$pop == "AFR",c("trait","PRS-CSx-auto")]
AFR_auto_PRScsx_auto = AFR_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
AFR_auto_PRScsx_auto$trait = factor(AFR_auto_PRScsx_auto$trait, levels = unique(AFR_auto_PRScsx_auto$trait))
PRScsx_auto_AFR_p <- ggplot(AFR_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 30, 
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
  ggtitle("AFR traits") + xlab("")

SAS_auto_PRScsx_auto = prs_relative[prs_relative$pop == "SAS",c("trait","PRS-CSx-auto")]
SAS_auto_PRScsx_auto = SAS_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
SAS_auto_PRScsx_auto$trait = factor(SAS_auto_PRScsx_auto$trait, levels = unique(SAS_auto_PRScsx_auto$trait))
PRScsx_auto_SAS_p <- ggplot(SAS_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 30, 
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
  ggtitle("SAS traits") + xlab("")

AMR_auto_PRScsx_auto = prs_relative[prs_relative$pop == "AMR",c("trait","PRS-CSx-auto")]
AMR_auto_PRScsx_auto = AMR_auto_PRScsx_auto %>% arrange(`PRS-CSx-auto`)
AMR_auto_PRScsx_auto$trait = factor(AMR_auto_PRScsx_auto$trait, levels = unique(AMR_auto_PRScsx_auto$trait))
PRScsx_auto_AMR_p <- ggplot(AMR_auto_PRScsx_auto, aes(x = trait, y = `PRS-CSx-auto`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx-auto` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 30, 
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
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_PRScsx_auto <- ggarrange(PRScsx_auto_EAS_p, PRScsx_auto_AFR_p, ggarrange(PRScsx_auto_SAS_p,PRScsx_auto_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"), ncol = 1, nrow = 3)
print(combined_plot_PRScsx_auto)
# no_val_PRScsx_auto_bar_plot.png width 1600 height 1600

## SDPRX
EAS_auto_SDPRX = prs_relative[prs_relative$pop == "EAS",c("trait","SDPRX")]
EAS_auto_SDPRX = EAS_auto_SDPRX %>% arrange(`SDPRX`)
EAS_auto_SDPRX$trait = factor(EAS_auto_SDPRX$trait, levels = unique(EAS_auto_SDPRX$trait))
SDPRX_EAS_p <- ggplot(EAS_auto_SDPRX, aes(x = trait, y = `SDPRX`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `SDPRX` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 10, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_SDPRX))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("SDPRX"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_SDPRX = prs_relative[prs_relative$pop == "AFR",c("trait","SDPRX")]
AFR_auto_SDPRX = AFR_auto_SDPRX %>% arrange(`SDPRX`)
AFR_auto_SDPRX$trait = factor(AFR_auto_SDPRX$trait, levels = unique(AFR_auto_SDPRX$trait))
SDPRX_AFR_p <- ggplot(AFR_auto_SDPRX, aes(x = trait, y = `SDPRX`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `SDPRX` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_SDPRX))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("SDPRX"), "-1")), 
                     limits = c(-100,240)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

## combined plot
combined_plot_SDPRX <- ggarrange(SDPRX_EAS_p, SDPRX_AFR_p, labels = c("a","b"), ncol = 1, nrow = 2)
print(combined_plot_SDPRX)
# no_val_SDPRX_bar_plot.png width 1600 height 1600

## XPASS
EAS_auto_XPASS = prs_relative[prs_relative$pop == "EAS",c("trait","XPASS")]
EAS_auto_XPASS = EAS_auto_XPASS %>% arrange(`XPASS`)
EAS_auto_XPASS$trait = factor(EAS_auto_XPASS$trait, levels = unique(EAS_auto_XPASS$trait))
XPASS_EAS_p <- ggplot(EAS_auto_XPASS, aes(x = trait, y = `XPASS`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `XPASS` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,200)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_XPASS = prs_relative[prs_relative$pop == "AFR",c("trait","XPASS")]
AFR_auto_XPASS = AFR_auto_XPASS %>% arrange(`XPASS`)
AFR_auto_XPASS$trait = factor(AFR_auto_XPASS$trait, levels = unique(AFR_auto_XPASS$trait))
XPASS_AFR_p <- ggplot(AFR_auto_XPASS, aes(x = trait, y = `XPASS`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `XPASS` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,200)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

SAS_auto_XPASS = prs_relative[prs_relative$pop == "SAS",c("trait","XPASS")]
SAS_auto_XPASS = SAS_auto_XPASS %>% arrange(`XPASS`)
SAS_auto_XPASS$trait = factor(SAS_auto_XPASS$trait, levels = unique(SAS_auto_XPASS$trait))
XPASS_SAS_p <- ggplot(SAS_auto_XPASS, aes(x = trait, y = `XPASS`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `XPASS` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 120, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,200)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("SAS traits") + xlab("")

AMR_auto_XPASS = prs_relative[prs_relative$pop == "AMR",c("trait","XPASS")]
AMR_auto_XPASS = AMR_auto_XPASS %>% arrange(`XPASS`)
AMR_auto_XPASS$trait = factor(AMR_auto_XPASS$trait, levels = unique(AMR_auto_XPASS$trait))
XPASS_AMR_p <- ggplot(AMR_auto_XPASS, aes(x = trait, y = `XPASS`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `XPASS` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 120, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,200)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_XPASS <- ggarrange(XPASS_EAS_p, XPASS_AFR_p, ggarrange(XPASS_SAS_p,XPASS_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_XPASS)
# no_val_XPASS_bar_plot.png width 1600 height 1600
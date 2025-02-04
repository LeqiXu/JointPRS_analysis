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

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PRS/")

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

prs_table = fread(paste0("PRS_update_diff_cohort_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")
prs_table[prs_table < 0.001] <- NA

prs_relative = prs_table[,c("pop","trait")]
prs_relative$SDPRX = (prs_table$JointPRS - prs_table$SDPRX) / prs_table$SDPRX
prs_relative$XPASS = (prs_table$JointPRS - prs_table$XPASS) / prs_table$XPASS
prs_relative$`PRS-CSx` = (prs_table$JointPRS - prs_table$`PRS-CSx`) / prs_table$`PRS-CSx`
prs_relative$MUSSEL = (prs_table$JointPRS - prs_table$MUSSEL) / prs_table$MUSSEL
prs_relative$PROSPER = (prs_table$JointPRS - prs_table$PROSPER) / prs_table$PROSPER
prs_relative$BridgePRS = (prs_table$JointPRS - prs_table$BridgePRS) / prs_table$BridgePRS

prs_average <- prs_relative %>%
  group_by(pop) %>%
  summarize(
    avg_SDPRX = mean(SDPRX, na.rm = TRUE),
    avg_XPASS = mean(XPASS, na.rm = TRUE),
    `avg_PRS-CSx` = mean(`PRS-CSx`, na.rm = TRUE),
    avg_MUSSEL = mean(MUSSEL, na.rm = TRUE),
    avg_PROSPER = mean(PROSPER, na.rm = TRUE),
    avg_BridgePRS = mean(BridgePRS, na.rm = TRUE)
  )

prs_average$pop = factor(prs_average$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average <- prs_average %>% arrange(pop)
print(prs_average)

prs_relative[,c(3:8)] = prs_relative[,c(3:8)] * 100
prs_average[,c(2:7)] = prs_average[,c(2:7)] * 100

## Plot for each cohort and pop
## SDPRX
AFR_auto_SDPRX = prs_relative[prs_relative$pop == "AFR",c("trait","SDPRX")]
AFR_auto_SDPRX = AFR_auto_SDPRX %>% arrange(SDPRX)
AFR_auto_SDPRX$trait = factor(AFR_auto_SDPRX$trait, levels = unique(AFR_auto_SDPRX$trait))
SDPRX_AFR_p <- ggplot(AFR_auto_SDPRX, aes(x = trait, y = SDPRX)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = SDPRX < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 40, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_SDPRX))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("SDPRX"), "-1")), 
                     limits = c(-100,300)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

## combined plot
combined_plot_SDPRX <- ggarrange(SDPRX_AFR_p, labels = c("a"), ncol = 1, nrow = 1)
print(combined_plot_SDPRX)
# diff_cohort_SDPRX_bar_plot.png width 1600 height 1600

## XPASS
AFR_auto_XPASS = prs_relative[prs_relative$pop == "AFR",c("trait","XPASS")]
AFR_auto_XPASS = AFR_auto_XPASS %>% arrange(XPASS)
AFR_auto_XPASS$trait = factor(AFR_auto_XPASS$trait, levels = unique(AFR_auto_XPASS$trait))
XPASS_AFR_p <- ggplot(AFR_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 70, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,350)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

AMR_auto_XPASS = prs_relative[prs_relative$pop == "AMR",c("trait","XPASS")]
AMR_auto_XPASS = AMR_auto_XPASS %>% arrange(XPASS)
AMR_auto_XPASS$trait = factor(AMR_auto_XPASS$trait, levels = unique(AMR_auto_XPASS$trait))
XPASS_AMR_p <- ggplot(AMR_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 6/4, y = 120, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,350)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_XPASS <- ggarrange(XPASS_AFR_p, XPASS_AMR_p, labels = c("a","b"),  ncol = 1, nrow = 2)
print(combined_plot_XPASS)
# diff_cohort_XPASS_bar_plot.png width 1600 height 1600

## PRS-CSx
AFR_auto_PRScsx = prs_relative[prs_relative$pop == "AFR",c("trait","PRS-CSx")]
AFR_auto_PRScsx = AFR_auto_PRScsx %>% arrange(`PRS-CSx`)
AFR_auto_PRScsx$trait = factor(AFR_auto_PRScsx$trait, levels = unique(AFR_auto_PRScsx$trait))
PRScsx_AFR_p <- ggplot(AFR_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 20, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", `avg_PRS-CSx`))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("PRS-CSx"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

AMR_auto_PRScsx = prs_relative[prs_relative$pop == "AMR",c("trait","PRS-CSx")]
AMR_auto_PRScsx = AMR_auto_PRScsx %>% arrange(`PRS-CSx`)
AMR_auto_PRScsx$trait = factor(AMR_auto_PRScsx$trait, levels = unique(AMR_auto_PRScsx$trait))
PRScsx_AMR_p <- ggplot(AMR_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 6/4, y = 20, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", `avg_PRS-CSx`))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("PRS-CSx"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_PRScsx <- ggarrange(PRScsx_AFR_p, PRScsx_AMR_p, labels = c("a","b"),  ncol = 1, nrow = 2)
print(combined_plot_PRScsx)
# diff_cohort_PRScsx_bar_plot.png width 1600 height 1600

## MUSSEL
AFR_auto_MUSSEL = prs_relative[prs_relative$pop == "AFR",c("trait","MUSSEL")]
AFR_auto_MUSSEL = AFR_auto_MUSSEL %>% arrange(MUSSEL)
AFR_auto_MUSSEL$trait = factor(AFR_auto_MUSSEL$trait, levels = unique(AFR_auto_MUSSEL$trait))
MUSSEL_AFR_p <- ggplot(AFR_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 15, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_MUSSEL))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("MUSSEL"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

AMR_auto_MUSSEL = prs_relative[prs_relative$pop == "AMR",c("trait","MUSSEL")]
AMR_auto_MUSSEL = AMR_auto_MUSSEL %>% arrange(MUSSEL)
AMR_auto_MUSSEL$trait = factor(AMR_auto_MUSSEL$trait, levels = unique(AMR_auto_MUSSEL$trait))
MUSSEL_AMR_p <- ggplot(AMR_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 6/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_MUSSEL))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("MUSSEL"), "-1")), 
                     limits = c(-100,300)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_MUSSEL <- ggarrange(MUSSEL_AFR_p, MUSSEL_AMR_p, labels = c("a","b"),  ncol = 1, nrow = 2)
print(combined_plot_MUSSEL)
# diff_cohort_MUSSEL_bar_plot.png width 1600 height 1600

## PROSPER
AFR_auto_PROSPER = prs_relative[prs_relative$pop == "AFR",c("trait","PROSPER")]
AFR_auto_PROSPER = AFR_auto_PROSPER %>% arrange(PROSPER)
AFR_auto_PROSPER$trait = factor(AFR_auto_PROSPER$trait, levels = unique(AFR_auto_PROSPER$trait))
PROSPER_AFR_p <- ggplot(AFR_auto_PROSPER, aes(x = trait, y = PROSPER)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = PROSPER < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_PROSPER))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("PROSPER"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

AMR_auto_PROSPER = prs_relative[prs_relative$pop == "AMR",c("trait","PROSPER")]
AMR_auto_PROSPER = AMR_auto_PROSPER %>% arrange(PROSPER)
AMR_auto_PROSPER$trait = factor(AMR_auto_PROSPER$trait, levels = unique(AMR_auto_PROSPER$trait))
PROSPER_AMR_p <- ggplot(AMR_auto_PROSPER, aes(x = trait, y = PROSPER)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = PROSPER < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 6/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_PROSPER))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("PROSPER"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_PROSPER <- ggarrange(PROSPER_AFR_p, PROSPER_AMR_p, labels = c("a","b"),  ncol = 1, nrow = 2)
print(combined_plot_PROSPER)
# diff_cohort_PROSPER_bar_plot.png width 1600 height 1600

## BridgePRS
AFR_auto_BridgePRS = prs_relative[prs_relative$pop == "AFR",c("trait","BridgePRS")]
AFR_auto_BridgePRS = AFR_auto_BridgePRS %>% arrange(BridgePRS)
AFR_auto_BridgePRS$trait = factor(AFR_auto_BridgePRS$trait, levels = unique(AFR_auto_BridgePRS$trait))
BridgePRS_AFR_p <- ggplot(AFR_auto_BridgePRS, aes(x = trait, y = BridgePRS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = BridgePRS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_BridgePRS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("BridgePRS"), "-1")), 
                     limits = c(-100,500)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

AMR_auto_BridgePRS = prs_relative[prs_relative$pop == "AMR",c("trait","BridgePRS")]
AMR_auto_BridgePRS = AMR_auto_BridgePRS %>% arrange(BridgePRS)
AMR_auto_BridgePRS$trait = factor(AMR_auto_BridgePRS$trait, levels = unique(AMR_auto_BridgePRS$trait))
BridgePRS_AMR_p <- ggplot(AMR_auto_BridgePRS, aes(x = trait, y = BridgePRS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = BridgePRS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 6/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_BridgePRS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("BridgePRS"), "-1")), 
                     limits = c(-100,150)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_BridgePRS <- ggarrange(BridgePRS_AFR_p, BridgePRS_AMR_p, labels = c("a","b"),  ncol = 1, nrow = 2)
print(combined_plot_BridgePRS)
# diff_cohort_BridgePRS_bar_plot.png width 1600 height 1600
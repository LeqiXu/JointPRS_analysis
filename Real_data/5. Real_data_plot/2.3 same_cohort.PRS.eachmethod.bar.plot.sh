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

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/")

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
prs_continuous_table = fread(paste0("PRS_update_same_cohort_r2.csv"))
prs_binary_table = fread("PRS_update_same_cohort_auc.csv")
prs_table = rbind(prs_continuous_table,prs_binary_table)

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

prs_relative_average = prs_relative %>% 
  group_by(pop, trait) %>%
  summarise(
    SDPRX = mean(SDPRX, na.rm = TRUE),
    XPASS = mean(XPASS, na.rm = TRUE),
    `PRS-CSx` = mean(`PRS-CSx`, na.rm = TRUE),
    MUSSEL = mean(MUSSEL, na.rm = TRUE),
    PROSPER = mean(PROSPER, na.rm = TRUE),
    BridgePRS = mean(BridgePRS, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

prs_average <- prs_relative_average %>%
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

prs_relative_average[,c(3:8)] = prs_relative_average[,c(3:8)] * 100
prs_average[,c(2:7)] = prs_average[,c(2:7)] * 100

## Plot for each cohort and pop
## SDPRX
EAS_auto_SDPRX = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","SDPRX")]
EAS_auto_SDPRX = EAS_auto_SDPRX %>% arrange(SDPRX)
EAS_auto_SDPRX$trait = factor(EAS_auto_SDPRX$trait, levels = unique(EAS_auto_SDPRX$trait))
SDPRX_EAS_p <- ggplot(EAS_auto_SDPRX, aes(x = trait, y = SDPRX)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = SDPRX < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 10, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_SDPRX))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("SDPRX"), "-1")), 
                     limits = c(-100,100)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_SDPRX = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","SDPRX")]
AFR_auto_SDPRX = AFR_auto_SDPRX %>% arrange(SDPRX)
AFR_auto_SDPRX$trait = factor(AFR_auto_SDPRX$trait, levels = unique(AFR_auto_SDPRX$trait))
SDPRX_AFR_p <- ggplot(AFR_auto_SDPRX, aes(x = trait, y = SDPRX)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = SDPRX < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 30, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_SDPRX))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("SDPRX"), "-1")), 
                     limits = c(-100,250)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

## combined plot
combined_plot_SDPRX <- ggarrange(SDPRX_EAS_p, SDPRX_AFR_p, labels = c("a","b"), ncol = 1, nrow = 2)
print(combined_plot_SDPRX)
# same_cohort_SDPRX_bar_plot.png width 1600 height 1600

## XPASS
EAS_auto_XPASS = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","XPASS")]
EAS_auto_XPASS = EAS_auto_XPASS %>% arrange(XPASS)
EAS_auto_XPASS$trait = factor(EAS_auto_XPASS$trait, levels = unique(EAS_auto_XPASS$trait))
XPASS_EAS_p <- ggplot(EAS_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_XPASS = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","XPASS")]
AFR_auto_XPASS = AFR_auto_XPASS %>% arrange(XPASS)
AFR_auto_XPASS$trait = factor(AFR_auto_XPASS$trait, levels = unique(AFR_auto_XPASS$trait))
XPASS_AFR_p <- ggplot(AFR_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

SAS_auto_XPASS = prs_relative_average[prs_relative_average$pop == "SAS",c("trait","XPASS")]
SAS_auto_XPASS = SAS_auto_XPASS %>% arrange(XPASS)
SAS_auto_XPASS$trait = factor(SAS_auto_XPASS$trait, levels = unique(SAS_auto_XPASS$trait))
XPASS_SAS_p <- ggplot(SAS_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 180, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("SAS traits") + xlab("")

AMR_auto_XPASS = prs_relative_average[prs_relative_average$pop == "AMR",c("trait","XPASS")]
AMR_auto_XPASS = AMR_auto_XPASS %>% arrange(XPASS)
AMR_auto_XPASS$trait = factor(AMR_auto_XPASS$trait, levels = unique(AMR_auto_XPASS$trait))
XPASS_AMR_p <- ggplot(AMR_auto_XPASS, aes(x = trait, y = XPASS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = XPASS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 180, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_XPASS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("XPASS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_XPASS <- ggarrange(XPASS_EAS_p, XPASS_AFR_p, ggarrange(XPASS_SAS_p,XPASS_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_XPASS)
# same_cohort_XPASS_bar_plot.png width 1600 height 1600

## PRS-CSx
EAS_auto_PRScsx = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","PRS-CSx")]
EAS_auto_PRScsx = EAS_auto_PRScsx %>% arrange(`PRS-CSx`)
EAS_auto_PRScsx$trait = factor(EAS_auto_PRScsx$trait, levels = unique(EAS_auto_PRScsx$trait))
PRScsx_EAS_p <- ggplot(EAS_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
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
  ggtitle("EAS traits") + xlab("")

AFR_auto_PRScsx = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","PRS-CSx")]
AFR_auto_PRScsx = AFR_auto_PRScsx %>% arrange(`PRS-CSx`)
AFR_auto_PRScsx$trait = factor(AFR_auto_PRScsx$trait, levels = unique(AFR_auto_PRScsx$trait))
PRScsx_AFR_p <- ggplot(AFR_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", `avg_PRS-CSx`))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("PRS-CSx"), "-1")), 
                     limits = c(-100,260)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

SAS_auto_PRScsx = prs_relative_average[prs_relative_average$pop == "SAS",c("trait","PRS-CSx")]
SAS_auto_PRScsx = SAS_auto_PRScsx %>% arrange(`PRS-CSx`)
SAS_auto_PRScsx$trait = factor(SAS_auto_PRScsx$trait, levels = unique(SAS_auto_PRScsx$trait))
PRScsx_SAS_p <- ggplot(SAS_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 50, 
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
  ggtitle("SAS traits") + xlab("")

AMR_auto_PRScsx = prs_relative_average[prs_relative_average$pop == "AMR",c("trait","PRS-CSx")]
AMR_auto_PRScsx = AMR_auto_PRScsx %>% arrange(`PRS-CSx`)
AMR_auto_PRScsx$trait = factor(AMR_auto_PRScsx$trait, levels = unique(AMR_auto_PRScsx$trait))
PRScsx_AMR_p <- ggplot(AMR_auto_PRScsx, aes(x = trait, y = `PRS-CSx`)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = `PRS-CSx` < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 50, 
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
combined_plot_PRScsx <- ggarrange(PRScsx_EAS_p, PRScsx_AFR_p, ggarrange(PRScsx_SAS_p,PRScsx_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_PRScsx)
# same_cohort_PRScsx_bar_plot.png width 1600 height 1600

## MUSSEL
EAS_auto_MUSSEL = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","MUSSEL")]
EAS_auto_MUSSEL = EAS_auto_MUSSEL %>% arrange(MUSSEL)
EAS_auto_MUSSEL$trait = factor(EAS_auto_MUSSEL$trait, levels = unique(EAS_auto_MUSSEL$trait))
MUSSEL_EAS_p <- ggplot(EAS_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_MUSSEL))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("MUSSEL"), "-1")), 
                     limits = c(-100,150)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_MUSSEL = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","MUSSEL")]
AFR_auto_MUSSEL = AFR_auto_MUSSEL %>% arrange(MUSSEL)
AFR_auto_MUSSEL$trait = factor(AFR_auto_MUSSEL$trait, levels = unique(AFR_auto_MUSSEL$trait))
MUSSEL_AFR_p <- ggplot(AFR_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AFR"),], aes(x = 11/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_MUSSEL))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("MUSSEL"), "-1")), 
                     limits = c(-100,280)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

SAS_auto_MUSSEL = prs_relative_average[prs_relative_average$pop == "SAS",c("trait","MUSSEL")]
SAS_auto_MUSSEL = SAS_auto_MUSSEL %>% arrange(MUSSEL)
SAS_auto_MUSSEL$trait = factor(SAS_auto_MUSSEL$trait, levels = unique(SAS_auto_MUSSEL$trait))
MUSSEL_SAS_p <- ggplot(SAS_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 61, 
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
  ggtitle("SAS traits") + xlab("")

AMR_auto_MUSSEL = prs_relative_average[prs_relative_average$pop == "AMR",c("trait","MUSSEL")]
AMR_auto_MUSSEL = AMR_auto_MUSSEL %>% arrange(MUSSEL)
AMR_auto_MUSSEL$trait = factor(AMR_auto_MUSSEL$trait, levels = unique(AMR_auto_MUSSEL$trait))
MUSSEL_AMR_p <- ggplot(AMR_auto_MUSSEL, aes(x = trait, y = MUSSEL)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = MUSSEL < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 260, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_MUSSEL))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("MUSSEL"), "-1")), 
                     limits = c(-100,350)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_MUSSEL <- ggarrange(MUSSEL_EAS_p, MUSSEL_AFR_p, ggarrange(MUSSEL_SAS_p,MUSSEL_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_MUSSEL)
# same_cohort_MUSSEL_bar_plot.png width 1600 height 1600

## PROSPER
EAS_auto_PROSPER = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","PROSPER")]
EAS_auto_PROSPER = EAS_auto_PROSPER %>% arrange(PROSPER)
EAS_auto_PROSPER$trait = factor(EAS_auto_PROSPER$trait, levels = unique(EAS_auto_PROSPER$trait))
PROSPER_EAS_p <- ggplot(EAS_auto_PROSPER, aes(x = trait, y = PROSPER)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = PROSPER < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
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
  ggtitle("EAS traits") + xlab("")

AFR_auto_PROSPER = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","PROSPER")]
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

SAS_auto_PROSPER = prs_relative_average[prs_relative_average$pop == "SAS",c("trait","PROSPER")]
SAS_auto_PROSPER = SAS_auto_PROSPER %>% arrange(PROSPER)
SAS_auto_PROSPER$trait = factor(SAS_auto_PROSPER$trait, levels = unique(SAS_auto_PROSPER$trait))
PROSPER_SAS_p <- ggplot(SAS_auto_PROSPER, aes(x = trait, y = PROSPER)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = PROSPER < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 50, 
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
  ggtitle("SAS traits") + xlab("")

AMR_auto_PROSPER = prs_relative_average[prs_relative_average$pop == "AMR",c("trait","PROSPER")]
AMR_auto_PROSPER = AMR_auto_PROSPER %>% arrange(PROSPER)
AMR_auto_PROSPER$trait = factor(AMR_auto_PROSPER$trait, levels = unique(AMR_auto_PROSPER$trait))
PROSPER_AMR_p <- ggplot(AMR_auto_PROSPER, aes(x = trait, y = PROSPER)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = PROSPER < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 50, 
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
combined_plot_PROSPER <- ggarrange(PROSPER_EAS_p, PROSPER_AFR_p, ggarrange(PROSPER_SAS_p,PROSPER_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_PROSPER)
# same_cohort_PROSPER_bar_plot.png width 1600 height 1600

## BridgePRS
EAS_auto_BridgePRS = prs_relative_average[prs_relative_average$pop == "EAS",c("trait","BridgePRS")]
EAS_auto_BridgePRS = EAS_auto_BridgePRS %>% arrange(BridgePRS)
EAS_auto_BridgePRS$trait = factor(EAS_auto_BridgePRS$trait, levels = unique(EAS_auto_BridgePRS$trait))
BridgePRS_EAS_p <- ggplot(EAS_auto_BridgePRS, aes(x = trait, y = BridgePRS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = BridgePRS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="EAS"),], aes(x = 24/4, y = 50, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_BridgePRS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("BridgePRS"), "-1")), 
                     limits = c(-100,6000)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("EAS traits") + xlab("")

AFR_auto_BridgePRS = prs_relative_average[prs_relative_average$pop == "AFR",c("trait","BridgePRS")]
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
                     limits = c(-100,2300)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AFR traits") + xlab("")

SAS_auto_BridgePRS = prs_relative_average[prs_relative_average$pop == "SAS",c("trait","BridgePRS")]
SAS_auto_BridgePRS = SAS_auto_BridgePRS %>% arrange(BridgePRS)
SAS_auto_BridgePRS$trait = factor(SAS_auto_BridgePRS$trait, levels = unique(SAS_auto_BridgePRS$trait))
BridgePRS_SAS_p <- ggplot(SAS_auto_BridgePRS, aes(x = trait, y = BridgePRS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = BridgePRS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="SAS"),], aes(x = 10/4, y = 180, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_BridgePRS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("BridgePRS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("SAS traits") + xlab("")

AMR_auto_BridgePRS = prs_relative_average[prs_relative_average$pop == "AMR",c("trait","BridgePRS")]
AMR_auto_BridgePRS = AMR_auto_BridgePRS %>% arrange(BridgePRS)
AMR_auto_BridgePRS$trait = factor(AMR_auto_BridgePRS$trait, levels = unique(AMR_auto_BridgePRS$trait))
BridgePRS_AMR_p <- ggplot(AMR_auto_BridgePRS, aes(x = trait, y = BridgePRS)) +
  geom_bar(stat = "identity", 
           position = "dodge",
           aes(fill = BridgePRS < 0)) + 
  geom_text(data = prs_average[which(prs_average$pop=="AMR"),], aes(x = 10/4, y = 180, 
                                    label = paste("Average increase percentage:", sprintf("%.2f%%", avg_BridgePRS))), 
            vjust = -4, size=6, 
            fontface = "bold") + 
  scale_y_continuous(labels = scales::percent_format(scale = 1, accuracy = 1),
                     name = expression(paste("R"^2, scriptstyle("JointPRS"), "/", "R"^2, scriptstyle("BridgePRS"), "-1")), 
                     limits = c(-100,270)) +
  scale_fill_manual(values = c("#FB9A99", "#1F78B4")) + 
  theme_classic(base_size = 15) +
  my_theme +
  theme(legend.position="none") +
  ggtitle("AMR traits") + xlab("")

## combined plot
combined_plot_BridgePRS <- ggarrange(BridgePRS_EAS_p, BridgePRS_AFR_p, ggarrange(BridgePRS_SAS_p,BridgePRS_AMR_p,ncol=2,nrow=1, widths = c(0.5,0.5),labels = c("c","d")), labels = c("a","b"),  ncol = 1, nrow = 3)
print(combined_plot_BridgePRS)
# same_cohort_BridgePRS_bar_plot.png width 1600 height 1600
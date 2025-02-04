library(data.table)
library(ggplot2)
library(ggpubr)
library(scales)

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

prs_auto_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/PRS_no_val_corr_r2.csv"))
corr_auto_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/corr_no_val_corr_r2.csv"))

prs_auto_table$trait = factor(prs_auto_table$trait, levels = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT"))
corr_auto_table$trait = factor(corr_auto_table$trait, levels = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT"))
corr_auto_table$trait_type = factor(corr_auto_table$trait_type, levels = c("GLGC","PAGE","BBJ"), labels = c("GLGC traits","PAGE traits","BBJ traits"))

prs_auto_table$pop = factor(prs_auto_table$pop, levels = c("EAS","AFR","SAS","AMR"))
corr_auto_table$pop = factor(corr_auto_table$pop, levels = c("EAS","AFR","SAS","AMR"))

EAS_plot = ggplot(data = corr_auto_table[which(corr_auto_table$pop == "EAS"),], aes(x = trait, y = JointPRS_chr_corr, fill = trait_type)) + 
  geom_boxplot() + 
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "EAS Population",
    x = "EAS Trait",
    y = "JointPRS Chromosome Correlation"
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(limits = c(0,1))

AFR_plot = ggplot(data = corr_auto_table[which(corr_auto_table$pop == "AFR"),], aes(x = trait, y = JointPRS_chr_corr, fill = trait_type)) + 
  geom_boxplot() + 
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "AFR Population",
    x = "AFR Trait",
    y = "JointPRS Chromosome Correlation"
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(limits = c(0,1))

SAS_plot = ggplot(data = corr_auto_table[which(corr_auto_table$pop == "SAS"),], aes(x = trait, y = JointPRS_chr_corr, fill = trait_type)) + 
  geom_boxplot() + 
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "SAS Population",
    x = "SAS Trait",
    y = "JointPRS Chromosome Correlation"
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(limits = c(0,1))

AMR_plot = ggplot(data = corr_auto_table[which(corr_auto_table$pop == "AMR"),], aes(x = trait, y = JointPRS_chr_corr, fill = trait_type)) + 
  geom_boxplot() + 
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "AMR Population",
    x = "AMR Trait",
    y = "JointPRS Chromosome Correlation"
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(limits = c(0,1))

combined_plot = ggarrange(EAS_plot,AFR_plot,ggarrange(SAS_plot + theme(legend.position = "none"), AMR_plot + theme(legend.position = "none"), ncol = 2, nrow = 1, labels = c("c","d")), ncol = 1, nrow = 3, heights = c(1, 1, 1), labels = c("a","b"), common.legend = TRUE, legend = "right")
print(combined_plot)

# no_val_corr_box_plot.png width 1600 height 1600


## consider the relationship between mean correlation and the r2 improvement
mean_corr_table <- corr_auto_table[, .(mean_JointPRS_chr_corr = mean(JointPRS_chr_corr, na.rm = TRUE)), by = .(pop, trait, trait_type)]
prs_auto_table$improvement = (prs_auto_table$JointPRS_auto_2 - prs_auto_table$PRScsx_auto_2) / prs_auto_table$PRScsx_auto_2

prs_corr_table = merge(prs_auto_table,mean_corr_table, by = c("pop","trait"))

EAS_plot = ggplot(data = prs_corr_table[which(prs_corr_table$pop == "EAS"),], aes(x = mean_JointPRS_chr_corr, y = improvement, color = trait_type)) + 
  geom_point(size = 3) + 
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "EAS Population",
    x = "Mean of JointPRS Chromosome Correlation",
    y = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1"))
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(labels = scales::percent, limits = c(0,1))

AFR_plot = ggplot(data = prs_corr_table[which(prs_corr_table$pop == "AFR"),], aes(x = mean_JointPRS_chr_corr, y = improvement, color = trait_type)) + 
  geom_point(size = 3) + 
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "AFR Population",
    x = "Mean of JointPRS Chromosome Correlation",
    y = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1"))
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(labels = scales::percent, limits = c(0,1))

SAS_plot = ggplot(data = prs_corr_table[which(prs_corr_table$pop == "SAS"),], aes(x = mean_JointPRS_chr_corr, y = improvement, color = trait_type)) + 
  geom_point(size = 3) + 
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "SAS Population",
    x = "Mean of JointPRS Chromosome Correlation",
    y = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1"))
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(labels = scales::percent, limits = c(0,1))

AMR_plot = ggplot(data = prs_corr_table[which(prs_corr_table$pop == "AMR"),], aes(x = mean_JointPRS_chr_corr, y = improvement, color = trait_type)) + 
  geom_point(size = 3) + 
  scale_color_brewer(palette = "Set2") +
  labs(
    title = "AMR Population",
    x = "Mean of JointPRS Chromosome Correlation",
    y = expression(paste("R"^2, scriptstyle("JointPRS-auto"), "/", "R"^2, scriptstyle("PRS-CSx-auto"), "-1"))
  ) +
  facet_wrap(~pop) +
  theme_classic() +
  my_theme +
  scale_y_continuous(labels = scales::percent, limits = c(0,1))

combined_plot = ggarrange(EAS_plot,AFR_plot,ggarrange(SAS_plot + theme(legend.position = "none"), AMR_plot + theme(legend.position = "none"), ncol = 2, nrow = 1, labels = c("c","d")), ncol = 1, nrow = 3, heights = c(1, 1, 1), labels = c("a","b"), common.legend = TRUE, legend = "right")
print(combined_plot)

# no_val_corr_improvement_scatter_plot.png width 1600 height 1600

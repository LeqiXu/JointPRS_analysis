## Load packages
library(data.table)
library(dplyr)
library(ggplot2)
library(ggpattern)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/")

## Load data
GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
Binary_trait =  c("T2D","BrC","CAD","LuC")

prs_evaluation_continuous_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_JointPRS_version_same_cohort_r2.csv"))
prs_evaluation_binary_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_JointPRS_version_same_cohort_auc.csv"))

prs_version_continuous_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_JointPRS_version_choose_same_cohort_continuous.csv"))
prs_version_binary_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_JointPRS_version_choose_same_cohort_binary.csv"))

prs_continuous_table = merge(prs_evaluation_continuous_table,prs_version_continuous_table, by = c("pop","trait","s"))
prs_binary_table = merge(prs_evaluation_binary_table,prs_version_binary_table, by = c("pop","trait","s"))

prs_continuous_table$pop = factor(prs_continuous_table$pop, levels = c("EAS","AFR","SAS","AMR"))
prs_binary_table$pop = factor(prs_binary_table$pop, levels = c("EAS","AFR","SAS","AMR"))

prs_continuous_table$trait = factor(prs_continuous_table$trait, levels = c(GLGC_trait,PAGE_trait,BBJ_trait))
prs_binary_table$trait = factor(prs_binary_table$trait, levels = c(Binary_trait))

colnames(prs_continuous_table)[4:5] = c("meta","tune")
colnames(prs_binary_table)[4:5] = c("meta","tune")

## Convert data to long format for ggplot
prs_continuous_long <- melt(prs_continuous_table, id.vars = c("pop", "trait", "s", "JointPRS_version"),
                 variable.name = "version", value.name = "r2")

prs_binary_long <- melt(prs_binary_table, id.vars = c("pop", "trait", "s", "JointPRS_version"),
                 variable.name = "version", value.name = "r2")


## Create a new column to identify chosen version
my_theme <- theme(
    plot.title = element_text(size=12, face = "bold"),
    text = element_text(size=12),
    axis.text.x = element_text(size=10),
    axis.text.y = element_text(size=10),
    axis.title.x = element_text(size=12, face = "bold"),
    axis.title.y = element_text(size=12),
    legend.text = element_text(size=10),
    legend.title = element_text(size=12, face = "bold"),
    strip.text = element_text(face = "bold", size = 10),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey", size = 0.5),
    panel.grid.minor.y = element_line(color = "lightgrey", size = 0.25)
  )

prs_continuous_long <- prs_continuous_long %>%
  mutate(pattern = ifelse(JointPRS_version == version, "stripe", "none"))

prs_binary_long <- prs_binary_long %>%
  mutate(pattern = ifelse(JointPRS_version == version, "stripe", "none"))

## Bar Plot
p_GLGC = ggplot(data = prs_continuous_long[which(prs_continuous_long$trait %in% GLGC_trait),], aes(x = factor(s), y = r2, fill = version, pattern = pattern)) +
  geom_bar_pattern(position = position_dodge(width = 0.9),
                   stat = "identity",
                   color = "black", 
                   pattern_fill = "black",
                   pattern_angle = 45,
                   pattern_density = 0.1,
                   pattern_spacing = 0.025,
                   pattern_key_scale_factor = 0.6) +
  scale_pattern_manual(values = c(stripe = "stripe", none = "none"), 
                       labels = c("stripe" = "Selected", "none" = "Not selected")) +
  labs(x = "Cross-Validation Fold",
       y = "R²",
       fill = "JointPRS Version",
       pattern = "Version Selection") +
  facet_grid(pop ~ trait, scales = "free_x") +
  theme_classic() + 
  my_theme +
  scale_y_continuous(limits = c(NA, 0.35))

print(p_GLGC)

# same_cohort_JointPRS_version_compare_bar_plot_GLGC.png width 1350 height 1600

p_PAGE = ggplot(data = prs_continuous_long[which(prs_continuous_long$trait %in% PAGE_trait),], aes(x = factor(s), y = r2, fill = version, pattern = pattern)) +
  geom_bar_pattern(position = position_dodge(width = 0.9),
                   stat = "identity",
                   color = "black", 
                   pattern_fill = "black",
                   pattern_angle = 45,
                   pattern_density = 0.1,
                   pattern_spacing = 0.025,
                   pattern_key_scale_factor = 0.6) +
  scale_pattern_manual(values = c(stripe = "stripe", none = "none"), 
                       labels = c("stripe" = "Selected", "none" = "Not selected")) +
  labs(x = "Cross-Validation Fold",
       y = "R²",
       fill = "JointPRS Version",
       pattern = "Version Selection") +
  facet_wrap(pop ~ trait, scales = "free_x") +
  theme_classic() + 
  my_theme +
  scale_y_continuous(limits = c(NA, 0.35))

print(p_PAGE)

# same_cohort_JointPRS_version_compare_bar_plot_PAGE.png width 1350 height 1600

p_BBJ = ggplot(data = prs_continuous_long[which(prs_continuous_long$trait %in% BBJ_trait),], aes(x = factor(s), y = r2, fill = version, pattern = pattern)) +
  geom_bar_pattern(position = position_dodge(width = 0.9),
                   stat = "identity",
                   color = "black", 
                   pattern_fill = "black",
                   pattern_angle = 45,
                   pattern_density = 0.1,
                   pattern_spacing = 0.025,
                   pattern_key_scale_factor = 0.6) +
  scale_pattern_manual(values = c(stripe = "stripe", none = "none"), 
                       labels = c("stripe" = "Selected", "none" = "Not selected")) +
  labs(x = "Cross-Validation Fold",
       y = "R²",
       fill = "JointPRS Version",
       pattern = "Version Selection") +
  facet_wrap(pop ~ trait, nrow = 4, scales = "free_x") +
  theme_classic() + 
  my_theme +
  scale_y_continuous(limits = c(NA, 0.35))

print(p_BBJ)

# same_cohort_JointPRS_version_compare_bar_plot_BBJ.png width 1350 height 1600

p_Binary = ggplot(data = prs_binary_long[which(prs_binary_long$trait %in% Binary_trait),], aes(x = factor(s), y = r2, fill = version, pattern = pattern)) +
  geom_bar_pattern(position = position_dodge(width = 0.9),
                   stat = "identity",
                   color = "black", 
                   pattern_fill = "black",
                   pattern_angle = 45,
                   pattern_density = 0.1,
                   pattern_spacing = 0.025,
                   pattern_key_scale_factor = 0.6) +
  scale_pattern_manual(values = c(stripe = "stripe", none = "none"), 
                       labels = c("stripe" = "Selected", "none" = "Not selected")) +
  labs(x = "Cross-Validation Fold",
       y = "R²",
       fill = "JointPRS Version",
       pattern = "Version Selection") +
  facet_grid(pop ~ trait, scales = "free_x") +
  theme_classic() + 
  my_theme +
  scale_y_continuous(limits = c(NA, 1))

print(p_Binary)

# same_cohort_JointPRS_version_compare_bar_plot_Binary.png width 1350 height 1600
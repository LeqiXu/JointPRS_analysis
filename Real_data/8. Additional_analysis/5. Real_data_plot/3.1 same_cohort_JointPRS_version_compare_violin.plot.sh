## Load packages
library(data.table)
library(dplyr)
library(ggplot2)
library(ggpattern)
library(ggpubr)

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

prs_table = rbind(prs_continuous_table,prs_binary_table)
prs_table$select = ifelse(prs_table$JointPRS_version == "tune",prs_table$tune,prs_table$meta)

prs_table$meta_percentage = (prs_table$select - prs_table$meta) / prs_table$meta
prs_table$tune_percentage = (prs_table$select - prs_table$tune) / prs_table$tune

prs_compare_table = prs_table[,c("pop","meta_percentage","tune_percentage")]
colnames(prs_compare_table) = c("pop","Meta Version","Tune Version")

prs_long_compre_table <- melt(prs_compare_table, id.vars = c("pop"), variable.name = "version", value.name = "relative_change")

## Violin Plot
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

p_meta = ggplot(prs_compare_table, aes(x = pop, y = `Meta Version`, fill = pop)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  labs(title = "Relative improvement of JointPRS selected version over meta version", 
       x = "pop",
       y = expression(paste("R"^2, scriptstyle("Selected Version"), "/", "R"^2, scriptstyle("Meta Version"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1.5,1.5))

p_tune = ggplot(prs_compare_table, aes(x = pop, y = `Tune Version`, fill = pop)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  labs(title = "Relative improvement of JointPRS selected version over tune version", 
       x = "pop",
       y = expression(paste("R"^2, scriptstyle("Selected Version"), "/", "R"^2, scriptstyle("Tune Version"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1.5,1.5))

## combined plot
combined_plot_compare <- ggarrange(p_meta, p_tune, labels = c("a","b"), ncol = 1, nrow = 2)
print(combined_plot_compare)

# same_cohort_JointPRS_version_compare_violin_plot.png width 1350 height 1600
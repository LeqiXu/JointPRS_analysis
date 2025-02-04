## auto and tune method comparison
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
all_method_color = c("JointPRS" = "#B0003C",
"JointPRS-auto" = "#E65475", "XPASS" = "#FF8C00", "SDPRX" = "#fec44f","PRS-CSx-auto" = "#FDCAC7", 
"PRS-CSx" = "#006400","MUSSEL" = "#8FBC8F","PROSPER" = "#5E92F3","BridgePRS" = "#89CFF0")

auto_tune_combine_method = c("JointPRS")
auto_tune_combine_method_color = c("#B0003C")

auto_method = c("JointPRS-auto","XPASS","SDPRX","PRS-CSx-auto")
auto_method_color = c("#E65475","#FF8C00","#fec44f","#FDCAC7")

tune_method = c("PRS-CSx","MUSSEL","PROSPER","BridgePRS")
tune_method_color = c("#006400","#8FBC8F","#5E92F3","#89CFF0")

col_df = tibble(
  color = c(auto_tune_combine_method_color, auto_method_color, tune_method_color),
  method = factor(c(auto_tune_combine_method,auto_method,tune_method),
                  levels = c(auto_tune_combine_method,auto_method,tune_method)),
  category = case_when(method %in% auto_tune_combine_method ~ "Combine method",
                       method %in% auto_method ~ "Auto method",
                       method %in% tune_method ~ "tune method")
) %>% 
  mutate(category = factor(category,levels = c("Combine method","Auto method","tune method")))

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

getLegend <- function(p) {
  g <- ggplotGrob(p)
  k <- which(g$layout$name=="guide-box")
  g$grobs[[k]]
}

run_plot = function(filler, values) {
  values = col_df %>% 
    filter(category %in% filler)
  labels = values %>% 
    pull(method)
  values = values %>% pull(color)
  names(values) = labels
  ggplot(
    long_table %>% 
      filter(category %in% filler),
    aes(x= trait,y=mean_r2,
        group = method))+
    geom_bar(aes(fill = method),
             stat="identity",
             position = position_dodge())+
    theme_classic()+
    my_theme +
    xlab("Sample Size")+
    labs(fill = filler)+
    scale_fill_manual(values = values)
}

# Continuous plot
## Data preprocessing
prs_table = fread(paste0("PRS_update_same_cohort_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS_tune","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

## Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("pop", "trait"),
                   variable.name = "method", value.name = "r2")
long_table$trait = factor(long_table$trait, levels = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT"))
long_table$pop <- factor(long_table$pop, levels = c("EAS","AFR","SAS","AMR"))
long_table$method = factor(long_table$method, levels = c("JointPRS_tune","XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, trait, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

## Calcualte the relative change of other methods over JointPRS
JointPRS_ref <- long_table[long_table$method == "JointPRS_tune", c("pop", "trait", "mean_r2")]
colnames(JointPRS_ref)[3] <- "JointPRS_tune_mean_r2"
long_table_with_JointPRS  <- merge(long_table, JointPRS_ref, by = c("pop", "trait"))

long_table_with_JointPRS$relative_change <- with(long_table_with_JointPRS , 
                                                 (mean_r2 - JointPRS_tune_mean_r2) / JointPRS_tune_mean_r2)
long_table_with_JointPRS <- long_table_with_JointPRS [long_table_with_JointPRS $method != "JointPRS_tune",]
long_table_with_JointPRS <- long_table_with_JointPRS [,c("pop", "trait","method","relative_change")]
long_table_with_JointPRS$method = factor(long_table_with_JointPRS$method, levels = c("XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))

long_table_with_JointPRS = long_table_with_JointPRS %>% left_join(col_df)

## Plot for each cohort and pop
p_GLGC_EAS = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% GLGC_trait & long_table_with_JointPRS$pop == "EAS"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "GLGC traits",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_GLGC_AFR = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% GLGC_trait & long_table_with_JointPRS$pop == "AFR"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_GLGC_SAS = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% GLGC_trait & long_table_with_JointPRS$pop == "SAS"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

  
p_GLGC_AMR = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% GLGC_trait & long_table_with_JointPRS$pop == "AMR"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) + 
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_PAGE_EAS = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% PAGE_trait & long_table_with_JointPRS$pop == "EAS"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "PAGE traits",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_PAGE_AFR = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% PAGE_trait & long_table_with_JointPRS$pop == "AFR"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_BBJ_EAS = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$trait %in% BBJ_trait & long_table_with_JointPRS$pop == "EAS"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "BBJ traits",
       x = "",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

## Data preprocessing
prs_binary_table = fread(paste0("PRS_update_same_cohort_auc.csv"))
prs_binary_table = prs_binary_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_binary_table) = c("pop", "trait", "JointPRS_tune","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

## Reshape the data to a long format and estimate the mean and sd
long_binary_table <- melt(prs_binary_table, id.vars = c("pop", "trait"),
                   variable.name = "method", value.name = "auc")
long_binary_table$trait = factor(long_binary_table$trait, levels = c("T2D","BrC","CAD","LuC"))
long_binary_table$pop <- factor(long_binary_table$pop, levels = c("EAS","AFR"))
long_binary_table$method = factor(long_binary_table$method, levels = c("JointPRS_tune","XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))
long_binary_table$auc[which(long_binary_table$auc == 0)] = NA

long_binary_table <- long_binary_table %>%
  group_by(pop, trait, method) %>%
  summarise(
    mean_auc = mean(auc, na.rm = TRUE),
    sd_auc = sd(auc, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

Binary_trait =  c("T2D","BrC","CAD","LuC")

## Calcualte the relative change of other methods over JointPRS
JointPRS_binary_ref <- long_binary_table[long_binary_table$method == "JointPRS_tune", c("pop", "trait", "mean_auc")]
colnames(JointPRS_binary_ref)[3] <- "JointPRS_tune_mean_auc"
long_binary_table_with_JointPRS  <- merge(long_binary_table, JointPRS_binary_ref, by = c("pop", "trait"))

long_binary_table_with_JointPRS$relative_change <- with(long_binary_table_with_JointPRS , 
                                                 (mean_auc - JointPRS_tune_mean_auc) / JointPRS_tune_mean_auc)
long_binary_table_with_JointPRS <- long_binary_table_with_JointPRS [long_binary_table_with_JointPRS $method != "JointPRS_tune",]
long_binary_table_with_JointPRS <- long_binary_table_with_JointPRS [,c("pop", "trait","method","relative_change")]
long_binary_table_with_JointPRS$method = factor(long_binary_table_with_JointPRS$method, levels = c("XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))

long_binary_table_with_JointPRS = long_binary_table_with_JointPRS %>% left_join(col_df)

## Plot for each cohort and pop
p_Binary_EAS = ggplot(long_binary_table_with_JointPRS[which(long_binary_table_with_JointPRS$trait %in% Binary_trait & long_binary_table_with_JointPRS$pop == "EAS"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "Binary traits",
       x = "",
       y = expression(paste("AUC", "/", "AUC", scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-0.25,0.25))

p_Binary_AFR = ggplot(long_binary_table_with_JointPRS[which(long_binary_table_with_JointPRS$trait %in% Binary_trait & long_binary_table_with_JointPRS$pop == "AFR"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=1.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "",
       x = "",
       y = expression(paste("AUC", "/", "AUC", scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-0.25,0.25))

combined_plot_GLGC <- ggarrange(p_GLGC_EAS, p_GLGC_AFR, p_GLGC_SAS, p_GLGC_AMR,  ncol = 2, nrow = 2)
combined_plot_PAGE <- ggarrange(p_PAGE_EAS, p_PAGE_AFR, ncol = 2, nrow = 1)
combined_plot_BBJ <- ggarrange(p_BBJ_EAS, ncol = 1, nrow = 1)
combined_binary_plot = ggarrange(p_Binary_EAS, p_Binary_AFR, ncol = 2, nrow = 1)

combined_plot = ggarrange(combined_plot_GLGC,combined_plot_PAGE,combined_plot_BBJ,combined_binary_plot, ncol = 1, nrow = 4, heights = c(1, 0.5, 0.5,0.5), labels = c("a","b","c","d"))
print(combined_plot)
# same_cohort_PRS_violin_plot.png width 1350 height 1600

print(combined_plot_GLGC)
# same_cohort_PRS_violin_GLGC_plot.png width 1350 height 800

print(combined_plot_PAGE)
# same_cohort_PRS_violin_PAGE_plot.png width 1350 height 800

print(combined_plot_BBJ)
# same_cohort_PRS_violin_BBJ_plot.png width 1350 height 800

print(combined_binary_plot)
# same_cohort_PRS_violin_Binary_plot.png width 1350 height 800
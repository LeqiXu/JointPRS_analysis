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
                       method %in% tune_method ~ "Tune method")
) %>% 
  mutate(category = factor(category,levels = c("Combine method","Auto method","Tune method")))

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
prs_table = fread(paste0("PRS_update_same_cohort_EUR_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

## Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("pop", "trait"),
                   variable.name = "method", value.name = "r2")
long_table$trait = factor(long_table$trait, levels = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT"))
long_table$pop <- factor(long_table$pop, levels = c("EUR","EAS","AFR","SAS","AMR"))
long_table$method = factor(long_table$method, levels = c("JointPRS","XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, trait, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

GLGC_trait = c("HDL","LDL","TC","logTG")

## Find best and second best method for each table
long_table <- long_table %>%
  group_by(trait, pop) %>%
  arrange(desc(mean_r2)) %>%
  mutate(rank = row_number()) %>%
  ungroup() %>%
  mutate(annotation = case_when(
    rank == 1 ~ "**",  # Best method
    rank == 2 ~ "*",   # Second best method
    TRUE ~ ""          # Others
  ))

long_table = long_table %>% left_join(col_df)

## Obtain the legend and plot
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  legs[[2]],
                  legs[[3]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3,0.3,0.3))

p_GLGC <- ggplot(long_table[which(long_table$trait %in% GLGC_trait),], aes(x = pop, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 5) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "Auto method") +
  facet_wrap(~ trait, ncol = 1, scales = "free_x") +
  labs(title = "GLGC traits",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 0.25))

combined_plot <- ggarrange(p_GLGC, p.leg, 
                           ncol = 2, widths = c(0.8,0.2))

# Render the combined plot
grid.draw(combined_plot)

grid.text("**", 
          x = unit(0.84, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Best Method", 
          x = unit(0.895, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

grid.text("*", 
          x = unit(0.84, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Second Best Method", 
          x = unit(0.923, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

# same_cohort_GLGC_EUR_PRS_bar_plot.png width 1350 height 1600
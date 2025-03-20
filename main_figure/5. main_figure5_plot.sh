## Figure5: no_val_PRS_bar_plot.png 13cm width X 15.5cm height (600dpi)
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
  color = auto_method_color,
  method = factor(c(auto_method),
                  levels = c(auto_method)),
  category = case_when(method %in% auto_method ~ "Auto method")
) %>% 
  mutate(category = factor(category,levels = c("Auto method")))

my_theme <- theme(
    plot.title = element_text(size = 6, face = "bold"),  # Smaller title
    text = element_text(size = 6),  # Slightly smaller general text
    axis.text.x = element_text(size = 5),  
    axis.text.y = element_text(size = 5),  # Smaller y-axis text
    axis.title.x = element_text(size = 6, face = "bold"),  # Smaller x-axis title
    axis.title.y = element_text(size = 6),  # Smaller y-axis title
    legend.text = element_text(size = 5),  # Smaller legend text
    legend.title = element_text(size = 6, face = "bold"),  # Smaller legend title
    strip.text = element_text(face = "bold", size = 4.5),  # Smaller facet labels
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_line(color = "grey", size = 0.25),  # Lighter grid lines
    panel.grid.minor.y = element_line(color = "lightgrey", size = 0.2)  # Even thinner minor grid lines
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
    aes(x= trait,y=r2,
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

# Data preprocessing
# Continuous plot
## Data preprocessing
prs_table = fread(paste0("PRS_no_val_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")

## Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("pop", "trait"),
                   variable.name = "method", value.name = "r2")
long_table$trait = factor(long_table$trait, levels = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT"))
long_table$pop <- factor(long_table$pop, levels = c("EAS","AFR","SAS","AMR"))
long_table$method = factor(long_table$method, levels = c("JointPRS-auto","XPASS","SDPRX","PRS-CSx-auto"))
long_table$r2[which(long_table$r2 == 0)] = NA

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

## Find best and second best method for each table
long_table <- long_table %>%
  group_by(trait, pop) %>%
  arrange(desc(r2)) %>%
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
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3))

p_GLGC <- ggplot(long_table[which(long_table$trait %in% GLGC_trait),], aes(x = trait, y = r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 2) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(~ pop, scales = "free_x", space = "free_x") +
  labs(title = "GLGC traits",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 0.25))

p_PAGE <- ggplot(long_table[which(long_table$trait %in% PAGE_trait),], aes(x = trait, y = r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 2) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(~ pop, scales = "free_x", space = "free_x") +
  labs(title = "PAGE traits",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 0.25))

p_BBJ <- ggplot(long_table[which(long_table$trait %in% BBJ_trait),], aes(x = trait, y = r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 2) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(~ pop, scales = "free_x", space = "free_x") +
  labs(title = "BBJ traits",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 0.25))

# Binary plot
## Data preprocessing
prs_binary_table = fread(paste0("PRS_no_val_auc.csv"))
prs_binary_table = prs_binary_table[,c("pop", "trait", "JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_binary_table) = c("pop", "trait", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")

## Reshape the data to a long format and estimate the mean and sd
long_binary_table <- melt(prs_binary_table, id.vars = c("pop", "trait"),
                   variable.name = "method", value.name = "auc")
long_binary_table$trait = factor(long_binary_table$trait, levels = c("T2D","BrC","CAD","LuC"))
long_binary_table$pop <- factor(long_binary_table$pop, levels = c("EAS","AFR"))
long_binary_table$method = factor(long_binary_table$method, levels = c("JointPRS-auto","XPASS","SDPRX","PRS-CSx-auto"))
long_binary_table$auc[which(long_binary_table$auc == 0)] = NA

Binary_trait =  c("T2D","BrC","CAD","LuC")

## Find best and second best method for each table
long_binary_table <- long_binary_table %>%
  group_by(trait, pop) %>%
  arrange(desc(auc)) %>%
  mutate(rank = row_number()) %>%
  ungroup() %>%
  mutate(annotation = case_when(
    rank == 1 ~ "**",  # Best method
    rank == 2 ~ "*",   # Second best method
    TRUE ~ ""          # Others
  ))

long_binary_table = long_binary_table %>% left_join(col_df)

## Obtain the plot
p_Binary <- ggplot(long_binary_table[which(long_binary_table$trait %in% Binary_trait),], aes(x = trait, y = auc, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 2) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(~ pop, scales = "free_x", space = "free_x") +
  labs(title = "Binary traits",
       x = "",
       y = "AUC") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 1)) +
  scale_x_discrete(labels = c("T2D" = "T2D", "BrC" = "Breast Cancer", "CAD" = "CAD", "LuC" = "Lung Cancer"))

# Combined plot
combined_plot <- ggarrange(ggarrange(p_GLGC,p_PAGE,p_BBJ,p_Binary,
                           nrow = 4,
                           labels = c("a","b","c","d"),
                           font.label = list(size = 7, face = "bold"),
                           heights = c(1/4,1/4,1/4,1/4)), 
                           p.leg, 
                           ncol = 2, widths = c(0.8,0.2))

# Render the combined plot
grid.draw(combined_plot)

ggsave("no_val_PRS_bar_plot.png", plot = combined_plot, width = 13, height = 15.5, dpi = 600, units = "cm", bg = "white")

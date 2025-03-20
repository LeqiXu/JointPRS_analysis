## Figure3: sim_PRS_auto_bar_plot.png 13cm width X 15.5cm height (600dpi)
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

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/")

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
    axis.text.x = element_blank(),  # No x-axis text
    axis.ticks.x = element_blank(),  # No x-axis ticks
    axis.text.y = element_text(size = 5),  # Smaller y-axis text
    axis.title.x = element_text(size = 6, face = "bold"),  # Smaller x-axis title
    axis.title.y = element_text(size = 6),  # Smaller y-axis title
    legend.text = element_text(size = 5),  # Smaller legend text
    legend.title = element_text(size = 6, face = "bold"),  # Smaller legend title
    strip.text = element_text(face = "bold", size = 5),  # Smaller facet labels
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
    aes(x= minor_sample,y=mean_r2,
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
prs_table = fread(paste0("sim_PRS_real_auto_no_val_r2.csv"))
prs_table = prs_table[,c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5","PRScsx_auto_5","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("n", "pop", "p", "rho", "sample2", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")

prs_table = prs_table %>% 
  mutate(minor_sample = case_when(sample2 == "15K" ~ "15,000",
                                  sample2 == "80K" ~ "80,000"))

# Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2","minor_sample"),
                   variable.name = "method", value.name = "r2")
long_table$p <- factor(long_table$p, levels = c(0.1, 0.01, 0.001, 5e-04))
levels(long_table$p) <- c("0.1", "0.01", "0.001", "5 × 10⁻⁴")
long_table$pop <- factor(long_table$pop, levels = c("EAS", "AFR", "SAS", "AMR"))
long_table$method = factor(long_table$method, levels = c("JointPRS-auto","XPASS","SDPRX","PRS-CSx-auto"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, minor_sample, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

# Find best and second best method for each table
long_table <- long_table %>%
  group_by(minor_sample, p, pop) %>%
  arrange(desc(mean_r2)) %>%
  mutate(rank = row_number()) %>%
  ungroup() %>%
  mutate(annotation = case_when(
    rank == 1 ~ "**",  # Best method
    rank == 2 ~ "*",   # Second best method
    TRUE ~ ""          # Others
  ))

long_table = long_table %>% left_join(col_df)

# Define the labeller for the 'p' values
p_label <- as_labeller(c(`0.1` = " p = 0.1", `0.01` = "p = 0.01", `0.001` = "p = 0.001", `5 × 10⁻⁴` = "p = 5 × 10⁻⁴"))

# Obtain the legend and plot
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3))

p_15K <- ggplot(long_table[which(long_table$minor_sample == "15,000"),], aes(x = minor_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 3) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(p ~ pop, scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "Non-European Population Training Sample Size = 15,000",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none", axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  scale_y_continuous(limits = c(NA, 0.41))

p_80K <- ggplot(long_table[which(long_table$minor_sample == "80,000"),], aes(x = minor_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", size = 0.3) +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 3) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(p ~ pop, scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "Non-European Population Training Sample Size = 80,000",
       x = "",
       y = "R²") +
  theme_classic() +
  my_theme + 
  theme(legend.position = "none", axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  scale_y_continuous(limits = c(NA, 0.41))


# Combined plot
combined_plot <- ggarrange(ggarrange(p_80K, p_15K, 
                           nrow = 2,
                           labels = c("a", "b"),
                           font.label = list(size = 7, face = "bold"),
                           heights = c(0.5,0.5)), 
                           p.leg, 
                           ncol = 2, widths = c(0.8,0.2))

# Render the combined plot
grid.draw(combined_plot)

ggsave("sim_PRS_auto_bar_plot.png", plot = combined_plot, width = 13, height = 15.5, dpi = 600, units = "cm", bg = "white")

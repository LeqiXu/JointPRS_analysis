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

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/")

# Fixed plot value
auto_method = c("JointPRS_popcorn","JointPRS-auto","SDPRX")
auto_method_color = c("grey","#E65475","#fec44f")

col_df = tibble(
  color = auto_method_color,
  method = factor(c(auto_method),
                  levels = c(auto_method)),
  category = case_when(method %in% auto_method ~ "Auto method")
) %>% 
  mutate(category = factor(category,levels = c("Auto method")))

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
prs_table = fread(paste0("sim_PRS_real_auto_no_val_JointPRS_popcorn_r2.csv"))
prs_table = prs_table[,c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5","SDPRX_auto_2","JointPRS_popcorn_auto_2")]
colnames(prs_table) = c("n", "pop", "p", "rho", "sample2", "JointPRS-auto","SDPRX","JointPRS_popcorn")

prs_table = prs_table %>% 
  mutate(minor_sample = case_when(sample2 == "15K" ~ "15,000",
                                  sample2 == "80K" ~ "80,000"))

# Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2","minor_sample"),
                   variable.name = "method", value.name = "r2")
long_table$p <- factor(long_table$p, levels = c(0.1, 0.01, 0.001, 5e-04))
levels(long_table$p) <- c("0.1", "0.01", "0.001", "5 × 10⁻⁴")
long_table$pop <- factor(long_table$pop, levels = c("EAS", "AFR", "SAS", "AMR"))
long_table$method = factor(long_table$method, levels = c("JointPRS_popcorn","JointPRS-auto","SDPRX"))
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

p_15K <- ggplot(long_table, aes(x = minor_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 5) +  # Bold stars
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(p ~ pop, scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "Non-European Population Training Sample Size = 15,000",
       x = "",
       y = "R²") +
  theme_classic() + 
  my_theme + 
  theme(legend.position = "none", axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  scale_y_continuous(limits = c(NA, 0.41))


# Render the p_15K plot
grid.draw(ggarrange(p_15K, p.leg, 
                    ncol = 2, widths = c(0.8,0.2)))

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

# sim_PRS_auto_bar_p_15K_JointPRS_popcorn_plot.png width 1350 height 800
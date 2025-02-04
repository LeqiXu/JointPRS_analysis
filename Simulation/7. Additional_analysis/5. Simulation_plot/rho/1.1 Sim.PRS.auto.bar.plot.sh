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
all_method_color = c("JointPRS" = "#B0003C",
"JointPRS-auto" = "#E65475","PRS-CSx-auto" = "#FDCAC7", "SDPRX" = "#FF8C00","XPASS" = "#fec44f",
"PRS-CSx" = "#006400","MUSSEL" = "#8FBC8F","PROSPER" = "#5E92F3","BridgePRS" = "#89CFF0")

auto_tune_combine_method = c("JointPRS")
auto_tune_combine_method_color = c("#B0003C")

auto_method = c("JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")
auto_method_color = c("#E65475","#FDCAC7","#FF8C00","#fec44f")

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
prs_table = fread(paste0("sim_PRS_real_auto_no_val_multi_rho_r2.csv"))
prs_table = prs_table[,c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5","PRScsx_auto_5")]
colnames(prs_table) = c("n", "pop", "p", "rho", "sample2", "JointPRS-auto","PRS-CSx-auto")

# Comparing EUR and AFR
prs_afr = prs_table[pop == "AFR"]
prs_eur = prs_table[pop == "EUR"]

merged_table = merge(prs_afr, prs_eur, by = c("n","p","rho","sample2"), suffixes = c("_AFR", "_EUR"))

merged_table[, `JointPRS_ratio` := `JointPRS-auto_AFR` / `JointPRS-auto_EUR`]
merged_table[, `PRS-CSx_ratio` := `PRS-CSx-auto_AFR` / `PRS-CSx-auto_EUR`]

mean_ratios = merged_table[, .(`Mean_JointPRS_ratio` = mean(`JointPRS_ratio`),
                               `Mean_PRS-CSx_ratio` = mean(`PRS-CSx_ratio`)), 
                           by = .(p, rho, sample2)]

# All bar plot
prs_table = prs_table %>% 
  mutate(minor_sample = case_when(sample2 == "80K" ~ "80,000"))

# Reshape the data to a long format and estimate the mean and sd
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2","minor_sample"),
                   variable.name = "method", value.name = "r2")
long_table$rho <- factor(long_table$rho, levels = c(0, 0.2, 0.4, 0.6,0.8))
long_table$pop <- factor(long_table$pop, levels = c("AFR", "AMR", "EAS", "EUR", "SAS"))
long_table$method = factor(long_table$method, levels = c("JointPRS-auto","PRS-CSx-auto"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, minor_sample, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

long_table = long_table %>% left_join(col_df)

# Obtain the legend and plot
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3))

p_label <- as_labeller(c(`0.1` = " p = 0.1", `0.01` = "p = 0.01", `0.001` = "p = 0.001", `5 × 10⁻⁴` = "p = 5 × 10⁻⁴"))

p_80K <- ggplot(long_table, aes(x = rho, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  scale_fill_manual(values = auto_method_color, name = "Auto method") +
  facet_grid(p~ pop, scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "Non-European Population Training Sample Size = 80,000",
       x = "True Genetic Correlation",
       y = "R²") +
  theme_classic() +
  my_theme + 
  theme(legend.position = "none") +
  scale_y_continuous(limits = c(NA, 0.2))



# Render the p_80K plot
grid.draw(ggarrange(p_80K, p.leg, 
                    ncol = 2, widths = c(0.8,0.2)))


# sim_PRS_auto_bar_p_80K_multi_rho_plot.png width 1350 height 800
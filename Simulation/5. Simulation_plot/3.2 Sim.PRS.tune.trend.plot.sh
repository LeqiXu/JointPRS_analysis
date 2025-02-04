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
  color = c(auto_tune_combine_method_color, auto_method_color, tune_method_color),
  method = factor(c(auto_tune_combine_method,auto_method,tune_method),
                  levels = c(auto_tune_combine_method,auto_method,tune_method)),
  category = case_when(method %in% auto_tune_combine_method ~ "Combine method",
                       method %in% auto_method ~ "Auto method",
                       method %in% tune_method ~ "Tune method")
) %>% 
  mutate(category = factor(category,levels = c("Combine method","Auto method","Tune method")))

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
    panel.grid.minor.y = element_line(color = "lightgrey", size = 0.35)
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
prs_table_auto = fread(paste0("sim_PRS_real_auto_r2.csv"))
prs_table_tune = fread(paste0("sim_PRS_update_real_tune_r2.csv"))

prs_table_auto = prs_table_auto[,c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table_auto) = c("n", "pop", "p", "rho", "sample2", "JointPRS_auto","SDPRX","XPASS")
prs_table_tune = prs_table_tune[,c("n", "pop", "p", "rho", "sample2","val_sample","choose_JointPRS_tune_5","JointPRS_tune_5","PRScsx_tune_5","PROSPER_tune_5","MUSSEL_tune_5","BridgePRS_tune_2")]
colnames(prs_table_tune) = c("n", "pop", "p", "rho", "sample2","val_sample","choose_JointPRS_linear","JointPRS_linear","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

prs_table_auto <- prs_table_auto %>%
  mutate(val_sample = case_when(sample2 %in% c("15K","80K") ~ "0.5K",
                                sample2 %in% c("20K","85K") ~ "5K",
                                sample2 %in% c("25K","90K") ~ "10K"))
prs_table_auto_extra <- prs_table_auto[sample2 %in% c("15K","80K"), ]
prs_table_auto_extra$val_sample <- "2K"
prs_table_auto <- rbind(prs_table_auto, prs_table_auto_extra)
update_sample2 <- function(data) {
  data$sample2[data$sample2 %in% c("20K", "25K")] <- "15K"
  data$sample2[data$sample2 %in% c("85K", "90K")] <- "80K"
  return(data)
}
prs_table_auto <- update_sample2(prs_table_auto)
prs_table <- merge(prs_table_auto, prs_table_tune, 
                   by = c("n", "pop", "p", "rho", "sample2","val_sample"), 
                   all = TRUE) 

prs_table = prs_table %>% 
  mutate(minor_sample = case_when(sample2 == "15K" ~ "15,000",
                                  sample2 == "80K" ~ "80,000"),
         minor_val_sample = case_when(val_sample == "0.5K" ~ "500",
                                      val_sample == "2K" ~ "2,000",
                                      val_sample == "5K" ~ "5,000",
                                      val_sample == "10K" ~ "10,000"))

# Decide JointPRS based on the tuning result
prs_table$JointPRS = ifelse(prs_table$choose_JointPRS_linear == "yes",prs_table$JointPRS_linear,prs_table$JointPRS_auto)
prs_table <- prs_table %>%
  select(-JointPRS_auto, -choose_JointPRS_linear, -JointPRS_linear)

# Reshape the data to a long format
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2","minor_sample","val_sample","minor_val_sample"),
                   variable.name = "method", value.name = "r2")
long_table$p <- factor(long_table$p, levels = c(0.1, 0.01, 0.001, 5e-04))
levels(long_table$p) <- c("0.1", "0.01", "0.001", "5 × 10⁻⁴")
long_table$minor_val_sample <- factor(long_table$minor_val_sample, levels = c("500","2,000","5,000","10,000"))
long_table$pop <- factor(long_table$pop, levels = c("EAS", "AFR", "SAS", "AMR"))
long_table$method = factor(long_table$method, levels = c("XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS","JointPRS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, minor_sample,val_sample,minor_val_sample, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

# Find best and second best method for each table
long_table = long_table %>% left_join(col_df)

# Define the labeller for the 'p' values
p_label <- as_labeller(c(`0.1` = " p = 0.1", `0.01` = "p = 0.01", `0.001` = "p = 0.001", `5 × 10⁻⁴` = "p = 5 × 10⁻⁴"))

# Obtain the legend and plot
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  legs[[2]],
                  legs[[3]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3,0.3,0.3))

# Plotting trend plots
plot_trends <- function(data, sample_size, pop) {
  subdata = data[which(data$minor_sample == sample_size & data$pop == pop),]
  ggplot(subdata, 
         aes(x = minor_val_sample, y = mean_r2, group = method, color = method)) +
    geom_line(size = 1) +  # Add transparency to lines
    geom_point(size = 1.5) +  # Add transparency to points
    scale_color_manual(values = all_method_color) +
    facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) + 
    labs(title = paste(pop, "Training Sample Size =", sample_size),
         x = paste(pop, "Tuning Sample Size"),
         y = expression(R^2)) +
    theme_classic() + 
    theme(legend.position = "none") +
    scale_y_continuous(limits = c(NA, 0.41)) + 
    my_theme
}

# Generate plots for each combination of sample size, population, and p-values
trend_plots <- list()
for (sample_size in c("15,000", "80,000")) {
  for (pop in c("EAS", "AFR", "SAS", "AMR")) {
      trend_plots[[paste(sample_size, pop)]] <- plot_trends(long_table, sample_size, pop)
  }
}

# Arrange and plot
EAS_plot <- ggarrange(ggarrange(trend_plots[["80,000 EAS"]],trend_plots[["15,000 EAS"]],
            ncol = 2, nrow = 1, labels = c("a","b")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

AFR_plot <- ggarrange(ggarrange(trend_plots[["80,000 AFR"]],trend_plots[["15,000 AFR"]],
            ncol = 2, nrow = 1, labels = c("a","b")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

SAS_plot <- ggarrange(ggarrange(trend_plots[["80,000 SAS"]],trend_plots[["15,000 SAS"]],
            ncol = 2, nrow = 1, labels = c("a","b")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

AMR_plot <- ggarrange(ggarrange(trend_plots[["80,000 AMR"]],trend_plots[["15,000 AMR"]],
            ncol = 2, nrow = 1, labels = c("a","b")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

print(EAS_plot)
# sim_PRS_tune_trend_plot_EAS.png width 1600 height 1000

print(AFR_plot)
# sim_PRS_tune_trend_plot_AFR.png width 1600 height 1000

print(SAS_plot)
# sim_PRS_tune_trend_plot_SAS.png width 1600 height 1000

print(AMR_plot)
# sim_PRS_tune_trend_plot_AMR.png width 1600 height 1000
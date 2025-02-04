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
long_table$method = factor(long_table$method, levels = c("JointPRS","XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, minor_sample,val_sample,minor_val_sample, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

# Find best and second best method for each table
long_table <- long_table %>%
  group_by(minor_sample, val_sample, p, pop) %>%
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
                  legs[[2]],
                  legs[[3]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3,0.3,0.3))

p_15K_EAS_highp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "EAS" & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "EAS Training Sample Size = 15,000",
       x = "EAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_EAS_lowp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "EAS" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "EAS Training Sample Size = 15,000",
       x = "EAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_EAS_highp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "EAS" & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "EAS Training Sample Size = 80,000",
       x = "EAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_EAS_lowp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "EAS" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "EAS Training Sample Size = 80,000",
       x = "EAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_AFR_highp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "AFR" & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AFR Training Sample Size = 15,000",
       x = "AFR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_AFR_lowp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "AFR" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AFR Training Sample Size = 15,000",
       x = "AFR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_AFR_highp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "AFR"  & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AFR Training Sample Size = 80,000",
       x = "AFR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_AFR_lowp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "AFR" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AFR Training Sample Size = 80,000",
       x = "AFR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_SAS_highp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "SAS"  & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "SAS Training Sample Size = 15,000",
       x = "SAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_SAS_lowp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "SAS" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "SAS Training Sample Size = 15,000",
       x = "SAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_SAS_highp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "SAS"  & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "SAS Training Sample Size = 80,000",
       x = "SAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_SAS_lowp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "SAS" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "SAS Training Sample Size = 80,000",
       x = "SAS Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_AMR_highp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "AMR"  & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AMR Training Sample Size = 15,000",
       x = "AMR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_15K_AMR_lowp <- ggplot(long_table[which(long_table$minor_sample == "15,000" & long_table$pop == "AMR" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AMR Training Sample Size = 15,000",
       x = "AMR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_AMR_highp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "AMR"  & long_table$p %in% c("0.1","0.01")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AMR Training Sample Size = 80,000",
       x = "AMR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

p_80K_AMR_lowp <- ggplot(long_table[which(long_table$minor_sample == "80,000" & long_table$pop == "AMR" & long_table$p %in% c("0.001","5 × 10⁻⁴")),], aes(x = minor_val_sample, y = mean_r2, group = method, fill = method)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  geom_text(aes(label = annotation), vjust = 0, position = position_dodge(width = 0.9), color = "red", fontface = "bold", size = 4) +  # Bold stars
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(p ~ pop , scales = "free_x", space = "free_x", labeller = labeller(p = p_label)) +
  labs(title = "AMR Training Sample Size = 80,000",
       x = "AMR Tuning Sample Size",
       y = "R²") +
  theme_classic() + 
  theme(legend.position = "none") +
  my_theme + 
  scale_y_continuous(limits = c(NA, 0.41))

# Combined plot 15K
combined_plot_15K_highp <- ggarrange(ggarrange(p_15K_EAS_highp, p_15K_AFR_highp, 
            p_15K_SAS_highp, p_15K_AMR_highp, 
            ncol = 1, nrow = 4, labels = c("a","b","c","d")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

combined_plot_15K_lowp <- ggarrange(ggarrange(p_15K_EAS_lowp, p_15K_AFR_lowp, 
            p_15K_SAS_lowp, p_15K_AMR_lowp, 
            ncol = 1, nrow = 4, labels = c("a","b","c","d")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

# Render the combined plot
grid.draw(combined_plot_15K_highp)

grid.text("**", 
          x = unit(0.82, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Best Method", 
          x = unit(0.88, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

grid.text("*", 
          x = unit(0.82, "npc"), y = unit(0.80, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Second Best Method", 
          x = unit(0.91, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

# sim_PRS_tune_bar_plot_15K_highp.png width 1350 height 1600

grid.draw(combined_plot_15K_lowp)

grid.text("**", 
          x = unit(0.82, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Best Method", 
          x = unit(0.88, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

grid.text("*", 
          x = unit(0.82, "npc"), y = unit(0.80, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Second Best Method", 
          x = unit(0.91, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

# sim_PRS_tune_bar_plot_15K_lowp.png width 1350 height 1600

# Combined plot 80K
combined_plot_80K_highp <- ggarrange(ggarrange(p_80K_EAS_highp, p_80K_AFR_highp, 
            p_80K_SAS_highp, p_80K_AMR_highp, 
            ncol = 1, nrow = 4, labels = c("a","b","c","d")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

combined_plot_80K_lowp <- ggarrange(ggarrange(p_80K_EAS_lowp, p_80K_AFR_lowp, 
            p_80K_SAS_lowp, p_80K_AMR_lowp, 
            ncol = 1, nrow = 4, labels = c("a","b","c","d")),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))

# Render the combined plot
grid.draw(combined_plot_80K_highp)

grid.text("**", 
          x = unit(0.82, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Best Method", 
          x = unit(0.88, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

grid.text("*", 
          x = unit(0.82, "npc"), y = unit(0.80, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Second Best Method", 
          x = unit(0.91, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

# sim_PRS_tune_bar_plot_80K_highp.png width 1350 height 1600

grid.draw(combined_plot_80K_lowp)

grid.text("**", 
          x = unit(0.82, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Best Method", 
          x = unit(0.88, "npc"), y = unit(0.82, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

grid.text("*", 
          x = unit(0.82, "npc"), y = unit(0.80, "npc"), 
          gp = gpar(col = "red", fontsize = 14))

grid.text("Second Best Method", 
          x = unit(0.91, "npc"), y = unit(0.8, "npc"), 
          gp = gpar(col = "black", fontsize = 14))

# sim_PRS_tune_bar_plot_80K_lowp.png width 1350 height 1600
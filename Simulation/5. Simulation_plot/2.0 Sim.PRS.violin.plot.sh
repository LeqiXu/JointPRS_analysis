## no_val figure
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
all_method_color = c("XPASS" = "#FF8C00", "SDPRX" = "#fec44f","PRS-CSx-auto" = "#FDCAC7", 
"PRS-CSx" = "#006400","MUSSEL" = "#8FBC8F","PROSPER" = "#5E92F3","BridgePRS" = "#89CFF0")

auto_method = c("XPASS","SDPRX","PRS-CSx-auto")
auto_method_color = c("#FF8C00","#fec44f","#FDCAC7")

tune_method = c("PRS-CSx","MUSSEL","PROSPER","BridgePRS")
tune_method_color = c("#006400","#8FBC8F","#5E92F3","#89CFF0")

col_df = tibble(
  color = c(auto_method_color),
  method = factor(c(auto_method),
                  levels = c(auto_method)),
  category = case_when(method %in% auto_method ~ "Auto method")
) %>% 
  mutate(category = factor(category,levels = c("Auto method")))

my_theme <- theme(
    plot.title = element_text(size=16, face = "bold"),
    text = element_text(size=16),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
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
    long_table_with_JointPRS %>% 
      filter(category %in% filler),
    aes(x= minor_sample,y=relative_change,
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

JointPRS_ref <- long_table[long_table$method == "JointPRS-auto", c("pop", "p", "rho", "sample2", "minor_sample", "mean_r2")]
colnames(JointPRS_ref)[6] <- "JointPRS_auto_mean_r2"
long_table_with_JointPRS <- merge(long_table, JointPRS_ref, by = c("pop", "p", "rho", "sample2", "minor_sample"))

long_table_with_JointPRS$relative_change <- with(long_table_with_JointPRS, 
                                                 (mean_r2 - JointPRS_auto_mean_r2) / JointPRS_auto_mean_r2)
long_table_with_JointPRS <- long_table_with_JointPRS[long_table_with_JointPRS$method != "JointPRS-auto",]
long_table_with_JointPRS <- long_table_with_JointPRS[,c("pop", "p", "rho", "sample2", "minor_sample", "method", "relative_change")]
long_table_with_JointPRS$method = factor(long_table_with_JointPRS$method, levels = c("XPASS","SDPRX","PRS-CSx-auto"))

long_table_with_JointPRS = long_table_with_JointPRS %>% left_join(col_df)

# Plotting
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3))

p_15K = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$minor_sample == "15,000"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=0.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "Non-European Population Training Sample Size = 15,000",
       x = "Method",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS-auto"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_80K = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$minor_sample == "80,000"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.8), 
             color="black", size=0.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "Non-European Population Training Sample Size = 80,000",
       x = "Method",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS-auto"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

combined_plot_noval = ggarrange(ggarrange(p_80K,p_15K,
            ncol = 1, nrow = 2),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))
print(combined_plot_noval)


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
all_method_color = c("PRS-CSx-auto" = "#FDCAC7", "SDPRX" = "#FF8C00","XPASS" = "#fec44f",
"PRS-CSx" = "#006400","MUSSEL" = "#8FBC8F","PROSPER" = "#5E92F3","BridgePRS" = "#89CFF0")

auto_method = c("JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")
auto_method_color = c("#E65475","#FDCAC7","#FF8C00","#fec44f")

tune_method = c("PRS-CSx","MUSSEL","PROSPER","BridgePRS")
tune_method_color = c("#006400","#8FBC8F","#5E92F3","#89CFF0")

col_df = tibble(
  color = c(auto_method_color, tune_method_color),
  method = factor(c(auto_method,tune_method),
                  levels = c(auto_method,tune_method)),
  category = case_when(method %in% auto_method ~ "Auto method",
                       method %in% tune_method ~ "Tune method")
) %>% 
  mutate(category = factor(category,levels = c("Auto method","Tune method")))

my_theme <- theme(
    plot.title = element_text(size=16, face = "bold"),
    text = element_text(size=16),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
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
    long_table_with_JointPRS %>% 
      filter(category %in% filler),
    aes(x= minor_sample,y=relative_change,
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

JointPRS_ref <- long_table[long_table$method == "JointPRS", c("pop", "p", "rho", "sample2", "minor_sample", "mean_r2")]
colnames(JointPRS_ref)[6] <- "JointPRS_auto_mean_r2"
long_table_with_JointPRS <- merge(long_table, JointPRS_ref, by = c("pop", "p", "rho", "sample2", "minor_sample"))

long_table_with_JointPRS$relative_change <- with(long_table_with_JointPRS, 
                                                 (mean_r2 - JointPRS_auto_mean_r2) / JointPRS_auto_mean_r2)
long_table_with_JointPRS <- long_table_with_JointPRS[long_table_with_JointPRS$method != "JointPRS",]
long_table_with_JointPRS <- long_table_with_JointPRS[,c("pop", "p", "rho", "sample2", "minor_sample", "method", "relative_change")]
long_table_with_JointPRS$method = factor(long_table_with_JointPRS$method, levels = c("XPASS","SDPRX","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))

long_table_with_JointPRS = long_table_with_JointPRS %>% left_join(col_df)

# Plotting
legs = lapply(sort(unique(col_df$category)), run_plot)
legs = lapply(legs, getLegend)
p.leg = plot_grid(NULL,
                  legs[[1]],
                  legs[[2]],
                  NULL,
                  align="v",ncol=1,
                  rel_heights=c(0.3,0.3))

p_15K = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$minor_sample == "15,000"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.5), 
             color="black", size=0.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "Non-European Population Training Sample Size = 15,000",
       x = "Method",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

p_80K = ggplot(long_table_with_JointPRS[which(long_table_with_JointPRS$minor_sample == "80,000"),],
                  aes(x = method, y = relative_change, group = method, fill = method)) +
  geom_violin(trim=TRUE, position=position_dodge(width=0.8), color="white", adjust=1.5, scale="area") +
  geom_point(aes(group=pop), position=position_jitterdodge(jitter.width = 0, dodge.width=0.5), 
             color="black", size=0.5, alpha=0.6) +
  stat_summary(fun=mean, geom="crossbar", width=0.2, 
               position=position_dodge(width=0.8), color = alpha("black", alpha=0.6)) +
  geom_hline(yintercept = 0, linetype = "solid", color = alpha("darkred", alpha=0.5), size = 1) +
  scale_fill_manual(values = all_method_color, name = "All method") +
  facet_grid(~ pop) +
  labs(title = "Non-European Population Training Sample Size = 80,000",
       x = "Method",
       y = expression(paste("R"^2, "/", "R"^2, scriptstyle("JointPRS"), "-1"))) +
  theme_classic() +
  my_theme +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(-1,1))

combined_plot_val = ggarrange(ggarrange(p_80K,p_15K, 
            ncol = 1, nrow = 2),
            p.leg, 
            ncol = 2, widths = c(0.8,0.2))
print(combined_plot_val)

combined_plot = ggarrange(combined_plot_noval,combined_plot_val,ncol = 1, nrow = 2, labels = c("a","b"))
print(combined_plot)

# sim_PRS_violin_plot.png width 1350 height 1600
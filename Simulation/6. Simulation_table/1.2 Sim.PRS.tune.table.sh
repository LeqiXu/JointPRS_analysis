library(data.table)
library(dplyr)
library(tidyr)
library(openxlsx)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/")

# Data preprocessing for prs_table
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

prs_table$pop <- factor(prs_table$pop, levels = c("EAS", "AFR", "SAS", "AMR"))

prs_table = prs_table %>% 
  mutate(minor_sample = case_when(sample2 == "15K" ~ "15,000",
                                  sample2 == "80K" ~ "80,000"),
         minor_val_sample = case_when(val_sample == "0.5K" ~ "500",
                                      val_sample == "2K" ~ "2,000",
                                      val_sample == "5K" ~ "5,000",
                                      val_sample == "10K" ~ "10,000"))

prs_table$JointPRS = ifelse(prs_table$choose_JointPRS_linear == "yes",prs_table$JointPRS_linear,prs_table$JointPRS_auto)
prs_table <- prs_table %>%
  select(-JointPRS_auto, -choose_JointPRS_linear, -JointPRS_linear) # Decide JointPRS based on the tuning result

# Reshape to long_table
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2","minor_sample","val_sample","minor_val_sample"),
                   variable.name = "method", value.name = "r2")
long_table$method = factor(long_table$method, levels = c("JointPRS","SDPRX","XPASS","PRS-CSx","MUSSEL","PROSPER","BridgePRS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, minor_sample,val_sample,minor_val_sample, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

# Obtain tune_table
tune_table <- long_table %>%
  pivot_wider(names_from = pop, values_from = c(mean_r2, sd_r2))

tune_table = tune_table[,c("p", "minor_sample","minor_val_sample", "method", paste0(rep(c("mean_r2_","sd_r2_"),4), rep(c("EAS", "AFR", "SAS", "AMR"),each=2)))]

tune_table$p <- factor(tune_table$p, levels = c(0.1, 0.01, 0.001, 5e-04), labels = c("0.1", "0.01", "0.001", "5 × 10⁻⁴"))
tune_table$minor_sample <- factor(tune_table$minor_sample, levels = c("80,000","15,000"))
tune_table$minor_val_sample <- factor(tune_table$minor_val_sample, levels = c("500","2,000","5,000","10,000"))

tune_table = tune_table %>% arrange(p,minor_sample,minor_val_sample,method)
print(tune_table)

write.xlsx(tune_table, "sim_tune_table.xlsx", sheetName = "TableS2", rowNames = FALSE)

# Obtain tune_best_table
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

long_table$p_category = ifelse(long_table$p %in% c("0.1", "0.01"),"p = 0.1, 0.01","p = 0.001, 5 × 10⁻⁴")
long_table$p_category = factor(long_table$p_category, levels = c("p = 0.1, 0.01","p = 0.001, 5 × 10⁻⁴"))

tune_best_table <- long_table %>%
  group_by(pop, p_category, method) %>%
  summarise(
    best_or_second_best_count = sum(annotation %in% c("**", "*")),
    best_count = sum(annotation == "**"),
    second_best_count = sum(annotation == "*"),
    .groups = 'drop'
  )

tune_best_table = tune_best_table %>% arrange(pop,p_category,method)
print(tune_best_table)

write.xlsx(tune_best_table, "sim_tune_best_table.xlsx", sheetName = "Table1", rowNames = FALSE)

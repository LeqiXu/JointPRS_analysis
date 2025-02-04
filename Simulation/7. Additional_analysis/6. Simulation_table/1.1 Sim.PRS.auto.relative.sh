library(data.table)
library(dplyr)

## auto and tune method comparison
setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/")

# Data preprocessing
prs_table = fread(paste0("sim_PRS_real_auto_no_val_r2.csv"))
prs_table = prs_table[,c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5","PRScsx_auto_5","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("n", "pop", "p", "rho", "sample2", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")

# compare JointPRS to XPASS
prs_table_XPASS = prs_table
prs_table_XPASS$JointPRS_to_XPASS = prs_table_XPASS$`JointPRS-auto` / prs_table_XPASS$XPASS - 1
prs_table_XPASS = prs_table_XPASS[,c("n", "pop", "p", "rho", "sample2", "JointPRS_to_XPASS")]

prs_mean_table_XPASS <- prs_table_XPASS %>%
  group_by(pop) %>%
  summarise(
    mean_relative_r2 = mean(JointPRS_to_XPASS, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

print(prs_mean_table_XPASS)

# compare JointPRS to SDPRX for large training sample size (N_train = 80,000) and large causal SNP proportions (p = 0.1, 0.01)
prs_table_SDPRX = prs_table[which(prs_table$sample2 == "80K"),]
prs_table_SDPRX$SDPRX[which(prs_table_SDPRX$SDPRX == 0)] = NA
prs_table_SDPRX = prs_table_SDPRX[which(prs_table_SDPRX$p %in% c(0.1,0.01)),]
prs_table_SDPRX$JointPRS_to_SDPRX = prs_table_SDPRX$`JointPRS-auto` / prs_table_SDPRX$SDPRX - 1
prs_table_SDPRX = prs_table_SDPRX[,c("n", "pop", "p", "rho", "sample2", "JointPRS_to_SDPRX")]

prs_mean_table_SDPRX <- prs_table_SDPRX %>%
  group_by(pop) %>%
  summarise(
    mean_relative_r2 = mean(JointPRS_to_SDPRX, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

print(prs_mean_table_SDPRX)

# compare JointPRS to PRScsx
prs_table_PRScsx = prs_table
prs_table_PRScsx$JointPRS_to_PRScsx = prs_table_PRScsx$`JointPRS-auto` / prs_table_PRScsx$`PRS-CSx-auto` - 1
prs_table_PRScsx = prs_table_PRScsx[,c("n", "pop", "p", "rho", "sample2", "JointPRS_to_PRScsx")]

prs_mean_table_PRScsx <- prs_table_PRScsx %>%
  group_by(pop) %>%
  summarise(
    mean_relative_r2 = mean(JointPRS_to_PRScsx, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

print(prs_mean_table_PRScsx)
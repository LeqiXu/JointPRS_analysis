## no_val result
library(data.table)
library(dplyr)

prs_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/PRS_no_val_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")

prs_relative = prs_table[,c("pop","trait")]
prs_relative$`PRS-CSx-auto` = (prs_table$`JointPRS-auto` - prs_table$`PRS-CSx-auto`) / prs_table$`PRS-CSx-auto`
prs_relative$`SDPRX` = (prs_table$`JointPRS-auto` - prs_table$`SDPRX`) / prs_table$`SDPRX`
prs_relative$`XPASS` = (prs_table$`JointPRS-auto` - prs_table$`XPASS`) / prs_table$`XPASS`

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

prs_relative = prs_relative[prs_relative$trait %in% PAGE_trait,]

prs_average <- prs_relative %>%
  group_by(pop) %>%
  summarize(
    `avg_PRS-CSx_auto` = mean(`PRS-CSx-auto`, na.rm = TRUE),
    avg_SDPRX = mean(SDPRX, na.rm = TRUE),
    avg_XPASS = mean(XPASS, na.rm = TRUE)
  )
prs_average$pop = factor(prs_average$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average <- prs_average %>% arrange(pop)
print(prs_average)

## same_cohort result
library(data.table)
library(dplyr)

prs_table = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_same_cohort_r2.csv"))
prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS_tune","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

prs_relative = prs_table[,c("pop","trait")]
prs_relative$`SDPRX` = (prs_table$`JointPRS_tune` - prs_table$`SDPRX`) / prs_table$`SDPRX`
prs_relative$`XPASS` = (prs_table$`JointPRS_tune` - prs_table$`XPASS`) / prs_table$`XPASS`
prs_relative$`PRS-CSx` = (prs_table$`JointPRS_tune` - prs_table$`PRS-CSx`) / prs_table$`PRS-CSx`
prs_relative$`PROSPER` = (prs_table$`JointPRS_tune` - prs_table$`PROSPER`) / prs_table$`PROSPER`
prs_relative$`MUSSEL` = (prs_table$`JointPRS_tune` - prs_table$`MUSSEL`) / prs_table$`MUSSEL`
prs_relative$`BridgePRS` = (prs_table$`JointPRS_tune` - prs_table$`BridgePRS`) / prs_table$`BridgePRS`

# Calculate the median for each trait within each population
prs_median <- prs_relative %>%
  group_by(pop, trait) %>%
  summarize(
    med_SDPRX = mean(SDPRX, na.rm = TRUE),
    med_XPASS = mean(XPASS, na.rm = TRUE),
    `med_PRS-CSx` = mean(`PRS-CSx`, na.rm = TRUE),
    med_PROSPER = mean(PROSPER, na.rm = TRUE),
    med_MUSSEL = mean(MUSSEL, na.rm = TRUE),
    med_BridgePRS = mean(BridgePRS, na.rm = TRUE)
  )

# Calculate the average of the medians for each population
prs_average <- prs_median %>%
  group_by(pop) %>%
  summarize(
    avg_med_SDPRX = mean(med_SDPRX, na.rm = TRUE),
    avg_med_XPASS = mean(med_XPASS, na.rm = TRUE),
    `avg_med_PRS-CSx` = mean(`med_PRS-CSx`, na.rm = TRUE),
    avg_med_PROSPER = mean(med_PROSPER, na.rm = TRUE),
    avg_med_MUSSEL = mean(med_MUSSEL, na.rm = TRUE),
    avg_med_BridgePRS = mean(med_BridgePRS, na.rm = TRUE)
  )

# View the results
prs_average$pop = factor(prs_average$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average <- prs_average %>% arrange(pop)
print(prs_average)

## diff_cohort
prs_table1 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PRS/PRS_diff_cohort_AFR_r2.csv"))
prs_table2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PRS/PRS_diff_cohort_r2.csv"))
prs_table2 = prs_table2[which(prs_table2$pop == "AMR"),]
prs_table = rbind(prs_table1,prs_table2)
prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS_tune","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")

prs_relative = prs_table[,c("pop","trait")]
prs_relative$`SDPRX` = (prs_table$`JointPRS_tune` - prs_table$`SDPRX`) / prs_table$`SDPRX`
prs_relative$`XPASS` = (prs_table$`JointPRS_tune` - prs_table$`XPASS`) / prs_table$`XPASS`
prs_relative$`PRS-CSx` = (prs_table$`JointPRS_tune` - prs_table$`PRS-CSx`) / prs_table$`PRS-CSx`
prs_relative$`PROSPER` = (prs_table$`JointPRS_tune` - prs_table$`PROSPER`) / prs_table$`PROSPER`
prs_relative$`MUSSEL` = (prs_table$`JointPRS_tune` - prs_table$`MUSSEL`) / prs_table$`MUSSEL`
prs_relative$`BridgePRS` = (prs_table$`JointPRS_tune` - prs_table$`BridgePRS`) / prs_table$`BridgePRS`

prs_average <- prs_relative %>%
  group_by(pop) %>%
  summarize(
    avg_SDPRX = mean(SDPRX, na.rm = TRUE),
    avg_XPASS = mean(XPASS, na.rm = TRUE),
    `avg_PRS-CSx` = mean(PRS-CSx, na.rm = TRUE),
    avg_PROSPER = mean(PROSPER, na.rm = TRUE),
    avg_MUSSEL = mean(MUSSEL, na.rm = TRUE),
    avg_BridgePRS = mean(BridgePRS, na.rm = TRUE)
  )

# View the results
prs_average$pop = factor(prs_average$pop,levels=c("EAS","AFR","SAS","AMR"))
prs_average <- prs_average %>% arrange(pop)
print(prs_average)
library(data.table)
library(dplyr)
library(tidyr)
library(openxlsx)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PRS/")

# Data preprocessing for prs_table
prs_table = fread(paste0("PRS_update_diff_cohort_r2.csv"))

prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")
prs_table[prs_table == 0] <- NA

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
Binary_trait = c("T2D","BrC","CAD","LuC")

prs_table$trait <- factor(prs_table$trait, levels = c(GLGC_trait,PAGE_trait,BBJ_trait,Binary_trait))
prs_table$pop <- factor(prs_table$pop, levels = c("EAS","AFR","SAS","AMR"))
prs_table = prs_table[,c("trait", "pop", "JointPRS","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")]
prs_table <- prs_table %>% arrange(trait,pop)

write.xlsx(prs_table, "diff_cohort_table.xlsx", sheetName = "TableS12", rowNames = FALSE)
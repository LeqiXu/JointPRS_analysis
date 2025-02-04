library(data.table)
library(dplyr)
library(tidyr)
library(openxlsx)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/")

# Data preprocessing for prs_table
prs_continous_table = fread(paste0("PRS_no_val_r2.csv"))
prs_binary_table = fread(paste0("PRS_no_val_auc.csv"))
prs_table = rbind(prs_continous_table,prs_binary_table)
prs_table = prs_table[,c("trait", "pop", "JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")]
colnames(prs_table) = c("trait", "pop", "JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS")
prs_table[prs_table == 0] <- NA

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
Binary_trait = c("T2D","BrC","CAD","LuC")

prs_table$trait <- factor(prs_table$trait, levels = c(GLGC_trait,PAGE_trait,BBJ_trait,Binary_trait))
prs_table$pop <- factor(prs_table$pop, levels = c("EAS","AFR","SAS","AMR"))
prs_table <- prs_table %>% arrange(trait,pop)

write.xlsx(prs_table, "no_val_table.xlsx", sheetName = "TableS1", rowNames = FALSE)
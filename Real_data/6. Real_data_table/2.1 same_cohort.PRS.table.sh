library(data.table)
library(dplyr)
library(tidyr)
library(openxlsx)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/")

# Data preprocessing for prs_table
prs_continuous_table = fread(paste0("PRS_update_same_cohort_r2.csv"))
prs_binary_table = fread("PRS_update_same_cohort_auc.csv")
prs_table = rbind(prs_continuous_table,prs_binary_table)

prs_table = prs_table[,c("pop", "trait", "JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")]
colnames(prs_table) = c("pop", "trait", "JointPRS","SDPRX","XPASS","PRS-CSx","PROSPER","MUSSEL","BridgePRS")
prs_table[prs_table < 0.001] <- NA

GLGC_trait = c("HDL","LDL","TC","logTG")
PAGE_trait = c("Height","BMI","SBP","DBP","PLT")
BBJ_trait = c("WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
Binary_trait = c("T2D","BrC","CAD","LuC")

prs_table_average = prs_table %>% 
  group_by(trait,pop) %>%
  summarise(
    JointPRS = mean(JointPRS, na.rm = TRUE),
    SDPRX = mean(SDPRX, na.rm = TRUE),
    XPASS = mean(XPASS, na.rm = TRUE),
    `PRS-CSx` = mean(`PRS-CSx`, na.rm = TRUE),
    MUSSEL = mean(MUSSEL, na.rm = TRUE),
    PROSPER = mean(PROSPER, na.rm = TRUE),
    BridgePRS = mean(BridgePRS, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

prs_table_average$trait <- factor(prs_table_average$trait, levels = c(GLGC_trait,PAGE_trait,BBJ_trait,Binary_trait))
prs_table_average$pop <- factor(prs_table_average$pop, levels = c("EAS","AFR","SAS","AMR"))
prs_table_average <- prs_table_average %>% arrange(trait,pop)

write.xlsx(prs_table_average, "same_cohort_table.xlsx", sheetName = "TableS11", rowNames = FALSE)
## continous trait
library(data.table)
library(stringr)
library(dplyr)

EAS_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
AFR_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT")
SAS_trait_list = c("HDL","LDL","TC","logTG")
AMR_trait_list = c("HDL","LDL","TC","logTG")

trait_type_list = c(rep("GLGC",4),rep("PAGE",5),rep("BBJ",13))
cv=5

JointPRS_version_table = list()

for (pop in c("EAS","AFR","SAS","AMR")){
trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

JointPRS_version_table[[pop]] = data.table(trait = rep(trait_list, each = 5),
                                           pop = pop,
                                           s = rep(c(1:5),n_trait),
                                           JointPRS_version = 0)

for (t in c(1:n_trait)){
trait = trait_list[t]
trait_type = trait_type_list[t]

for (s in c(1:cv)){
## test phenotype
Trait_pheno <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",pop,"_test_",s,"_doubleidname.tsv"))
Trait_pheno = Trait_pheno[,c(1,3)]
colnames(Trait_pheno) = c("eid","pheno")
Trait_pheno$pheno <- scale(Trait_pheno$pheno)
Trait_pheno_id = Trait_pheno$eid

## depend on the trait type and pop type, we read the score accordingly
## score alignment with trait pheno
if (trait_type == "GLGC"){

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) + unlist(JointPRS_linear_weight[1,4]) * unlist(scale(Trait_JointPRS_linear_max[,8])) + unlist(JointPRS_linear_weight[1,5]) * unlist(scale(Trait_JointPRS_linear_max[,9]))

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_SAS_AMR_pvalue_",pop,".txt"))

} else if (trait_type == "PAGE"){

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) 

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_pvalue_",pop,".txt"))

} else {

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) 

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_pvalue_",pop,".txt"))

}

Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]
Trait_JointPRS_linear_max = Trait_JointPRS_linear_max[match(Trait_pheno_id,Trait_JointPRS_linear_max$IID),]
if (JointPRS_meta_val_R2 > 0.01 && (JointPRS_linear_val_R2 - JointPRS_meta_val_R2 > 0) && JointPRS_meta_val_pvalue < 0.05){
    JointPRS_version_table[[pop]]$JointPRS_version[which(JointPRS_version_table[[pop]]$trait == trait & JointPRS_version_table[[pop]]$s == s)] = "tune"
} else {
    JointPRS_version_table[[pop]]$JointPRS_version[which(JointPRS_version_table[[pop]]$trait == trait & JointPRS_version_table[[pop]]$s == s)] = "meta"
}



}
}
}

JointPRS_version_final_table1 = rbind(JointPRS_version_table[["EAS"]],JointPRS_version_table[["AFR"]],JointPRS_version_table[["SAS"]],JointPRS_version_table[["AMR"]])



## binary trait
library(data.table)
library(stringr)
library(dplyr)
library(pROC)

EAS_trait_list = c("T2D","BrC","CAD","LuC")
AFR_trait_list = c("T2D","BrC")

trait_type_list = c(rep("Binary_3",2),rep("Binary_2",2))
cv=5

JointPRS_version_table = list()

for (pop in c("EAS","AFR")){
trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

JointPRS_version_table[[pop]] = data.table(trait = rep(trait_list, each = 5),
                                           pop = pop,
                                           s = rep(c(1:5),n_trait),
                                           JointPRS_version = 0)

for (t in c(1:n_trait)){
trait = trait_list[t]
trait_type = trait_type_list[t]

for (s in c(1:cv)){
## test phenotype
Trait_pheno <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",pop,"_test_",s,"_doubleidname.tsv"))
Trait_pheno = Trait_pheno[,c(1,3)]
colnames(Trait_pheno) = c("eid","pheno")
Trait_pheno_id = Trait_pheno$eid

## depend on the trait type and pop type, we read the score accordingly
## score alignment with trait pheno
if (trait_type == "Binary_3"){

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) 

JointPRS_meta_val_AUC = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_auc_",pop,".txt"))
JointPRS_linear_val_AUC = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_auc_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_pvalue_",pop,".txt"))

} else {

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) 

JointPRS_meta_val_AUC = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_auc_",pop,".txt"))
JointPRS_linear_val_AUC = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_auc_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_pvalue_",pop,".txt"))

}

Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]
Trait_JointPRS_linear_max = Trait_JointPRS_linear_max[match(Trait_pheno_id,Trait_JointPRS_linear_max$IID),]
if (JointPRS_meta_val_AUC > 0.501 && (JointPRS_linear_val_AUC - JointPRS_meta_val_AUC > 0) && JointPRS_meta_val_pvalue < 0.05){
    JointPRS_version_table[[pop]]$JointPRS_version[which(JointPRS_version_table[[pop]]$trait == trait & JointPRS_version_table[[pop]]$s == s)] = "tune"
} else {
    JointPRS_version_table[[pop]]$JointPRS_version[which(JointPRS_version_table[[pop]]$trait == trait & JointPRS_version_table[[pop]]$s == s)] = "meta"
}


}
}
}

JointPRS_version_final_table2 = rbind(JointPRS_version_table[["EAS"]],JointPRS_version_table[["AFR"]])

JointPRS_version_final_table = rbind(JointPRS_version_final_table1,JointPRS_version_final_table2)

table = JointPRS_version_final_table %>%
  group_by(trait, JointPRS_version, pop) %>%
  summarise(count = n(), .groups = 'drop') %>%
  pivot_wider(names_from = JointPRS_version, values_from = count, values_fill = 0) %>%
  mutate(pop = factor(pop, levels = c("EAS", "AFR", "SAS", "AMR")),
         trait = factor(trait, levels = c("HDL", "LDL", "TC", "logTG", "Height", "BMI", "SBP", "DBP", "PLT", "WBC", "NEU", "LYM", "MON", "EOS", "RBC", "HB", "HCT", "MCH", "MCV", "ALT", "ALP", "GGT", "T2D", "BrC", "CAD", "LuC"))) %>%
  arrange(pop, trait)


library(openxlsx)
write.xlsx(table, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_same_cohort_JointPRS_version.xlsx", sheetName = "TableS14", rowNames = FALSE)

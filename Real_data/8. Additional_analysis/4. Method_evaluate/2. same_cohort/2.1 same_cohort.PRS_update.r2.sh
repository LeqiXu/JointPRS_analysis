# same_cohort situation
library(data.table)
library(stringr)
library(dplyr)

## traits
pop = "EUR"
trait_list = c("HDL","LDL","TC","logTG")
trait_type_list = c(rep("GLGC",4))
n_trait = length(trait_list)

## covariates
cov_choice = c("age_recruit","sex",paste0("PC",1:20))
total_covariates = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
total_covariates = total_covariates %>% select(all_of(c("eid",cov_choice)))

## prs_EUR_table
prs_EUR_table = data.table(pop = rep(pop,n_trait), trait = trait_list,
                       JointPRS_tune_max = rep(0,n_trait),
                       SDPRX_auto_2 = rep(0,n_trait),
                       XPASS_auto_2 = rep(0,n_trait),
                       PRScsx_tune_max = rep(0,n_trait),
                       PROSPER_tune_max = rep(0,n_trait),
                       MUSSEL_tune_max = rep(0,n_trait),
                       BridgePRS_tune_2 = rep(0,n_trait))


for (t in c(1:n_trait)){
trait = trait_list[t]
trait_type = trait_type_list[t]

## test phenotype
val_id <- fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR_10K.fam", header = F)

Trait_pheno <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",pop,"_doubleidname.tsv"))
Trait_pheno = Trait_pheno[,c(1,3)]
colnames(Trait_pheno) = c("eid","pheno")

Trait_pheno <- Trait_pheno[which(!(Trait_pheno$eid %in% val_id$V1)),]
Trait_pheno$pheno <- scale(Trait_pheno$pheno)
Trait_pheno_id = Trait_pheno$eid


## JointPRS
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
colnames(Trait_JointPRS_auto_max)[5] = c("SCORE1_AVG")

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_weight_EUR_10K.txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) + unlist(JointPRS_linear_weight[1,4]) * unlist(scale(Trait_JointPRS_linear_max[,8])) + unlist(JointPRS_linear_weight[1,5]) * unlist(scale(Trait_JointPRS_linear_max[,9]))

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_r2_EUR_10K.txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_r2_EUR_10K.txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_pvalue_EUR_10K.txt"))

Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]
Trait_JointPRS_linear_max = Trait_JointPRS_linear_max[match(Trait_pheno_id,Trait_JointPRS_linear_max$IID),]
if (JointPRS_meta_val_R2 > 0.01 && (JointPRS_linear_val_R2 - JointPRS_meta_val_R2 > 0) && JointPRS_meta_val_pvalue < 0.05){
    Trait_JointPRS_tune_max = Trait_JointPRS_linear_max
} else {
    Trait_JointPRS_tune_max = Trait_JointPRS_auto_max
}

## SDPRX
Trait_SDPRX_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/UKB_",trait,"_SDPRX_test_EUR_bestpop_prs_",pop,".sscore"))
Trait_SDPRX_auto_2 = Trait_SDPRX_auto_2[match(Trait_pheno_id,Trait_SDPRX_auto_2$IID),]

## XPASS
Trait_XPASS_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/UKB_",trait,"_XPASS_test_EUR_bestpop_prs_",pop,".sscore"))
Trait_XPASS_auto_2 = Trait_XPASS_auto_2[match(Trait_pheno_id,Trait_XPASS_auto_2$IID),]

## PRScsx
Trait_PRScsx_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_",trait,"_PRScsx_test_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_SAS_AMR_weight_EUR_10K.txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(Trait_PRScsx_tune_max[,7])) + unlist(PRScsx_weight[1,4]) * unlist(scale(Trait_PRScsx_tune_max[,8])) + unlist(PRScsx_weight[1,5]) * unlist(scale(Trait_PRScsx_tune_max[,9])) 
Trait_PRScsx_tune_max = Trait_PRScsx_tune_max[match(Trait_pheno_id,Trait_PRScsx_tune_max$IID),]

## MUSSEL
Trait_MUSSEL_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_",trait,"_MUSSEL_test_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = Trait_MUSSEL_tune_max[match(Trait_pheno_id,Trait_MUSSEL_tune_max$IID),]

## PROSPER
Trait_PROSPER_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_",trait,"_PROSPER_update_test_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
Trait_PROSPER_tune_max = Trait_PROSPER_tune_max[match(Trait_pheno_id,Trait_PROSPER_tune_max$IID),]

## BirdgePRS
Trait_BridgePRS_tune_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS/UKB_",trait,"_BridgePRS_test_EUR_SAS_prs_",pop,".sscore"))
Trait_BridgePRS_tune_2 = Trait_BridgePRS_tune_2[match(Trait_pheno_id,Trait_BridgePRS_tune_2$IID),]

## score alignment with trait pheno
covariates = total_covariates[match(Trait_pheno_id,total_covariates$eid),]
pheno_covariates = cbind(Trait_pheno[,-1],covariates[,-1])
        
# null model in all individuals in UKBB dataset
linear_null = lm(pheno ~ . , data = pheno_covariates)
linear_null_summary = summary(linear_null)
linear_null_res2 = sum(linear_null_summary$residuals^2)

test_data = data.table(JointPRS_tune_max = scale(Trait_JointPRS_tune_max$SCORE1_AVG),
                       SDPRX_auto_2 = scale(Trait_SDPRX_auto_2$SCORE1_AVG),
                       XPASS_auto_2 = scale(Trait_XPASS_auto_2$SCORE1_AVG),
                       PRScsx_tune_max = scale(Trait_PRScsx_tune_max$SCORE1_AVG), 
                       PROSPER_tune_max = scale(Trait_PROSPER_tune_max$SCORE1_AVG), 
                       MUSSEL_tune_max = scale(Trait_MUSSEL_tune_max$SCORE1_AVG), 
                       BridgePRS_tune_2 = scale(Trait_BridgePRS_tune_2$SCORE1_AVG))

colnames(test_data) = c("JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")
    
for (j in 1:7){
    data = pheno_covariates
    data$prs <- unlist(test_data[,..j])
    linear = lm(pheno ~ ., data=data)
    linear_summary=summary(linear)
    linear_summary_res2 = sum(linear_summary$residuals^2)
          
    prs_EUR_table[t,j+2] = 1 - linear_summary_res2/linear_null_res2
}

}

prs_nonEUR_table <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_update_same_cohort_r2.csv"))
prs_final_table <- rbind(prs_EUR_table,prs_nonEUR_table)

write.table(prs_final_table,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_update_same_cohort_EUR_r2.csv"))
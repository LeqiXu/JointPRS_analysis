# same_cohort situation
library(data.table)
library(stringr)
library(dplyr)

cov_choice = c("age_recruit","sex",paste0("PC",1:20))
total_covariates = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
total_covariates = total_covariates %>% select(all_of(c("eid",cov_choice)))

EAS_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")
AFR_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT")
SAS_trait_list = c("HDL","LDL","TC","logTG")
AMR_trait_list = c("HDL","LDL","TC","logTG")

trait_type_list = c(rep("GLGC",4),rep("PAGE",5),rep("BBJ",13))
cv=5

prs_table = list()

for (pop in c("EAS","AFR","SAS","AMR")){
trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

prs_table[[pop]] = data.table(pop = rep(pop,n_trait * cv), trait = rep(trait_list, each = cv),
                       JointPRS_tune_max = rep(0,n_trait * cv),
                       SDPRX_auto_2 = rep(0,n_trait * cv),
                       XPASS_auto_2 = rep(0,n_trait * cv),
                       PRScsx_tune_max = rep(0,n_trait * cv),
                       PROSPER_tune_max = rep(0,n_trait * cv),
                       MUSSEL_tune_max = rep(0,n_trait * cv),
                       BridgePRS_tune_2 = rep(0,n_trait * cv))

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

Trait_PRScsx_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_",trait,"_PRScsx_test_",s,"_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_val_",s,"_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(Trait_PRScsx_tune_max[,7])) + unlist(PRScsx_weight[1,4]) * unlist(scale(Trait_PRScsx_tune_max[,8])) + unlist(PRScsx_weight[1,5]) * unlist(scale(Trait_PRScsx_tune_max[,9])) 

Trait_PROSPER_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_",trait,"_PROSPER_test_",s,"_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_",trait,"_MUSSEL_test_",s,"_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))

} else if (trait_type == "PAGE"){

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) 

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_pvalue_",pop,".txt"))

Trait_PRScsx_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_",trait,"_PRScsx_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(Trait_PRScsx_tune_max[,7])) 

Trait_PROSPER_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_",trait,"_PROSPER_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_",trait,"_MUSSEL_test_",s,"_EUR_EAS_AFR_prs_",pop,".sscore"))

} else {

Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_auto_test_",s,"_EUR_EAS_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_",trait,"_JointPRS_linear_test_",s,"_EUR_EAS_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) 

JointPRS_meta_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_pvalue_",pop,".txt"))

Trait_PRScsx_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_",trait,"_PRScsx_test_",s,"_EUR_EAS_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_val_",s,"_EUR_EAS_weight_",pop,".txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) 

Trait_PROSPER_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_",trait,"_PROSPER_test_",s,"_EUR_EAS_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_",trait,"_MUSSEL_test_",s,"_EUR_EAS_prs_",pop,".sscore"))

}

Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]
Trait_JointPRS_linear_max = Trait_JointPRS_linear_max[match(Trait_pheno_id,Trait_JointPRS_linear_max$IID),]
if (JointPRS_meta_val_R2 > 0.01 && (JointPRS_linear_val_R2 - JointPRS_meta_val_R2 > 0) && JointPRS_meta_val_pvalue < 0.05){
    Trait_JointPRS_tune_max = Trait_JointPRS_linear_max
} else {
    Trait_JointPRS_tune_max = Trait_JointPRS_auto_max
}

Trait_PRScsx_tune_max = Trait_PRScsx_tune_max[match(Trait_pheno_id,Trait_PRScsx_tune_max$IID),]
Trait_PROSPER_tune_max = Trait_PROSPER_tune_max[match(Trait_pheno_id,Trait_PROSPER_tune_max$IID),]
Trait_MUSSEL_tune_max = Trait_MUSSEL_tune_max[match(Trait_pheno_id,Trait_MUSSEL_tune_max$IID),]

if (pop == "EAS" || pop == "AFR"){
Trait_SDPRX_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/UKB_",trait,"_SDPRX_test_",s,"_EUR_",pop,"_prs_",pop,".sscore"))
Trait_SDPRX_auto_2 = Trait_SDPRX_auto_2[match(Trait_pheno_id,Trait_SDPRX_auto_2$IID),]
}

Trait_XPASS_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/UKB_",trait,"_XPASS_test_",s,"_EUR_",pop,"_prs_",pop,".sscore"))
Trait_XPASS_auto_2 = Trait_XPASS_auto_2[match(Trait_pheno_id,Trait_XPASS_auto_2$IID),]

Trait_BridgePRS_tune_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS/UKB_",trait,"_BridgePRS_test_",s,"_EUR_",pop,"_prs_",pop,".sscore"))
Trait_BridgePRS_tune_2 = Trait_BridgePRS_tune_2[match(Trait_pheno_id,Trait_BridgePRS_tune_2$IID),]

## score alignment with trait pheno
covariates = total_covariates[match(Trait_pheno_id,total_covariates$eid),]
pheno_covariates = cbind(Trait_pheno[,-1],covariates[,-1])
        
# null model in all individuals in UKBB dataset
linear_null = lm(pheno ~ . , data = pheno_covariates)
linear_null_summary = summary(linear_null)
linear_null_res2 = sum(linear_null_summary$residuals^2)

if (pop == "EAS" || pop == "AFR"){
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
          
        prs_table[[pop]][(t - 1) * cv + s,j+2] = 1 - linear_summary_res2/linear_null_res2
    }

} else {

    test_data = data.table(JointPRS_tune_max = scale(Trait_JointPRS_tune_max$SCORE1_AVG),
                           SDPRX_auto_2 = 0,
                           XPASS_auto_2 = scale(Trait_XPASS_auto_2$SCORE1_AVG),
                           PRScsx_tune_max = scale(Trait_PRScsx_tune_max$SCORE1_AVG), 
                           PROSPER_tune_max = scale(Trait_PROSPER_tune_max$SCORE1_AVG), 
                           MUSSEL_tune_max = scale(Trait_MUSSEL_tune_max$SCORE1_AVG), 
                           BridgePRS_tune_2 = scale(Trait_BridgePRS_tune_2$SCORE1_AVG))

    colnames(test_data) = c("JointPRS_tune_max","SDPRX_auto_2","XPASS_auto_2","PRScsx_tune_max","PROSPER_tune_max","MUSSEL_tune_max","BridgePRS_tune_2")

    for (j in c(1,3:7)){
        data = pheno_covariates
        data$prs <- unlist(test_data[,..j])
        linear = lm(pheno ~ ., data=data)
        linear_summary=summary(linear)
        linear_summary_res2 = sum(linear_summary$residuals^2)
          
        prs_table[[pop]][(t - 1) * cv + s,j+2] = 1 - linear_summary_res2/linear_null_res2
    }

}

}
}
}

prs_final_table = rbind(prs_table[["EAS"]],prs_table[["AFR"]],prs_table[["SAS"]],prs_table[["AMR"]])

write.table(prs_final_table,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRS/PRS_same_cohort_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
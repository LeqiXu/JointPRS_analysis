# no_val situation
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

prs_table = list()

for (pop in c("EAS","AFR","SAS","AMR")){
trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

prs_table[[pop]] = data.table(pop = rep(pop,n_trait), trait = trait_list,
                       JointPRS_auto_max = rep(0,n_trait),
                       PRScsx_auto_max = rep(0,n_trait),
                       SDPRX_auto_2 = rep(0,n_trait),
                       XPASS_auto_2 = rep(0,n_trait))

for (t in 1:n_trait){
trait = trait_list[t]
trait_type = trait_type_list[t]

## test phenotype
Trait_pheno <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",pop,".tsv"))
colnames(Trait_pheno) = c("eid","pheno")
Trait_pheno$pheno <- scale(Trait_pheno$pheno)
Trait_pheno_id = Trait_pheno$eid

## depend on the trait type and pop type, we read the score accordingly
## score alignment with trait pheno
if (trait_type == "GLGC"){
Trait_PRScsx_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
} else if (trait_type == "PAGE") {
Trait_PRScsx_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_EAS_AFR_prs_",pop,".sscore"))
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_EAS_AFR_prs_",pop,".sscore"))
} else {
Trait_PRScsx_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_EAS_prs_",pop,".sscore"))
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_EAS_prs_",pop,".sscore"))
}

Trait_PRScsx_auto_max = Trait_PRScsx_auto_max[match(Trait_pheno_id,Trait_PRScsx_auto_max$IID),]
Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]

if (pop == "EAS" || pop == "AFR"){
Trait_SDPRX_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/UKB_",trait,"_SDPRX_EUR_",pop,"_prs_",pop,".sscore"))
Trait_SDPRX_auto_2 = Trait_SDPRX_auto_2[match(Trait_pheno_id,Trait_SDPRX_auto_2$IID),]
}

Trait_XPASS_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/XPASS/UKB_",trait,"_XPASS_EUR_",pop,"_prs_",pop,".sscore"))
Trait_XPASS_auto_2 = Trait_XPASS_auto_2[match(Trait_pheno_id,Trait_XPASS_auto_2$IID),]

## score alignment with trait pheno
covariates = total_covariates[match(Trait_pheno_id,total_covariates$eid),]
pheno_covariates = cbind(Trait_pheno[,-1],covariates[,-1])
        
# null model in all individuals in UKBB dataset
linear_null = lm(pheno ~ . , data = pheno_covariates)
linear_null_summary = summary(linear_null)
linear_null_res2 = sum(linear_null_summary$residuals^2)
        
# prs comparison            
if (pop == "EAS" || pop == "AFR"){
    test_data = data.table(JointPRS_auto_max = scale(Trait_JointPRS_auto_max$SCORE1_AVG), 
                           PRScsx_auto_max = scale(Trait_PRScsx_auto_max$SCORE1_AVG), 
                           SDPRX_auto_2 = scale(Trait_SDPRX_auto_2$SCORE1_AVG),
                           XPASS_auto_2 = scale(Trait_XPASS_auto_2$SCORE1_AVG))
    colnames(test_data) = c("JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")
    for (j in 1:4){
        data = pheno_covariates
        data$prs <- unlist(test_data[,..j])
        linear = lm(pheno ~ ., data=data)
        linear_summary=summary(linear)
        linear_summary_res2 = sum(linear_summary$residuals^2)
          
        prs_table[[pop]][t,j+2] = 1 - linear_summary_res2/linear_null_res2
    }

    } else{
    test_data = data.table(JointPRS_auto_max = scale(Trait_JointPRS_auto_max$SCORE1_AVG), 
                           PRScsx_auto_max = scale(Trait_PRScsx_auto_max$SCORE1_AVG), 
                           SDPRX_auto_2 = 0,
                           XPASS_auto_2 = scale(Trait_XPASS_auto_2$SCORE1_AVG))
                           
    colnames(test_data) = c("JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")
    for (j in c(1,2,4)){
        data = pheno_covariates
        data$prs <- unlist(test_data[,..j])
        linear = lm(pheno ~ ., data=data)
        linear_summary=summary(linear)
        linear_summary_res2 = sum(linear_summary$residuals^2)
          
        prs_table[[pop]][t,j+2] = 1 - linear_summary_res2/linear_null_res2
    }

    }

}
}

prs_auto_table = rbind(prs_table[["EAS"]],prs_table[["AFR"]],prs_table[["SAS"]],prs_table[["AMR"]])

write.table(prs_auto_table,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/PRS_no_val_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
# no_val situation
library(data.table)
library(stringr)
library(dplyr)
library(pROC)

cov_choice = c("age_recruit","sex",paste0("PC",1:20))
total_covariates = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
total_covariates = total_covariates %>% select(all_of(c("eid",cov_choice)))

EAS_trait_list = c("T2D","BrC","CAD","LuC")
AFR_trait_list = c("T2D","BrC")

trait_type_list = c(rep("Binary_3",2),rep("Binary_2",2))

prs_table = list()

for (pop in c("EAS","AFR")){
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
Trait_pheno_id = Trait_pheno$eid

## depend on the trait type and pop type, we read the score accordingly
## score alignment with trait pheno
if (trait_type == "Binary_3") {
Trait_PRScsx_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_EAS_AFR_prs_",pop,".sscore"))
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_EAS_AFR_prs_",pop,".sscore"))
} else {
Trait_PRScsx_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_EAS_prs_",pop,".sscore"))
Trait_JointPRS_auto_max = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_EAS_prs_",pop,".sscore"))
}

Trait_PRScsx_auto_max = Trait_PRScsx_auto_max[match(Trait_pheno_id,Trait_PRScsx_auto_max$IID),]
Trait_JointPRS_auto_max = Trait_JointPRS_auto_max[match(Trait_pheno_id,Trait_JointPRS_auto_max$IID),]

Trait_SDPRX_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/UKB_",trait,"_SDPRX_EUR_",pop,"_prs_",pop,".sscore"))
Trait_SDPRX_auto_2 = Trait_SDPRX_auto_2[match(Trait_pheno_id,Trait_SDPRX_auto_2$IID),]

Trait_XPASS_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/XPASS/UKB_",trait,"_XPASS_EUR_",pop,"_prs_",pop,".sscore"))
Trait_XPASS_auto_2 = Trait_XPASS_auto_2[match(Trait_pheno_id,Trait_XPASS_auto_2$IID),]

## score alignment with trait pheno
pheno = Trait_pheno[,-1]
            
# prs comparison            
test_data = data.table(JointPRS_auto_max = scale(Trait_JointPRS_auto_max$SCORE1_AVG), 
                       PRScsx_auto_max = scale(Trait_PRScsx_auto_max$SCORE1_AVG), 
                       SDPRX_auto_2 = scale(Trait_SDPRX_auto_2$SCORE1_AVG),
                       XPASS_auto_2 = scale(Trait_XPASS_auto_2$SCORE1_AVG))
colnames(test_data) = c("JointPRS_auto_max","PRScsx_auto_max","SDPRX_auto_2","XPASS_auto_2")
for (j in 1:4){
    data = pheno
    data$prs <- unlist(test_data[,..j])
    glmfit = glm(pheno~prs, data=data,family=binomial(link="logit"))
    glmfit_prob = predict(glmfit, type="response")
    glmfit_auc = roc(data$pheno, glmfit_prob, quiet=T, plot=F)$auc
          
    prs_table[[pop]][t,j+2] = glmfit_auc
}


}
}

prs_auto_table = rbind(prs_table[["EAS"]],prs_table[["AFR"]])

write.table(prs_auto_table,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/PRS_no_val_auc.csv"),quote=F,sep='\t',row.names=F,col.names=T)
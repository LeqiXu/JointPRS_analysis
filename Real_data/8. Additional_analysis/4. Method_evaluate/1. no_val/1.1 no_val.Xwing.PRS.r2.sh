# no_val situation
library(data.table)
library(stringr)
library(dplyr)

cov_choice = c("age_recruit","sex",paste0("PC",1:20))
total_covariates = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
total_covariates = total_covariates %>% select(all_of(c("eid",cov_choice)))

EAS_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

trait_type_list = c(rep("GLGC",4),rep("PAGE",5),rep("BBJ",13))

prs_table = list()

for (pop in c("EAS")){
trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

prs_table[[pop]] = data.table(pop = rep(pop,n_trait), trait = trait_list,
                       JointPRS_auto_2 = rep(0,n_trait),
                       PRScsx_auto_2 = rep(0,n_trait),
                       Xwing_auto_2 = rep(0,n_trait))

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
Trait_PRScsx_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_",trait,"_PRScsx_auto_EUR_",pop,"_prs_",pop,".sscore"))
Trait_JointPRS_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_",trait,"_JointPRS_EUR_",pop,"_prs_",pop,".sscore"))
Trait_Xwing_auto_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/Xwing/UKB_",trait,"_Xwing_auto_EUR_",pop,"_prs_",pop,".sscore"))

Trait_PRScsx_auto_2 = Trait_PRScsx_auto_2[match(Trait_pheno_id,Trait_PRScsx_auto_2$IID),]
Trait_JointPRS_auto_2 = Trait_JointPRS_auto_2[match(Trait_pheno_id,Trait_JointPRS_auto_2$IID),]
Trait_Xwing_auto_2 = Trait_Xwing_auto_2[match(Trait_pheno_id,Trait_Xwing_auto_2$IID),]

## score alignment with trait pheno
covariates = total_covariates[match(Trait_pheno_id,total_covariates$eid),]
pheno_covariates = cbind(Trait_pheno[,-1],covariates[,-1])
        
# null model in all individuals in UKBB dataset
linear_null = lm(pheno ~ . , data = pheno_covariates)
linear_null_summary = summary(linear_null)
linear_null_res2 = sum(linear_null_summary$residuals^2)
        
# prs comparison            
test_data = data.table(JointPRS_auto_2 = scale(Trait_JointPRS_auto_2$SCORE1_AVG), 
                        PRScsx_auto_2 = scale(Trait_PRScsx_auto_2$SCORE1_AVG), 
                        Xwing_auto_2 = scale(Trait_Xwing_auto_2$SCORE1_AVG))

colnames(test_data) = c("JointPRS_auto_2","PRScsx_auto_2","Xwing_auto_2")
    
for (j in 1:3){
    data = pheno_covariates
    data$prs <- unlist(test_data[,..j])
    linear = lm(pheno ~ ., data=data)
    linear_summary=summary(linear)
    linear_summary_res2 = sum(linear_summary$residuals^2)
          
    prs_table[[pop]][t,j+2] = 1 - linear_summary_res2/linear_null_res2
}

}
}

prs_auto_table = rbind(prs_table[["EAS"]])

write.table(prs_auto_table,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRS/PRS_no_val_Xwing_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
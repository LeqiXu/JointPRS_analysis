# diff_cohort situation
library(data.table)
library(stringr)
library(dplyr)

AFR_trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT")
AMR_trait_list = c("HDL","LDL","TC","logTG")
trait_type_list = c(rep("GLGC",4),rep("PAGE",5))

prs_table = list()

for (pop in c("AFR","AMR")){

trait_list = get(paste0(pop,"_trait_list"))
n_trait = length(trait_list)

prs_table[[pop]] = data.table(pop = rep(pop,n_trait), trait = rep(trait_list),
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

## obtain score
if (trait_type == "GLGC"){

Trait_JointPRS_auto_max = fread(paste0("./result/score/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("./result/score/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) + unlist(JointPRS_linear_weight[1,4]) * unlist(scale(Trait_JointPRS_linear_max[,8])) + unlist(JointPRS_linear_weight[1,5]) * unlist(scale(Trait_JointPRS_linear_max[,9])) 

JointPRS_meta_val_R2 = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_pvalue_",pop,".txt"))

if (JointPRS_meta_val_R2 > 0.01 && (JointPRS_linear_val_R2 - JointPRS_meta_val_R2 > 0) && JointPRS_meta_val_pvalue < 0.05){
    Trait_JointPRS_tune_max = Trait_JointPRS_linear_max
} else {
    Trait_JointPRS_tune_max = Trait_JointPRS_auto_max
}

Trait_PRScsx_tune_max = fread(paste0("./result/score/diff_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("./data/final_weight/diff_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(Trait_PRScsx_tune_max[,7])) + unlist(PRScsx_weight[1,4]) * unlist(scale(Trait_PRScsx_tune_max[,8])) + unlist(PRScsx_weight[1,5]) * unlist(scale(Trait_PRScsx_tune_max[,9])) 

Trait_PROSPER_tune_max = fread(paste0("./result/score/diff_cohort/PROSPER/",trait,"_PROSPER_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = fread(paste0("./result/score/diff_cohort/MUSSEL/",trait,"_MUSSEL_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))

if (pop == "EAS" || pop == "AFR"){
Trait_SDPRX_auto_2 = fread(paste0("./result/score/diff_cohort/SDPRX/",trait,"_SDPRX_EUR_",pop,"_prs_",pop,".sscore"))
}
Trait_XPASS_auto_2 = fread(paste0("./result/score/diff_cohort/XPASS/",trait,"_XPASS_EUR_",pop,"_prs_",pop,".sscore"))
Trait_BridgePRS_tune_2 = fread(paste0("./result/score/diff_cohort/BridgePRS/",trait,"_BridgePRS_EUR_",pop,"_prs_",pop,".sscore"))

} else {
Trait_JointPRS_auto_max = fread(paste0("./result/score/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_prs_",pop,".sscore"))

Trait_JointPRS_linear_max = fread(paste0("./result/score/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_prs_",pop,".sscore"))
JointPRS_linear_weight = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_JointPRS_linear_max$SCORE1_AVG = unlist(JointPRS_linear_weight[1,1]) * unlist(scale(Trait_JointPRS_linear_max[,5])) + unlist(JointPRS_linear_weight[1,2]) * unlist(scale(Trait_JointPRS_linear_max[,6])) + unlist(JointPRS_linear_weight[1,3]) * unlist(scale(Trait_JointPRS_linear_max[,7])) 

JointPRS_meta_val_R2 = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_linear_val_R2 = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_linear_EUR_EAS_AFR_r2_",pop,".txt"))
JointPRS_meta_val_pvalue = fread(paste0("./data/final_weight/diff_cohort/JointPRS/",trait,"_JointPRS_meta_EUR_EAS_AFR_pvalue_",pop,".txt"))

if (JointPRS_meta_val_R2 > 0.01 && (JointPRS_linear_val_R2 - JointPRS_meta_val_R2 > 0) && JointPRS_meta_val_pvalue < 0.05){
    Trait_JointPRS_tune_max = Trait_JointPRS_linear_max
} else {
    Trait_JointPRS_tune_max = Trait_JointPRS_auto_max
}
 
Trait_PRScsx_tune_max = fread(paste0("./result/score/diff_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_prs_",pop,".sscore"))
PRScsx_weight = fread(paste0("./data/final_weight/diff_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_weight_",pop,".txt"))
Trait_PRScsx_tune_max$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(Trait_PRScsx_tune_max[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(Trait_PRScsx_tune_max[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(Trait_PRScsx_tune_max[,7])) 

Trait_PROSPER_tune_max = fread(paste0("./result/score/diff_cohort/PROSPER/",trait,"_PROSPER_EUR_EAS_AFR_prs_",pop,".sscore"))
Trait_MUSSEL_tune_max = fread(paste0("./result/score/diff_cohort/MUSSEL/",trait,"_MUSSEL_EUR_EAS_AFR_prs_",pop,".sscore"))

Trait_SDPRX_auto_2 = fread(paste0("./result/score/diff_cohort/SDPRX/",trait,"_SDPRX_EUR_",pop,"_prs_",pop,".sscore"))
Trait_XPASS_auto_2 = fread(paste0("./result/score/diff_cohort/XPASS/",trait,"_XPASS_EUR_",pop,"_prs_",pop,".sscore"))
Trait_BridgePRS_tune_2 = fread(paste0("./result/score/diff_cohort/BridgePRS/",trait,"_BridgePRS_EUR_",pop,"_prs_",pop,".sscore"))
}

## trait and covarites
library(data.table)

trait_data = fread(paste0("./data/pheno_data/",trait,".txt"))
trait_data = trait_data[which(trait_data$person_id %in% Trait_JointPRS_tune_max$IID),]
trait_data = na.omit(trait_data)
    
# remove outliers
Q1 <- quantile(trait_data$value_as_number, 0.25)
Q3 <- quantile(trait_data$value_as_number, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
trait_data <- trait_data[trait_data$value_as_number >= lower_bound & trait_data$value_as_number <= upper_bound, ]

Trait_pheno = trait_data[,c("person_id","value_as_number")]
colnames(Trait_pheno) = c("eid","pheno")
Trait_pheno$pheno <- scale(Trait_pheno$pheno)
Trait_pheno_id = Trait_pheno$eid

covariates = trait_data[match(Trait_pheno_id,trait_data$person_id),c("person_id","sex_at_birth","measurement_age",paste0("PC",1:16))]
pheno_covariates = cbind(Trait_pheno[,-1],covariates[,-1])

Trait_JointPRS_tune_max = Trait_JointPRS_tune_max[match(Trait_pheno_id,Trait_JointPRS_tune_max$IID),]
Trait_PRScsx_tune_max = Trait_PRScsx_tune_max[match(Trait_pheno_id,Trait_PRScsx_tune_max$IID),]
Trait_PROSPER_tune_max = Trait_PROSPER_tune_max[match(Trait_pheno_id,Trait_PROSPER_tune_max$IID),]
Trait_MUSSEL_tune_max = Trait_MUSSEL_tune_max[match(Trait_pheno_id,Trait_MUSSEL_tune_max$IID),]
if (pop == "EAS" || pop == "AFR"){
Trait_SDPRX_auto_2 = Trait_SDPRX_auto_2[match(Trait_pheno_id,Trait_SDPRX_auto_2$IID),]
}
Trait_XPASS_auto_2 = Trait_XPASS_auto_2[match(Trait_pheno_id,Trait_XPASS_auto_2$IID),]
Trait_BridgePRS_tune_2 = Trait_BridgePRS_tune_2[match(Trait_pheno_id,Trait_BridgePRS_tune_2$IID),]

# null model in all individuals in AoU dataset
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

# alternative model for each method in all individuals in AoU dataset
for (j in 1:7){
    data = pheno_covariates
    data$prs <- unlist(test_data[,..j])
    linear = lm(pheno ~ ., data=data)
    linear_summary=summary(linear)
    linear_summary_res2 = sum(linear_summary$residuals^2)
          
    prs_table[[pop]][t,j+2] = 1 - linear_summary_res2/linear_null_res2
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

# alternative model for each method in all individuals in AoU dataset
for (j in c(1,3:7)){
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

prs_final_table = rbind(prs_table[["AFR"]],prs_table[["AMR"]])
print(prs_final_table)

write.table(prs_final_table,paste0("./result/PRS/PRS_diff_cohort_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
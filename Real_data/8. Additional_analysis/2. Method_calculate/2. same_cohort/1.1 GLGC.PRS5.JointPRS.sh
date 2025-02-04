# JointPRS
# Step3: Calculate prs for each pop for each param in each trait
for trait in HDL LDL TC logTG; do
for pop in EUR_10K; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR
#SBATCH --output=out_PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out ${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_${pop}_phi${param_phi}
EOT
fi
done
done
done

# Step4: Select the optimal parameter and obtain the corresponding weight
library(data.table)
library(stringr)
library(dplyr)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(trait in c("HDL","LDL","TC","logTG")){
for(pop in c("EUR_10K")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phiauto.sscore"))
    Trait_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phi1e-06.sscore"))
    Trait_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phi1e-04.sscore"))
    Trait_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phi1e-02.sscore"))
    Trait_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_EUR_doubleid.tsv"), header = FALSE)
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phi1e_06_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phi1e_06_val = scale_pheno[Trait_JointPRS_phi1e_06_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phi1e_06_val = na.omit(Trait_JointPRS_phi1e_06_val)

    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phi1e_04_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phi1e_04_val = scale_pheno[Trait_JointPRS_phi1e_04_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phi1e_04_val = na.omit(Trait_JointPRS_phi1e_04_val)
    
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phi1e_02_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phi1e_02_val = scale_pheno[Trait_JointPRS_phi1e_02_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phi1e_02_val = na.omit(Trait_JointPRS_phi1e_02_val)

    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phi1e_00_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phi1e_00_val = scale_pheno[Trait_JointPRS_phi1e_00_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phi1e_00_val = na.omit(Trait_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:7)])
    lm_JointPRS_phi1e_06_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_06_val[,c(2:7)])
    lm_JointPRS_phi1e_04_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_04_val[,c(2:7)])
    lm_JointPRS_phi1e_02_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_02_val[,c(2:7)])
    lm_JointPRS_phi1e_00_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_00_val[,c(2:7)])

    Trait_JointPRS_val_R2 = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val)$`r.squared`,
                                    JointPRS_phi1e_06 = summary(lm_JointPRS_phi1e_06_val)$`r.squared`, 
                                    JointPRS_phi1e_04 = summary(lm_JointPRS_phi1e_04_val)$`r.squared`,
                                    JointPRS_phi1e_02 = summary(lm_JointPRS_phi1e_02_val)$`r.squared`, 
                                    JointPRS_phi1e_00 = summary(lm_JointPRS_phi1e_00_val)$`r.squared`)
    JointPRS_val_weight = data.table(rbind(lm_JointPRS_phiauto_val$coefficient,lm_JointPRS_phi1e_06_val$coefficient,lm_JointPRS_phi1e_04_val$coefficient,lm_JointPRS_phi1e_02_val$coefficient,lm_JointPRS_phi1e_00_val$coefficient))
                         
    ## best index
    JointPRS_index = which.max(Trait_JointPRS_val_R2)
    best_param = param_list[JointPRS_index]
    print(JointPRS_index)

    Trait_JointPRS_optimal_weight = JointPRS_val_weight[JointPRS_index,]
    Trait_JointPRS_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_phi",best_param,"_beta.txt"))

    write.table(Trait_JointPRS_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_JointPRS_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

## Part3: JointPRS: selecting between JointPRS-meta and JointPRS-tune based on R2 in validation
# we want to selecting between JointPRS-meta and JointPRS-tune
# but we compare R2 from JointPRS-auto and JointPRS-auto with linear combination as well as the f-test result between them as the selection guideline

# Step1: perform submodel test
library(data.table)
library(stringr)
library(dplyr)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(trait in c("HDL","LDL","TC","logTG")){
for(pop in c("EUR_10K")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_phiauto.sscore"))
    
    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_EUR_doubleid.tsv"), header = FALSE)
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7,8,9)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Trait_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val_sub = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,..col_idx])
    lm_JointPRS_phiauto_val_full = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:7)])

    R2_sub = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_sub)$`r.squared`)
    R2_full = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_full)$`r.squared`)

    p_value = anova(lm_JointPRS_phiauto_val_sub,lm_JointPRS_phiauto_val_full)$`Pr(>F)`
    p_value = na.omit(p_value)

    write.table(R2_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(R2_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_SAS_AMR_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
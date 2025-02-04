# PRScsx
# Step3: Calculate prs for each pop for each param in each trait
for trait in HDL LDL TC logTG; do
for pop in EUR_10K; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/${trait}_EUR_EAS_AFR_SAS_AMR_PRScsx_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_PRScsx_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR
#SBATCH --output=out_PRS_${trait}_PRScsx_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_AFR_SAS_AMR_PRScsx_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out ${trait}_EUR_EAS_AFR_SAS_AMR_PRScsx_${pop}_phi${param_phi}
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
    
    Trait_PRScsx_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_",pop,"_phiauto.sscore"))
    Trait_PRScsx_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_",pop,"_phi1e-06.sscore"))
    Trait_PRScsx_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_",pop,"_phi1e-04.sscore"))
    Trait_PRScsx_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_",pop,"_phi1e-02.sscore"))
    Trait_PRScsx_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_EUR_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## PRScsx
    Trait_PRScsx_phiauto_val = Trait_PRScsx_phiauto_val[,c(1,5,6,7,8,9)]
    colnames(Trait_PRScsx_phiauto_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_PRScsx_phiauto_val = scale_pheno[Trait_PRScsx_phiauto_val, on = .(eid = eid)]
    Trait_PRScsx_phiauto_val = Trait_PRScsx_phiauto_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_PRScsx_phiauto_val = na.omit(Trait_PRScsx_phiauto_val)
    
    Trait_PRScsx_phi1e_06_val = Trait_PRScsx_phi1e_06_val[,c(1,5,6,7,8,9)]
    colnames(Trait_PRScsx_phi1e_06_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_PRScsx_phi1e_06_val = scale_pheno[Trait_PRScsx_phi1e_06_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_06_val = Trait_PRScsx_phi1e_06_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_PRScsx_phi1e_06_val = na.omit(Trait_PRScsx_phi1e_06_val)

    Trait_PRScsx_phi1e_04_val = Trait_PRScsx_phi1e_04_val[,c(1,5,6,7,8,9)]
    colnames(Trait_PRScsx_phi1e_04_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_PRScsx_phi1e_04_val = scale_pheno[Trait_PRScsx_phi1e_04_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_04_val = Trait_PRScsx_phi1e_04_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_PRScsx_phi1e_04_val = na.omit(Trait_PRScsx_phi1e_04_val)
    
    Trait_PRScsx_phi1e_02_val = Trait_PRScsx_phi1e_02_val[,c(1,5,6,7,8,9)]
    colnames(Trait_PRScsx_phi1e_02_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_PRScsx_phi1e_02_val = scale_pheno[Trait_PRScsx_phi1e_02_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_02_val = Trait_PRScsx_phi1e_02_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_PRScsx_phi1e_02_val = na.omit(Trait_PRScsx_phi1e_02_val)

    Trait_PRScsx_phi1e_00_val = Trait_PRScsx_phi1e_00_val[,c(1,5,6,7,8,9)]
    colnames(Trait_PRScsx_phi1e_00_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Trait_PRScsx_phi1e_00_val = scale_pheno[Trait_PRScsx_phi1e_00_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_00_val = Trait_PRScsx_phi1e_00_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Trait_PRScsx_phi1e_00_val = na.omit(Trait_PRScsx_phi1e_00_val)

    # PRScsx validation data select the best performed parameter
    lm_PRScsx_phiauto_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phiauto_val[,c(2:7)])
    lm_PRScsx_phi1e_06_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_06_val[,c(2:7)])
    lm_PRScsx_phi1e_04_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_04_val[,c(2:7)])
    lm_PRScsx_phi1e_02_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_02_val[,c(2:7)])
    lm_PRScsx_phi1e_00_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_00_val[,c(2:7)])

    Trait_PRScsx_val_R2 = data.table(PRScsx_phiauto = summary(lm_PRScsx_phiauto_val)$`r.squared`,
                                    PRScsx_phi1e_06 = summary(lm_PRScsx_phi1e_06_val)$`r.squared`, 
                                    PRScsx_phi1e_04 = summary(lm_PRScsx_phi1e_04_val)$`r.squared`,
                                    PRScsx_phi1e_02 = summary(lm_PRScsx_phi1e_02_val)$`r.squared`, 
                                    PRScsx_phi1e_00 = summary(lm_PRScsx_phi1e_00_val)$`r.squared`)
    PRScsx_val_weight = data.table(rbind(lm_PRScsx_phiauto_val$coefficient,lm_PRScsx_phi1e_06_val$coefficient,lm_PRScsx_phi1e_04_val$coefficient,lm_PRScsx_phi1e_02_val$coefficient,lm_PRScsx_phi1e_00_val$coefficient))
                         
    ## best index
    PRScsx_index = which.max(Trait_PRScsx_val_R2)
    best_param = param_list[PRScsx_index]
    print(PRScsx_index)

    Trait_PRScsx_optimal_weight = PRScsx_val_weight[PRScsx_index,]
    Trait_PRScsx_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_SAS_AMR_PRScsx_phi",best_param,"_beta.txt"))

    write.table(Trait_PRScsx_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_PRScsx_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
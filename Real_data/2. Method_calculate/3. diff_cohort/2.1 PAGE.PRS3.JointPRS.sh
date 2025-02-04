## Part1: JointPRS-meta: auto estimator using GWAS that include validation data
# Step1: Estimate beta
for trait in Height BMI SBP DBP PLT; do

# sample size
if [[ ${trait} == "Height" ]]; then
sample_size1=252357; sample_size2=159095; sample_size3=56194
elif [[ ${trait} == "BMI" ]]; then
sample_size1=233787; sample_size2=158284; sample_size3=55736
elif [[ ${trait} == "SBP" ]]; then
sample_size1=728893; sample_size2=179000; sample_size3=41701
elif [[ ${trait} == "DBP" ]]; then
sample_size1=746038; sample_size2=179000; sample_size3=41701
elif [[ ${trait} == "PLT" ]]; then
sample_size1=539667; sample_size2=179000; sample_size3=35473
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_meta_AFR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_JointPRS_meta_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_JointPRS_meta_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_UKB_PRScsx.txt \
--rho_cons=1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/diff_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_JointPRS_meta

EOT
fi
done
done


# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("Height","BMI","SBP","DBP","PLT")){
for (pop in c("EAS","AFR")){

JointPRS_all <- data.table()
for(i in 1:22){
    JointPRS_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_meta_",pop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    JointPRS_pop_chr <- JointPRS_pop_chr[,c(2,4,6)]
    names(JointPRS_pop_chr) = c("rsID","A1",pop)

    JointPRS_all = rbind(JointPRS_all,JointPRS_pop_chr)
    
}

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)


}
}

## Part2: JointPRS-tune: tuning and linear combination estimator using GWAS that exclude validation data
# Step1: copy the beta estimate from same cohort as the estimation procedure is exactly the same
for trait in Height BMI SBP DBP PLT; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_phi${param_phi}_beta.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_phi${param_phi}_beta.txt
done
done

# Step2: copy the score estimate for the whole UKB results for further estimation
for trait in Height BMI SBP DBP PLT; do
for pop in EAS AFR; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_${pop}_phi${param_phi}.sscore /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_${pop}_phi${param_phi}.sscore
done
done
done

# Step3: Select the optimal parameter and obtain the corresponding weight
library(data.table)
library(stringr)
library(dplyr)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(trait in c("Height","BMI","SBP","DBP","PLT")){
for(pop in c("EAS","AFR")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phiauto.sscore"))
    Trait_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-06.sscore"))
    Trait_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-04.sscore"))
    Trait_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-02.sscore"))
    Trait_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",pop,"_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_06_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_06_val = scale_pheno[Trait_JointPRS_phi1e_06_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_06_val = na.omit(Trait_JointPRS_phi1e_06_val)

    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_04_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_04_val = scale_pheno[Trait_JointPRS_phi1e_04_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_04_val = na.omit(Trait_JointPRS_phi1e_04_val)
    
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_02_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_02_val = scale_pheno[Trait_JointPRS_phi1e_02_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_02_val = na.omit(Trait_JointPRS_phi1e_02_val)

    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_00_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_00_val = scale_pheno[Trait_JointPRS_phi1e_00_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_00_val = na.omit(Trait_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:5)])
    lm_JointPRS_phi1e_06_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_06_val[,c(2:5)])
    lm_JointPRS_phi1e_04_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_04_val[,c(2:5)])
    lm_JointPRS_phi1e_02_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_02_val[,c(2:5)])
    lm_JointPRS_phi1e_00_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_00_val[,c(2:5)])

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
    Trait_JointPRS_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_phi",best_param,"_beta.txt"))

    write.table(Trait_JointPRS_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_JointPRS_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

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

for(trait in c("Height","BMI","SBP","DBP","PLT")){
for(pop in c("EAS","AFR")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phiauto.sscore"))
    
    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",pop,"_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Trait_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val_sub = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,..col_idx])
    lm_JointPRS_phiauto_val_full = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:5)])

    R2_sub = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_sub)$`r.squared`)
    R2_full = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_full)$`r.squared`)

    p_value = anova(lm_JointPRS_phiauto_val_sub,lm_JointPRS_phiauto_val_full)$`Pr(>F)`
    p_value = na.omit(p_value)

    write.table(R2_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(R2_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_tune/",trait,"_JointPRS_linear_EUR_EAS_AFR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS_meta/",trait,"_JointPRS_meta_EUR_EAS_AFR_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step2:  Clean the previous result
for trait in Height BMI SBP DBP PLT; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/JointPRS/
rm -rf ${trait}_*_chr*.txt
done
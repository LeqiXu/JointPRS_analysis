## Part1: JointPRS-meta: auto estimator using GWAS that include validation data
# Step0: Copy the beta estimation for EAS from no_val as we use the same EAS GWAS
for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop in EAS; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/${trait}_JointPRS_EUR_${pop}_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/${trait}_JointPRS_meta_val_${s}_EUR_${pop}_beta_${pop}.txt
done
done
done

## Part2: JointPRS-tune: tuning and linear combination estimator using GWAS that exclude validation data
# Step1: Estimate beta
trait=GGT #WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT

# sample size
if [[ ${pop2} == "EAS" && ${trait} == "WBC" ]]; then
sample_size1=559083; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "NEU" ]]; then
sample_size1=517889; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "LYM" ]]; then
sample_size1=523524; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MON" ]]; then
sample_size1=520195; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "EOS" ]]; then
sample_size1=473152; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "RBC" ]]; then
sample_size1=542043; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "HCT" ]]; then
sample_size1=559099; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MCH" ]]; then
sample_size1=483664; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MCV" ]]; then
sample_size1=540967; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "HB" ]]; then
sample_size1=408112; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "ALT" ]]; then
sample_size1=437267; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "ALP" ]]; then
sample_size1=437267; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "GGT" ]]; then
sample_size1=437267; sample_size2=179000
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_JointPRS_EAS_pst_eff_a1_b0.5_phi${param_phi}_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${param_phi}" == "1e-06" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--rho_cons=0,0 \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--phi=${param_phi} \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_JointPRS
fi

if [[ "${param_phi}" != "auto" && "${param_phi}" != "1e-06" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--rho_cons=1,1 \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--phi=${param_phi} \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_JointPRS
fi

if [[ "${param_phi}" == "auto" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--rho_cons=1,1 \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_JointPRS
fi
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
for (param_phi in c("1e-06","1e-04","1e-02","1e+00","auto")){

JointPRS_all <- data.table()
for(chr in 1:22){
    JointPRS_EUR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_EUR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_EAS_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_EAS_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))

    JointPRS_EUR_chr <- JointPRS_EUR_chr[,c(2,4,6)]
    names(JointPRS_EUR_chr) = c("rsID","A1","EUR")
    JointPRS_EAS_chr <- JointPRS_EAS_chr[,c(2,4,6)]
    names(JointPRS_EAS_chr) = c("rsID","A1","EAS")

    JointPRS_all_chr = merge(JointPRS_EUR_chr,JointPRS_EAS_chr, by = c("rsID","A1"), all = TRUE)

    JointPRS_all = rbind(JointPRS_all,JointPRS_all_chr)
}

JointPRS_all[is.na(JointPRS_all)] <- 0

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait, "_EUR_EAS_JointPRS_phi",param_phi,"_beta.txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step3: Calculate prs for each pop for each param in each trait
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop in EAS; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_JointPRS_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS
#SBATCH --output=out_PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop}_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_JointPRS_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 \
--out ${trait}_EUR_EAS_JointPRS_${pop}_phi${param_phi}
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

for(s in c(1:5)){
for(trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
for(pop in c("EAS")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phiauto.sscore"))
    Trait_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-06.sscore"))
    Trait_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-04.sscore"))
    Trait_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-02.sscore"))
    Trait_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",pop,"_val_",s,"_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_06_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_06_val = scale_pheno[Trait_JointPRS_phi1e_06_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_06_val = na.omit(Trait_JointPRS_phi1e_06_val)

    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_04_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_04_val = scale_pheno[Trait_JointPRS_phi1e_04_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_04_val = na.omit(Trait_JointPRS_phi1e_04_val)
    
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_02_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_02_val = scale_pheno[Trait_JointPRS_phi1e_02_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_02_val = na.omit(Trait_JointPRS_phi1e_02_val)

    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_00_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_00_val = scale_pheno[Trait_JointPRS_phi1e_00_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_00_val = na.omit(Trait_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:4)])
    lm_JointPRS_phi1e_06_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_06_val[,c(2:4)])
    lm_JointPRS_phi1e_04_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_04_val[,c(2:4)])
    lm_JointPRS_phi1e_02_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_02_val[,c(2:4)])
    lm_JointPRS_phi1e_00_val = lm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_00_val[,c(2:4)])

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
    Trait_JointPRS_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_phi",best_param,"_beta.txt"))

    write.table(Trait_JointPRS_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_JointPRS_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
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

for(s in c(1:5)){
for(trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
for(pop in c("EAS")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phiauto.sscore"))
    
    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",pop,"_val_",s,"_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phiauto_val = scale_pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Trait_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val_sub = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,..col_idx])
    lm_JointPRS_phiauto_val_full = lm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:4)])

    R2_sub = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_sub)$`r.squared`)
    R2_full = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_full)$`r.squared`)

    p_value = anova(lm_JointPRS_phiauto_val_sub,lm_JointPRS_phiauto_val_full)$`Pr(>F)`
    p_value = na.omit(p_value)

    write.table(R2_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(R2_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

# Step2:  Clean the previous result
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/
rm -rf ${trait}_*_chr*.txt
done
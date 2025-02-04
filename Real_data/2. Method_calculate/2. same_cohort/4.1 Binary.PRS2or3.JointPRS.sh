## Part1: JointPRS-meta: auto estimator using GWAS that include validation data
# Step0: Copy the beta estimation for EAS and AFR from no_val as we use the same EAS AFR GWAS
for s in {1..5}; do
for trait in T2D BrC; do
for pop in EAS AFR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/${trait}_JointPRS_EUR_EAS_AFR_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/${trait}_JointPRS_meta_val_${s}_EUR_EAS_AFR_beta_${pop}.txt
done
done
done

for s in {1..5}; do
for trait in CAD LuC; do
for pop in EAS; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/${trait}_JointPRS_EUR_EAS_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/${trait}_JointPRS_meta_val_${s}_EUR_EAS_beta_${pop}.txt
done
done
done

## Part2: JointPRS-tune: tuning and linear combination estimator using GWAS that exclude validation data
# Step1: Estimate beta
trait=LuC #T2D BrC CAD LuC

# sample size
if [[ ${trait} == "T2D" ]]; then
sample_size1=88825; sample_size2=118493; sample_size3=38919
elif [[ ${trait} == "BrC" ]]; then
sample_size1=245620; sample_size2=27138; sample_size3=7434
elif [[ ${trait} == "CAD" ]]; then
sample_size1=61333; sample_size2=101092
elif [[ ${trait} == "LuC" ]]; then
sample_size1=77095; sample_size2=15891
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_AFR_pst_eff_a1_b0.5_phi${param_phi}_chr${chr}.txt" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_JointPRS_EAS_pst_eff_a1_b0.5_phi${param_phi}_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${param_phi}" == "1e-06" ]]; then
if [[ "${trait}" == "T2D" ]] || [[ "${trait}" == "BrC" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--rho_cons=0,0,0 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--phi=${param_phi} \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_JointPRS
fi

if [[ "${trait}" == "CAD" ]] || [[ "${trait}" == "LuC" ]]; then
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
fi

if [[ "${param_phi}" != "auto" && "${param_phi}" != "1e-06" ]]; then
if [[ "${trait}" == "T2D" ]] || [[ "${trait}" == "BrC" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--rho_cons=1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--phi=${param_phi} \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_JointPRS
fi

if [[ "${trait}" == "CAD" ]] || [[ "${trait}" == "LuC" ]]; then
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
fi

if [[ "${param_phi}" == "auto" ]]; then
if [[ "${trait}" == "T2D" ]] || [[ "${trait}" == "BrC" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--rho_cons=1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/same_cohort/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_JointPRS
fi

if [[ "${trait}" == "CAD" ]] || [[ "${trait}" == "LuC" ]]; then
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
fi
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("T2D","BrC")){
for (param_phi in c("1e-06","1e-04","1e-02","1e+00","auto")){

JointPRS_all <- data.table()
for(chr in 1:22){
    JointPRS_EUR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_EUR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_EAS_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_EAS_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_AFR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_AFR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))

    JointPRS_EUR_chr <- JointPRS_EUR_chr[,c(2,4,6)]
    names(JointPRS_EUR_chr) = c("rsID","A1","EUR")
    JointPRS_EAS_chr <- JointPRS_EAS_chr[,c(2,4,6)]
    names(JointPRS_EAS_chr) = c("rsID","A1","EAS")
    JointPRS_AFR_chr <- JointPRS_AFR_chr[,c(2,4,6)]
    names(JointPRS_AFR_chr) = c("rsID","A1","AFR")

    JointPRS_all_chr = merge(JointPRS_EUR_chr,JointPRS_EAS_chr, by = c("rsID","A1"), all = TRUE)
    JointPRS_all_chr = merge(JointPRS_all_chr,JointPRS_AFR_chr, by = c("rsID","A1"), all = TRUE)

    JointPRS_all = rbind(JointPRS_all,JointPRS_all_chr)
}

JointPRS_all[is.na(JointPRS_all)] <- 0

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait, "_EUR_EAS_AFR_JointPRS_phi",param_phi,"_beta.txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

library(data.table)

for (trait in c("CAD","LuC")){
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
for trait in T2D BrC; do
for pop in EAS AFR; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS_AFR
#SBATCH --output=out_PRS_${trait}_JointPRS_${pop}_phi${param_phi}_EUR_EAS_AFR.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop}_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_AFR_JointPRS_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 5 \
--out ${trait}_EUR_EAS_AFR_JointPRS_${pop}_phi${param_phi}
EOT
fi
done
done
done

for trait in CAD LuC; do
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
library(pROC)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(s in c(1:5)){
for(trait in c("T2D","BrC")){
for(pop in c("EAS","AFR")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phiauto.sscore"))
    Trait_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-06.sscore"))
    Trait_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-04.sscore"))
    Trait_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e-02.sscore"))
    Trait_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phi1e+00.sscore"))

    pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",pop,"_val_",s,"_doubleid.tsv"))
    pheno = pheno[,c(1,3)]
    colnames(pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phiauto_val = pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_06_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_06_val = pheno[Trait_JointPRS_phi1e_06_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_06_val = na.omit(Trait_JointPRS_phi1e_06_val)

    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_04_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_04_val = pheno[Trait_JointPRS_phi1e_04_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_04_val = na.omit(Trait_JointPRS_phi1e_04_val)
    
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_02_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_02_val = pheno[Trait_JointPRS_phi1e_02_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_02_val = na.omit(Trait_JointPRS_phi1e_02_val)

    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phi1e_00_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phi1e_00_val = pheno[Trait_JointPRS_phi1e_00_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phi1e_00_val = na.omit(Trait_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    glm_JointPRS_phiauto_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:5)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_06_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_06_val[,c(2:5)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_04_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_04_val[,c(2:5)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_02_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_02_val[,c(2:5)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_00_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_00_val[,c(2:5)],family=binomial(link="logit"))

    Trait_JointPRS_val_AUC = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val, type="response"), quiet=T, plot=F)$auc,
                                    JointPRS_phi1e_06 = roc(Trait_JointPRS_phi1e_06_val$pheno, predict(glm_JointPRS_phi1e_06_val, type="response"), quiet=T, plot=F)$auc, 
                                    JointPRS_phi1e_04 = roc(Trait_JointPRS_phi1e_04_val$pheno, predict(glm_JointPRS_phi1e_04_val, type="response"), quiet=T, plot=F)$auc,
                                    JointPRS_phi1e_02 = roc(Trait_JointPRS_phi1e_02_val$pheno, predict(glm_JointPRS_phi1e_02_val, type="response"), quiet=T, plot=F)$auc, 
                                    JointPRS_phi1e_00 = roc(Trait_JointPRS_phi1e_00_val$pheno, predict(glm_JointPRS_phi1e_00_val, type="response"), quiet=T, plot=F)$auc)                         

    JointPRS_val_weight = data.table(rbind(glm_JointPRS_phiauto_val$coefficient,glm_JointPRS_phi1e_06_val$coefficient,glm_JointPRS_phi1e_04_val$coefficient,glm_JointPRS_phi1e_02_val$coefficient,glm_JointPRS_phi1e_00_val$coefficient))
                         
    ## best index
    JointPRS_index = which.max(Trait_JointPRS_val_AUC)
    best_param = param_list[JointPRS_index]
    print(JointPRS_index)

    Trait_JointPRS_optimal_weight = JointPRS_val_weight[JointPRS_index,]
    Trait_JointPRS_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_phi",best_param,"_beta.txt"))

    write.table(Trait_JointPRS_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_JointPRS_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

library(data.table)
library(stringr)
library(dplyr)
library(pROC)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(s in c(1:5)){
for(trait in c("CAD","LuC")){
for(pop in c("EAS")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phiauto.sscore"))
    Trait_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-06.sscore"))
    Trait_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-04.sscore"))
    Trait_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e-02.sscore"))
    Trait_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phi1e+00.sscore"))

    pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",pop,"_val_",s,"_doubleid.tsv"))
    pheno = pheno[,c(1,3)]
    colnames(pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phiauto_val = pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_06_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_06_val = pheno[Trait_JointPRS_phi1e_06_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_06_val = Trait_JointPRS_phi1e_06_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_06_val = na.omit(Trait_JointPRS_phi1e_06_val)

    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_04_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_04_val = pheno[Trait_JointPRS_phi1e_04_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_04_val = Trait_JointPRS_phi1e_04_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_04_val = na.omit(Trait_JointPRS_phi1e_04_val)
    
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_02_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_02_val = pheno[Trait_JointPRS_phi1e_02_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_02_val = Trait_JointPRS_phi1e_02_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_02_val = na.omit(Trait_JointPRS_phi1e_02_val)

    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phi1e_00_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phi1e_00_val = pheno[Trait_JointPRS_phi1e_00_val, on = .(eid = eid)]
    Trait_JointPRS_phi1e_00_val = Trait_JointPRS_phi1e_00_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phi1e_00_val = na.omit(Trait_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    glm_JointPRS_phiauto_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:4)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_06_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_06_val[,c(2:4)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_04_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_04_val[,c(2:4)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_02_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_02_val[,c(2:4)],family=binomial(link="logit"))
    glm_JointPRS_phi1e_00_val = glm(pheno ~ . + 0, data = Trait_JointPRS_phi1e_00_val[,c(2:4)],family=binomial(link="logit"))

    Trait_JointPRS_val_AUC = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val, type="response"), quiet=T, plot=F)$auc,
                                    JointPRS_phi1e_06 = roc(Trait_JointPRS_phi1e_06_val$pheno, predict(glm_JointPRS_phi1e_06_val, type="response"), quiet=T, plot=F)$auc, 
                                    JointPRS_phi1e_04 = roc(Trait_JointPRS_phi1e_04_val$pheno, predict(glm_JointPRS_phi1e_04_val, type="response"), quiet=T, plot=F)$auc,
                                    JointPRS_phi1e_02 = roc(Trait_JointPRS_phi1e_02_val$pheno, predict(glm_JointPRS_phi1e_02_val, type="response"), quiet=T, plot=F)$auc, 
                                    JointPRS_phi1e_00 = roc(Trait_JointPRS_phi1e_00_val$pheno, predict(glm_JointPRS_phi1e_00_val, type="response"), quiet=T, plot=F)$auc)                         

    JointPRS_val_weight = data.table(rbind(glm_JointPRS_phiauto_val$coefficient,glm_JointPRS_phi1e_06_val$coefficient,glm_JointPRS_phi1e_04_val$coefficient,glm_JointPRS_phi1e_02_val$coefficient,glm_JointPRS_phi1e_00_val$coefficient))
                         
    ## best index
    JointPRS_index = which.max(Trait_JointPRS_val_AUC)
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
library(pROC)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(s in c(1:5)){
for(trait in c("T2D","BrC")){
for(pop in c("EAS","AFR")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_AFR_JointPRS_",pop,"_phiauto.sscore"))
    
    pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",pop,"_val_",s,"_doubleid.tsv"))
    pheno =pheno[,c(1,3)]
    colnames(pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6,7)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR")
    Trait_JointPRS_phiauto_val = pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Trait_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    glm_JointPRS_phiauto_val_full = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:5)],family=binomial(link="logit"))
    glm_JointPRS_phiauto_val_sub = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,..col_idx],family=binomial(link="logit"))

    AUC_sub = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val_sub, type="response"), quiet=T, plot=F)$auc)
    AUC_full = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val_full, type="response"), quiet=T, plot=F)$auc)

    p_value = anova(glm_JointPRS_phiauto_val_sub,glm_JointPRS_phiauto_val_full,test="Chisq")$`Pr(>Chi)`
    p_value = na.omit(p_value)

    write.table(AUC_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_auc_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(AUC_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_AFR_auc_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_AFR_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

library(data.table)
library(stringr)
library(dplyr)
library(pROC)

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for(s in c(1:5)){
for(trait in c("CAD","LuC")){
for(pop in c("EAS")){
    
    Trait_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/",trait,"_EUR_EAS_JointPRS_",pop,"_phiauto.sscore"))
    
    pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",pop,"_val_",s,"_doubleid.tsv"))
    pheno =pheno[,c(1,3)]
    colnames(pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(1,5,6)]
    colnames(Trait_JointPRS_phiauto_val) = c("eid","EUR","EAS")
    Trait_JointPRS_phiauto_val = pheno[Trait_JointPRS_phiauto_val, on = .(eid = eid)]
    Trait_JointPRS_phiauto_val = Trait_JointPRS_phiauto_val[,c(3:4) := lapply(.SD,scale),.SDcols = c(3:4)]
    Trait_JointPRS_phiauto_val = na.omit(Trait_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Trait_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    glm_JointPRS_phiauto_val_sub = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,..col_idx],family=binomial(link="logit"))
    glm_JointPRS_phiauto_val_full = glm(pheno ~ . + 0, data = Trait_JointPRS_phiauto_val[,c(2:4)],family=binomial(link="logit"))

    AUC_sub = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val_sub, type="response"), quiet=T, plot=F)$auc)
    AUC_full = data.table(JointPRS_phiauto = roc(Trait_JointPRS_phiauto_val$pheno, predict(glm_JointPRS_phiauto_val_full, type="response"), quiet=T, plot=F)$auc)

    p_value = anova(glm_JointPRS_phiauto_val_sub,glm_JointPRS_phiauto_val_full,test="Chisq")$`Pr(>Chi)`
    p_value = na.omit(p_value)

    write.table(AUC_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_auc_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(AUC_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/",trait,"_JointPRS_linear_val_",s,"_EUR_EAS_auc_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/",trait,"_JointPRS_meta_val_",s,"_EUR_EAS_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

# Step2:  Clean the previous result
for trait in T2D BrC CAD LuC; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/
rm -rf ${trait}_*_chr*.txt
done
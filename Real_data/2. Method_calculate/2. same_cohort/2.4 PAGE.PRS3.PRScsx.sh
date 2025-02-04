# PRScsx
# Step1: Estimate beta
trait=PLT #Height BMI SBP DBP PLT

# sample size
if [[ ${trait} == "Height" ]]; then
sample_size1=252357; sample_size2=159095; sample_size3=49781
elif [[ ${trait} == "BMI" ]]; then
sample_size1=233787; sample_size2=158284; sample_size3=49335
elif [[ ${trait} == "SBP" ]]; then
sample_size1=728893; sample_size2=179000; sample_size3=35433
elif [[ ${trait} == "DBP" ]]; then
sample_size1=746038; sample_size2=179000; sample_size3=35433
elif [[ ${trait} == "PLT" ]]; then
sample_size1=539667; sample_size2=179000; sample_size3=29328
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/${trait}_EUR_EAS_AFR_PRScsx_AFR_pst_eff_a1_b0.5_phi${param_phi}_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_PRScsx_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_PRScsx_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${param_phi}" != "auto" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--phi=${param_phi} \
--out_dir=result/summary_result/same_cohort/PRScsx \
--out_name=${trait}_EUR_EAS_AFR_PRScsx
fi

if [[ "${param_phi}" == "auto" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/same_cohort/PRScsx \
--out_name=${trait}_EUR_EAS_AFR_PRScsx
fi
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("Height","BMI","SBP","DBP","PLT")){
for (param_phi in c("1e-06","1e-04","1e-02","1e+00","auto")){

PRScsx_all <- data.table()
for(chr in 1:22){
    PRScsx_EUR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_EUR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    PRScsx_EAS_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_EAS_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    PRScsx_AFR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_AFR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))

    PRScsx_EUR_chr <- PRScsx_EUR_chr[,c(2,4,6)]
    names(PRScsx_EUR_chr) = c("rsID","A1","EUR")
    PRScsx_EAS_chr <- PRScsx_EAS_chr[,c(2,4,6)]
    names(PRScsx_EAS_chr) = c("rsID","A1","EAS")
    PRScsx_AFR_chr <- PRScsx_AFR_chr[,c(2,4,6)]
    names(PRScsx_AFR_chr) = c("rsID","A1","AFR")

    PRScsx_all_chr = merge(PRScsx_EUR_chr,PRScsx_EAS_chr, by = c("rsID","A1"), all = TRUE)
    PRScsx_all_chr = merge(PRScsx_all_chr,PRScsx_AFR_chr, by = c("rsID","A1"), all = TRUE)

    PRScsx_all = rbind(PRScsx_all,PRScsx_all_chr)
}

PRScsx_all[is.na(PRScsx_all)] <- 0

write.table(PRScsx_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait, "_EUR_EAS_AFR_PRScsx_phi",param_phi,"_beta.txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step3: Calculate prs for each pop for each param in each trait
for trait in Height BMI SBP DBP PLT; do
for pop in EAS AFR; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/${trait}_EUR_EAS_AFR_PRScsx_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_PRScsx_${pop}_phi${param_phi}_EUR_EAS_AFR
#SBATCH --output=out_PRS_${trait}_PRScsx_${pop}_phi${param_phi}_EUR_EAS_AFR.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop}_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_AFR_PRScsx_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 5 \
--out ${trait}_EUR_EAS_AFR_PRScsx_${pop}_phi${param_phi}
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
for(trait in c("Height","BMI","SBP","DBP","PLT")){
for(pop in c("EAS","AFR")){
    
    Trait_PRScsx_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_phiauto.sscore"))
    Trait_PRScsx_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_phi1e-06.sscore"))
    Trait_PRScsx_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_phi1e-04.sscore"))
    Trait_PRScsx_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_phi1e-02.sscore"))
    Trait_PRScsx_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",pop,"_val_",s,"_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## PRScsx
    Trait_PRScsx_phiauto_val = Trait_PRScsx_phiauto_val[,c(1,5,6,7)]
    colnames(Trait_PRScsx_phiauto_val) = c("eid","EUR","EAS","AFR")
    Trait_PRScsx_phiauto_val = scale_pheno[Trait_PRScsx_phiauto_val, on = .(eid = eid)]
    Trait_PRScsx_phiauto_val = Trait_PRScsx_phiauto_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_PRScsx_phiauto_val = na.omit(Trait_PRScsx_phiauto_val)
    
    Trait_PRScsx_phi1e_06_val = Trait_PRScsx_phi1e_06_val[,c(1,5,6,7)]
    colnames(Trait_PRScsx_phi1e_06_val) = c("eid","EUR","EAS","AFR")
    Trait_PRScsx_phi1e_06_val = scale_pheno[Trait_PRScsx_phi1e_06_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_06_val = Trait_PRScsx_phi1e_06_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_PRScsx_phi1e_06_val = na.omit(Trait_PRScsx_phi1e_06_val)

    Trait_PRScsx_phi1e_04_val = Trait_PRScsx_phi1e_04_val[,c(1,5,6,7)]
    colnames(Trait_PRScsx_phi1e_04_val) = c("eid","EUR","EAS","AFR")
    Trait_PRScsx_phi1e_04_val = scale_pheno[Trait_PRScsx_phi1e_04_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_04_val = Trait_PRScsx_phi1e_04_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_PRScsx_phi1e_04_val = na.omit(Trait_PRScsx_phi1e_04_val)
    
    Trait_PRScsx_phi1e_02_val = Trait_PRScsx_phi1e_02_val[,c(1,5,6,7)]
    colnames(Trait_PRScsx_phi1e_02_val) = c("eid","EUR","EAS","AFR")
    Trait_PRScsx_phi1e_02_val = scale_pheno[Trait_PRScsx_phi1e_02_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_02_val = Trait_PRScsx_phi1e_02_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_PRScsx_phi1e_02_val = na.omit(Trait_PRScsx_phi1e_02_val)

    Trait_PRScsx_phi1e_00_val = Trait_PRScsx_phi1e_00_val[,c(1,5,6,7)]
    colnames(Trait_PRScsx_phi1e_00_val) = c("eid","EUR","EAS","AFR")
    Trait_PRScsx_phi1e_00_val = scale_pheno[Trait_PRScsx_phi1e_00_val, on = .(eid = eid)]
    Trait_PRScsx_phi1e_00_val = Trait_PRScsx_phi1e_00_val[,c(3:5) := lapply(.SD,scale),.SDcols = c(3:5)]
    Trait_PRScsx_phi1e_00_val = na.omit(Trait_PRScsx_phi1e_00_val)

    # PRScsx validation data select the best performed parameter
    lm_PRScsx_phiauto_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phiauto_val[,c(2:5)])
    lm_PRScsx_phi1e_06_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_06_val[,c(2:5)])
    lm_PRScsx_phi1e_04_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_04_val[,c(2:5)])
    lm_PRScsx_phi1e_02_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_02_val[,c(2:5)])
    lm_PRScsx_phi1e_00_val = lm(pheno ~ . + 0, data = Trait_PRScsx_phi1e_00_val[,c(2:5)])

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
    Trait_PRScsx_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_phi",best_param,"_beta.txt"))

    write.table(Trait_PRScsx_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_val_",s,"_EUR_EAS_AFR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(Trait_PRScsx_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/",trait,"_PRScsx_val_",s,"_EUR_EAS_AFR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

# Step5:  Clean the previous result
for trait in Height BMI SBP DBP PLT; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/
rm -rf ${trait}_*_chr*.txt
done
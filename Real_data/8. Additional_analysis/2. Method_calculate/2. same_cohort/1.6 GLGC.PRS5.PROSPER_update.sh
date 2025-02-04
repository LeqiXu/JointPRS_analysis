# PROSPER
## Step 3: statistical learning
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER_update
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for trait in HDL LDL TC logTG; do
for pop2 in EUR; do
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_PROSPER_SL
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_PROSPER_SL.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/scripts/tuning_testing.R \
--PATH_plink ${path_plink} \
--PATH_out ${path_result}/${trait}/PROSPER_EUR_EAS_AFR_SAS_AMR \
--prefix ${pop2} \
--bfile_tuning ${ukb_pheno}/geno_data/EUR_10K \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/${trait}_scale_${pop2}_doubleid.tsv \
--cleanup FALSE \
--NCORES 5
EOT
done
done

## Step4: copy the beta_file into the Final weight folder
for trait in HDL LDL TC logTG; do
for pop2 in EUR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/PROSPER/${trait}/PROSPER_EUR_EAS_AFR_SAS_AMR/after_ensemble_${pop2}/PROSPER_prs_file.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_update_EUR_EAS_AFR_SAS_AMR_beta_EUR_10K.txt
done
done

## Select three column
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop2 in c("EUR_10K")){
beta_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/",trait,"_PROSPER_update_EUR_EAS_AFR_SAS_AMR_beta_",pop2,".txt"))
beta_df = beta_df[,c("rsid","a1","weight")]

write.table(beta_df, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/",trait,"_PROSPER_update_EUR_EAS_AFR_SAS_AMR_beta_",pop2,".txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
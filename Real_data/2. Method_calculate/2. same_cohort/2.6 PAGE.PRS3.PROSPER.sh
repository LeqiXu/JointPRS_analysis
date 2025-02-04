# PROSPER
for trait in Height BMI SBP DBP PLT; do
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/${trait}
done

## Step 1: run and tune lassosum
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop in EUR EAS AFR; do
if [[ ! -e "${path_result}/${trait}/lassosum2_val_${s}/${pop}/optimal_param.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_${pop}_lassosum_val_${s}
#SBATCH --output=out_${trait}_${pop}_lassosum_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2

## Step1
if [[ "${pop}" == "EUR" ]]; then
Rscript ${package}/scripts/lassosum2.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/lassosum2_val_${s} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${trait}_${pop}_inter_PROSPER.txt \
--pop ${pop} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop}_10K \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/${trait}_scale_${pop}_doubleid.tsv \
--NCORES 5
fi

if [[ "${pop}" != "EUR" ]]; then
Rscript ${package}/scripts/lassosum2.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/lassosum2_val_${s} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${trait}_${pop}_inter_PROSPER.txt \
--pop ${pop} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop} \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/split/${trait}_scale_${pop}_val_${s}_doubleid.tsv \
--NCORES 5
fi
EOT
fi
done
done
done

## Step 2: run PROSPER
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
if [[ ! -e "${path_result}/${trait}/PROSPER_val_${s}_EUR_EAS_AFR/before_ensemble/score_param.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_PROSPER_val_${s}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_PROSPER_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/scripts/PROSPER.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/PROSPER_val_${s}_EUR_EAS_AFR \
--FILE_sst ${sum_data}/${trait}_EUR_inter_PROSPER.txt,${sum_data}/${trait}_EAS_inter_PROSPER.txt,${sum_data}/${trait}_AFR_inter_PROSPER.txt \
--pop EUR,EAS,AFR \
--lassosum_param ${path_result}/${trait}/lassosum2_val_${s}/EUR/optimal_param.txt,${path_result}/${trait}/lassosum2_val_${s}/EAS/optimal_param.txt,${path_result}/${trait}/lassosum2_val_${s}/AFR/optimal_param.txt \
--chrom 1-22 \
--NCORES 5
EOT
fi
done
done

## Step 3: statistical learning
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "${path_result}/${trait}/PROSPER_val_${s}_EUR_EAS_AFR/after_ensemble_${pop2}/PROSPER_prs_file.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_PROSPER_SL_val_${s}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_PROSPER_SL_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/scripts/tuning_testing.R \
--PATH_plink ${path_plink} \
--PATH_out ${path_result}/${trait}/PROSPER_val_${s}_EUR_EAS_AFR \
--prefix ${pop2} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/split/${trait}_scale_${pop2}_val_${s}_doubleid.tsv \
--cleanup FALSE \
--NCORES 5
EOT
fi
done
done
done

## Step4: copy the beta_file into the Final weight folder
for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/${trait}/PROSPER_val_${s}_EUR_EAS_AFR/after_ensemble_${pop2}/PROSPER_prs_file.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt
done
done
done

## Select three column
library(data.table)

for (s in c(1:5)){
for (trait in c("Height","BMI","SBP","DBP","PLT")){
for (pop2 in c("EAS","AFR")){
beta_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/",trait,"_PROSPER_val_",s,"_EUR_EAS_AFR_beta_",pop2,".txt"))
beta_df = beta_df[,c("rsid","a1","weight")]

write.table(beta_df, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/",trait,"_PROSPER_val_",s,"_EUR_EAS_AFR_beta_",pop2,".txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
}

## Step5: Clean the previous result
for trait in Height BMI SBP DBP PLT; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/${trait}
rm -rf PROSPER_*
rm -rf lassosum2_*
done
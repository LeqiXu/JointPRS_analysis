# MUSSEL
for trait in HDL LDL TC logTG; do
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/${trait}
done

## Step 1: run LDpred2
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR SAS AMR; do
for chr in {1..22}; do
if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop1}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]] || [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop2}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_chr${chr}_LDpred2_val_${s}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_chr${chr}_LDpred2_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2

if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop1}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
Rscript ${package}/R/LDpred2.R  \
--PATH_package ${package} \
--PATH_ref ${path_LDref} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--FILE_sst ${sum_data}/${trait}_${pop1}_inter_PROSPER.txt \
--pop ${pop1} \
--chrom ${chr} \
--p 1e-04,0.00018,0.00032,0.00056,0.001,0.0018,0.0032,0.0056,0.01,0.018,0.032,0.056,0.1,0.18,0.32,0.56,1 \
--H2 0.7,1,1.4 \
--sparse 0 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop1}_10K \
--NCORES 5
fi

if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop2}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
Rscript ${package}/R/LDpred2.R  \
--PATH_package ${package} \
--PATH_ref ${path_LDref} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--FILE_sst ${sum_data}/${trait}_${pop2}_inter_PROSPER.txt \
--pop ${pop2} \
--chrom ${chr} \
--p 1e-04,0.00018,0.00032,0.00056,0.001,0.0018,0.0032,0.0056,0.01,0.018,0.032,0.056,0.1,0.18,0.32,0.56,1 \
--H2 0.7,1,1.4 \
--sparse 0 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2} \
--NCORES 5
fi
EOT
fi
done
done
done
done

## Step 2: tune LDpred2
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for s in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop1}/optim_params.txt" ]] || [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop2}/optim_params.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_LDpred2_val_${s}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_LDpred2_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2

if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop1}/optim_params.txt" ]]; then
Rscript ${package}/R/LDpred2_tuning.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${trait}_${pop1}_inter_PROSPER.txt \
--pop ${pop1} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop1}_10K \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/${trait}_scale_${pop1}_doubleid.tsv \
--NCORES 5
fi

if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/${pop2}/optim_params.txt" ]]; then
Rscript ${package}/R/LDpred2_tuning.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${trait}_${pop2}_inter_PROSPER.txt \
--pop ${pop2} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/split/${trait}_scale_${pop2}_val_${s}_doubleid.tsv \
--NCORES 5
fi
EOT
fi
done
done
done

## Step 3: run MUSS
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR

for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for chr in {1..22}; do
if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/tmp/MUSS_beta_in_all_settings_bychrom/AMR-chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_chr${chr}_MUSS_val_${s}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_chr${chr}_MUSS_val_${s}.txt

module load miniconda
conda activate r_env
module load PLINK/2
        
Rscript ${package}/R/MUSS.R \
--PATH_package ${package} \
--PATH_LDref ${path_LDref} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--FILE_sst ${sum_data}/${trait}_EUR_inter_PROSPER.txt,${sum_data}/${trait}_EAS_inter_PROSPER.txt,${sum_data}/${trait}_AFR_inter_PROSPER.txt,${sum_data}/${trait}_SAS_inter_PROSPER.txt,${sum_data}/${trait}_AMR_inter_PROSPER.txt \
--pop EUR,EAS,AFR,SAS,AMR \
--LDpred2_params ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/EUR/optim_params.txt,${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/EAS/optim_params.txt,${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/AFR/optim_params.txt,${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/SAS/optim_params.txt,${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/AMR/optim_params.txt \
--chrom ${chr} --cors_additional NA --ps_additional NA \
--bfile_tuning ${ukb_pheno}/geno_data/EUR_10K,${ukb_pheno}/geno_data/EAS,${ukb_pheno}/geno_data/AFR,${ukb_pheno}/geno_data/SAS,${ukb_pheno}/geno_data/AMR \
--NCORES 5
EOT
fi
done
done
done

## Step 4: statistical learning
path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data

pop1=EUR
for s in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/MUSSEL/MUSSEL_beta_file_${pop2}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_MUSSEL
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_MUSSEL.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/R/MUSSEL.R \
--PATH_package ${package} \
--PATH_out ${path_result}/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR \
--PATH_plink ${path_plink} \
--pop ${pop2} \
--target_pop ${pop2} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${trait}/split/${trait}_scale_${pop2}_val_${s}_doubleid.tsv \
--testing FALSE \
--NCORES 1
EOT
fi
done
done
done

## Step5: copy the beta_file into the Final weight folder
for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/${trait}/MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR/MUSSEL/MUSSEL_beta_file_${pop2}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/MUSSEL/${trait}_MUSSEL_val_${s}_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt
done
done
done

## Step6: Clean the previous result
for trait in HDL LDL TC logTG; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/${trait}
rm -rf MUSSEL_*
done
# MUSSEL
## Step 1: run LDpred2
i=5 #1-5
rho=0.8
p=0.1 #0.001 0.01 5e-04 0.1

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

pop1=EUR
sample1=UKB
val_sample=10K # 0.5K 2K 5K 10K

for sample2 in 15K 80K; do
for pop2 in EAS AFR SAS AMR; do
for chr in {1..22}; do
if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop1}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]] || [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop2}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_chr${chr}_LDpred2_real
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_chr${chr}_LDpred2_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop1}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
Rscript ${package}/R/LDpred2.R  \
--PATH_package ${package} \
--PATH_ref ${path_LDref} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--FILE_sst ${sum_data}/${pop1}/discover/PROSPER/${pop1}_sim${i}_p${p}_rho${rho}_UKB_PROSPER_real.txt \
--pop ${pop1} \
--chrom ${chr} \
--p 1e-04,0.00018,0.00032,0.00056,0.001,0.0018,0.0032,0.0056,0.01,0.018,0.032,0.056,0.1,0.18,0.32,0.56,1 \
--H2 0.7,1,1.4 \
--sparse 0 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop1}/validate/${pop1} \
--NCORES 5
fi

if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop2}/tmp/beta_files/beta_in_all_settings_bychrom/ldpred2effect-chr${chr}.txt" ]]; then
Rscript ${package}/R/LDpred2.R  \
--PATH_package ${package} \
--PATH_ref ${path_LDref} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--FILE_sst ${sum_data}/${pop2}/discover/PROSPER/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt \
--pop ${pop2} \
--chrom ${chr} \
--p 1e-04,0.00018,0.00032,0.00056,0.001,0.0018,0.0032,0.0056,0.01,0.018,0.032,0.056,0.1,0.18,0.32,0.56,1 \
--H2 0.7,1,1.4 \
--sparse 0 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2}/validate/${pop2} \
--NCORES 5
fi
EOT
fi
done
done
done

## Step 2: tune LDpred2
i=5 #1-5
rho=0.8

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for val_sample in 0.5K 2K 5K 10K; do
for sample2 in 15K 80K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop1}/optim_params.txt" ]] || [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop2}/optim_params.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_LDpred2_real
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_LDpred2_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop1}/optim_params.txt" ]]; then
Rscript ${package}/R/LDpred2_tuning.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${pop1}/discover/PROSPER/${pop1}_sim${i}_p${p}_rho${rho}_UKB_PROSPER_real.txt \
--pop ${pop1} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop1}/validate/${pop1} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleid.tsv \
--NCORES 5
fi

if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/${pop2}/optim_params.txt" ]]; then
Rscript ${package}/R/LDpred2_tuning.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${pop2}/discover/PROSPER/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt \
--pop ${pop2} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2}/validate/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleid.tsv \
--NCORES 5
fi
EOT
fi
done
done
done
done

## Step 3: run MUSS
i=1 #1-5
rho=0.8
p=0.1 #0.001 0.01 5e-04 0.1

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

pop1=EUR
sample1=UKB

for val_sample in 0.5K 2K 5K 10K; do
for sample2 in 15K 80K; do
for chr in {1..22}; do
if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/tmp/MUSS_beta_in_all_settings_bychrom/AMR-chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_chr${chr}_MUSS_real
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_chr${chr}_MUSS_real.txt

module load miniconda
conda activate r_env
module load PLINK/2
        
Rscript ${package}/R/MUSS.R \
--PATH_package ${package} \
--PATH_LDref ${path_LDref} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--FILE_sst ${sum_data}/EUR/discover/PROSPER/EUR_sim${i}_p${p}_rho${rho}_UKB_PROSPER_real.txt,${sum_data}/EAS/discover/PROSPER/EAS_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/AFR/discover/PROSPER/AFR_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/SAS/discover/PROSPER/SAS_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/AMR/discover/PROSPER/AMR_sim${i}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt \
--pop EUR,EAS,AFR,SAS,AMR \
--LDpred2_params ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/EUR/optim_params.txt,${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/EAS/optim_params.txt,${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/AFR/optim_params.txt,${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/SAS/optim_params.txt,${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/AMR/optim_params.txt \
--chrom ${chr} --cors_additional NA --ps_additional NA \
--bfile_tuning ${ukb_pheno}/geno_data/EUR/validate/EUR,${ukb_pheno}/geno_data/EAS/validate/EAS,${ukb_pheno}/geno_data/AFR/validate/AFR,${ukb_pheno}/geno_data/SAS/validate/SAS,${ukb_pheno}/geno_data/AMR/validate/AMR \
--NCORES 5
EOT
fi
done
done
done

## Step 4: statistical learning
i=5 #1-5
rho=0.8

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/MUSSEL
path_LDref=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/MUSSEL/1kg
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for val_sample in 0.5K 2K 5K 10K; do
for sample2 in 15K 80K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/MUSSEL/MUSSEL_beta_file_${pop2}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_MUSSEL_real
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_MUSSEL_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/R/MUSSEL.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--PATH_plink ${path_plink} \
--pop ${pop2} \
--target_pop ${pop2} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2}/validate/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleid.tsv \
--testing FALSE \
--NCORES 1
EOT
fi
done
done
done
done

## Step5: copy the beta_file into the Final weight folder
rho=0.8

sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL/sim${i}_p${p}_rho${rho}/MUSSEL_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/MUSSEL/MUSSEL_beta_file_${pop2}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/MUSSEL/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_MUSSEL_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt
done
done
done
done
done

## Step6: Clean the previous result
rho=0.8

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL/sim${i}_p${p}_rho${rho}
rm -rf MUSSEL_*
done
done
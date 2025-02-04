## 1. JointPRS_tune
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_JointPRS_tune_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_JointPRS_tune_real.txt

module load PLINK/2

# JointPRS_tune
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
done
done
done
done

## 2. PRScsx
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PRScsx_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PRScsx_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PRScsx_real.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PRScsx/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PRScsx_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PRScsx_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
done
done
done
done

## 3. PROSPER
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_real.txt

module load PLINK/2

# PROSPER
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PROSPER/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
done
done
done
done


## 3. PROSPER_update
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_update_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_update_real.txt

module load PLINK/2

# PROSPER_update
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PROSPER/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
done
done
done
done

## 4. MUSSEL
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_MUSSEL_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_MUSSEL_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_MUSSEL_real.txt

module load PLINK/2

# MUSSEL
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/MUSSEL/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_MUSSEL_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_MUSSEL_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
done
done
done
done
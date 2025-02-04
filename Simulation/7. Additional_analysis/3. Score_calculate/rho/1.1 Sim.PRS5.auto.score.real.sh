## 1. JointPRS
p=0.1

sample1=UKB
sample2=80K

for i in {1..5}; do
for rho in 0 0.2 0.4 0.6 0.8; do
for pop2 in EUR EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then
if [[ "${sample2}" == "15K" || "${sample2}" == "20K" || "${sample2}" == "25K" ]]; then
sample3="15K"
elif [[ "${sample2}" == "80K" || "${sample2}" == "85K" || "${sample2}" == "90K" ]]; then
sample3="80K"
else
sample3="unknown"
fi
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_p${p}_rho${rho}

if [[ ${pop2} == "EUR" ]]; then
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}

else
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample3}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
fi

EOT
fi
done
done
done

## 2. PRScsx-auto
p=0.1

sample1=UKB
sample2=80K

for i in {1..5}; do
for rho in 0 0.2 0.4 0.6 0.8; do
for pop2 in EUR EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_auto_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_auto_real.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim${i}_p${p}_rho${rho}

if [[ ${pop2} == "EUR" ]]; then
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/PRScsx/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}

else
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/PRScsx/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
fi

EOT
fi
done
done
done
## 1. JointPRS_popcorn
rho=0.8 

sample1=UKB
sample2=15K

pop1=EUR

for i in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
for p in 5e-04 0.1; do

if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_p${p}_rho${rho}/test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_popcorn_real_${pop1}_${pop2}_prs_${pop2}.sscore" ]]; then
if [[ "${sample2}" == "15K" || "${sample2}" == "20K" || "${sample2}" == "25K" ]]; then
sample3="15K"
else
sample3="unknown"
fi
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real
#SBATCH --output=out_PRS_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real.txt

module load PLINK/2

# JointPRS_popcorn
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/test/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample3}_inter_snplist_real.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_popcorn_real_${pop1}_${pop2}_beta_${pop2}.txt \
--out test_sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_JointPRS_popcorn_real_${pop1}_${pop2}_prs_${pop2}
EOT
fi
done
done
done

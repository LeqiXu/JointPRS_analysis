## 1. SDPRX
pop1=EUR

for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/UKB_${trait}_SDPRX_${pop1}_${pop2}_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_${pop1}_${pop2}_SDPRX
#SBATCH --output=out_PRS_${trait}_${pop1}_${pop2}_SDPRX.txt

module load PLINK/2

# SDPRX
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/${trait}_SDPRX_${pop1}_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_SDPRX_${pop1}_${pop2}_prs_${pop2}
EOT
fi
done
done

## 2. XPASS
pop1=EUR

for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/XPASS/UKB_${trait}_XPASS_${pop1}_${pop2}_prs_${pop2}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_${pop1}_${pop2}_XPASS
#SBATCH --output=out_PRS_${trait}_${pop1}_${pop2}_XPASS.txt

module load PLINK/2

# XPASS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/XPASS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/${trait}_XPASS_${pop1}_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_XPASS_${pop1}_${pop2}_prs_${pop2}
EOT
fi
done
done
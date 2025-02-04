## 1. SDPRX
pop1=EUR

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/UKB_${trait}_SDPRX_test_${s}_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_SDPRX_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_SDPRX_test_${s}.txt

module load PLINK/2

# SDPRX
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/SDPRX/${trait}_SDPRX_val_${s}_EUR_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_SDPRX_test_${s}_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done
done

## 2. XPASS
pop1=EUR

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/UKB_${trait}_XPASS_test_${s}_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_XPASS_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_XPASS_test_${s}.txt

module load PLINK/2

# XPASS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_val_${s}_EUR_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_XPASS_test_${s}_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done
done

## 3. BridgePRS
pop1=EUR

for s in {1..5}; do
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS/UKB_${trait}_BridgePRS_test_${s}_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_BridgePRS_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_BridgePRS_test_${s}.txt

module load PLINK/2

# BridgePRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/BridgePRS/${trait}_BridgePRS_val_${s}_EUR_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_BridgePRS_test_${s}_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done
done
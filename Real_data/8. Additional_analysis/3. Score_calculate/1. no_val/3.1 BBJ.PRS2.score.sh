## 1. JointPRS
pop1=EUR

for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/UKB_${trait}_JointPRS_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_JointPRS
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_JointPRS.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/${trait}_JointPRS_EUR_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_JointPRS_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done

## 2. PRScsx-auto
pop1=EUR

for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/UKB_${trait}_PRScsx_auto_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_PRScsx_auto
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_PRScsx_auto.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/PRScsx/${trait}_PRScsx_auto_EUR_${pop2}_beta_${pop2}.txt \
--out UKB_${trait}_PRScsx_auto_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done


## 3. Xwing-auto
pop1=EUR

for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/Xwing/UKB_${trait}_Xwing_auto_EUR_${pop2}_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_Xwing_auto
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_Xwing_auto.txt

module load PLINK/2

# Xwing
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/Xwing

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/Xwing/${trait}_Xwing_auto_EUR_${pop2}_beta_${pop2}.txt 2 4 6 \
--out UKB_${trait}_Xwing_auto_EUR_${pop2}_prs_${pop2}
EOT
fi
done
done
## 1.1 JointPRS_auto
pop1=EUR
pop2=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_auto_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_auto_test
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_auto_test.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score ${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_phiauto_beta.txt header-read \
--score-col-nums 3 \
--out UKB_${trait}_JointPRS_auto_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done

## 1.2 JointPRS_linear
pop1=EUR
pop2=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_linear_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_linear_test
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_linear_test.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/${trait}_JointPRS_linear_EUR_EAS_AFR_SAS_AMR_beta_EUR_10K.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out UKB_${trait}_JointPRS_linear_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done

## 2. PRScsx
pop1=EUR
pop2=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_${trait}_PRScsx_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_SAS_AMR_PRScsx_test
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_SAS_AMR_PRScsx_test.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/${trait}_PRScsx_EUR_EAS_AFR_SAS_AMR_beta_EUR_10K.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out UKB_${trait}_PRScsx_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done

## 3. PROSPER_update
pop1=EUR
pop2=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_${trait}_PROSPER_update_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_SAS_AMR_PROSPER_update_test
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_SAS_AMR_PROSPER_update_test.txt

module load PLINK/2

# PROSPER_update
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_update_EUR_EAS_AFR_SAS_AMR_beta_EUR_10K.txt \
--out UKB_${trait}_PROSPER_update_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done

## 4. MUSSEL
pop1=EUR
pop2=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_${trait}_MUSSEL_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_SAS_AMR_MUSSEL_test
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_SAS_AMR_MUSSEL_test.txt

module load PLINK/2

# MUSSEL
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/MUSSEL/${trait}_MUSSEL_EUR_EAS_AFR_SAS_AMR_beta_EUR_10K.txt \
--out UKB_${trait}_MUSSEL_test_EUR_EAS_AFR_SAS_AMR_prs_${pop2}
EOT
fi
done
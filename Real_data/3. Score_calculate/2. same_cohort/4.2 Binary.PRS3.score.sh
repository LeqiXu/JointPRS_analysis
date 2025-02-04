## 1.1 JointPRS_auto
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_auto_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_JointPRS_auto_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_JointPRS_auto_test_${s}.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/${trait}_JointPRS_meta_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt \
--out UKB_${trait}_JointPRS_auto_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done

## 1.2 JointPRS_linear
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_linear_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_JointPRS_linear_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_JointPRS_linear_test_${s}.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/${trait}_JointPRS_linear_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt header-read \
--score-col-nums 3 4 5 \
--out UKB_${trait}_JointPRS_linear_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done

## 2. PRScsx
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_${trait}_PRScsx_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_PRScsx_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_PRScsx_test_${s}.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/${trait}_PRScsx_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt header-read \
--score-col-nums 3 4 5 \
--out UKB_${trait}_PRScsx_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done

## 3. PROSPER
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_${trait}_PROSPER_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_PROSPER_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_PROSPER_test_${s}.txt

module load PLINK/2

# PROSPER
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt \
--out UKB_${trait}_PROSPER_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done

## 3. PROSPER_update
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_${trait}_PROSPER_update_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_PROSPER_update_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_PROSPER_update_test_${s}.txt

module load PLINK/2

# PROSPER_update
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_update_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt \
--out UKB_${trait}_PROSPER_update_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done

## 4. MUSSEL
pop1=EUR

for s in {1..5}; do
for trait in T2D BrC; do
for pop2 in EAS AFR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_${trait}_MUSSEL_test_${s}_EUR_EAS_AFR_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_AFR_MUSSEL_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_AFR_MUSSEL_test_${s}.txt

module load PLINK/2

# MUSSEL
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/MUSSEL/${trait}_MUSSEL_val_${s}_EUR_EAS_AFR_beta_${pop2}.txt \
--out UKB_${trait}_MUSSEL_test_${s}_EUR_EAS_AFR_prs_${pop2}
EOT
fi
done
done
done
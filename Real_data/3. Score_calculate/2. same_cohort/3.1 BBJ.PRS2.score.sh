## 1.1 JointPRS_auto
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_auto_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_JointPRS_auto_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_JointPRS_auto_test_${s}.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_meta/${trait}_JointPRS_meta_val_${s}_EUR_EAS_beta_${pop2}.txt \
--out UKB_${trait}_JointPRS_auto_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done

## 1.2 JointPRS_best
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_best_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_JointPRS_best_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_JointPRS_best_test_${s}.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/${trait}_JointPRS_best_val_${s}_EUR_EAS_beta_${pop2}.txt \
--out UKB_${trait}_JointPRS_best_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done


## 1.3 JointPRS_linear
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS/UKB_${trait}_JointPRS_linear_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_JointPRS_linear_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_JointPRS_linear_test_${s}.txt

module load PLINK/2

# JointPRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/JointPRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/JointPRS_tune/${trait}_JointPRS_linear_val_${s}_EUR_EAS_beta_${pop2}.txt header-read \
--score-col-nums 3 4 \
--out UKB_${trait}_JointPRS_linear_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done

## 2. SDPRX
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
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

## 3. XPASS
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
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


## 4. PRScsx
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx/UKB_${trait}_PRScsx_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_PRScsx_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_PRScsx_test_${s}.txt

module load PLINK/2

# PRScsx
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PRScsx

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PRScsx/${trait}_PRScsx_val_${s}_EUR_EAS_beta_${pop2}.txt header-read \
--score-col-nums 3 4 \
--out UKB_${trait}_PRScsx_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done

## 5. PROSPER
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_${trait}_PROSPER_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_PROSPER_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_PROSPER_test_${s}.txt

module load PLINK/2

# PROSPER
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_val_${s}_EUR_EAS_beta_${pop2}.txt \
--out UKB_${trait}_PROSPER_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done


## 5. PROSPER_update
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER/UKB_${trait}_PROSPER_update_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_PROSPER_update_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_PROSPER_update_test_${s}.txt

module load PLINK/2

# PROSPER_update
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/PROSPER

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/PROSPER/${trait}_PROSPER_update_val_${s}_EUR_EAS_beta_${pop2}.txt \
--out UKB_${trait}_PROSPER_update_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done


## 6. MUSSEL
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL/UKB_${trait}_MUSSEL_test_${s}_EUR_EAS_prs_${pop2}.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_EAS_MUSSEL_test_${s}
#SBATCH --output=out_PRS_${trait}_EUR_EAS_MUSSEL_test_${s}.txt

module load PLINK/2

# MUSSEL
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/MUSSEL

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop2}_test_${s}_id.tsv \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/MUSSEL/${trait}_MUSSEL_val_${s}_EUR_EAS_beta_${pop2}.txt \
--out UKB_${trait}_MUSSEL_test_${s}_EUR_EAS_prs_${pop2}
EOT
fi
done
done
done

## 7. BridgePRS
pop1=EUR

for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do
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
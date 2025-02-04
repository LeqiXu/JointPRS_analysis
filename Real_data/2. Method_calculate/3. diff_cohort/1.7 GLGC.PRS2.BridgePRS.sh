## BridgePRS
for trait in HDL LDL TC logTG; do
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}
done

############### Step 1 - 3 EUR model and choose best params ###############
## Step 1: EUR clump
## Step 2: EUR stage1 beta
## Step 3: EUR best params
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/EUR_stage1_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_1to3_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_1to3_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_1.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_2.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_3.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done

############### Step 4 - 6 Stage1 model and the Stage 2 model based on Stage1 model ###############
## Step4: Stage1 beta
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/models/stage1_beta_bar_chr22.txt.gz" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_4_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_4_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_4.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done

## Step5: Prior based on stage1
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/models/${pop2}_stage2_KLdist_chr22.txt.gz" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_5_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_5_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_5.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done

## Step6: Target pop stage2 beta based on Stage1 beta
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/${pop2}_stage2_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_6_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_6_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_6.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done

############### Step 7 - 9 target pop model and choose best params ###############
## Step7: Target pop clump
## Step8: Target pop stage1 beta
## Step9: Target pop best params
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/${pop2}_stage1_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_7to9_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_7to9_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_7.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_8.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_9.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done

############### Step 10 combine weights and obtain score ###############
pop1=EUR
for pop2 in EAS AFR SAS AMR; do
for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/${pop2}_weighted_combined_snp_weights.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_BridgePRS_10_EUR_${pop2}
#SBATCH --output=out_${trait}_BridgePRS_10_EUR_${pop2}.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_10.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop1}_inter_clean.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/${trait}_${pop2}_inter_clean.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop1}_inter_snplist_ukbb.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop2}_inter_snplist_ukbb.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop1}_10K \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop1}_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/${trait}_scale_${pop2}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name ${trait} \
--sumstats_snpID SNP \
--sumstats_p P \
--sumstats_beta BETA \
--sumstats_allele1 A1 \
--sumstats_allele0 A2 \
--sumstats_n N \
--sumstats_se SE \
--sumstats_frq MAF \
--do_combine 1
EOT
fi
done
done


## Step11: copy the beta_file into the Final weight folder
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/EUR_${pop2}/${pop2}_weighted_combined_snp_weights.dat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/BridgePRS/${trait}_BridgePRS_EUR_${pop2}_beta_${pop2}.txt
done
done

## Only select three column
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop2 in c("EAS","AFR","SAS","AMR")){
beta_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/BridgePRS/",trait,"_BridgePRS_EUR_",pop2,"_beta_",pop2,".txt"))
beta_df = beta_df[,c(1,2,4)]
colnames(beta_df) = c("rsid","a1","weight")

write.table(beta_df, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/BridgePRS/",trait,"_BridgePRS_EUR_",pop2,"_beta_",pop2,".txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}

## Step12: Clean the previous result
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR SAS AMR; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/${trait}/
rm -rf EUR_${pop2}
done
done
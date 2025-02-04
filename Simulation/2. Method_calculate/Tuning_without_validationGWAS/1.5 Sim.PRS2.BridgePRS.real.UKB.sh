## BridgePRS
############### Step 1 - 3 EUR model and choose best params ###############
## Step 1: EUR clump
## Step 2: EUR stage1 beta
## Step 3: EUR best params
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/EUR_stage1_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_1to3
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_1to3.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_1.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

############### Step 4 - 6 Stage1 model and the Stage 2 model based on Stage1 model ###############
## Step4: Stage1 beta
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/models/stage1_beta_bar_chr22.txt.gz" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_4
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_4.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_4.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

## Step5: Prior based on stage1
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/models/${pop2}_stage2_KLdist_chr22.txt.gz" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_5
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_5.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_5.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

## Step6: Target pop stage2 beta based on Stage1 beta
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/${pop2}_stage2_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_6
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_6.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_6.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

############### Step 7 - 9 target pop model and choose best params ###############
## Step7: Target pop clump
## Step8: Target pop stage1 beta
## Step9: Target pop best params
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/${pop2}_stage1_best_model_params.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_7to9
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_7to9.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_7.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

############### Step 10 combine weights and obtain score ###############
i=5 #1-5
rho=0.8 

pop1=EUR
sample1=UKB

for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/${pop2}_weighted_combined_snp_weights.dat" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_10
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_10.txt

module load miniconda
conda activate r_env
module load PLINK/1

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS

/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Bash/BridgePRS_10.sh /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/BridgePRS/src/Rscripts \
--outdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample} \
--pop1 ${pop1} \
--pop2 ${pop2} \
--fst 0.15 \
--pop1_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/clean/${pop1}_sim${i}_p${p}_rho${rho}_UKB_clean_real.txt \
--pop2_sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover/clean/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_clean_real.txt \
--pop1_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop1}_sim${i}_p${p}_rho${rho}_${sample1}_inter_snplist_real.txt \
--pop2_qc_snplist /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_inter_snplist_real.txt \
--pop1_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop1}/validate/${pop1} \
--pop2_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop2}/validate/${pop2} \
--pop1_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop1}/validate/${pop1}_sim${i}_p${p}_rho${rho}_10K_doubleidname.tsv \
--pop2_test_data /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop2}/validate/${pop2}_sim${i}_p${p}_rho${rho}_${val_sample}_doubleidname.tsv \
--pop1_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--pop2_ld_bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
--pop1_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop1}_id.tsv \
--pop2_ld_ids /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop2}_id.tsv \
--pheno_name pheno \
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
done
done

## Step11: copy the beta_file into the Final weight folder
rho=0.8 

pop1=EUR
sample1=UKB

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
for sample2 in 15K 80K; do
for val_sample in 0.5K 2K 5K 10K; do
for pop2 in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}/BridgePRS_real_${pop1}_${pop2}_${sample1}_${sample2}_${val_sample}/${pop2}_weighted_combined_snp_weights.dat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/BridgePRS/sim${i}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_BridgePRS_real_EUR_${pop2}_beta_${pop2}.txt
done
done
done
done
done

## Only select three column
library(data.table)

rho=0.8 
sample1 = "UKB"

for (i in c(1:5)){
for (p in c(0.001,0.01,5e-04,0.1)){
for (sample2 in c("15K","80K")){
for (val_sample in c("0.5K","2K","5K","10K")){
for (pop2 in c("EAS","AFR","SAS","AMR")){
beta_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/BridgePRS/sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_BridgePRS_real_EUR_",pop2,"_beta_",pop2,".txt"))
beta_df = beta_df[,c("snp","effect.allele","effect")]
colnames(beta_df) = c("rsid","a1","weight")

write.table(beta_df, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/BridgePRS/sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_BridgePRS_real_EUR_",pop2,"_beta_",pop2,".txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
}
}
}

## Step12: Clean the previous result
rho=0.8 

for i in {1..5}; do
for p in 0.001 0.01 5e-04 0.1; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim${i}_p${p}_rho${rho}
rm -rf BridgePRS_*
done
done
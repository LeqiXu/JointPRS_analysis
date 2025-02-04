# BridgePRS
############### Step 1 - 3 EUR model and choose best params ###############
## Step 1: EUR clump
## Step 2: EUR stage1 beta
## Step 3: EUR best params
pop1=EUR
for pop2 in SAS; do
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

## Step4: organize the EUR beta 
library(readr)
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
best_params = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/",trait,"/EUR_SAS/EUR_stage1_best_model_params.dat"))
best_beta_column = paste("beta.bar",best_params$lambda.opt,best_params$S.opt,sep="_")

BridgePRS_all <- data.table()

for(i in 1:22){

BridgePRS_pop_chr <- read_delim(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/BridgePRS/",trait,"/EUR_SAS/models/EUR_stage1_beta_bar_chr",i,".txt.gz"))
BridgePRS_pop_chr = BridgePRS_pop_chr[,c("snp","effect.allele",best_beta_column)]
colnames(BridgePRS_pop_chr) = c("rsid","a1","weight")

BridgePRS_all = rbind(BridgePRS_all,BridgePRS_pop_chr)

}

write.table(BridgePRS_all, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/BridgePRS/",trait,"_BridgePRS_EUR_SAS_beta_EUR_10K.txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
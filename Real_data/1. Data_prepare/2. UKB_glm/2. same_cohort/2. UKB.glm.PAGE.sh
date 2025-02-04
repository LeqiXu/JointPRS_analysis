## Step1 Generate summary statistics [grace]
for trait in Height BMI SBP DBP PLT; do
for s in {1..5}; do
for pop in AFR; do
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=GWAS_${trait}_${pop}_UKB_val_${s}
#SBATCH --output=out_GWAS_${trait}_${pop}_UKB_val_${s}.txt

  module load PLINK/2

  plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
  --double-id \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/${pop}_inter_snplist.txt \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop}_val_${s}_id.tsv \
  --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/${trait}/split/${trait}_${pop}_val_${s}_doubleid.tsv \
  --covar /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/agesex20PC.csv \
  --covar-variance-standardize \
  --glm hide-covar cols=chrom,pos,alt,ref,a1freq,orbeta,se,tz,p,nobs \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/${trait}_${pop}_UKB_val_${s}

EOT
done
done
done

## Step2 Clean summary statistics
library(data.table)

for (trait in c("Height","BMI","SBP","DBP","PLT")){
for (pop in c("AFR")){
for (s in c(1:5)){
    # sumstat obtain
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/",trait,"_",pop,"_UKB_val_",s,".PHENO1.glm.linear"))
    sumstat_inter = sumstat_inter[, A2 := ifelse(REF == A1, ALT, REF)]

    # clean sumstat
    sumstat_inter_clean = sumstat_inter[,c("ID","#CHROM","POS","A1","A2","OBS_CT","A1_FREQ","BETA","SE","T_STAT","P")]
    colnames(sumstat_inter_clean) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")
    write.table(sumstat_inter_clean, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/",trait,"_",pop,"_UKB_val_",s,".txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
}

## Step3 Clean unecessary data
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/

for trait in Height BMI SBP DBP PLT
do
rm -rf ${trait}*.glm.linear
rm -rf ${trait}*.log
done
# 1. Assign ancestry groups to each individual
## obtain id for each ancestry group that are unrelated with a predicted probability greater than 0.9
## EUR:311601 SAS:7857 AFR:6829 EAS:2091 AMR:636
cp /gpfs/gibbs/pi/zhao/gz222/SDPRX/real/genotype/PCA/pbk_ref.PC.predPop.tsv /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/ukbb_ancestry_pred.tsv
cp /gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_pheno/MR_time/adjust/adjust.csv  /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv

library(data.table)
ukbb_ancestry_pred <- fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/ukbb_ancestry_pred.tsv")
adjust <- fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
adjust = adjust[which(adjust$kin == 0),c("eid")]

for(pop in c("EUR","SAS","AFR","EAS","AMR")){
    pop_data = ukbb_ancestry_pred[which(ukbb_ancestry_pred$predicted_pop == pop),]
    pop_data = pop_data[which(pop_data$FID %in% adjust$eid),]
    pop_data = pop_data[which(pop_data$probability > 0.9),]
    pop_id = pop_data[,c("FID","IID")]
    print(nrow(pop_id))
    write.table(pop_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/",pop,"_id.tsv"), row.names=F, col.names=T, quote = F)
}

## obtain genetic data for each ancestry group
#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=ukbb_ancestry_geno
#SBATCH --output=out_ukbb_ancestry_geno.txt
module load PLINK/2

for pop in EUR SAS AFR EAS AMR
do
plink2 --bfile /gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/${pop}_id.tsv \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop}
done

## Extract 10K people for EUR for tuning
library(data.table)

for(pop in c("EUR")){
    pop_id = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/",pop,"_id.tsv"))
    tune_row = sample(seq_len(nrow(pop_id)), size = 10000)

    pop_tune_id = pop_id[tune_row,]    
    write.table(pop_tune_id,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/",pop,"_10K_id.tsv"), row.names=F, col.names=T, quote = F)

}

sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=ukbb_EUR_subgeno
#SBATCH --output=out_ukbb_EUR_subgeno.txt
module load PLINK/2

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/EUR_10K_id.tsv \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR_10K
EOT

## covariates
library(data.table)

covariates = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/adjust.csv")
covariates$FID = covariates$eid
covariates$IID = covariates$eid
covariates$sex = ifelse(covariates$sex=="Male",1,2)
covariates = covariates[,c("FID","IID","age_recruit","sex",paste0("PC",c(1:20)))]

write.table(covariates, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/cov_data/agesex20PC.csv", row.names=F, col.names=T, quote = F, sep = "\t")

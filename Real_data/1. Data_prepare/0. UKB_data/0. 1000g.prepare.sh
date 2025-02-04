## 1. Obtain sample list and snp list for each pop in 1000g
# EUR sample: 503 snp: 1120696
# SAS sample: 489 snp: 1131558
# AFR sample: 661 snp: 1225319
# EAS sample: 504 snp: 1034118
# AMR sample: 347 snp: 1211275

library(data.table)
all_sample = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/ALL_sample.txt",header=T,quote='\t')
all_sample = all_sample[,c(1:4)]
all_snp = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/snpinfo_mult_1kg_hm3",header=T,quote='\t')
all_snp_id = data.table(SNP = all_snp$SNP)
all_snp_info = all_snp[,c("SNP","A1","A2")]
write.table(all_snp_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/ALL_snp.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(all_snp_info, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/ALL_snp_info.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

for (pop in c("EUR","SAS","AFR","EAS","AMR")){
    pop_row_idx = which(all_sample$super_pop == pop)
    pop_sample = all_sample[pop_row_idx,]
    pop_id = data.table(FID = 0, IID = pop_sample$ample)
    print(paste0(pop," sample size: ",nrow(pop_id)))

    pop_snp = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
    pop_snp_id = data.table(SNP = pop_snp$SNP)
    pop_snp_info = pop_snp[,c("SNP","A1","A2")]
    print(paste0(pop," snp size: ",nrow(pop_snp_id)))

    write.table(pop_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/",pop,"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pop_snp_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/",pop,"_snp.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pop_snp_info, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/",pop,"_snp_info.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

    for (chr in c(1:22)){
        pop_snp_chr = pop_snp[which(pop_snp$CHR == chr),]
        pop_snp_chr_id = data.table(SNP = pop_snp_chr$SNP)
        write.table(pop_snp_chr_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/",pop,"_chr/",chr,"_snp.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    }
}


## 2. Extract genetic data for each pop
## Plink2
module load PLINK/2

for pop in EUR SAS AFR EAS AMR
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/1000G_phase3_common_norel \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop}_id.tsv \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop}_snp.tsv \
--geno 0.1 \
--hwe 1e-6 \
--maf 0.01 \
--keep-allele-order \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop}
done

## 3. Obtain PCA for each individual
# Perform LD pruning
module load PLINK/2

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/1000G_phase3_common_norel \
--double-id \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/ALL_snp.tsv \
--geno 0.1 \
--hwe 1e-6 \
--maf 0.01 \
--keep-allele-order \
--indep-pairwise 200 100 0.1 \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/pca_data/ALL_prune

# Perform PCA
# Run pca
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/1000G_phase3_common_norel \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/pca_data/ALL_prune.prune.in \
--pca 20 \
--out ALL_pca

# Obtain PCA for each pop
library(data.table)

pca_vec = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/pca_data/ALL_pca.eigenvec")

for (pop in c("EUR","SAS","AFR","EAS","AMR")){
pop_id = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/",pop,"_id.tsv"))
pop_pca_vec = pca_vec[which(pca_vec$IID %in% pop_id$IID),]
pop_pca_vec = pop_pca_vec[order(pop_id$IID),c(paste0("PC",1:20))]
write.table(pop_pca_vec, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/pca_data/",pop,"_pca.eigenvec"), row.names=F, col.names=F, quote = F)
}

## 4. Obtain LD score for each pop (AFR,SAS,AMR) EUR and EAS are already available
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=ldsc_l2_popTHEPOP_chrTHECHR_1kg
#SBATCH --output=out_ldsc_l2_popTHEPOP_chrTHECHR_1kg.txt

module load miniconda
conda activate ldsc

pop=THEPOP
chr=THECHR

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/ldsc/ldsc.py \
--bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop} \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/ancestry_info/${pop}_chr/${chr}_snp.tsv \
--l2 \
--yes-really \
--ld-wind-cm 1 \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/XPXP/${pop,,}_ldscores/${chr}

vim ldsc_l2_popTHEPOP_chrTHECHR_1kg.sh
for pop in AFR SAS AMR; do for chr in {1..22}; do cp ldsc_l2_popTHEPOP_chrTHECHR_1kg.sh ldsc_l2_pop${pop}_chr${chr}_1kg.sh;sed -i "s/THECHR/${chr}/g" ldsc_l2_pop${pop}_chr${chr}_1kg.sh;sed -i "s/THEPOP/${pop}/g" ldsc_l2_pop${pop}_chr${chr}_1kg.sh;done;done
for pop in AFR SAS AMR; do for chr in {1..22}; do sbatch ldsc_l2_pop${pop}_chr${chr}_1kg.sh;done;done
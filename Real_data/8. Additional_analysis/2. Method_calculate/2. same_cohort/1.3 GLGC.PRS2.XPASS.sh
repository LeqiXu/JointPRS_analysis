# XPASS+:
# Step1: Estimate beta
module load PLINK/1.9b_6.21-x86_64
module load miniconda
conda activate r_env

library(XPASS)
library(RhpcBLASctl)
library(ieugwasr)
library(data.table)

type="1kg"

for (trait in c("HDL","LDL","TC","logTG")){
for (pop2 in c("EAS","AFR","SAS","AMR")){
pop1="EUR"

file_path = paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/",trait,"_XPASS_EUR_",pop2,"_beta_EUR.txt")

if(file.exists(file_path)) {
  print(paste0(trait, " XPASS File exists."))
} else {

# reference genotype
ref_pop1 <- "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/EUR"
ref_pop2 <- paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/",pop2)

# sumstats of Height
glm_pop1 <- paste0('/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/XPXP/',trait,'_',pop1,'_inter_XPXP.txt') # auxiliary
glm_pop2 <- paste0('/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/XPXP/',trait,'_',pop2,'_inter_XPXP.txt') # target

z_pop1 <- fread(glm_pop1)
pval_pop1 <- data.frame(rsid=z_pop1$SNP,pval=2*pnorm(abs(z_pop1$Z),lower.tail=F))

if(length(which(pval_pop1$pval < 1e-10)) > 0){
    clp_pop1 <- ld_clump(pval_pop1, clump_kb=1000, clump_r2=0.1, clump_p=1e-10,
                    bfile=ref_pop1, plink_bin="plink")
    snp_pop1 <- clp_pop1$rsid 
} else{
    snp_pop1 <- NULL
}

z_pop2 <- fread(glm_pop2)
pval_pop2 <- data.frame(rsid=z_pop2$SNP,pval=2*pnorm(abs(z_pop2$Z),lower.tail=F))

if(length(which(pval_pop2$pval < 1e-10)) > 0){
    clp_pop2 <- ld_clump(pval_pop2, clump_kb=1000, clump_r2=0.1, clump_p=1e-10,
                    bfile=ref_pop2, plink_bin="plink")
    snp_pop2 <- clp_pop2$rsid  
} else{
    snp_pop2 <- NULL
}

post_beta <-XPASS(file_z1 = glm_pop2,file_z2 = glm_pop1,
                  file_ref1 = ref_pop2,file_ref2 = ref_pop1,
                  snps_fe1 = snp_pop2, snps_fe2 = snp_pop1)

final_beta = post_beta$mu[,c("SNP","A1","mu_XPASS2")]
colnames(final_beta) = c("rsID","A1","EUR")

write.table(final_beta, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/",trait,"_XPASS_EUR_",pop2,"_beta_EUR.txt"), row.names=F, col.names=T, quote=F, append=F)
}
}
}

# Step2: Copy the beta estimation for EUR from no_val
for trait in HDL LDL TC logTG; do
for pop in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/${trait}_XPASS_EUR_${pop}_beta_EUR.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_EUR_${pop}_beta_EUR.txt
done
done

# Step3: Calculate prs for each pop for each param in each trait
for trait in HDL LDL TC logTG; do
for pop in EUR_10K; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/${trait}_EUR_${pop2}_XPASS_${pop}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_XPASS_${pop}_EUR_${pop2}
#SBATCH --output=out_PRS_${trait}_XPASS_${pop}_EUR_${pop2}.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_EUR_${pop2}_beta_EUR.txt header-read \
--out ${trait}_EUR_${pop2}_XPASS_${pop}
EOT
fi
done
done
done

# Step4: Select the optimal EUR from EUR_EAS EUR_AFR EUR_SAS EUR_AMR
library(data.table)
library(stringr)
library(dplyr)

pop_list = c("EAS","AFR","SAS","AMR")

for(trait in c("HDL","LDL","TC","logTG")){
for(pop in c("EUR_10K")){
    
    Trait_XPASS_popEAS_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/",trait,"_EUR_EAS_XPASS_",pop,".sscore"))
    Trait_XPASS_popAFR_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/",trait,"_EUR_AFR_XPASS_",pop,".sscore"))
    Trait_XPASS_popSAS_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/",trait,"_EUR_SAS_XPASS_",pop,".sscore"))
    Trait_XPASS_popAMR_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/",trait,"_EUR_AMR_XPASS_",pop,".sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_EUR_doubleid.tsv"))
    scale_pheno =scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## XPASS
    Trait_XPASS_popEAS_val = Trait_XPASS_popEAS_val[,c(1,5)]
    colnames(Trait_XPASS_popEAS_val) = c("eid","EUR")
    Trait_XPASS_popEAS_val = scale_pheno[Trait_XPASS_popEAS_val, on = .(eid = eid)]
    Trait_XPASS_popEAS_val = Trait_XPASS_popEAS_val[,c(3) := lapply(.SD,scale),.SDcols = c(3)]
    Trait_XPASS_popEAS_val = na.omit(Trait_XPASS_popEAS_val)
    
    Trait_XPASS_popAFR_val = Trait_XPASS_popAFR_val[,c(1,5)]
    colnames(Trait_XPASS_popAFR_val) = c("eid","EUR")
    Trait_XPASS_popAFR_val = scale_pheno[Trait_XPASS_popAFR_val, on = .(eid = eid)]
    Trait_XPASS_popAFR_val = Trait_XPASS_popAFR_val[,c(3) := lapply(.SD,scale),.SDcols = c(3)]
    Trait_XPASS_popAFR_val = na.omit(Trait_XPASS_popAFR_val)

    Trait_XPASS_popSAS_val = Trait_XPASS_popSAS_val[,c(1,5)]
    colnames(Trait_XPASS_popSAS_val) = c("eid","EUR")
    Trait_XPASS_popSAS_val = scale_pheno[Trait_XPASS_popSAS_val, on = .(eid = eid)]
    Trait_XPASS_popSAS_val = Trait_XPASS_popSAS_val[,c(3) := lapply(.SD,scale),.SDcols = c(3)]
    Trait_XPASS_popSAS_val = na.omit(Trait_XPASS_popSAS_val)
    
    Trait_XPASS_popAMR_val = Trait_XPASS_popAMR_val[,c(1,5)]
    colnames(Trait_XPASS_popAMR_val) = c("eid","EUR")
    Trait_XPASS_popAMR_val = scale_pheno[Trait_XPASS_popAMR_val, on = .(eid = eid)]
    Trait_XPASS_popAMR_val = Trait_XPASS_popAMR_val[,c(3) := lapply(.SD,scale),.SDcols = c(3)]
    Trait_XPASS_popAMR_val = na.omit(Trait_XPASS_popAMR_val)

    # XPASS validation data select the best performed parameter
    lm_XPASS_popEAS_val = lm(pheno ~ . + 0, data = Trait_XPASS_popEAS_val[,c(2,3)])
    lm_XPASS_popAFR_val = lm(pheno ~ . + 0, data = Trait_XPASS_popAFR_val[,c(2,3)])
    lm_XPASS_popSAS_val = lm(pheno ~ . + 0, data = Trait_XPASS_popSAS_val[,c(2,3)])
    lm_XPASS_popAMR_val = lm(pheno ~ . + 0, data = Trait_XPASS_popAMR_val[,c(2,3)])

    Trait_XPASS_val_R2 = data.table(XPASS_popEAS = summary(lm_XPASS_popEAS_val)$`r.squared`,
                                    XPASS_popAFR = summary(lm_XPASS_popAFR_val)$`r.squared`, 
                                    XPASS_popSAS = summary(lm_XPASS_popSAS_val)$`r.squared`,
                                    XPASS_popAMR = summary(lm_XPASS_popAMR_val)$`r.squared`)
                         
    ## best index
    XPASS_index = which.max(Trait_XPASS_val_R2)
    best_pop = pop_list[XPASS_index]
    print(XPASS_index)

    Trait_XPASS_optimal_pop = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/",trait,"_XPASS_EUR_",best_pop,"_beta_EUR.txt"))

    write.table(Trait_XPASS_optimal_pop,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/",trait,"_XPASS_EUR_bestpop_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
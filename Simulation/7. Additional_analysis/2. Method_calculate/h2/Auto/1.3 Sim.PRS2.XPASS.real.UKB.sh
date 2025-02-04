# XPASS+:
module load PLINK/1.9b_6.21-x86_64
module load miniconda
conda activate r_env

library(XPASS)
library(RhpcBLASctl)
library(ieugwasr)
library(data.table)

h2=0.1
rho=0.8 
p=0.1

pop1="EUR"

sample1="UKB"
sample2="90K"

for (i in c(1:5)){
for (pop2 in c("EAS","AFR","SAS","AMR")){

file_path = paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/XPASS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_XPASS_real_EUR_",pop2,"_beta_",pop2,".txt")

if(file.exists(file_path)) {
  print(paste0("sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2, " XPASS File exists."))
} else {

# reference genotype
ref_pop1 <- "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/EUR"
ref_pop2 <- paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/",pop2)

# sumstats of Height
glm_pop1 <- paste0('/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/',pop1,'/discover/XPXP/',pop1,'_sim',i,'_h2',h2,'_p',p,'_rho',rho,'_UKB_XPXP_real.txt') # auxiliary
if (sample2 == "15K" | sample2 == "80K"){
    glm_pop2 <- paste0('/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/',pop2,'/discover/XPXP/',pop2,'_sim',i,'_h2',h2,'_p',p,'_rho',rho,'_',sample2,'_XPXP_real.txt') # target
} else{
    glm_pop2 <- paste0('/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/',pop2,'/discover_validate/XPXP/',pop2,'_sim',i,'_h2',h2,'_p',p,'_rho',rho,'_',sample2,'_XPXP_real.txt') # target
}

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

final_beta = post_beta$mu[,c("SNP","A1","mu_XPASS1")]
colnames(final_beta) = c("rsID","A1",pop2)


write.table(final_beta, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/XPASS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_XPASS_real_EUR_",pop2,"_beta_",pop2,".txt"), row.names=F, col.names=T, quote=F, append=F)


}


}
}
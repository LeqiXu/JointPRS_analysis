# 2. True effect size simulation for all SNPs
# R script
library(MASS) # mvrnorm
library(data.table)
library(tidyr)
library(dplyr)

## set up
h2 = 0.4 # heritability
p = 0.1 # causal SNP proportion
h2s = rep(sqrt(h2),5)

for (i in c(1:5)){
for (rho in c(0, 0.2, 0.4, 0.6)){
print("Start!")
path_sim <- "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data"

## obtain common snp
snp_info = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_mega+hm3")
snp_info = snp_info[complete.cases(snp_info),]
snp = read.table("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_rs_id_infor_hm3.snplist")
snp_info = snp_info[which(snp_info$rs_id %in% snp$V1),]

snp_split <- snp_info %>% separate(SNP,into=c("rsid","position2","noncoding","coding"),sep=":")
snp = snp_info$rs_id
S = length(snp)

# find common SNPs and assign effect SNPs among them
snp_common = snp_info[which(snp_info$FREQ_A1_EUR >= 0.01 & snp_info$FREQ_A1_EUR <= 0.99),]
snp_common = snp_common[which(snp_common$FREQ_A1_EAS >= 0.01 & snp_common$FREQ_A1_EAS <= 0.99),]
snp_common = snp_common[which(snp_common$FREQ_A1_AFR >= 0.01 & snp_common$FREQ_A1_AFR <= 0.99),]
snp_common = snp_common[which(snp_common$FREQ_A1_SAS >= 0.01 & snp_common$FREQ_A1_SAS <= 0.99),]
snp_common = snp_common[which(snp_common$FREQ_A1_AMR >= 0.01 & snp_common$FREQ_A1_AMR <= 0.99),]

#need to obtain the minor allele effect
num_select = round(p * S)
p_variable <- rep(0,S)
selected_indices <- sample(which(snp %in% snp_common$rs_id), size = num_select, replace = FALSE)
p_variable[selected_indices] <- 1

rho_matrix <- matrix(c(1,rho,rho,rho,rho,
                       rho,1,rho,rho,rho,
                       rho,rho,1,rho,rho,
                       rho,rho,rho,1,rho,
                       rho,rho,rho,rho,1),nrow=5)

cov_matrix <- 1 / (p * S) * diag(h2s) %*% rho_matrix %*% diag(h2s)

  print(paste0("Replicate: ", i))
  
  while (TRUE) {
    beta_true <- data.frame(EUR_beta_true = rep(0, S),
                            EAS_beta_true = rep(0, S),
                            AFR_beta_true = rep(0, S),
                            SAS_beta_true = rep(0, S),
                            AMR_beta_true = rep(0, S))

    beta_true[,c("EUR_beta_true","EAS_beta_true","AFR_beta_true","SAS_beta_true","AMR_beta_true")] <- mvrnorm(S,c(0,0,0,0,0), Sigma = cov_matrix)
    beta_true[,c("EUR_beta_true")] = p_variable * beta_true[,c("EUR_beta_true")]
    beta_true[,c("EAS_beta_true")] = p_variable * beta_true[,c("EAS_beta_true")]
    beta_true[,c("AFR_beta_true")] = p_variable * beta_true[,c("AFR_beta_true")]
    beta_true[,c("SAS_beta_true")] = p_variable * beta_true[,c("SAS_beta_true")]
    beta_true[,c("AMR_beta_true")] = p_variable * beta_true[,c("AMR_beta_true")]

    if ((abs(sum(beta_true$EUR_beta_true^2) - h2) < 1e-2) & 
        (abs(sum(beta_true$EAS_beta_true^2) - h2) < 1e-2) & 
        (abs(sum(beta_true$AFR_beta_true^2) - h2) < 1e-2) &
        (abs(sum(beta_true$SAS_beta_true^2) - h2) < 1e-2) &
        (abs(sum(beta_true$AMR_beta_true^2) - h2) < 1e-2) ) break
  }
  
  print(paste0("EUR h2: ",sum(beta_true$EUR_beta_true^2)))
  print(paste0("EAS h2: ",sum(beta_true$EAS_beta_true^2)))
  print(paste0("AFR h2: ",sum(beta_true$AFR_beta_true^2)))
  print(paste0("SAS h2: ",sum(beta_true$SAS_beta_true^2)))
  print(paste0("AMR h2: ",sum(beta_true$AMR_beta_true^2)))

  print(paste0("EUR_EAS corr: ",cor(beta_true$EUR_beta_true,beta_true$EAS_beta_true)))
  print(paste0("EUR_AFR corr: ",cor(beta_true$EUR_beta_true,beta_true$AFR_beta_true)))
  print(paste0("EUR_SAS corr: ",cor(beta_true$EUR_beta_true,beta_true$SAS_beta_true)))
  print(paste0("EUR_AMR corr: ",cor(beta_true$EUR_beta_true,beta_true$AMR_beta_true)))

  # EUR  
  EUR_causal = data.table(snp_id = snp,
                    coding = snp_split$coding,
                    effect = beta_true$EUR_beta_true)
  EUR_bim.infor <- fread(("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/EUR/discover/EUR.bim"))
  colnames(EUR_bim.infor) <- c("chr","snpid","nonthing","position","minor","major")
  EUR_bim.infor = EUR_bim.infor[,c("snpid","minor")]
  EUR_causal = EUR_causal[EUR_bim.infor, on = .(snp_id = snpid)]
  EUR_causal = na.omit(EUR_causal)
  EUR_causal$effect <- ifelse(EUR_causal$coding!=EUR_causal$minor,-EUR_causal$effect,EUR_causal$effect)
  EUR_causal = EUR_causal[which(EUR_causal$effect != 0),]

  # EAS  
  EAS_causal = data.table(snp_id = snp,
                    coding = snp_split$coding,
                    effect = beta_true$EAS_beta_true)
  EAS_bim.infor <- fread(("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/EAS/discover/EAS.bim"))
  colnames(EAS_bim.infor) <- c("chr","snpid","nonthing","position","minor","major")
  EAS_bim.infor = EAS_bim.infor[,c("snpid","minor")]
  EAS_causal = EAS_causal[EAS_bim.infor, on = .(snp_id = snpid)]
  EAS_causal = na.omit(EAS_causal)
  EAS_causal$effect <- ifelse(EAS_causal$coding!=EAS_causal$minor,-EAS_causal$effect,EAS_causal$effect)
  EAS_causal = EAS_causal[which(EAS_causal$effect != 0),]

  # AFR
  AFR_causal = data.table(snp_id = snp,
                    coding = snp_split$coding,
                    effect = beta_true$AFR_beta_true)
  AFR_bim.infor <- fread(("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/AFR/discover/AFR.bim"))
  colnames(AFR_bim.infor) <- c("chr","snpid","nonthing","position","minor","major")
  AFR_bim.infor = AFR_bim.infor[,c("snpid","minor")]
  AFR_causal = AFR_causal[AFR_bim.infor, on = .(snp_id = snpid)]
  AFR_causal = na.omit(AFR_causal)
  AFR_causal$effect <- ifelse(AFR_causal$coding!=AFR_causal$minor,-AFR_causal$effect,AFR_causal$effect)
  AFR_causal = AFR_causal[which(AFR_causal$effect != 0),]

  # SAS
  SAS_causal = data.table(snp_id = snp,
                    coding = snp_split$coding,
                    effect = beta_true$SAS_beta_true)
  SAS_bim.infor <- fread(("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/SAS/discover/SAS.bim"))
  colnames(SAS_bim.infor) <- c("chr","snpid","nonthing","position","minor","major")
  SAS_bim.infor = SAS_bim.infor[,c("snpid","minor")]
  SAS_causal = SAS_causal[SAS_bim.infor, on = .(snp_id = snpid)]
  SAS_causal = na.omit(SAS_causal)
  SAS_causal$effect <- ifelse(SAS_causal$coding!=SAS_causal$minor,-SAS_causal$effect,SAS_causal$effect)
  SAS_causal = SAS_causal[which(SAS_causal$effect != 0),]
  
  # AMR
  AMR_causal = data.table(snp_id = snp,
                    coding = snp_split$coding,
                    effect = beta_true$AMR_beta_true)
  AMR_bim.infor <- fread(("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/AMR/discover/AMR.bim"))
  colnames(AMR_bim.infor) <- c("chr","snpid","nonthing","position","minor","major")
  AMR_bim.infor = AMR_bim.infor[,c("snpid","minor")]
  AMR_causal = AMR_causal[AMR_bim.infor, on = .(snp_id = snpid)]
  AMR_causal = na.omit(AMR_causal)
  AMR_causal$effect <- ifelse(AMR_causal$coding!=AMR_causal$minor,-AMR_causal$effect,AMR_causal$effect)
  AMR_causal = AMR_causal[which(AMR_causal$effect != 0),]

  # write effect size
  write.table(EUR_causal[,c(1,3)], 
              file=paste0(path_sim, "/EUR_sim",i,"_p",p,"_rho",rho,".txt"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write EUR effect size.")

  write.table(EAS_causal[,c(1,3)], 
              file=paste0(path_sim, "/EAS_sim",i,"_p",p,"_rho",rho,".txt"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write EAS effect size.")

  write.table(AFR_causal[,c(1,3)], 
              file=paste0(path_sim, "/AFR_sim",i,"_p",p,"_rho",rho,".txt"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write AFR effect size.")

  write.table(SAS_causal[,c(1,3)], 
              file=paste0(path_sim, "/SAS_sim",i,"_p",p,"_rho",rho,".txt"), 
              append = F, quote = F, sep = "\t", row.names = F,col.names = F)
  print("Write SAS effect size.")

  write.table(AMR_causal[,c(1,3)], 
              file=paste0(path_sim, "/AMR_sim",i,"_p",p,"_rho",rho,".txt"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write AMR effect size.")

  # write causal snps
  write.table(EUR_causal[,c(1)], 
              file=paste0(path_sim, "/EUR_sim",i,"_p",p,"_rho",rho,".snplist"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write EUR snplist.")

  write.table(EAS_causal[,c(1)], 
              file=paste0(path_sim, "/EAS_sim",i,"_p",p,"_rho",rho,".snplist"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write EAS snplist.")

  write.table(AFR_causal[,c(1)], 
              file=paste0(path_sim, "/AFR_sim",i,"_p",p,"_rho",rho,".snplist"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write AFR snplist.")

  write.table(SAS_causal[,c(1)], 
              file=paste0(path_sim, "/SAS_sim",i,"_p",p,"_rho",rho,".snplist"), 
              append = F, quote = F, sep = "\t", row.names = F,col.names = F)
  print("Write SAS snplist.")

  write.table(AMR_causal[,c(1)], 
              file=paste0(path_sim, "/AMR_sim",i,"_p",p,"_rho",rho,".snplist"), 
              append = F, quote = F, sep = "\t", row.names = F, col.names = F)
  print("Write AMR snplist.")

print("Finish!")
}
}
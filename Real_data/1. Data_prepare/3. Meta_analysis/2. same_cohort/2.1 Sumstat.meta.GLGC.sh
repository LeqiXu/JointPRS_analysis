# 1. GLGC method data
## Sample size
#s=1
## HDL   AFR_inter: 95285 SAS_inter: 39274
## LDL   AFR_inter: 92425 SAS_inter: 39198
## TC    AFR_inter: 97207 SAS_inter: 39665
## logTG AFR_inter: 94306 SAS_inter: 39863

#s=2
## HDL   AFR_inter: 95284 SAS_inter: 39273
## LDL   AFR_inter: 92424 SAS_inter: 39197
## TC    AFR_inter: 97208 SAS_inter: 39666
## logTG AFR_inter: 94305 SAS_inter: 39860

#s=3
## HDL   AFR_inter: 95286 SAS_inter: 39273
## LDL   AFR_inter: 92424 SAS_inter: 39198
## TC    AFR_inter: 97208 SAS_inter: 39666
## logTG AFR_inter: 94305 SAS_inter: 39862

#s=4
## HDL   AFR_inter: 95282 SAS_inter: 39274
## LDL   AFR_inter: 92426 SAS_inter: 39198
## TC    AFR_inter: 97208 SAS_inter: 39665
## logTG AFR_inter: 94305 SAS_inter: 39863

#s=5
## HDL   AFR_inter: 95286 SAS_inter: 39273
## LDL   AFR_inter: 92425 SAS_inter: 39197
## TC    AFR_inter: 97206 SAS_inter: 39665
## logTG AFR_inter: 94306 SAS_inter: 39863

library(readr)
library(data.table)

for (s in c(1:5)){
for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("AFR","SAS")){
    # meta obtain
    sumstat_meta = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/",trait,"_",pop,"_inter_UKB_val_",s,"_meta1.tbl"))
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/",trait,"_",pop,"_inter_clean.txt"))
    sumstat_ukb = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/",trait,"_",pop,"_UKB_val_",s,".txt"))

    snplist = intersect(sumstat_meta$MarkerName,sumstat_inter$SNP)
    snplist = intersect(snplist,sumstat_ukb$SNP)

    sumstat_meta = sumstat_meta[match(snplist,sumstat_meta$MarkerName),]
    sumstat_inter = sumstat_inter[match(snplist,sumstat_inter$SNP),]
    sumstat_ukb = sumstat_ukb[match(snplist,sumstat_ukb$SNP),]

    # meta clean
    sumstat_meta$Allele1 = toupper(sumstat_meta$Allele1)
    sumstat_meta$Allele2 = toupper(sumstat_meta$Allele2)

    sumstat_meta = sumstat_meta[sumstat_inter[,c("SNP","CHR","POS","A1","A2")], on = .(MarkerName = SNP)]
    sumstat_meta = sumstat_meta[, Effect := ifelse(Allele1 == A1, Effect, -Effect)]
    sumstat_meta$`P-value` = as.numeric(sumstat_meta$`P-value`)
    sumstat_meta$N = sumstat_inter$N + sumstat_ukb$N
    sumstat_meta$MAF = (sumstat_inter$N * sumstat_inter$MAF + sumstat_ukb$N * sumstat_ukb$MAF) / sumstat_meta$N
    sumstat_meta$Z = sumstat_meta$Effect / sumstat_meta$StdErr

    # clean sumstat
    sumstat_inter_clean = sumstat_meta[,c("MarkerName","CHR","POS","A1","A2","N","MAF","Effect","StdErr","Z","P-value")]
    colnames(sumstat_inter_clean) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")
    write.table(sumstat_inter_clean, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/",trait,"_",pop,"_inter_UKB_val_",s,"_clean.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    print(paste0(trait," ", pop, " inter median sample size: ", median(sumstat_inter_clean$N)))

    # popcorn
    sumstat_inter_popcorn = sumstat_inter_clean[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(sumstat_inter_popcorn) = c("rsid", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(sumstat_inter_popcorn, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/",trait,"_",pop,"_inter_UKB_val_",s,"_popcorn.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    sumstat_inter_PRScsx = sumstat_inter_clean[,c("SNP","A1","A2","BETA","P")]
    write.table(sumstat_inter_PRScsx, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PRScsx/",trait,"_",pop,"_inter_UKB_val_",s,"_PRScsx.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # SDPRX
    sumstat_inter_SDPRX = sumstat_inter_clean[,c("SNP","A1","A2","Z","P","N")]
    write.table(sumstat_inter_SDPRX, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/SDPRX/",trait,"_",pop,"_inter_UKB_val_",s,"_SDPRX.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    sumstat_inter_XPXP = sumstat_inter_clean[,c("SNP","N","Z","A1","A2","P")]
    write.table(sumstat_inter_XPXP, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/XPXP/",trait,"_",pop,"_inter_UKB_val_",s,"_XPXP.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    sumstat_inter_PROSPER = sumstat_inter_clean[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(sumstat_inter_PROSPER) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(sumstat_inter_PROSPER, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER/",trait,"_",pop,"_inter_UKB_val_",s,"_PROSPER.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
}
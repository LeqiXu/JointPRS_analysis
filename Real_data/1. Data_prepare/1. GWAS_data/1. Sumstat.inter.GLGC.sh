# 1.  GLGC data no UKB
# 1.1 GLGC sumstat cleaning
library(readr)
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("EUR","EAS","AFR","SAS","AMR")){
    # sumstat obtain
    sumstat = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"))
    sumstat[sumstat$pvalue<1e-323,"pvalue"] = 1e-323
    sumstat$Z = sumstat$EFFECT_SIZE / sumstat$SE
    sumstat = sumstat[!duplicated(sumstat$rsID),]

    # SNP restriction
    snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
    sumstat_inter = sumstat[sumstat$rsID %in% snp_inter$V1,]
    print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
    write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
    # ldsc
    sumstat_inter_ldsc = sumstat_inter[,c("rsID","ALT","REF","N","pvalue","Z")]
    colnames(sumstat_inter_ldsc) = c("SNP","A1","A2","N","P","Z")
    write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
}
}

# 1.2 GLGC ldsc
## SNP size
## HDL   EUR_inter: 800281 EAS_inter: 735249 AFR_inter: 827727 SAS_inter: 1085452 AMR_inter: 1107923
## LDL   EUR_inter: 800283 EAS_inter: 797861 AFR_inter: 827727 SAS_inter: 1088264 AMR_inter: 1104517
## TC    EUR_inter: 800281 EAS_inter: 461893 AFR_inter: 827727 SAS_inter: 1085270 AMR_inter: 1111066
## logTG EUR_inter: 800286 EAS_inter: 797898 AFR_inter: 827727 SAS_inter: 1088215 AMR_inter: 1109126

for trait in HDL LDL TC logTG; do
for pop in EUR EAS AFR SAS AMR; do
python /gpfs/gibbs/pi/zhao/lx94/Software/ldsc/munge_sumstats.py --sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc.txt --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc
done
done

# 1.3 GLGC method data
## Sample size
## HDL   EUR_inter: 885546 EAS_inter: 116404 AFR_inter: 90804 SAS_inter: 33953 AMR_inter: 47276
## LDL   EUR_inter: 840012 EAS_inter: 79693  AFR_inter: 87759 SAS_inter: 33658 AMR_inter: 33989
## TC    EUR_inter: 929739 EAS_inter: 144579 AFR_inter: 92554 SAS_inter: 34135 AMR_inter: 48055
## logTG EUR_inter: 860679 EAS_inter: 81071  AFR_inter: 89467 SAS_inter: 34023 AMR_inter: 37273

library(readr)
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("EUR","EAS","AFR","SAS","AMR")){
    # sumstat obtain
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"))
    
    # ldsc data
    sumstat_inter_ldsc = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.sumstats.gz"))

    # clean sumstat
    sumstat_inter_clean = sumstat_inter[which(sumstat_inter$rsID %in% sumstat_inter_ldsc$SNP),c("rsID","CHROM","POS_b37","ALT","REF","N","POOLED_ALT_AF","EFFECT_SIZE","SE","Z","pvalue")]
    colnames(sumstat_inter_clean) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")
    write.table(sumstat_inter_clean, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/",trait,"_",pop,"_inter_clean.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    print(paste0(trait," ", pop, " inter median sample size: ", median(sumstat_inter_clean$N)))

    # popcorn
    sumstat_inter_popcorn = sumstat_inter_clean[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(sumstat_inter_popcorn) = c("rsid", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(sumstat_inter_popcorn, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/",trait,"_",pop,"_inter_popcorn.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    sumstat_inter_PRScsx = sumstat_inter_clean[,c("SNP","A1","A2","BETA","P")]
    write.table(sumstat_inter_PRScsx, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PRScsx/",trait,"_",pop,"_inter_PRScsx.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # SDPRX
    sumstat_inter_SDPRX = sumstat_inter_clean[,c("SNP","A1","A2","Z","P","N")]
    write.table(sumstat_inter_SDPRX, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/SDPRX/",trait,"_",pop,"_inter_SDPRX.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    sumstat_inter_XPXP = sumstat_inter_clean[,c("SNP","N","Z","A1","A2","P")]
    write.table(sumstat_inter_XPXP, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/XPXP/",trait,"_",pop,"_inter_XPXP.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    sumstat_inter_PROSPER = sumstat_inter_clean[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(sumstat_inter_PROSPER) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(sumstat_inter_PROSPER, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER/",trait,"_",pop,"_inter_PROSPER.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}

# 2.  GLGC data with UKB
# 2.1 GLGC sumstat cleaning
library(readr)
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("AFR","SAS")){
    # sumstat obtain
    sumstat = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat_UKB.gz"))
    sumstat[sumstat$pvalue<1e-323,"pvalue"] = 1e-323
    sumstat$Z = sumstat$EFFECT_SIZE / sumstat$SE
    sumstat = sumstat[!duplicated(sumstat$rsID),]

    # SNP restriction
    snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
    sumstat_inter = sumstat[sumstat$rsID %in% snp_inter$V1,]
    print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
    write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_UKB.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
    # ldsc
    sumstat_inter_ldsc = sumstat_inter[,c("rsID","ALT","REF","N","pvalue","Z")]
    colnames(sumstat_inter_ldsc) = c("SNP","A1","A2","N","P","Z")
    write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_UKB_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
}
}

# 2.2 GLGC ldsc
## SNP size
## HDL   AFR_inter: 827727 SAS_inter: 1087640
## LDL   AFR_inter: 827727 SAS_inter: 1089447
## TC    AFR_inter: 827727 SAS_inter: 1087423
## logTG AFR_inter: 827727 SAS_inter: 1089410

for trait in HDL LDL TC logTG; do
for pop in AFR SAS; do
python /gpfs/gibbs/pi/zhao/lx94/Software/ldsc/munge_sumstats.py --sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_UKB_ldsc.txt --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_UKB_ldsc
done
done

# 2.3 GLGC method data
## Sample size
## SNP size
## HDL   AFR_inter: 97169 SAS_inter: 40172
## LDL   AFR_inter: 94622 SAS_inter: 40472
## TC    AFR_inter: 99430 SAS_inter: 40962
## logTG AFR_inter: 96341 SAS_inter: 40845

library(readr)
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("AFR","SAS")){
    # sumstat obtain
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_UKB.txt"))
    
    # ldsc data
    sumstat_inter_ldsc = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_UKB_ldsc.sumstats.gz"))

    # clean sumstat
    sumstat_inter_clean = sumstat_inter[which(sumstat_inter$rsID %in% sumstat_inter_ldsc$SNP),c("rsID","CHROM","POS_b37","ALT","REF","N","POOLED_ALT_AF","EFFECT_SIZE","SE","Z","pvalue")]
    colnames(sumstat_inter_clean) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")
    write.table(sumstat_inter_clean, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/",trait,"_",pop,"_inter_UKB_clean.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    print(paste0(trait," ", pop, " inter median sample size: ", median(sumstat_inter_clean$N)))

    # popcorn
    sumstat_inter_popcorn = sumstat_inter_clean[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(sumstat_inter_popcorn) = c("rsid", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(sumstat_inter_popcorn, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/",trait,"_",pop,"_inter_UKB_popcorn.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    sumstat_inter_PRScsx = sumstat_inter_clean[,c("SNP","A1","A2","BETA","P")]
    write.table(sumstat_inter_PRScsx, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PRScsx/",trait,"_",pop,"_inter_UKB_PRScsx.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # SDPRX
    sumstat_inter_SDPRX = sumstat_inter_clean[,c("SNP","A1","A2","Z","P","N")]
    write.table(sumstat_inter_SDPRX, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/SDPRX/",trait,"_",pop,"_inter_UKB_SDPRX.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    sumstat_inter_XPXP = sumstat_inter_clean[,c("SNP","N","Z","A1","A2","P")]
    write.table(sumstat_inter_XPXP, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/XPXP/",trait,"_",pop,"_inter_UKB_XPXP.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    sumstat_inter_PROSPER = sumstat_inter_clean[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(sumstat_inter_PROSPER) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(sumstat_inter_PROSPER, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/PROSPER/",trait,"_",pop,"_inter_UKB_PROSPER.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}

# 3. Clean unnecessary data
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/

for trait in HDL LDL TC logTG
do
rm -rf ${trait}*.log
rm -rf ${trait}*.gz
rm -rf ${trait}*.txt
done
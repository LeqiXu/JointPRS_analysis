# 2.4  DBP data
# 2.4.1 DBP sumstat cleaning
## EUR_pop
library(readr)
library(data.table)
library(stringr)

trait="DBP"
pop = "EUR"

# sumstat obtain
sumstat = read_delim(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"))
sumstat[sumstat$`P`<1e-323,"P"] = 1e-323
sumstat$Z = sumstat$Effect / sumstat$StdErr
sumstat$CHR = str_split_fixed(sumstat$MarkerName,":",3)[,1]
sumstat$POS = str_split_fixed(sumstat$MarkerName,":",3)[,2]
sumstat$CHR = as.integer(sumstat$CHR)
sumstat$POS = as.integer(sumstat$POS)
sumstat = sumstat[!duplicated(sumstat$MarkerName),c("CHR","POS","Allele1","Allele2","Freq1","Effect","StdErr","Z","P","N_effective")]
colnames(sumstat) = c("CHR","POS","A1","A2","MAF","BETA","SE","Z","P","N")
sumstat$A1 = toupper(sumstat$A1)
sumstat$A2 = toupper(sumstat$A2)

# SNP restriction
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
colnames(snp_1kg)[3] = "POS"
sumstat_inter = merge(sumstat,snp_1kg[,c("SNP","CHR","POS")],by=c("CHR","POS"))
sumstat_inter = na.omit(sumstat_inter)
sumstat_inter = sumstat_inter[sumstat_inter$SNP %in% snp_inter$V1,]

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

## EAS_pop
library(readr)
library(data.table)

trait="DBP"
pop = "EAS"

# sumstat obtain
sumstat = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"))
sumstat[sumstat$P_LINREG<1e-323,"P_LINREG"] = 1e-323
sumstat$Z = sumstat$BETA / sumstat$SE
sumstat$N = 179000
sumstat = sumstat[!duplicated(sumstat$SNP),c("SNP","CHR","BP","ALLELE1","ALLELE0","A1FREQ","BETA","SE","P_LINREG","Z","N")]
colnames(sumstat) = c("SNP","CHR","POS","A1","A2","MAF","BETA","SE","P","Z","N")

# SNP restriction
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
sumstat_inter = na.omit(sumstat)
sumstat_inter = sumstat_inter[sumstat_inter$SNP %in% snp_inter$V1,]

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

## AFR_pop
library(readr)
library(data.table)

trait="DBP"
pop = "AFR"

# sumstat obtain
sumstat = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"))
sumstat[sumstat$"P-val"<1e-323,"P-val"] = 1e-323
sumstat$Z = sumstat$Beta / sumstat$SE
sumstat = sumstat[!duplicated(sumstat$rsid),c(-3,-11)]
colnames(sumstat) = c("CHR","POS","A2","A1","MAF","N","BETA","SE","P","SNP","Z")

# SNP restriction
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
sumstat_inter = sumstat[sumstat$SNP %in% snp_inter$V1,]

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")


# 2.4.2 DBP ldsc
## SNP size
## DBP EUR_inter: 798292 EAS_inter: 747306 AFR_inter: 827738

trait=DBP
for pop in EUR EAS AFR; do
python /gpfs/gibbs/pi/zhao/lx94/Software/ldsc/munge_sumstats.py --sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc.txt --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc
done

# 2.4.3 DBP method data
## Sample size
## DBP EUR_inter: 746038 EAS_inter: 179000 AFR_inter: 35433

library(readr)
library(data.table)

trait="DBP"

for (pop in c("EUR","EAS","AFR")){
    # sumstat obtain
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"))
    
    # ldsc data
    sumstat_inter_ldsc = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.sumstats.gz"))

    # clean sumstat
    sumstat_inter_clean = sumstat_inter[which(sumstat_inter$SNP %in% sumstat_inter_ldsc$SNP),c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")]
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

# 2.4.4 Clean unnecessary data
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/

trait=DBP

rm -rf ${trait}*.log
rm -rf ${trait}*.gz
rm -rf ${trait}*.txt
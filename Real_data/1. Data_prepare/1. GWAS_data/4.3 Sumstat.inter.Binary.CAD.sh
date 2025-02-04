# 4.3  CAD data
# 4.3.1 CAD sumstat cleaning
## EUR_pop
library(readr)
library(data.table)

trait="CAD"
pop = "EUR"

# sumstat obtain
sumstat = read.table(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"), header=T, stringsAsFactors=F)
sumstat[sumstat$`pvalue`<1e-323,"pvalue"] = 1e-323
sumstat$N = 4*sumstat$N_case*sumstat$N_control/(sumstat$N_case+sumstat$N_control)
sumstat$Z = sumstat$log_odds / sumstat$log_odds_se
sumstat = sumstat[,c(1,3,4,5,6,8,9,13,14)]
colnames(sumstat) = c("SNP","A1","A2","MAF","P","BETA","SE","N","Z")

# SNP restriction
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)

sumstat_inter = sumstat[sumstat$SNP %in% snp_inter$V1,]
sumstat_inter = merge(sumstat_inter,snp_1kg[,c("SNP","CHR","BP")],by="SNP")
colnames(sumstat_inter) = c("SNP","A1","A2","MAF","P","BETA","SE","N","Z","CHR","POS")
sumstat_inter = sumstat_inter[!duplicated(sumstat_inter$SNP),]

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

## EAS_pop
library(readr)
library(data.table)

trait="CAD"
pop = "EAS"

# sumstat obtain
sumstat = read_delim(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"))
sumstat[sumstat$p.value<1e-323,"p.value"] = 1e-323
sumstat$Z = sumstat$BETA / sumstat$SE
sumstat = sumstat[!duplicated(sumstat$SNPID),c(1,2,4,5,7,9,10,12,21)]
N_case = 29319
N_control = 183134 
sumstat$N = 4*N_case*N_control/(N_case+N_control)
colnames(sumstat) = c("CHR","POS","A2","A1","MAF","BETA","SE","P","Z","N")

# SNP restriction
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
colnames(snp_1kg)[3] = "POS"

sumstat_inter = merge(sumstat,snp_1kg[,c("SNP","CHR","POS")],by=c("CHR","POS"))
sumstat_inter = na.omit(sumstat_inter)
sumstat_inter$POS = as.integer(sumstat_inter$POS)
sumstat_inter = sumstat_inter[which(sumstat_inter$SNP %in% snp_inter$V1),]

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

# 4.3.2 CAD ldsc
## SNP size
## CAD EUR_inter: 653825 EAS_inter: 786215

trait=CAD
for pop in EUR EAS; do
python /gpfs/gibbs/pi/zhao/lx94/Software/ldsc/munge_sumstats.py --sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc.txt --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc
done

# 4.3.3 CAD method data
## sample size
## CAD EUR_inter: 61333 EAS_inter: 101092

library(readr)
library(data.table)

trait="CAD"

for (pop in c("EUR","EAS")){
    # sumstat obtain
    sumstat_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"))
    
    # ldsc data
    sumstat_inter_ldsc = read_tsv(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.sumstats.gz"))

    # clean sumstat
    sumstat_inter_clean = sumstat_inter[which(sumstat_inter$SNP %in% sumstat_inter_ldsc$SNP),c("SNP","CHR","POS","A1","A2","N","MAF","BETA","SE","Z","P")]
    write.table(sumstat_inter_clean, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/",trait,"_",pop,"_inter_clean.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    print(paste0(trait," ", pop, " inter median sample size: ", median(sumstat_inter_clean$N)))

    # popcorn
    sumstat_inter_popcorn = sumstat_inter_clean[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(sumstat_inter_popcorn) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
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

# 4.3.4 Clean unnecessary data
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/

trait=CAD
rm -rf ${trait}*.log
rm -rf ${trait}*.gz
rm -rf ${trait}*.txt
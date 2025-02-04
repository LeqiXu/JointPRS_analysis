# 4.2  BrC data
# 4.2.1 BrC sumstat cleaning
## EUR_pop
library(readr)
library(data.table)
library(stringr)

trait="BrC"
pop = "EUR"

# sumstat obtain
sumstat = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"), header=T, stringsAsFactors=F)
sumstat[sumstat$`p.meta`<1e-323,"p.meta"] = 1e-323
sumstat$MAF = ifelse(sumstat$`Baseline.Meta` == sumstat$`Baseline.Gwas`, sumstat$`Freq.Gwas`, 1 - sumstat$`Freq.Gwas`)

sumstat = sumstat[,c("var_name","MAF","Effect.Meta","Baseline.Meta","Beta.meta","sdE.meta","p.meta")]
sumstat$Z = sumstat$`Beta.meta` / sumstat$`sdE.meta`
sumstat$CHR = str_split_fixed(sumstat$var_name,"_",4)[,1]
sumstat$POS = str_split_fixed(sumstat$var_name,"_",4)[,2]
sumstat$CHR = as.integer(sumstat$CHR)
sumstat$POS = as.integer(sumstat$POS)

N_case = 133384
N_control = 113789
sumstat$N = 4*N_case*N_control/(N_case+N_control)
sumstat = sumstat[!duplicated(sumstat$var_name),c("CHR","POS","Effect.Meta","Baseline.Meta","MAF","Beta.meta","sdE.meta","p.meta","Z","N")]
colnames(sumstat) = c("CHR","POS","A1","A2","MAF","BETA","SE","P","Z","N")

# SNP restriction
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
colnames(snp_1kg)[3] = "POS"
sumstat_inter = merge(sumstat,snp_1kg[,c("SNP","CHR","POS")],by=c("CHR","POS"))
sumstat_inter = na.omit(sumstat_inter)
sumstat_inter = sumstat_inter[sumstat_inter$SNP %in% snp_inter$V1,]
sumstat_inter$POS = as.integer(sumstat_inter$POS)

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

## EAS_pop
library(readr)
library(data.table)
library(stringr)

trait="BrC"
pop = "EAS"

# sumstat obtain
sumstat = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"), header=T, stringsAsFactors=F)
sumstat[sumstat$`P_meta`<1e-323,"P_meta"] = 1e-323
sumstat$w_total = sumstat$w_BBJ + sumstat$w_BCAC
sumstat$MAF = ifelse(sumstat$flip_sign == FALSE, (sumstat$Freq_effect_BBJ * sumstat$w_BBJ + sumstat$Freq_effect_BCAC * sumstat$w_BCAC) / sumstat$w_total, 
(sumstat$Freq_effect_BBJ * sumstat$w_BBJ + (1 - sumstat$Freq_effect_BCAC) * sumstat$w_BCAC) / sumstat$w_total)

sumstat = sumstat[,c("SNPID","unique_SNP_id","effect_allele_meta","non_effect_allele_meta","MAF","BETA_meta","SE_meta","P_meta")]
sumstat$Z = sumstat$`BETA_meta` / sumstat$`SE_meta`
sumstat$CHR = str_split_fixed(sumstat$unique_SNP_id,"_",4)[,1]
sumstat$POS = str_split_fixed(sumstat$unique_SNP_id,"_",4)[,2]
sumstat$CHR = as.integer(sumstat$CHR)
sumstat$POS = as.integer(sumstat$POS)

N_case = 14068
N_control = 13104
sumstat$N = 4*N_case*N_control/(N_case+N_control)

sumstat = sumstat[!duplicated(sumstat$SNPID),c("SNPID","CHR","POS","effect_allele_meta","non_effect_allele_meta","MAF","BETA_meta","SE_meta","P_meta","Z","N")]
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
library(stringr)

trait="BrC"
pop = "AFR"

# sumstat obtain
sumstat = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_sumstat.gz"), header=T, stringsAsFactors=F)
sumstat[sumstat$`P-value`<1e-323,"P-value"] = 1e-323

sumstat = sumstat[,c("MarkerName","Allele1","Allele2","Freq1","Effect","StdErr","P-value")]
sumstat$Z = sumstat$`Effect` / sumstat$`StdErr`
sumstat$CHR = str_split_fixed(sumstat$MarkerName,"_",4)[,1]
sumstat$POS = str_split_fixed(sumstat$MarkerName,"_",4)[,2]
sumstat$CHR = as.integer(sumstat$CHR)
sumstat$POS = as.integer(sumstat$POS)
sumstat$Allele1 = toupper(sumstat$Allele1)
sumstat$Allele2 = toupper(sumstat$Allele2)

N_case = 4832
N_control = 3020
sumstat$N = 4*N_case*N_control/(N_case+N_control)
sumstat = sumstat[!duplicated(sumstat$MarkerName),c("CHR","POS","Allele1","Allele2","Freq1","Effect","StdErr","P-value","Z","N")]
colnames(sumstat) = c("CHR","POS","A1","A2","MAF","BETA","SE","P","Z","N")

# SNP restriction
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_inter = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"),header=F)
colnames(snp_1kg)[3] = "POS"
sumstat_inter = merge(sumstat,snp_1kg[,c("SNP","CHR","POS")],by=c("CHR","POS"))
sumstat_inter = na.omit(sumstat_inter)
sumstat_inter = sumstat_inter[sumstat_inter$SNP %in% snp_inter$V1,]
sumstat_inter$POS = as.integer(sumstat_inter$POS)

print(paste0(trait," ", pop, " inter snp size: ", nrow(sumstat_inter)))
write.table(sumstat_inter, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")
    
# ldsc
sumstat_inter_ldsc = sumstat_inter[,c("SNP","A1","A2","N","P","Z")]
write.table(sumstat_inter_ldsc, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/",trait,"_",pop,"_inter_ldsc.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")

# 4.2.2 BrC ldsc
## SNP size
## BrC EUR_inter: 800245 EAS_inter: 747306 AFR_inter: 827774

trait=BrC
for pop in EUR EAS AFR; do
python /gpfs/gibbs/pi/zhao/lx94/Software/ldsc/munge_sumstats.py --sumstats /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc.txt --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/${trait}_${pop}_inter_ldsc
done

# 4.2.3 BrC method data
## Sample size
## BrC EUR_inter: 245620 EAS_inter: 27138 AFR_inter: 7434

library(readr)
library(data.table)

trait="BrC"

for (pop in c("EUR","EAS","AFR")){
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

# 4.2.4 Clean unnecessary data
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/

trait=BrC
rm -rf ${trait}*.log
rm -rf ${trait}*.gz
rm -rf ${trait}*.txt
## 1. Intersect with reference panel
## EUR SNP: all: 1106034 hm3: 1094900 inter: 800322
## EAS SNP: all: 1016785 hm3: 986090  inter: 800300
## AFR SNP: all: 1209443 hm3: 1064958 inter: 827778
## SAS SNP: all: 1118349 hm3: 1091799 inter: 1091799
## AMR SNP: all: 1169187 hm3: 1114281 inter: 1114281

library(data.table)

SDPRX_EUR_SNP = fread("/gpfs/gibbs/pi/zhao/gz222/SDPRX/real/snplist/1kg_prscs_inter_eas.txt", header = F)
SDPRX_EAS_SNP = fread("/gpfs/gibbs/pi/zhao/gz222/SDPRX/real/snplist/1kg_prscs_inter_eas.txt", header = F)
SDPRX_AFR_SNP = fread("/gpfs/gibbs/pi/zhao/gz222/SDPRX/real/snplist/1kg_prscs_inter_afr.txt", header = F)

hm3_SNP = fread("/gpfs/gibbs/pi/zhao/gz222/1000g_phase3/Hapmap3_snp/hm3_noMHC.snplist", header = F)

for (pop in c("EUR","EAS","AFR","SAS")){
    # refer_panel
    snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
    snp_ukbb = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/ukbb/ldblk_ukbb_",tolower(pop),"/snpinfo_ukbb_hm3"))

    ## PRScsx
    snplist = intersect(snp_1kg$SNP,snp_ukbb$SNP)

    print(paste0(pop, " all snp size: ", length(snplist)))
    write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_all_snplist.txt"), row.names=F, col.names=F, quote=F, append=F)

    ## PRScsx and hm3
    snplist = intersect(snplist,hm3_SNP$V1)

    print(paste0(pop, " hm3 snp size: ", length(snplist)))
    write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_hm3_snplist.txt"), row.names=F, col.names=F, quote=F, append=F)

    ## PRScsx and hm3 and SDPRX
    if(pop != "SAS"){
        SDPRX_SNP = get(paste0('SDPRX_',pop,"_SNP"))
        snplist = intersect(SDPRX_SNP$V1,snplist)
    }
    
    print(paste0(pop, " intersection snp size: ", length(snplist)))
    write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"), row.names=F, col.names=F, quote=F, append=F)
}

pop="AMR"

# refer_panel
snp_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg/ldblk_1kg_",tolower(pop),"/snpinfo_1kg_hm3"))
snp_ukbb = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/ukbb/ldblk_ukbb_",tolower(pop),"/snpinfo_ukbb_hm3"))

## PRScsx
snplist = intersect(snp_1kg$SNP,snp_ukbb$SNP)

print(paste0(pop, " all snp size: ", length(snplist)))
write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_all_snplist.txt"), row.names=F, col.names=F, quote=F, append=F)

## PRScsx and hm3
snplist = intersect(snplist,hm3_SNP$V1)

print(paste0(pop, " hm3 snp size: ", length(snplist)))
write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_hm3_snplist.txt"), row.names=F, col.names=F, quote=F, append=F)

## 2. Intersect with UKB for BridgePRS
library(data.table)

for (pop in c("EUR","EAS","AFR","SAS","AMR")){
snplist = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist.txt"), header = F)

if (pop == "EUR"){
    ukbb_bim = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/",pop,"_10K.bim"), header = F)
} else{
    ukbb_bim = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/",pop,".bim"), header = F)
}

snplist = intersect(snplist$V1,ukbb_bim$V2)
write.table(snplist, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist_ukbb.txt"), row.names=F, col.names=F, quote=F, append=F)
}
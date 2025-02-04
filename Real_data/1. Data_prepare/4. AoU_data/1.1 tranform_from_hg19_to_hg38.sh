# 1. Obtain the hg19 liftover_bed file
library(data.table)

for (pop in c("EUR","AFR","AMR")){

geno_bim = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/",pop,".bim"), header = FALSE)
geno_snplist = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/",pop,"_inter_snplist_ukbb.txt"), header = FALSE)
geno_bim = geno_bim[which(geno_bim$V2 %in% geno_snplist$V1),]

liftover_bed = data.table(CHR = paste0("chr",geno_bim$V1), Start = geno_bim$V4 - 1, End = geno_bim$V4, BP = geno_bim$V4, SNP = geno_bim$V2)

liftover_bed$Start = as.integer(liftover_bed$Start)
liftover_bed$End = as.integer(liftover_bed$End)
liftover_bed$BP = as.integer(liftover_bed$BP)

write.table(liftover_bed, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg19/",pop,"_liftover.bed"), row.names=F, col.names=F, quote=F, append=F)

}

# 2. Use UCSC LiftOver to tranfrom from hg19 to hg38
cd /gpfs/gibbs/pi/zhao/lx94/Software

for pop in EUR AFR AMR
do
liftOver /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg19/${pop}_liftover.bed /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/liftover_data/hg19ToHg38.over.chain /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg38/${pop}_liftover_newmap.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg38/${pop}_liftover_exclude.txt
done

# 3. Obtain the hg38 bim file
library(data.table)

for (pop in c("EUR","AFR","AMR")){

geno_bim = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/",pop,".bim"), header = FALSE)
liftover_newmap = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg38/",pop,"_liftover_newmap.txt"), header = FALSE)

geno_bim$chr_bp = paste0("chr",geno_bim$V1,":",geno_bim$V4)
liftover_newmap$chr_bp = paste0(liftover_newmap$V1,":",liftover_newmap$V4)

geno_bim = geno_bim[,c("V1","V2","V3","V5","V6","chr_bp")]
colnames(geno_bim) = c("CHR","SNP","CM","A1","A2","chr_bp")
liftover_newmap = liftover_newmap[,c("V3","V5","chr_bp")]
colnames(liftover_newmap) = c("BP","SNP","chr_bp")

map_geno_bim = merge(geno_bim,liftover_newmap, by = c("SNP","chr_bp"))
map_geno_bim = map_geno_bim[,c("CHR","SNP","CM","BP","A1","A2")]
map_geno_bim = setorder(map_geno_bim, CHR, BP)

write.table(map_geno_bim, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/aou_data/geno_data/hg38/",pop,".bim"), row.names=F, col.names=F, quote=F, append=F, sep = "\t")
}

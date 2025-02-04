## 1. Intersect with hapmaps
## hm3 SNP: 1203063

library(data.table)

snp_info = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_mega+hm3")
snp_hm3 = fread("/gpfs/gibbs/pi/zhao/gz222/1000g_phase3/Hapmap3_snp/hm3_noMHC.snplist", header = F)
snp_info_hm3 = intersect(snp_info$rs_id,snp_hm3$V1)
SNP_info_hm3_SNP = snp_info$SNP[which(snp_info$rs_id %in% snp_info_hm3)]
SNP_info_hm3_rs_id = snp_info$rs_id[which(snp_info$rs_id %in% snp_info_hm3)]

SNP_map = data.table(SNP = SNP_info_hm3_SNP, rs_id = SNP_info_hm3_rs_id)
print(paste0("hm3 snp size: ", length(SNP_info_hm3_SNP)))

write.table(SNP_info_hm3_SNP, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_hm3.snplist", row.names=F, col.names=F, quote=F, append=F)
write.table(SNP_info_hm3_rs_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_rs_id_infor_hm3.snplist", row.names=F, col.names=F, quote=F, append=F)
write.table(SNP_map, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist", row.names=F, col.names=F, quote=F, append=F, sep = "\t")


## 2. Extract discover validate and test people
library(data.table)

discover_id = data.table(FID = c(1:100000), IID = c(1:100000))
validate_id = data.table(FID = c(100001:110000), IID = c(100001:110000))
test_id = data.table(FID = c(110001:120000), IID = c(110001:120000))

write.table(discover_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")
write.table(validate_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/validate_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")
write.table(test_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/test_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")

discover_15K_id = data.table(FID = c(1:15000), IID = c(1:15000))
discover_80K_id = data.table(FID = c(1:80000), IID = c(1:80000))
write.table(discover_15K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_15K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")
write.table(discover_80K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_80K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")

discover_validate_20K_id = data.table(FID = c(c(1:15000),c(100001:105000)), IID = c(c(1:15000),c(100001:105000)))
discover_validate_25K_id = data.table(FID = c(c(1:15000),c(100001:110000)), IID = c(c(1:15000),c(100001:110000)))
write.table(discover_validate_20K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_20K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")
write.table(discover_validate_25K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_25K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")

discover_validate_85K_id = data.table(FID = c(c(1:80000),c(100001:105000)), IID = c(c(1:80000),c(100001:105000)))
discover_validate_90K_id = data.table(FID = c(c(1:80000),c(100001:110000)), IID = c(c(1:80000),c(100001:110000)))
write.table(discover_validate_85K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_85K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")
write.table(discover_validate_90K_id, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_90K_id.tsv", row.names=F, col.names=T, quote = F, sep = "\t")

## 3. merge list
library(data.table)

for(pop in c("EUR","EAS","AFR","SAS","AMR")){
    merge_list = data.table(name=paste0(pop,"_chr",2:22))

    write.table(merge_list, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/",pop,"_merge_list.txt"), row.names=F, col.names=F, quote = F, sep = "\t")
}
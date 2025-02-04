## 1. Generate summary statistics
rho=0.8
p=0.1
h2=0.1

for i in {1..5}; do
for pop in EUR EAS AFR SAS AMR; do
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}
#SBATCH --output=out_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}.txt

  module load PLINK/1
  if [[ ${pop} == "EUR" ]]; then
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_100K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_100K
  else
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_15K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_15K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_15K
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_20K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_20K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_20K
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_25K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_25K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_25K
  fi
EOT
done
done

rho=0.8
p=0.1
h2=0.1

for i in {1..5}; do
for pop in EUR EAS AFR SAS AMR; do
            sbatch <<EOT
#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --requeue
#SBATCH --mem=200G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l
#SBATCH --output=out_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l.txt

  module load PLINK/1

  if [[ ${pop} == "EUR" ]]; then
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB

  else
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_80K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_80K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_80K
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_85K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_85K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_85K
    plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_common_hm3.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_90K_id.tsv \
    --pheno /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_90K.phen \
    --linear --allow-no-sex \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_90K
  fi
EOT
done
done

## 2. Generated Data For Each Method
## use realdata reference panel
library(data.table)

rho=0.8
p=0.1
h2=0.1

pop_list=c("EUR","EAS","AFR","SAS","AMR")

update_name = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist", header=F)
snp_list = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_allpop_inter_hm3.snplist")

for (i in c(1:5)){
for (pop in 1:length(pop_list)){
  snp_info = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/",pop_list[pop],"_snp_infor"))

  if (pop == 1){
    data_100K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K.assoc.linear"))
    data_100K = data_100K[which(data_100K$SNP %in% snp_list$SNP),]

  } else{
    data_15K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K.assoc.linear"))
    data_25K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K.assoc.linear"))
    data_20K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K.assoc.linear"))

    data_15K = data_15K[which(data_15K$SNP %in% snp_list$SNP),]
    data_25K = data_25K[which(data_25K$SNP %in% snp_list$SNP),]
    data_20K = data_20K[which(data_20K$SNP %in% snp_list$SNP),]

  }
  
  print(paste0(pop_list[pop],"h2",h2,"p",p,"rho",rho,"i",i))
  if (pop == 1){
    data = data_100K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t") 

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_100K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

  } else{
    data = data_15K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_15K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


    data = data_25K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_25K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


    data = data_20K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_20K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


  }
}
}


## use realdata reference panel
library(data.table)

rho=0.8
p=0.1
h2=0.1

pop_list=c("EUR","EAS","AFR","SAS","AMR")

update_name = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist", header=F)
snp_list = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_allpop_inter_hm3.snplist")

for (i in c(1:5)){
for (pop in 1:length(pop_list)){
  snp_info = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/",pop_list[pop],"_snp_infor"))

  if (pop == 1){
    data_UKB = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB.assoc.linear"))
    data_UKB = data_UKB[which(data_UKB$SNP %in% snp_list$SNP),]
  } else{
    data_80K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K.assoc.linear"))
    data_90K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K.assoc.linear"))
    data_85K = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K.assoc.linear"))

    data_80K = data_80K[which(data_80K$SNP %in% snp_list$SNP),]
    data_90K = data_90K[which(data_90K$SNP %in% snp_list$SNP),]
    data_85K = data_85K[which(data_85K$SNP %in% snp_list$SNP),]

  }
  
  print(paste0(pop_list[pop],"p",p,"rho",rho,"i",i))
  if (pop == 1){
    data = data_UKB
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t") 

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

  } else{
    data = data_80K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_80K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


    data = data_90K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_90K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


    data = data_85K
    data = data[snp_info, on = .(SNP = rsid)]
    data$A2 = ifelse(data$A1 == snp_info$noncoding, snp_info$coding,snp_info$noncoding)
    data$MAF = ifelse(data$A1 == snp_info$noncoding, 1 - snp_info$FREQ_coding, snp_info$FREQ_coding)
    data = data[which(data$SNP %in% snp_list$SNP),]

    clean_data = data[,c("SNP","CHR","BP","A1","A2","NMISS","MAF","BETA","STAT","P")]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P")
    clean_data$SE = clean_data$BETA / clean_data$Z
    clean_data = clean_data[update_name, on = .(SNP = V2)]
    colnames(clean_data) = c("SNP","CHR","POS","A1","A2","N","MAF","BETA","Z","P","SE","rsid")
    clean_data = na.omit(clean_data)
    write.table(clean_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_clean_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # popcorn
    popcorn_data = clean_data[,c("SNP", "A1", "A2", "MAF", "N", "BETA", "SE", "Z")]
    colnames(popcorn_data) = c("SNP", "a1", "a2", "af", "N", "beta", "SE", "Z")
    write.table(popcorn_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/popcorn/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_popcorn_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PRScsx
    PRScsx_data = clean_data[,c("SNP","A1","A2","BETA","P")]
    write.table(PRScsx_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PRScsx/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_PRScsx_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F)

    # SDPRX
    SDPRX_data = clean_data[,c("SNP","A1","A2","Z","P","N")]
    write.table(SDPRX_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/SDPRX/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_SDPRX_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # XPXP
    XPXP_data = clean_data[,c("SNP","N","Z","A1","A2","P")]
    write.table(XPXP_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/XPXP/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_XPXP_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")

    # PROSPER
    PROSPER_data = clean_data[,c("SNP","CHR","A1","A2","BETA","SE","N")]
    colnames(PROSPER_data) = c("rsid","chr","a1","a0","beta","beta_se","n_eff")
    write.table(PROSPER_data, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover_validate/PROSPER/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_85K_PROSPER_real.txt"), 
                row.names=F, col.names=T, quote=F, append=F, sep = "\t")


  }
}
}

## 3. Intersect with each pop simulation test for BridgePRS in 
library(data.table)

rho=0.8
p=0.1
h2=0.1

pop_list=c("EUR","EAS","AFR","SAS","AMR")

update_name = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist", header=F)
snp_list = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_allpop_inter_hm3.snplist")

sample1_list = c("100K","UKB")
sample2_list = c("15K","80K")

for (i in c(1:5)){
for (pop in 1:length(pop_list)){

  print(p)
  print(pop)

  bim_test = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/",pop_list[pop],"/test/",pop_list[pop],".bim"), header = F)
  bim_1kg = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/",pop_list[pop],".bim"), header = F)
  bim_SNP = intersect(bim_test$V2,bim_1kg$V2)

  if (pop == 1){
    for (sample in sample1_list){
      clean_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample,"_clean_real.txt"))
      clean_data = clean_data[which(clean_data$SNP %in% snp_list$SNP),]
      clean_data = clean_data[which(clean_data$SNP %in% bim_SNP), ]
      snp_list_real = clean_data$SNP

      write.table(snp_list_real, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample,"_inter_snplist_real.txt"), 
            row.names=F, col.names=F, quote=F, append=F, sep = "\t") 

    }

  } else{
    for (sample in sample2_list){
      clean_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/",pop_list[pop],"/discover/clean/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample,"_clean_real.txt"))
      clean_data = clean_data[which(clean_data$SNP %in% snp_list$SNP),]
      clean_data = clean_data[which(clean_data$SNP %in% bim_SNP), ]
      snp_list_real = clean_data$SNP

      write.table(snp_list_real, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/simulation/",pop_list[pop],"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample,"_inter_snplist_real.txt"), 
                row.names=F, col.names=F, quote=F, append=F, sep = "\t") 

    }
  }

}
}
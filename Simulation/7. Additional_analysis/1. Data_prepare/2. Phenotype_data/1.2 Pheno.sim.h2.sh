## 1. Phenotype Simulation
# GCTA: standardized effect size
rho=0.8 
p=0.1
h2=0.1

for i in {1..5}; do 
for pop in EUR EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_100K.phen" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_15K.phen" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_d
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_d.txt

  # discover phenotype
  if [[ ${pop} == "EUR" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_100K.phen" ]]; then
    /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_id.tsv \
    --simu-qt \
    --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
    --simu-hsq 0.1 \
    --simu-rep 1 \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_100K
  fi

  if [[ ${pop} != "EUR" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_15K.phen" ]]; then
    /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
    --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_15K_id.tsv \
    --simu-qt \
    --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
    --simu-hsq 0.1 \
    --simu-rep 1 \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_15K
  fi

EOT
fi
done
done

## larger EUR and larger minor pop
rho=0.8 
p=0.1
h2=0.1
pop=EUR

for i in {1..5}; do 
if [[ ${pop} == "EUR" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB.phen" ]]; then
sbatch <<EOT
#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --requeue
#SBATCH --mem=200G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l.txt

    /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/${pop} \
    --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
    --simu-qt \
    --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
    --simu-hsq 0.1 \
    --simu-rep 1 \
    --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB
EOT
fi
done

rho=0.8 
p=0.1
h2=0.1

for i in {1..5}; do 
for pop in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_80K.phen" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=40G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_l.txt

  if [[ ${pop} != "EUR" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_80K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_80K_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_80K
  fi
EOT
fi
done
done

# discover combine with validation participants
rho=0.8 
p=0.1
h2=0.1

for i in {1..5}; do 
for pop in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_20K.phen" ]] || [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_25K.phen" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=40G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_dv
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_dv.txt

  # discover_validate phenotype
  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_20K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_20K_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_20K
  fi

  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_25K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_25K_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_25K
  fi
EOT
fi
done
done

rho=0.8 
p=0.1
h2=0.1

for i in {1..5}; do 
for pop in EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_85K.phen" ]] || [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_90K.phen" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=200G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_dv
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}_dv.txt

  # discover_validate phenotype
  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_85K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_85K_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_85K
  fi

  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_90K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_validate_90K_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/discover_validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_90K
  fi
EOT
fi
done
done

# validate participants and test participants
# discover combine with validation participants
rho=0.8 
p=0.1
h2=0.1

for i in {1..5}; do 
for pop in EUR EAS AFR SAS AMR; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K.phen" ]] || [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/test/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K.phen" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}
#SBATCH --output=out_phenotype_GWAS_simulation_${pop}_h2${h2}_p${p}_rho${rho}_i${i}.txt

  # validate phenotype
  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/validate_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K
  fi

  # test phenotype
  if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/test/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K.phen" ]]; then
  /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/gcta64/gcta-1.94.1 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/${pop} \
  --extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.snplist \
  --keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/test_id.tsv \
  --simu-qt \
  --simu-causal-loci /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/effect_data/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}.txt \
  --simu-hsq 0.1 \
  --simu-rep 1 \
  --out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/${pop}/test/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K
  fi
EOT
fi
done
done


## 2. Organize pheno data for validation and testing
# validate and test participants pheno data from simulation genotype data
library(data.table)

rho=0.8 
p=0.1
h2=0.1

for (i in c(1:5)){ 
for (pop in c("EUR","EAS","AFR","SAS","AMR")){
  val_data_all = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K.phen"))
  test_data_all = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/test/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K.phen"))
        
  val_data_0.5K = val_data_all[1:500,]
  val_data_2K = val_data_all[1:2000,]
  val_data_5K = val_data_all[1:5000,]
  val_data_10K = val_data_all[1:10000,]
  test_data_10K = test_data_all[1:10000,]

  val_data_0.5K[,c(3)] = scale(val_data_0.5K[,c(3)])
  val_data_2K[,c(3)] = scale(val_data_2K[,c(3)])
  val_data_5K[,c(3)] = scale(val_data_5K[,c(3)])
  val_data_10K[,c(3)] = scale(val_data_10K[,c(3)])
  test_data_10K[,c(3)] = scale(test_data_10K[,c(3)])

  colnames(val_data_0.5K) = c("FID","IID","pheno")
  colnames(val_data_2K) = c("FID","IID","pheno")
  colnames(val_data_5K) = c("FID","IID","pheno")
  colnames(val_data_10K) = c("FID","IID","pheno")
  colnames(test_data_10K) = c("FID","IID","pheno")

  write.table(val_data_0.5K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_0.5K_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
  write.table(val_data_2K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_2K_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
  write.table(val_data_5K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_5K_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
  write.table(val_data_10K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
  write.table(test_data_10K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/test/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")

  write.table(val_data_0.5K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_0.5K_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
  write.table(val_data_2K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_2K_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
  write.table(val_data_5K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_5K_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
  write.table(val_data_10K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
  write.table(test_data_10K, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/test/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")  
}
}
# PROSPER
## Step 1: run and tune lassosum
h2=0.1
rho=0.8 
p=0.1

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

# sample size
sample1=UKB
sample2=80K
val_sample=10K

for i in {1..5}; do
for pop in EUR EAS AFR SAS AMR; do
if [[ ! -e "${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/${pop}/optimal_param.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_${pop}_${sample1}_${sample2}_${val_sample}_lassosum_real
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_${pop}_${sample1}_${sample2}_${val_sample}_lassosum_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

## Step1
if [[ "${pop}" == "EUR" ]]; then
Rscript ${package}/scripts/lassosum2.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${pop}/discover/PROSPER/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PROSPER_real.txt \
--pop ${pop} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop}/validate/${pop} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop}/validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_10K_doubleid.tsv \
--NCORES 5
fi

if [[ "${pop}" != "EUR" ]]; then
Rscript ${package}/scripts/lassosum2.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample} \
--PATH_plink ${path_plink} \
--FILE_sst ${sum_data}/${pop}/discover/PROSPER/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt \
--pop ${pop} \
--chrom 1-22 \
--bfile_tuning ${ukb_pheno}/geno_data/${pop}/validate/${pop} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop}/validate/${pop}_sim${i}_h2${h2}_p${p}_rho${rho}_${val_sample}_doubleid.tsv \
--NCORES 5
fi
EOT
fi
done
done

## Step 2: run PROSPER
h2=0.1
rho=0.8 
p=0.1

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

# sample size
pop1=EUR
sample1=UKB
sample2=80K
val_sample=10K

for i in {1..5}; do
if [[ ! -e "${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/PROSPER_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/before_ensemble/score_param.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_real
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/scripts/PROSPER.R \
--PATH_package ${package} \
--PATH_out ${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/PROSPER_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--FILE_sst ${sum_data}/EUR/discover/PROSPER/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PROSPER_real.txt,${sum_data}/EAS/discover/PROSPER/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/AFR/discover/PROSPER/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/SAS/discover/PROSPER/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt,${sum_data}/AMR/discover/PROSPER/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PROSPER_real.txt \
--pop EUR,EAS,AFR,SAS,AMR \
--lassosum_param ${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/EUR/optimal_param.txt,${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/EAS/optimal_param.txt,${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/AFR/optimal_param.txt,${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/SAS/optimal_param.txt,${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/lassosum2_real_${sample1}_${sample2}_${val_sample}/AMR/optimal_param.txt \
--chrom 1-22 \
--NCORES 5
EOT
fi
done

## Step 3: statistical learning
h2=0.1
rho=0.8 
p=0.1

path_plink=plink2
package=/gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PROSPER_update2
path_result=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER
sum_data=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data
ukb_pheno=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data

# sample size
pop1=EUR
sample1=UKB
sample2=80K
val_sample=10K

for i in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
if [[ ! -e "${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/PROSPER_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/after_ensemble_${pop2}/PROSPER_prs_file.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_SL_real
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}_PROSPER_SL_real.txt

module load miniconda
conda activate r_env
module load PLINK/2

Rscript ${package}/scripts/tuning_testing.R \
--PATH_plink ${path_plink} \
--PATH_out ${path_result}/sim${i}_h2${h2}_p${p}_rho${rho}/PROSPER_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample} \
--prefix ${pop2} \
--bfile_tuning ${ukb_pheno}/geno_data/${pop2}/validate/${pop2} \
--pheno_tuning ${ukb_pheno}/pheno_data/${pop2}/validate/${pop2}_sim${i}_h2${h2}_p${p}_rho${rho}_${val_sample}_doubleid.tsv \
--cleanup FALSE \
--NCORES 5
EOT
fi
done
done

## Step4: copy the beta_file into the Final weight folder
rho=0.8

# sample size
pop1=EUR
sample1=UKB
sample2=80K
val_sample=10K

for i in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim${i}_h2${h2}_p${p}_rho${rho}/PROSPER_real_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_${val_sample}/after_ensemble_${pop2}/PROSPER_prs_file.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PROSPER/sim${i}_h2${h2}_p${p}_rho${rho}_${sample1}_${sample2}_${val_sample}_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_beta_${pop2}.txt
done
done

## Change rsID to SNP and only select three column
library(data.table)

h2=0.1
rho=0.8 
p=0.1

sample1="UKB"
sample2="80K"
val_sample="10K"

for (i in c(1:5)){
for (pop2 in c("EAS","AFR","SAS","AMR")){

beta_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PROSPER/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_beta_",pop2,".txt"))

# Check if the required columns exist in beta_df
if(all(c("rsid", "a1") %in% names(beta_df))) {
  beta_df = beta_df[, c("rsid", "a1", "weight")]
} else if (c("rsid") %in% names(beta_df)){
  ref_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/PROSPER_real_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_",val_sample,"/before_ensemble/score_file.txt"))
  rsid_list = intersect(beta_df$rsid,ref_df$rsid)
  ref_df = ref_df[match(rsid_list,ref_df$rsid),]
  beta_df = beta_df[match(rsid_list,beta_df$rsid),]
  beta_df = data.frame(rsid = beta_df$rsid, a1 = ref_df$a1, weight = beta_df$weight)
} else {
  ref_df = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/PROSPER_real_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_",val_sample,"/before_ensemble/score_file.txt"))
  beta_df = data.frame(rsid = ref_df$rsid, a1 = ref_df$a1, weight = beta_df$weight) 
}

write.table(beta_df, file=paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PROSPER/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_beta_",pop2,".txt"), 
row.names=F, col.names=T, quote=F, append=F, sep = "\t")

}
}
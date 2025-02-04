# JointPRS
# Step1: Estimate beta
h2=0.1
rho=0.8 
p=0.1

sample1=UKB

for sample2 in 80K 90K; do
for i in {1..5}; do
# sample size
if [[ ${sample2} == "80K" ]]; then
sample_size1=311600; sample_size2=80000
elif  [[ ${sample2} == "90K" ]]; then
sample_size1=311600; sample_size2=90000
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_h2${h2}_p${p}_rho${rho}/EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_AMR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_chr${chr}
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${sample2}" == "15K" ]] || [[ "${sample2}" == "80K" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover/PRScsx/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover/PRScsx/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover/PRScsx/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover/PRScsx/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho_cons=1,1,1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--out_dir=result/sim_result/JointPRS/sim${i}_h2${h2}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
fi

if [[ "${sample2}" == "20K" ]] || [[ "${sample2}" == "25K" ]] || [[ "${sample2}" == "85K" ]] || [[ "${sample2}" == "90K" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover_validate/PRScsx/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover_validate/PRScsx/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover_validate/PRScsx/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover_validate/PRScsx/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho_cons=1,1,1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--out_dir=result/sim_result/JointPRS/sim${i}_h2${h2}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
fi
EOT
fi
done
done
done

# Step2: Organize beta by chr pop for each param in each scenario
library(data.table)

h2=0.1
rho=0.8 
p=0.1

sample1="UKB"

for (i in c(1:5)){
for (sample2 in c("80K","90K")){
for (pop in c("EAS","AFR","SAS","AMR")){

JointPRS_all <- data.table()
for(chr in 1:22){
    
    JointPRS_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_pst_eff_a1_b0.5_phiauto_chr",chr,".txt"))
    JointPRS_pop_chr <- JointPRS_pop_chr[,c(2,4,6)]
    names(JointPRS_pop_chr) = c("rsID","A1",pop)

    JointPRS_all = rbind(JointPRS_all,JointPRS_pop_chr)
    
}

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}
# PRScsx
# Step1: Estimate beta
i=5 #1-5
p=0.1

# sample size
sample1=UKB
sample2=80K

if [[ ${sample2} == "15K" ]]; then
sample_size1=311600; sample_size2=15000
elif [[ ${sample2} == "80K" ]]; then
sample_size1=311600; sample_size2=80000
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
for rho in 0 0.2 0.4 0.6 0.8; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim${i}_p${p}_rho${rho}/EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_real_AMR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_real_chr${chr}
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_real_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover/PRScsx/EAS_sim${i}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover/PRScsx/AFR_sim${i}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover/PRScsx/SAS_sim${i}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover/PRScsx/AMR_sim${i}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--out_dir=result/sim_result/PRScsx/sim${i}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_PRScsx_real
EOT
fi
done
done

# Step2: Organize beta by chr pop for in each scenario
library(data.table)

p=0.1

sample1="UKB"
sample2="80K"

for (i in c(1:5)){
for (pop in c("EUR","EAS","AFR",'SAS',"AMR")){
for (rho in c(0,0.2,0.4,0.6,0.8)){

PRScsx_all <- data.table()
for(chr in 1:22){
    
    PRScsx_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim",i,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_PRScsx_real_",pop,"_pst_eff_a1_b0.5_phiauto_chr",chr,".txt"))
    PRScsx_pop_chr <- PRScsx_pop_chr[,c(2,4,6)]
    names(PRScsx_pop_chr) = c("rsID","A1",pop)

    PRScsx_all = rbind(PRScsx_all,PRScsx_pop_chr)
    
}

write.table(PRScsx_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/PRScsx/sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}
# SDPRX
# Step1: Estimate beta
h2=0.1
rho=0.8 
p=0.1

pop1=EUR

sample1=UKB
sample2=90K

for i in {1..5}; do
for pop2 in EAS AFR; do

# sample size
if [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "1" && ${pop2} == "EAS" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.85
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "1" && ${pop2} == "AFR" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.90
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "2" && ${pop2} == "EAS" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.74
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "2" && ${pop2} == "AFR" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.84
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "3" && ${pop2} == "EAS" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.83
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "3" && ${pop2} == "AFR" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.81
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "4" && ${pop2} == "EAS" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.88
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "4" && ${pop2} == "AFR" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.86
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "5" && ${pop2} == "EAS" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.73
elif [[ ${sample2} == "90K" && ${h2} == "0.1" && ${p} == "0.1" && ${rho} == "0.8" && ${i} == "5" && ${pop2} == "AFR" ]]; then
sample_size1=311600; sample_size2=90000; rho_est=0.77
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/SDPRX/sim${i}_h2${h2}_p${p}_rho${rho}/${pop1}_${pop2}_${sample1}_${sample2}_SDPRX_real_chr${chr}_2.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=20G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_SDPRX_real_chr${chr}
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_SDPRX_real_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${sample2}" == "20K" ]] || [[ "${sample2}" == "25K" ]] || [[ "${sample2}" == "85K" || "${sample2}" == "90K" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/SDPRX/SDPRX.py \
--load_ld /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/SDPRX/EUR_${pop2} \
--valid data/sim_data/geno_data/All/All_test.bim \
--ss1 data/sim_data/summary_data/${pop1}/discover/SDPRX/${pop1}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_SDPRX_real.txt \
--ss2 data/sim_data/summary_data/${pop2}/discover_validate/SDPRX/${pop2}_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_SDPRX_real.txt \
--N1 ${sample_size1} --N2 ${sample_size2} --mcmc_samples 2000 --burn 1000 --force_shared True \
--chr ${chr} \
--rho ${rho_est} \
--out result/sim_result/SDPRX/sim${i}_h2${h2}_p${p}_rho${rho}/${pop1}_${pop2}_${sample1}_${sample2}_SDPRX_real_chr${chr}
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
sample2="90K"

for (i in c(1:5)){
for (pop in c("EAS","AFR")){

SDPRX_all <- data.table()
for(chr in 1:22){
    
    SDPRX_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/SDPRX/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_",pop,"_",sample1,"_",sample2,"_SDPRX_real_chr",chr,"_2.txt"))
    names(SDPRX_pop_chr) = c("rsID","A1",pop)

    SDPRX_all = rbind(SDPRX_all,SDPRX_pop_chr)
    
}

write.table(SDPRX_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/SDPRX/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_SDPRX_real_EUR_",pop,"_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
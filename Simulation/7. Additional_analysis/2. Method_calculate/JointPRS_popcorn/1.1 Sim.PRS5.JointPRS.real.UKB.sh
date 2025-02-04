# JointPRS
# Step1: Estimate beta
rho=0.8 

sample1=UKB
sample2=15K

pop1=EUR

for i in {1..5}; do
for pop2 in EAS AFR SAS AMR; do
for p in 5e-04 0.1; do

# sample size
if [[ ${sample2} == "15K" ]]; then
sample_size1=311600; sample_size2=15000
else
echo "Please provide the available phenotype"
fi

if [[ ${i} == "1" ]] && [[ ${p} == "5e-04" ]]; then
rho_EUR_EAS=0.77; rho_EUR_AFR=0.88; rho_EUR_SAS=0.75; rho_EUR_AMR=0.86; rho_EAS_AFR=0.70; rho_EAS_SAS=0.65; rho_EAS_AMR=0.99; rho_AFR_SAS=0.91; rho_AFR_AMR=0.99; rho_SAS_AMR=0.86
elif [[ ${i} == "1" ]] && [[ ${p} == "0.1" ]]; then
rho_EUR_EAS=0.81; rho_EUR_AFR=0.75; rho_EUR_SAS=0.80; rho_EUR_AMR=0.73; rho_EAS_AFR=0.65; rho_EAS_SAS=0.88; rho_EAS_AMR=0.86; rho_AFR_SAS=0.90; rho_AFR_AMR=0.57; rho_SAS_AMR=0.86
elif [[ ${i} == "2" ]] && [[ ${p} == "5e-04" ]]; then
rho_EUR_EAS=0.85; rho_EUR_AFR=0.95; rho_EUR_SAS=0.87; rho_EUR_AMR=0.85; rho_EAS_AFR=0.99; rho_EAS_SAS=0.90; rho_EAS_AMR=0.95; rho_AFR_SAS=0.99; rho_AFR_AMR=0.99; rho_SAS_AMR=0.97
elif [[ ${i} == "2" ]] && [[ ${p} == "0.1" ]]; then
rho_EUR_EAS=0.80; rho_EUR_AFR=0.88; rho_EUR_SAS=0.79; rho_EUR_AMR=0.85; rho_EAS_AFR=0.89; rho_EAS_SAS=0.83; rho_EAS_AMR=0.85; rho_AFR_SAS=0.98; rho_AFR_AMR=0.99; rho_SAS_AMR=0.80
elif [[ ${i} == "3" ]] && [[ ${p} == "5e-04" ]]; then
rho_EUR_EAS=0.93; rho_EUR_AFR=0.76; rho_EUR_SAS=0.70; rho_EUR_AMR=0.76; rho_EAS_AFR=0.99; rho_EAS_SAS=0.81; rho_EAS_AMR=0.99; rho_AFR_SAS=0.63; rho_AFR_AMR=0.79; rho_SAS_AMR=0.83
elif [[ ${i} == "3" ]] && [[ ${p} == "0.1" ]]; then
rho_EUR_EAS=0.79; rho_EUR_AFR=0.74; rho_EUR_SAS=0.74; rho_EUR_AMR=0.86; rho_EAS_AFR=0.73; rho_EAS_SAS=0.74; rho_EAS_AMR=0.82; rho_AFR_SAS=0.86; rho_AFR_AMR=0.93; rho_SAS_AMR=0.89
elif [[ ${i} == "4" ]] && [[ ${p} == "5e-04" ]]; then
rho_EUR_EAS=0.64; rho_EUR_AFR=0.75; rho_EUR_SAS=0.68; rho_EUR_AMR=0.83; rho_EAS_AFR=0.56; rho_EAS_SAS=0.70; rho_EAS_AMR=0.84; rho_AFR_SAS=0.90; rho_AFR_AMR=0.89; rho_SAS_AMR=0.61
elif [[ ${i} == "4" ]] && [[ ${p} == "0.1" ]]; then
rho_EUR_EAS=0.81; rho_EUR_AFR=0.72; rho_EUR_SAS=0.74; rho_EUR_AMR=0.88; rho_EAS_AFR=0.73; rho_EAS_SAS=0.72; rho_EAS_AMR=0.90; rho_AFR_SAS=0.73; rho_AFR_AMR=0.90; rho_SAS_AMR=0.98
elif [[ ${i} == "5" ]] && [[ ${p} == "5e-04" ]]; then
rho_EUR_EAS=0.84; rho_EUR_AFR=0.94; rho_EUR_SAS=0.82; rho_EUR_AMR=0.83; rho_EAS_AFR=0.99; rho_EAS_SAS=0.91; rho_EAS_AMR=0.85; rho_AFR_SAS=0.83; rho_AFR_AMR=0.86; rho_SAS_AMR=0.89
elif [[ ${i} == "5" ]] && [[ ${p} == "0.1" ]]; then
rho_EUR_EAS=0.69; rho_EUR_AFR=0.84; rho_EUR_SAS=0.79; rho_EUR_AMR=0.82; rho_EAS_AFR=0.75; rho_EAS_SAS=0.72; rho_EAS_AMR=0.75; rho_AFR_SAS=0.67; rho_AFR_AMR=0.83; rho_SAS_AMR=0.99
else
echo "Please provide the available sim and p"
fi

var_name="rho_${pop1}_${pop2}"

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim${i}_p${p}_rho${rho}/${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real_${pop2}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real_chr${chr}
#SBATCH --output=out_sim${i}_p${p}_rho${rho}_${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${sample2}" == "15K" ]] || [[ "${sample2}" == "80K" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS_popcorn/JointPRS_popcorn.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/${pop1}/discover/PRScsx/${pop1}_sim${i}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/${pop2}/discover/PRScsx/${pop2}_sim${i}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho=1,${!var_name},${!var_name},1 \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=${pop1},${pop2} \
--out_dir=result/sim_result/JointPRS/sim${i}_p${p}_rho${rho} \
--out_name=${pop1}_${pop2}_${sample1}_${sample2}_JointPRS_popcorn_real
fi
EOT
fi
done
done
done
done

# Step2: Organize beta by chr pop for each param in each scenario
library(data.table)

rho=0.8 

pop1="EUR"
sample1="UKB"

for (i in c(1:5)){
for (p in c(5e-04,0.1)){
for (sample2 in c("15K")){
for (pop2 in c("EAS","AFR",'SAS',"AMR")){

JointPRS_all <- data.table()
for(chr in 1:22){
    
    JointPRS_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim",i,"_p",p,"_rho",rho,"/EUR_",pop2,"_",sample1,"_",sample2,"_JointPRS_popcorn_real_",pop2,"_pst_eff_a1_b0.5_phiauto_chr",chr,".txt"))
    JointPRS_pop_chr <- JointPRS_pop_chr[,c(2,4,6)]
    names(JointPRS_pop_chr) = c("rsID","A1",pop)

    JointPRS_all = rbind(JointPRS_all,JointPRS_pop_chr)
    
}

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_JointPRS_popcorn_real_EUR_",pop2,"_beta_",pop2,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}
}
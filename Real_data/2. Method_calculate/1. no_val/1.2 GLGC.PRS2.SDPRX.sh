# SDPRX
# Step1: Estimate beta
pop1=EUR

for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR; do

# sample size
if [[ ${pop2} == "EAS" && ${trait} == "HDL" ]]; then
sample_size1=885546; sample_size2=116404; rho=0.99
elif  [[ ${pop2} == "AFR" && ${trait} == "HDL" ]]; then
sample_size1=885546; sample_size2=90804; rho=0.93
elif [[ ${pop2} == "EAS" && ${trait} == "LDL" ]]; then
sample_size1=840012; sample_size2=79693; rho=0.90
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" ]]; then
sample_size1=840012; sample_size2=87759; rho=0.70
elif [[ ${pop2} == "EAS" && ${trait} == "TC" ]]; then
sample_size1=929739; sample_size2=144579; rho=0.99
elif [[ ${pop2} == "AFR" && ${trait} == "TC" ]]; then
sample_size1=929739; sample_size2=92554; rho=0.74
elif [[ ${pop2} == "EAS" && ${trait} == "logTG" ]]; then
sample_size1=860679; sample_size2=81071; rho=0.99
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" ]]; then
sample_size1=860679; sample_size2=89467; rho=0.93
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/${trait}_${pop1}_${pop2}_SDPRX_chr${chr}_2.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_${pop1}_${pop2}_SDPRX_chr${chr}
#SBATCH --output=out_${trait}_${pop1}_${pop2}_SDPRX_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/SDPRX/SDPRX.py \
--load_ld /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/SDPRX/EUR_${pop2} \
--valid /gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal.bim \
--ss1 data/summary_data/SDPRX/${trait}_${pop1}_inter_SDPRX.txt \
--ss2 data/summary_data/SDPRX/${trait}_${pop2}_inter_SDPRX.txt \
--N1 ${sample_size1} --N2 ${sample_size2} --mcmc_samples 2000 --burn 1000 --force_shared True \
--chr ${chr} \
--rho ${rho} \
--out result/summary_result/no_val/SDPRX/${trait}_${pop1}_${pop2}_SDPRX_chr${chr}
EOT
fi
done
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("EAS","AFR")){

SDPRX_all <- data.table()
for(i in 1:22){

    SDPRX_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/",trait,"_EUR_",pop,"_SDPRX_chr",i,"_2.txt"))

    names(SDPRX_pop_chr) = c("rsID","A1",pop)

    SDPRX_all = rbind(SDPRX_all,SDPRX_pop_chr)
    
}

write.table(SDPRX_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/",trait,"_SDPRX_EUR_",pop,"_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step3: Clean the previous result
for trait in HDL LDL TC logTG; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/
rm -rf ${trait}_*.txt
done
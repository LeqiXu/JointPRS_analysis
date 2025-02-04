# SDPRX
# Step0: Copy the beta estimation for EAS from no_val as we use the same EAS GWAS
for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop in EAS; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/${trait}_SDPRX_EUR_${pop}_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/SDPRX/${trait}_SDPRX_val_${s}_EUR_${pop}_beta_${pop}.txt
done
done
done

# Step1: Estimate beta
# we need to reestimate the AFR beta
s=5
pop1=EUR

for trait in HDL LDL TC logTG; do
for pop2 in AFR; do

# sample size
if  [[ ${pop2} == "AFR" && ${trait} == "HDL" && ${s} == "1" ]]; then
sample_size1=885546; sample_size2=95285; rho=0.88
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" && ${s} == "1" ]]; then
sample_size1=840012; sample_size2=92425; rho=0.70
elif [[ ${pop2} == "AFR" && ${trait} == "TC" && ${s} == "1" ]]; then
sample_size1=929739; sample_size2=97207; rho=0.75
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" && ${s} == "1" ]]; then
sample_size1=860679; sample_size2=94306; rho=0.90
elif  [[ ${pop2} == "AFR" && ${trait} == "HDL" && ${s} == "2" ]]; then
sample_size1=885546; sample_size2=95284; rho=0.89
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" && ${s} == "2" ]]; then
sample_size1=840012; sample_size2=92424; rho=0.71
elif [[ ${pop2} == "AFR" && ${trait} == "TC" && ${s} == "2" ]]; then
sample_size1=929739; sample_size2=97208; rho=0.74
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" && ${s} == "2" ]]; then
sample_size1=860679; sample_size2=94305; rho=0.90
elif  [[ ${pop2} == "AFR" && ${trait} == "HDL" && ${s} == "3" ]]; then
sample_size1=885546; sample_size2=95286; rho=0.92
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" && ${s} == "3" ]]; then
sample_size1=840012; sample_size2=92424; rho=0.71
elif [[ ${pop2} == "AFR" && ${trait} == "TC" && ${s} == "3" ]]; then
sample_size1=929739; sample_size2=97208; rho=0.75
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" && ${s} == "3" ]]; then
sample_size1=860679; sample_size2=94305; rho=0.92
elif  [[ ${pop2} == "AFR" && ${trait} == "HDL" && ${s} == "4" ]]; then
sample_size1=885546; sample_size2=95282; rho=0.90
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" && ${s} == "4" ]]; then
sample_size1=840012; sample_size2=92426; rho=0.70
elif [[ ${pop2} == "AFR" && ${trait} == "TC" && ${s} == "4" ]]; then
sample_size1=929739; sample_size2=97208; rho=0.75
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" && ${s} == "4" ]]; then
sample_size1=860679; sample_size2=94305; rho=0.89
elif  [[ ${pop2} == "AFR" && ${trait} == "HDL" && ${s} == "5" ]]; then
sample_size1=885546; sample_size2=95286; rho=0.90
elif [[ ${pop2} == "AFR" && ${trait} == "LDL" && ${s} == "5" ]]; then
sample_size1=840012; sample_size2=92425; rho=0.71
elif [[ ${pop2} == "AFR" && ${trait} == "TC" && ${s} == "5" ]]; then
sample_size1=929739; sample_size2=97206; rho=0.74
elif [[ ${pop2} == "AFR" && ${trait} == "logTG" && ${s} == "5" ]]; then
sample_size1=860679; sample_size2=94306; rho=0.90
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/${trait}_${pop1}_${pop2}_SDPRX_val_${s}_chr${chr}_2.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_${pop1}_${pop2}_SDPRX_val_${s}_chr${chr}
#SBATCH --output=out_${trait}_${pop1}_${pop2}_SDPRX_val_${s}_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${pop2}" == "AFR" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/SDPRX/SDPRX.py \
--load_ld /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/SDPRX/EUR_${pop2} \
--valid /gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal.bim \
--ss1 data/summary_data/SDPRX/${trait}_${pop1}_inter_SDPRX.txt \
--ss2 data/summary_data/SDPRX/${trait}_${pop2}_inter_UKB_val_${s}_SDPRX.txt \
--N1 ${sample_size1} --N2 ${sample_size2} --mcmc_samples 2000 --burn 1000 --force_shared True \
--chr ${chr} \
--rho ${rho} \
--out result/summary_result/same_cohort/SDPRX/${trait}_${pop1}_${pop2}_SDPRX_val_${s}_chr${chr}
fi
EOT
fi
done
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (s in c(1:5)){
for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("AFR")){

SDPRX_all <- data.table()
for(i in 1:22){

    SDPRX_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/",trait,"_EUR_",pop,"_SDPRX_val_",s,"_chr",i,"_2.txt"))

    names(SDPRX_pop_chr) = c("rsID","A1",pop)

    SDPRX_all = rbind(SDPRX_all,SDPRX_pop_chr)
    
}

write.table(SDPRX_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/SDPRX/",trait,"_SDPRX_val_",s,"_EUR_",pop,"_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
}

# Step3: Clean the previous result
for trait in HDL LDL TC logTG; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/
rm -rf ${trait}_*_chr*.txt
done
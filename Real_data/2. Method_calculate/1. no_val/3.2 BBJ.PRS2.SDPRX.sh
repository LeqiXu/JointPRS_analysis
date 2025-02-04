# SDPRX
# Step1: Estimate beta
pop1=EUR

for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do

# sample size
if [[ ${pop2} == "EAS" && ${trait} == "WBC" ]]; then
sample_size1=559083; sample_size2=179000; rho=0.77
elif [[ ${pop2} == "EAS" && ${trait} == "NEU" ]]; then
sample_size1=517889; sample_size2=179000; rho=0.80
elif [[ ${pop2} == "EAS" && ${trait} == "LYM" ]]; then
sample_size1=523524; sample_size2=179000; rho=0.78
elif [[ ${pop2} == "EAS" && ${trait} == "MON" ]]; then
sample_size1=520195; sample_size2=179000; rho=0.80
elif [[ ${pop2} == "EAS" && ${trait} == "EOS" ]]; then
sample_size1=473152; sample_size2=179000; rho=0.86
elif [[ ${pop2} == "EAS" && ${trait} == "RBC" ]]; then
sample_size1=542043; sample_size2=179000; rho=0.92
elif [[ ${pop2} == "EAS" && ${trait} == "HCT" ]]; then
sample_size1=559099; sample_size2=179000; rho=0.85
elif [[ ${pop2} == "EAS" && ${trait} == "MCH" ]]; then
sample_size1=483664; sample_size2=179000; rho=0.87
elif [[ ${pop2} == "EAS" && ${trait} == "MCV" ]]; then
sample_size1=540967; sample_size2=179000; rho=0.89
elif [[ ${pop2} == "EAS" && ${trait} == "HB" ]]; then
sample_size1=408112; sample_size2=179000; rho=0.84
elif [[ ${pop2} == "EAS" && ${trait} == "ALT" ]]; then
sample_size1=437267; sample_size2=179000; rho=0.69
elif [[ ${pop2} == "EAS" && ${trait} == "ALP" ]]; then
sample_size1=437267; sample_size2=179000; rho=0.52
elif [[ ${pop2} == "EAS" && ${trait} == "GGT" ]]; then
sample_size1=437267; sample_size2=179000; rho=0.79
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/${trait}_${pop1}_${pop2}_SDPRX_chr${chr}_2.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=30G
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

for (trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
for (pop in c("EAS")){

SDPRX_all <- data.table()
for(i in 1:22){

    SDPRX_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/",trait,"_EUR_EAS_SDPRX_chr",i,"_2.txt"))

    names(SDPRX_pop_chr) = c("rsID","A1",pop)

    SDPRX_all = rbind(SDPRX_all,SDPRX_pop_chr)
    
}

write.table(SDPRX_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/",trait,"_SDPRX_EUR_EAS_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

library(data.table)

for (trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
for (pop in c("EUR")){

SDPRX_all <- data.table()
for(i in 1:22){

    SDPRX_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/",trait,"_EUR_EAS_SDPRX_chr",i,"_1.txt"))

    names(SDPRX_pop_chr) = c("rsID","A1",pop)

    SDPRX_all = rbind(SDPRX_all,SDPRX_pop_chr)
    
}

write.table(SDPRX_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/",trait,"_SDPRX_EUR_EAS_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step3: Clean the previous result
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/SDPRX/
rm -rf ${trait}_*.txt
done
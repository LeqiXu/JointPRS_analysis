# JointPRS
# Step1: Estimate beta
for trait in HDL LDL TC logTG; do

# sample size
if [[ ${trait} == "HDL" ]]; then
sample_size1=885546; sample_size2=116404; sample_size3=90804; sample_size4=33953; sample_size5=47276
elif [[ ${trait} == "LDL" ]]; then
sample_size1=840012; sample_size2=79693; sample_size3=87759; sample_size4=33658; sample_size5=33989
elif [[ ${trait} == "TC" ]]; then
sample_size1=929739; sample_size2=144579; sample_size3=92554; sample_size4=34135; sample_size5=48055
elif [[ ${trait} == "logTG" ]]; then
sample_size1=860679; sample_size2=81071; sample_size3=89467; sample_size4=34023; sample_size5=37273
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_AMR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_SAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AMR_inter_PRScsx.txt \
--rho_cons=1,1,1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3},${sample_size4},${sample_size5} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--out_dir=result/summary_result/no_val/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_SAS_AMR_JointPRS
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("HDL","LDL","TC","logTG")){
for (pop in c("EAS","AFR",'SAS',"AMR")){

JointPRS_all <- data.table()
for(i in 1:22){
    JointPRS_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/",trait,"_EUR_EAS_AFR_SAS_AMR_JointPRS_",pop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    JointPRS_pop_chr <- JointPRS_pop_chr[,c(2,4,6)]
    names(JointPRS_pop_chr) = c("rsID","A1",pop)

    JointPRS_all = rbind(JointPRS_all,JointPRS_pop_chr)
    
}

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/",trait,"_JointPRS_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)


}
}

# Step3: Clean the previous result
for trait in HDL LDL TC logTG; do

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/
rm -rf ${trait}_*.txt
done
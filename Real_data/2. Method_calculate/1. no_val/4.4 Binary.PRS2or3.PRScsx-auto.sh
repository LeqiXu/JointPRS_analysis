# PRScsx
# Step1: Estimate beta
for trait in T2D BrC CAD LuC; do

# sample size
if [[ ${trait} == "T2D" ]]; then
sample_size1=88825; sample_size2=118493; sample_size3=38919
elif [[ ${trait} == "BrC" ]]; then
sample_size1=245620; sample_size2=27138; sample_size3=7434
elif [[ ${trait} == "CAD" ]]; then
sample_size1=61333; sample_size2=101092
elif [[ ${trait} == "LuC" ]]; then
sample_size1=77095; sample_size2=15891
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/${trait}_EUR_EAS_AFR_PRScsx_AFR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]] && [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/${trait}_EUR_EAS_PRScsx_EAS_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_PRScsx_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_PRScsx_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${trait}" == "T2D" ]] || [[ "${trait}" == "BrC" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/no_val/PRScsx \
--out_name=${trait}_EUR_EAS_AFR_PRScsx
fi

if [[ "${trait}" == "CAD" ]] || [[ "${trait}" == "LuC" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--out_dir=result/summary_result/no_val/PRScsx \
--out_name=${trait}_EUR_EAS_PRScsx
fi
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("T2D","BrC","CAD","LuC")){

if (trait %in% c("T2D","BrC")){
for (pop in c("EAS","AFR")){

PRScsx_all <- data.table()
for(i in 1:22){
    PRScsx_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/",trait,"_EUR_EAS_AFR_PRScsx_",pop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    PRScsx_pop_chr <- PRScsx_pop_chr[,c(2,4,6)]
    names(PRScsx_pop_chr) = c("rsID","A1",pop)

    PRScsx_all = rbind(PRScsx_all,PRScsx_pop_chr)
    
}

write.table(PRScsx_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/PRScsx/",trait,"_PRScsx_auto_EUR_EAS_AFR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)


}
}

if (trait %in% c("CAD","LuC")){
for (pop in c("EAS")){

PRScsx_all <- data.table()
for(i in 1:22){
    PRScsx_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/",trait,"_EUR_EAS_PRScsx_",pop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    PRScsx_pop_chr <- PRScsx_pop_chr[,c(2,4,6)]
    names(PRScsx_pop_chr) = c("rsID","A1",pop)

    PRScsx_all = rbind(PRScsx_all,PRScsx_pop_chr)
    
}

write.table(PRScsx_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/PRScsx/",trait,"_PRScsx_auto_EUR_EAS_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)


}
}
}

# Step3: Clean the previous result
for trait in T2D BrC CAD LuC; do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/
rm -rf ${trait}_*.txt
done
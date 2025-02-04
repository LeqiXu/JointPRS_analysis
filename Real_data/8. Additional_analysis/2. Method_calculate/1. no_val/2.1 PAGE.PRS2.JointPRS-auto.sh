# JointPRS
# Step1: Estimate beta
targetpop=AFR # EAS AFR 

for trait in Height BMI SBP DBP PLT; do

# sample size
if [[ ${trait} == "Height" ]]; then
sample_size1=252357; sample_size2=159095; sample_size3=49781
elif [[ ${trait} == "BMI" ]]; then
sample_size1=233787; sample_size2=158284; sample_size3=49335
elif [[ ${trait} == "SBP" ]]; then
sample_size1=728893; sample_size2=179000; sample_size3=35433
elif [[ ${trait} == "DBP" ]]; then
sample_size1=746038; sample_size2=179000; sample_size3=35433
elif [[ ${trait} == "PLT" ]]; then
sample_size1=539667; sample_size2=179000; sample_size3=29328
else
echo "Please provide the available phenotype"
fi

if [[ ${targetpop} == "EAS" ]]; then
sample_size_target=${sample_size2}
elif [[ ${targetpop} == "AFR" ]]; then
sample_size_target=${sample_size3}
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/${trait}_EUR_${targetpop}_JointPRS_${targetpop}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_${targetpop}_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_${targetpop}_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_${targetpop}_inter_PRScsx.txt \
--rho_cons=1,1 \
--n_gwas=${sample_size1},${sample_size_target} \
--chrom=${chr} \
--pop=EUR,${targetpop} \
--out_dir=result/summary_result/no_val/JointPRS \
--out_name=${trait}_EUR_${targetpop}_JointPRS
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (targetpop in c("EAS","AFR")){
for (trait in c("Height","BMI","SBP","DBP","PLT")){

JointPRS_all <- data.table()
for(i in 1:22){
    JointPRS_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/JointPRS/",trait,"_EUR_",targetpop,"_JointPRS_",targetpop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    JointPRS_pop_chr <- JointPRS_pop_chr[,c(2,4,6)]
    names(JointPRS_pop_chr) = c("rsID","A1",targetpop)

    JointPRS_all = rbind(JointPRS_all,JointPRS_pop_chr)
    
}

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/JointPRS/",trait,"_JointPRS_EUR_",targetpop,"_beta_",targetpop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
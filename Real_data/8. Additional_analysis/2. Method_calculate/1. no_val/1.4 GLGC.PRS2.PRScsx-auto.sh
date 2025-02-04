# PRScsx
# Step1: Estimate beta
targetpop=AMR # EAS AFR SAS AMR

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

if [[ ${targetpop} == "EAS" ]]; then
sample_size_target=${sample_size2}
elif [[ ${targetpop} == "AFR" ]]; then
sample_size_target=${sample_size3}
elif [[ ${targetpop} == "SAS" ]]; then
sample_size_target=${sample_size4}
elif [[ ${targetpop} == "AMR" ]]; then
sample_size_target=${sample_size5}
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/${trait}_EUR_${targetpop}_PRScsx_${targetpop}_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_${targetpop}_PRScsx_chr${chr}
#SBATCH --output=out_${trait}_EUR_${targetpop}_PRScsx_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_${targetpop}_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size_target} \
--chrom=${chr} \
--pop=EUR,${targetpop} \
--out_dir=result/summary_result/no_val/PRScsx \
--out_name=${trait}_EUR_${targetpop}_PRScsx
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

targetpop="EAS"

for (targetpop in c("EAS","AFR","SAS","AMR")){
for (trait in c("HDL","LDL","TC","logTG")){

PRScsx_all <- data.table()
for(i in 1:22){
    PRScsx_pop_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/",trait,"_EUR_",targetpop,"_PRScsx_",targetpop,"_pst_eff_a1_b0.5_phiauto_chr",i,".txt"))

    PRScsx_pop_chr <- PRScsx_pop_chr[,c(2,4,6)]
    names(PRScsx_pop_chr) = c("rsID","A1",targetpop)

    PRScsx_all = rbind(PRScsx_all,PRScsx_pop_chr)
    
}

write.table(PRScsx_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/PRScsx/",trait,"_PRScsx_auto_EUR_",targetpop,"_beta_",targetpop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)


}
}
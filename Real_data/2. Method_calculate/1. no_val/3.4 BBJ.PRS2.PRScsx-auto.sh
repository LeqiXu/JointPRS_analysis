# PRScsx
# Step1: Estimate beta
pop2=EAS

for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do

# sample size
if [[ ${pop2} == "EAS" && ${trait} == "WBC" ]]; then
sample_size1=559083; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "NEU" ]]; then
sample_size1=517889; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "LYM" ]]; then
sample_size1=523524; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MON" ]]; then
sample_size1=520195; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "EOS" ]]; then
sample_size1=473152; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "RBC" ]]; then
sample_size1=542043; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "HCT" ]]; then
sample_size1=559099; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MCH" ]]; then
sample_size1=483664; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "MCV" ]]; then
sample_size1=540967; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "HB" ]]; then
sample_size1=408112; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "ALT" ]]; then
sample_size1=437267; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "ALP" ]]; then
sample_size1=437267; sample_size2=179000
elif [[ ${pop2} == "EAS" && ${trait} == "GGT" ]]; then
sample_size1=437267; sample_size2=179000
else
echo "Please provide the available phenotype"
fi

for chr in {1..22}; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/${trait}_EUR_EAS_PRScsx_EAS_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_PRScsx_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_PRScsx_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--out_dir=result/summary_result/no_val/PRScsx \
--out_name=${trait}_EUR_EAS_PRScsx
EOT
fi
done
done

# Step2: Organize beta by chr pop for each param in each trait
library(data.table)

for (trait in c("WBC","NEU","LYM","MON","EOS","RBC","HCT","MCH","MCV","HB","ALT","ALP","GGT")){
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

# Step3: Clean the previous result
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/PRScsx/
rm -rf ${trait}_*.txt
done
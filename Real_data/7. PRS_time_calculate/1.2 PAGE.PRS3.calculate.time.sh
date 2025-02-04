## JointPRS-auto
for trait in Height BMI SBP DBP PLT; do

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

chr=2
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/time_result/JointPRS/${trait}_EUR_EAS_AFR_JointPRS_AFR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SPATCH --constraint="6240"
#SBATCH --partition=scavenge
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--rho_cons=1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/time_result/JointPRS \
--out_name=${trait}_EUR_EAS_AFR_JointPRS

EOT
fi
done

Height 34169353
BMI    34169354
SBP    34169355
DBP    34169356
PLT    34169357

# PRScsx-auto
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

chr=2
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/time_result/PRScsx/${trait}_EUR_EAS_AFR_PRScsx_AFR_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SPATCH --constraint="6240"
#SBATCH --partition=scavenge
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${trait}_EUR_EAS_AFR_PRScsx_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_AFR_PRScsx_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/PRScsx/PRScsx.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_AFR_inter_PRScsx.txt \
--n_gwas=${sample_size1},${sample_size2},${sample_size3} \
--chrom=${chr} \
--pop=EUR,EAS,AFR \
--out_dir=result/summary_result/time_result/PRScsx \
--out_name=${trait}_EUR_EAS_AFR_PRScsx
EOT
fi
done

Height 34169367
BMI    34169368
SBP    34169369
DBP    34169370
PLT    34169371
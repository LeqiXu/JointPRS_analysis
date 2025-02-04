## JointPRS
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

chr=2
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/time_result/JointPRS/${trait}_EUR_EAS_JointPRS_EAS_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
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
#SBATCH --job-name=${trait}_EUR_EAS_JointPRS_chr${chr}
#SBATCH --output=out_${trait}_EUR_EAS_JointPRS_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=/gpfs/gibbs/pi/zhao/zhao-data/yy496/ukbb_v3/ukbb3_neale/ukbb3_imp_nealqc/tmp_Ukb_imp_v3_neal \
--sst_file=data/summary_data/PRScsx/${trait}_EUR_inter_PRScsx.txt,data/summary_data/PRScsx/${trait}_EAS_inter_PRScsx.txt \
--rho_cons=1,1 \
--n_gwas=${sample_size1},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS \
--out_dir=result/summary_result/time_result/JointPRS \
--out_name=${trait}_EUR_EAS_JointPRS

EOT
fi
done

WBC 34162706
NEU 34162707
LYM 34162709
MON 34162710
EOS 34162711
RBC 34162712
HCT 34162713
MCH 34162714
MCV 34162715
HB  34162716
ALT 34162717
ALP 34162718
GGT 34162719

## PRScsx
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

chr=2
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/time_result/PRScsx/${trait}_EUR_EAS_PRScsx_EAS_pst_eff_a1_b0.5_phiauto_chr${chr}.txt" ]]; then
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
--out_dir=result/summary_result/time_result/PRScsx \
--out_name=${trait}_EUR_EAS_PRScsx
EOT
fi
done

WBC 34162822
NEU 34162823
LYM 34162824
MON 34162825
EOS 34162826
RBC 34162827
HCT 34162828
MCH 34162829
MCV 34162830
HB  34162831
ALT 34162832
ALP 34162833
GGT 34162834
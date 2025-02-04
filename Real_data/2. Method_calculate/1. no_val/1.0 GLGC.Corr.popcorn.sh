## Obtain genetic correlation
## HDL    EUR_EAS:0.99 EUR_AFR:0.93 EUR_SAS:0.99 EUR_AMR:0.95 EAS_AFR:0.71 EAS_SAS:0.99 EAS_AMR:0.85 AFR_SAS:0.99 AFR_AMR:0.96 SAS_AMR:0.99
## LDL    EUR_EAS:0.90 EUR_AFR:0.70 EUR_SAS:0.99 EUR_AMR:0.92 EAS_AFR:0.61 EAS_SAS:0.91 EAS_AMR:0.83 AFR_SAS:0.53 AFR_AMR:0.63 SAS_AMR:0.85
## TC     EUR_EAS:0.99 EUR_AFR:0.74 EUR_SAS:0.99 EUR_AMR:0.92 EAS_AFR:0.60 EAS_SAS:0.99 EAS_AMR:0.82 AFR_SAS:0.58 AFR_AMR:0.67 SAS_AMR:0.86
## logTG  EUR_EAS:0.99 EUR_AFR:0.93 EUR_SAS:0.91 EUR_AMR:0.96 EAS_AFR:0.92 EAS_SAS:0.99 EAS_AMR:0.96 AFR_SAS:0.78 AFR_AMR:0.99 SAS_AMR:0.96

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
pop1=SAS
for trait in HDL LDL TC logTG; do
for pop2 in AMR; do

popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done

pop1=EUR
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR SAS AMR; do

echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done

## precompute the gen eff cscore
module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
pop1=SAS
for pop2 in AMR
do
popcorn compute -v 0 \
--gen_effect \
--bfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop1} \
--bfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/1000g_phase3_data/geno_data/${pop2} \
./ref/${pop1}_${pop2}_all_gen_eff.cscore
done
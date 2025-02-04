## Obtain genetic correlation
## Height EUR_EAS:0.87 EUR_AFR:0.99 EAS_AFR:0.97
## BMI    EUR_EAS:0.84 EUR_AFR:0.99 EAS_AFR:0.92
## PLT    EUR_EAS:0.83 EUR_AFR:0.99 EAS_AFR:0.93
## DBP    EUR_EAS:0.72 EUR_AFR:0.99 EAS_AFR:0.99
## SBP    EUR_EAS:0.68 EUR_AFR:0.99 EAS_AFR:0.99

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
pop1=EUR
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do

popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
for trait in Height BMI SBP DBP PLT; do

popcorn fit -v 0 --cfile ./ref/EAS_AFR_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_EAS_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_AFR_inter_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_EAS_AFR_popcorn_corr.txt

done

pop1=EUR
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS AFR; do

echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done

for trait in Height BMI SBP DBP PLT; do

echo ${trait}:EAS_AFR
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_EAS_AFR_popcorn_corr.txt

done
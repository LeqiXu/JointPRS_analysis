## Obtain genetic correlation
## HDL    EUR_EAS:0.99 EUR_AFR:0.91
## LDL    EUR_EAS:0.90 EUR_AFR:0.68
## TC     EUR_EAS:0.99 EUR_AFR:0.73
## logTG  EUR_EAS:0.99 EUR_AFR:0.91

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
pop1=EUR
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR; do
if [[ "${pop2}" == "EAS" ]]; then
popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt
fi

if [[ "${pop2}" == "AFR" ]]; then
popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_UKB_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_UKB_popcorn_corr.txt
fi
done
done

pop1=EUR
for trait in HDL LDL TC logTG; do
for pop2 in EAS AFR; do
if [[ "${pop2}" == "EAS" ]]; then
echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt
fi

if [[ "${pop2}" == "AFR" ]]; then
echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_UKB_popcorn_corr.txt
fi
done
done
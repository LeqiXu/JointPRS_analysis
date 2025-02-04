## Step0: Copy the correlation estimation for EUR_EAS from no_val as we use the same EAS GWAS
pop1=EUR
for trait in Height BMI SBP DBP PLT; do
for pop2 in EAS; do

cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.e.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.e.log
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.o.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.o.log

done
done

## Step1: Obtain genetic correlation
# we need to reestimate the EUR_AFR correlation

## Height    EUR_AFR:0.99
## BMI       EUR_AFR:0.99
## SBP       EUR_AFR:0.99
## DBP       EUR_AFR:0.99
## PLT       EUR_AFR:0.99

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn

pop1=EUR

for trait in Height BMI SBP DBP PLT; do
for pop2 in AFR; do

if [[ "${pop2}" == "AFR" ]]; then
popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_UKB_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt
fi
done
done

## Step2 show correlation result
pop1=EUR

for trait in Height BMI SBP DBP PLT; do
for pop2 in AFR; do

if [[ "${pop2}" == "AFR" ]]; then
echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/diff_cohort/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt
fi
done
done
## Step0: Copy the correlation estimation for EUR_EAS from no_val as we use the same EAS GWAS
pop1=EUR
for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop2 in EAS; do

cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.e.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt.e.log
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.o.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt.o.log

done
done
done

## Step1: Obtain genetic correlation
# we need to reestimate the EUR_AFR correlation

## s=1
## HDL    EUR_AFR:0.88
## LDL    EUR_AFR:0.70
## TC     EUR_AFR:0.75
## logTG  EUR_AFR:0.90

## s=2
## HDL    EUR_AFR:0.89
## LDL    EUR_AFR:0.71
## TC     EUR_AFR:0.74
## logTG  EUR_AFR:0.90

## s=3
## HDL    EUR_AFR:0.92
## LDL    EUR_AFR:0.71
## TC     EUR_AFR:0.75
## logTG  EUR_AFR:0.92

## s=4
## HDL    EUR_AFR:0.90
## LDL    EUR_AFR:0.70
## TC     EUR_AFR:0.75
## logTG  EUR_AFR:0.89

## s=5
## HDL    EUR_AFR:0.90
## LDL    EUR_AFR:0.71
## TC     EUR_AFR:0.74
## logTG  EUR_AFR:0.90

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn

pop1=EUR

for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop2 in AFR; do

if [[ "${pop2}" == "AFR" ]]; then
popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_UKB_val_${s}_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt
fi
done
done
done

## Step2 show correlation result
pop1=EUR

for s in {1..5}; do
for trait in HDL LDL TC logTG; do
for pop2 in AFR; do

if [[ "${pop2}" == "AFR" ]]; then
echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt
fi
done
done
done
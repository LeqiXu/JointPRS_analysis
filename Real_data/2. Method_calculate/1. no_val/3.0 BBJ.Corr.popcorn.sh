## Obtain genetic correlation
## WBC    EUR_EAS:0.77
## NEU    EUR_EAS:0.80
## LYM    EUR_EAS:0.78
## MON    EUR_EAS:0.80
## EOS    EUR_EAS:0.86
## RBC    EUR_EAS:0.92
## HCT    EUR_EAS:0.85
## MCH    EUR_EAS:0.87
## MCV    EUR_EAS:0.89
## HB     EUR_EAS:0.84
## ALT    EUR_EAS:0.69
## ALP    EUR_EAS:0.52
## GGT    EUR_EAS:0.79

module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn
pop1=EUR
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS AFR; do

popcorn fit -v 0 --cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop1}_inter_popcorn.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/popcorn/${trait}_${pop2}_inter_popcorn.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done

pop1=EUR
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS AFR; do

echo ${trait}:EUR_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt

done
done
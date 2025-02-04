## Step0: Copy the correlation estimation for EUR_EAS from no_val as we use the same EAS GWAS
pop1=EUR
for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop2 in EAS; do

cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.e.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt.e.log
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/no_val/popcorn/${trait}_${pop1}_${pop2}_popcorn_corr.txt.o.log /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/popcorn/${trait}_${pop1}_${pop2}_val_${s}_popcorn_corr.txt.o.log

done
done
done
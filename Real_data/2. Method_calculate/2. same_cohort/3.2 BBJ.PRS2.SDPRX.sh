# SDPRX:
# Step0: Copy the beta estimation for EAS from no_val as we use the same EAS GWAS
for s in {1..5}; do
for trait in WBC NEU LYM MON EOS RBC HCT MCH MCV HB ALT ALP GGT; do
for pop in EAS; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/SDPRX/${trait}_SDPRX_EUR_${pop}_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/SDPRX/${trait}_SDPRX_val_${s}_EUR_${pop}_beta_${pop}.txt
done
done
done
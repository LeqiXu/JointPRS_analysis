# XPASS:
# Step0: Copy the beta estimation for EAS and AFR from no_val as we use the same EAS AFR GWAS
for s in {1..5}; do
for trait in T2D BrC; do
for pop in EAS AFR; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/${trait}_XPASS_EUR_${pop}_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_val_${s}_EUR_${pop}_beta_${pop}.txt
done
done
done

for s in {1..5}; do
for trait in CAD LuC; do
for pop in EAS; do
cp /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/no_val/XPASS/${trait}_XPASS_EUR_${pop}_beta_${pop}.txt /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_val_${s}_EUR_${pop}_beta_${pop}.txt
done
done
done
## Tuning method weight
############### PRScsx ###############
# GWAS without UKB and use UKB as validation
trait= #HDL LDL TC logTG
pop= #EAS AFR SAS AMR
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/PRScsx/${trait}_PRScsx_EUR_${pop}_beta_${pop}.txt
weight_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/PRScsx/${trait}_PRScsx_EUR_${pop}_weight_${pop}.txt
### here each score column calcualted from beta_file needs to be scaled and then we apply the weight to obtain the final PRS score

############### PROSPER ###############
# GWAS without UKB and use UKB as validation
trait= #HDL LDL TC logTG
pop= #EAS AFR SAS AMR
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/PROSPER/${trait}_PROSPER_EUR_${pop}_beta_${pop}.txt

############### MUSSEL ###############
# GWAS without UKB and use UKB as validation
trait= #HDL LDL TC logTG
pop= #EAS AFR SAS AMR
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/MUSSEL/${trait}_MUSSEL_EUR_${pop}_beta_${pop}.txt

############### BridgePRS ###############
# GWAS without UKB and use UKB as validation
trait= #HDL LDL TC logTG
pop= #EAS AFR SAS AMR
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/BridgePRS/${trait}_BridgePRS_EUR_${pop}_beta_${pop}.txt


## 2. Auto methods weight
############### JointPRS ###############
# GWAS with UKB
trait= #HDL LDL TC logTG
pop= #AFR SAS
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/JointPRS/${trait}_JointPRS_EUR_${pop}_beta_${pop}.txt

############### SDPRX ###############
# GWAS with UKB
trait= #HDL LDL TC logTG
pop= #AFR
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/SDPRX/${trait}_SDPRX_EUR_${pop}_beta_${pop}.txt

############### XPASS ###############
# GWAS with UKB
trait= #HDL LDL TC logTG
pop= #AFR SAS
beta_file=/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/diff_cohort/XPASS/${trait}_XPASS_EUR_${pop}_beta_${pop}.txt
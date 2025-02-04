## 1. SDPRX
pop1=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX/UKB_${trait}_SDPRX_test_EUR_bestpop_prs_EUR.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_bestpop_SDPRX_test
#SBATCH --output=out_PRS_${trait}_EUR_bestpop_SDPRX_test.txt

module load PLINK/2

# SDPRX
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/SDPRX

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/SDPRX/${trait}_SDPRX_EUR_bestpop_beta_EUR_10K.txt \
--out UKB_${trait}_SDPRX_test_EUR_bestpop_prs_EUR
EOT
fi
done

## 2. XPASS
pop1=EUR

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS/UKB_${trait}_XPASS_test_EUR_bestpop_prs_EUR.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_bestpop_XPASS_test
#SBATCH --output=out_PRS_${trait}_EUR_bestpop_XPASS_test.txt

module load PLINK/2

# XPASS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/XPASS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/XPASS/${trait}_XPASS_EUR_bestpop_beta_EUR_10K.txt \
--out UKB_${trait}_XPASS_test_EUR_bestpop_prs_EUR
EOT
fi
done

## 3. BridgePRS
pop1=EUR
pop2=SAS

for trait in HDL LDL TC logTG; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS/UKB_${trait}_BridgePRS_test_EUR_${pop2}_prs_EUR.sscore" ]]; then 
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${trait}_EUR_${pop2}_BridgePRS_test
#SBATCH --output=out_PRS_${trait}_EUR_${pop2}_BridgePRS_test.txt

module load PLINK/2

# BridgePRS
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/same_cohort/BridgePRS

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/geno_data/EUR \
--double-id \
--threads 1 \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/data/snplist_data/EUR_inter_snplist_ukbb.txt \
--score /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/summary_result/Final_weight/same_cohort/BridgePRS/${trait}_BridgePRS_EUR_${pop2}_beta_EUR_10K.txt \
--out UKB_${trait}_BridgePRS_test_EUR_${pop2}_prs_EUR
EOT
fi
done

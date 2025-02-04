## Step1 run metal
# Describe and process the GWAS input files
## Height AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/Height_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/diff_cohort/Height_AFR_UKB.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/diff_cohort/Height_AFR_inter_UKB_meta .tbl
ANALYZE
QUIT

## BMI AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/BMI_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/diff_cohort/BMI_AFR_UKB.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/diff_cohort/BMI_AFR_inter_UKB_meta .tbl
ANALYZE
QUIT

## SBP AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/SBP_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/diff_cohort/SBP_AFR_UKB.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/diff_cohort/SBP_AFR_inter_UKB_meta .tbl
ANALYZE
QUIT

## DBP AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/DBP_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/diff_cohort/DBP_AFR_UKB.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/diff_cohort/DBP_AFR_inter_UKB_meta .tbl
ANALYZE
QUIT

## PLT AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/PLT_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/diff_cohort/PLT_AFR_UKB.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/diff_cohort/PLT_AFR_inter_UKB_meta .tbl
ANALYZE
QUIT
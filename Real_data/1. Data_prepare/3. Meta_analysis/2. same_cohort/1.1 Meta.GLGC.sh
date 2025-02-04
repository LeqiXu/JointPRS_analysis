## Step1 run metal
# Describe and process the GWAS input files
## HDL AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_AFR_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_AFR_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_AFR_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_AFR_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_AFR_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_AFR_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_AFR_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_AFR_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_AFR_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_AFR_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## HDL SAS
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_SAS_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_SAS_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_SAS_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_SAS_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_SAS_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_SAS_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_SAS_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_SAS_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/HDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/HDL_SAS_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/HDL_SAS_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## LDL AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_AFR_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_AFR_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_AFR_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_AFR_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_AFR_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_AFR_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_AFR_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_AFR_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_AFR_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_AFR_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## LDL SAS
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_SAS_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_SAS_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_SAS_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_SAS_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_SAS_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_SAS_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_SAS_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_SAS_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/LDL_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/LDL_SAS_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/LDL_SAS_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## TC AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_AFR_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_AFR_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_AFR_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_AFR_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_AFR_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_AFR_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_AFR_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_AFR_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_AFR_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_AFR_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## TC SAS
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_SAS_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_SAS_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_SAS_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_SAS_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_SAS_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_SAS_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_SAS_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_SAS_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/TC_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/TC_SAS_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/TC_SAS_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## logTG AFR
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_AFR_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_AFR_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_AFR_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_AFR_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_AFR_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_AFR_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_AFR_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_AFR_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_AFR_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_AFR_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_AFR_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT

## logTG SAS
/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_SAS_UKB_val_1.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_SAS_inter_UKB_val_1_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_SAS_UKB_val_2.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_SAS_inter_UKB_val_2_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_SAS_UKB_val_3.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_SAS_inter_UKB_val_3_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_SAS_UKB_val_4.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_SAS_inter_UKB_val_4_meta .tbl
ANALYZE
QUIT

/gpfs/gibbs/pi/zhao/lx94/Software/generic-metal/metal
SCHEME   STDERR
MARKER   SNP
WEIGHT   N
ALLELE   A1 A2
FREQ     MAF
EFFECT   BETA
STDERR   SE
PVAL     P

PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/clean/logTG_SAS_inter_clean.txt
PROCESS /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/UKB_glm/same_cohort/logTG_SAS_UKB_val_5.txt
OUTFILE /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/summary_data/with_UKB_meta/same_cohort/logTG_SAS_inter_UKB_val_5_meta .tbl
ANALYZE
QUIT


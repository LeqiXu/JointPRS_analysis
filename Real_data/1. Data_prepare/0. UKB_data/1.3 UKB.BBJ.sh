# 1 Obtain basic phenotype from ukbb
## phnotypes
library(data.table)
library(stringr)

## remove id
remove_id = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/w29900_2023-04-25.csv")

## field1
field1 = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/10570/fields.ukb")
field1_data = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/10570/ukb671493.tab",header=T,quote='\t')

## field2
field2 = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/2008682/ukb42584.fields")
field2_data = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/2008682/ukb42584.tab",header=T,quote='\t')

## field
field = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/10570/fields.ukb")
field_data = fread("/gpfs/gibbs/pi/zhao/cz354/zhao-data/cz354/UKB/10570/ukb671493.tab",header=T,quote='\t')

med_male_code = "6177"
med_male_code_s = "f.6177.0.0"
med_female_code = "6153"
med_female_code_s = "f.6153.0.0"
field_name = c("f.eid",med_male_code_s,med_female_code_s)
med_data = field_data[,..field_name]
med_data$med = ifelse(is.na(med_data$f.6177.0.0),med_data$f.6153.0.0,med_data$f.6177.0.0)
med_data = med_data[,c("f.eid","med")]
colnames(med_data) = c("eid","med")
med_data = na.omit(med_data)

bpm_eid = med_data$eid[which(med_data$med %in% c("2"))]
no_bpm_eid = med_data$eid[which(med_data$med %in% c("1","3","4","5","-7"))]

## field2
## White blood cell (WBC) 30000
WBC_code = "30000"
WBC_code_s = "f.30000.0.0"
WBC_field_name = c("f.eid",WBC_code_s)

ukbb_WBC = field2_data[,..WBC_field_name]
colnames(ukbb_WBC) = c("eid","WBC")
ukbb_WBC$WBC = as.numeric(ukbb_WBC$WBC)
ukbb_WBC = ukbb_WBC[which(!(ukbb_WBC$eid %in% remove_id $V1)),]
ukbb_WBC = na.omit(ukbb_WBC)
write.table(ukbb_WBC, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/WBC/ukbb_WBC.tsv", row.names=F, col.names=T, quote = F)

## Neutrophil (NEU) 30140
NEU_code = "30140"
NEU_code_s = "f.30140.0.0"
NEU_field_name = c("f.eid",NEU_code_s)

ukbb_NEU = field2_data[,..NEU_field_name]
colnames(ukbb_NEU) = c("eid","NEU")
ukbb_NEU$NEU = as.numeric(ukbb_NEU$NEU)
ukbb_NEU = ukbb_NEU[which(!(ukbb_NEU$eid %in% remove_id $V1)),]
ukbb_NEU = na.omit(ukbb_NEU)
write.table(ukbb_NEU, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/NEU/ukbb_NEU.tsv", row.names=F, col.names=T, quote = F)

## Lymphocyte (LYM) 30120
LYM_code = "30120"
LYM_code_s = "f.30120.0.0"
LYM_field_name = c("f.eid",LYM_code_s)

ukbb_LYM = field2_data[,..LYM_field_name]
colnames(ukbb_LYM) = c("eid","LYM")
ukbb_LYM$LYM = as.numeric(ukbb_LYM$LYM)
ukbb_LYM = ukbb_LYM[which(!(ukbb_LYM$eid %in% remove_id $V1)),]
ukbb_LYM = na.omit(ukbb_LYM)
write.table(ukbb_LYM, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/LYM/ukbb_LYM.tsv", row.names=F, col.names=T, quote = F)

## Monocyte (MON) 30130
MON_code = "30130"
MON_code_s = "f.30130.0.0"
MON_field_name = c("f.eid",MON_code_s)

ukbb_MON = field2_data[,..MON_field_name]
colnames(ukbb_MON) = c("eid","MON")
ukbb_MON$MON = as.numeric(ukbb_MON$MON)
ukbb_MON = ukbb_MON[which(!(ukbb_MON$eid %in% remove_id $V1)),]
ukbb_MON = na.omit(ukbb_MON)
write.table(ukbb_MON, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/MON/ukbb_MON.tsv", row.names=F, col.names=T, quote = F)

## Eosinophil (EOS) 30150
EOS_code = "30150"
EOS_code_s = "f.30150.0.0"
EOS_field_name = c("f.eid",EOS_code_s)

ukbb_EOS = field2_data[,..EOS_field_name]
colnames(ukbb_EOS) = c("eid","EOS")
ukbb_EOS$EOS = as.numeric(ukbb_EOS$EOS)
ukbb_EOS = ukbb_EOS[which(!(ukbb_EOS$eid %in% remove_id $V1)),]
ukbb_EOS = na.omit(ukbb_EOS)
write.table(ukbb_EOS, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/EOS/ukbb_EOS.tsv", row.names=F, col.names=T, quote = F)

## Red blood cell (RBC) 30010
RBC_code = "30010"
RBC_code_s = "f.30010.0.0"
RBC_field_name = c("f.eid",RBC_code_s)

ukbb_RBC = field2_data[,..RBC_field_name]
colnames(ukbb_RBC) = c("eid","RBC")
ukbb_RBC$RBC = as.numeric(ukbb_RBC$RBC)
ukbb_RBC = ukbb_RBC[which(!(ukbb_RBC$eid %in% remove_id $V1)),]
ukbb_RBC = na.omit(ukbb_RBC)
write.table(ukbb_RBC, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/RBC/ukbb_RBC.tsv", row.names=F, col.names=T, quote = F)

## Hematocrit (HCT) 30030
HCT_code = "30030"
HCT_code_s = "f.30030.0.0"
HCT_field_name = c("f.eid",HCT_code_s)

ukbb_HCT = field2_data[,..HCT_field_name]
colnames(ukbb_HCT) = c("eid","HCT")
ukbb_HCT$HCT = as.numeric(ukbb_HCT$HCT)
ukbb_HCT = ukbb_HCT[which(!(ukbb_HCT$eid %in% remove_id $V1)),]
ukbb_HCT = na.omit(ukbb_HCT)
write.table(ukbb_HCT, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/HCT/ukbb_HCT.tsv", row.names=F, col.names=T, quote = F)

## Mean corpuscular hemoglobin (MCH) 30050
MCH_code = "30050"
MCH_code_s = "f.30050.0.0"
MCH_field_name = c("f.eid",MCH_code_s)

ukbb_MCH = field2_data[,..MCH_field_name]
colnames(ukbb_MCH) = c("eid","MCH")
ukbb_MCH$MCH = as.numeric(ukbb_MCH$MCH)
ukbb_MCH = ukbb_MCH[which(!(ukbb_MCH$eid %in% remove_id $V1)),]
ukbb_MCH = na.omit(ukbb_MCH)
write.table(ukbb_MCH, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/MCH/ukbb_MCH.tsv", row.names=F, col.names=T, quote = F)

## Mean corpuscular volume (MCV) 30040
MCV_code = "30040"
MCV_code_s = "f.30040.0.0"
MCV_field_name = c("f.eid",MCV_code_s)

ukbb_MCV = field2_data[,..MCV_field_name]
colnames(ukbb_MCV) = c("eid","MCV")
ukbb_MCV$MCV = as.numeric(ukbb_MCV$MCV)
ukbb_MCV = ukbb_MCV[which(!(ukbb_MCV$eid %in% remove_id $V1)),]
ukbb_MCV = na.omit(ukbb_MCV)
write.table(ukbb_MCV, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/MCV/ukbb_MCV.tsv", row.names=F, col.names=T, quote = F)

## Hemoglobin (HB) 30020
HB_code = "30020"
HB_code_s = "f.30020.0.0"
HB_field_name = c("f.eid",HB_code_s)

ukbb_HB = field2_data[,..HB_field_name]
colnames(ukbb_HB) = c("eid","HB")
ukbb_HB$HB = as.numeric(ukbb_HB$HB)
ukbb_HB = ukbb_HB[which(!(ukbb_HB$eid %in% remove_id $V1)),]
ukbb_HB = na.omit(ukbb_HB)
write.table(ukbb_HB, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/HB/ukbb_HB.tsv", row.names=F, col.names=T, quote = F)

## Alanine aminotransferase (ALT) 30620
ALT_code = "30620"
ALT_code_s = "f.30620.0.0"
ALT_field_name = c("f.eid",ALT_code_s)

ukbb_ALT = field2_data[,..ALT_field_name]
colnames(ukbb_ALT) = c("eid","ALT")
ukbb_ALT$ALT = as.numeric(ukbb_ALT$ALT)
ukbb_ALT = ukbb_ALT[which(!(ukbb_ALT$eid %in% remove_id $V1)),]
ukbb_ALT = na.omit(ukbb_ALT)
write.table(ukbb_ALT, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/ALT/ukbb_ALT.tsv", row.names=F, col.names=T, quote = F)

## Alkaline phosphatase (ALP) 30610
ALP_code = "30610"
ALP_code_s = "f.30610.0.0"
ALP_field_name = c("f.eid",ALP_code_s)

ukbb_ALP = field2_data[,..ALP_field_name]
colnames(ukbb_ALP) = c("eid","ALP")
ukbb_ALP$ALP = as.numeric(ukbb_ALP$ALP)
ukbb_ALP = ukbb_ALP[which(!(ukbb_ALP$eid %in% remove_id $V1)),]
ukbb_ALP = na.omit(ukbb_ALP)
write.table(ukbb_ALP, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/ALP/ukbb_ALP.tsv", row.names=F, col.names=T, quote = F)

## γ-glutamyl transpeptidase (GGT) 30730
GGT_code = "30730"
GGT_code_s = "f.30730.0.0"
GGT_field_name = c("f.eid",GGT_code_s)

ukbb_GGT = field2_data[,..GGT_field_name]
colnames(ukbb_GGT) = c("eid","GGT")
ukbb_GGT$GGT = as.numeric(ukbb_GGT$GGT)
ukbb_GGT = ukbb_GGT[which(!(ukbb_GGT$eid %in% remove_id $V1)),]
ukbb_GGT = na.omit(ukbb_GGT)
write.table(ukbb_GGT, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/GGT/ukbb_GGT.tsv", row.names=F, col.names=T, quote = F)
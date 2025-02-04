# 1 Obtain basic phenotype from ukbb
## obtain each phenotype
library(data.table)
library(stringr)

## remove id
remove_id = fread("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/w29900_2023-04-25.csv")

## phenotype
## Height
Height_data = fread("/gpfs/gibbs/pi/zhao/cz354/UKB/pheno/new/height.txt")
Height_data = Height_data[which(!(Height_data$IID %in% remove_id $V1)),]
ukbb_Height = Height_data[,c("IID","height")]
colnames(ukbb_Height) = c("eid","Height")
ukbb_Height = na.omit(ukbb_Height)
write.table(ukbb_Height, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/Height/ukbb_Height.tsv", row.names=F, col.names=T, quote = F)

## BMI
BMI_data = fread("/gpfs/gibbs/pi/zhao/cz354/UKB/pheno/new/BMI.txt")
BMI_data = BMI_data[which(!(BMI_data$eid %in% remove_id $V1)),]
ukbb_BMI = BMI_data[,c("eid","BMI")]
ukbb_BMI = na.omit(ukbb_BMI)
write.table(ukbb_BMI, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/BMI/ukbb_BMI.tsv", row.names=F, col.names=T, quote = F)

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

## field1
## Systolic blood pressure (SBP) 93 & 4080
SBP_code = c("93","4080")
SBP_code_s = c("f.93.0.0","f.4080.0.0")
SBP_field_name = c("f.eid",SBP_code_s)
ukbb_SBP = field1_data[,..SBP_field_name]
colnames(ukbb_SBP) = c("eid","SBP1","SBP2")
ukbb_SBP$SBP1 = as.numeric(ukbb_SBP$SBP1)
ukbb_SBP$SBP2 = as.numeric(ukbb_SBP$SBP2)
ukbb_SBP$SBP = rowMeans(ukbb_SBP[,c(2,3)],na.rm=TRUE)
ukbb_SBP = ukbb_SBP[which(!(ukbb_SBP$eid %in% remove_id$V1)),c("eid","SBP")]
ukbb_SBP = na.omit(ukbb_SBP)

ukbb_SBP = ukbb_SBP[which(ukbb_SBP$eid %in% c(bpm_eid,no_bpm_eid)),]
ukbb_SBP$SBP[which(ukbb_SBP$eid %in% bpm_eid)] = ukbb_SBP$SBP[which(ukbb_SBP$eid %in% bpm_eid)] + 15
write.table(ukbb_SBP, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/SBP/ukbb_SBP.tsv", row.names=F, col.names=T, quote = F)

## Diastolic blood pressure (DBP) 94 & 4079
DBP_code = c("94","4079")
DBP_code_s = c("f.94.0.0","f.4079.0.0")
DBP_field_name = c("f.eid",DBP_code_s)
ukbb_DBP = field1_data[,..DBP_field_name]
colnames(ukbb_DBP) = c("eid","DBP1","DBP2")
ukbb_DBP$DBP1 = as.numeric(ukbb_DBP$DBP1)
ukbb_DBP$DBP2 = as.numeric(ukbb_DBP$DBP2)
ukbb_DBP$DBP = rowMeans(ukbb_DBP[,c(2,3)],na.rm=TRUE)
ukbb_DBP = ukbb_DBP[which(!(ukbb_DBP$eid %in% remove_id$V1)),c("eid","DBP")]
ukbb_DBP = na.omit(ukbb_DBP)

ukbb_DBP = ukbb_DBP[which(ukbb_DBP$eid %in% c(bpm_eid,no_bpm_eid)),]
ukbb_DBP$DBP[which(ukbb_DBP$eid %in% bpm_eid)] = ukbb_DBP$DBP[which(ukbb_DBP$eid %in% bpm_eid)] + 10
write.table(ukbb_DBP, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/DBP/ukbb_DBP.tsv", row.names=F, col.names=T, quote = F)

## field2
## Platelet count (PLT) 30080
PLT_code = "30080"
PLT_code_s = "f.30080.0.0"
PLT_field_name = c("f.eid",PLT_code_s)

ukbb_PLT = field2_data[,..PLT_field_name]
colnames(ukbb_PLT) = c("eid","PLT")
ukbb_PLT$PLT = as.numeric(ukbb_PLT$PLT)
ukbb_PLT = ukbb_PLT[which(!(ukbb_PLT$eid %in% remove_id $V1)),]
ukbb_PLT = na.omit(ukbb_PLT)
write.table(ukbb_PLT, "/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/PLT/ukbb_PLT.tsv", row.names=F, col.names=T, quote = F)
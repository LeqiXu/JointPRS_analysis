## 1.Assign population for traits
### continuous traits
## HDL    EUR:271876 SAS:6784 AFR:5927 EAS:1812 AMR:561
## LDL    EUR:294412 SAS:7062 AFR:6171 EAS:1911 AMR:583
## TC     EUR:294966 SAS:7080 AFR:6183 EAS:1912 AMR:583
## logTG  EUR:296706 SAS:7444 AFR:6400 EAS:1993 AMR:607

## Height EUR:310797 SAS:7679 AFR:6574 EAS:2080 AMR:625
## BMI    EUR:310455 SAS:7668 AFR:6713 EAS:2077 AMR:623
## SBP    EUR:308802 SAS:7437 AFR:6688 EAS:2001 AMR:607
## DBP    EUR:308808 SAS:7437 AFR:6574 EAS:2001 AMR:607
## PLT    EUR:302170 SAS:7536 AFR:6445 EAS:2027 AMR:616

## WBC    EUR:302166 SAS:7536 AFR:6445 EAS:2027 AMR:616
## NEU    EUR:301618 SAS:7510 AFR:6425 EAS:2025 AMR:615
## LYM    EUR:301618 SAS:7510 AFR:6425 EAS:2025 AMR:615
## MON    EUR:301618 SAS:7510 AFR:6425 EAS:2025 AMR:615
## EOS    EUR:301618 SAS:7510 AFR:6425 EAS:2025 AMR:615
## RBC    EUR:302170 SAS:7536 AFR:6445 EAS:2027 AMR:616
## HCT    EUR:302170 SAS:7536 AFR:6445 EAS:2027 AMR:616
## MCH    EUR:302167 SAS:7536 AFR:6445 EAS:2027 AMR:616
## MCV    EUR:302170 SAS:7536 AFR:6445 EAS:2027 AMR:616
## HB     EUR:302170 SAS:7536 AFR:6445 EAS:2027 AMR:616
## ALT    EUR:296840 SAS:7438 AFR:6404 EAS:1993 AMR:606
## ALP    EUR:296959 SAS:7452 AFR:6406 EAS:1994 AMR:607
## GGT    EUR:296796 SAS:7453 AFR:6400 EAS:1991 AMR:607

library(data.table)

ancestry_list = c("EUR","SAS","AFR","EAS","AMR")

pop_data = lapply(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/",ancestry_list,"_id.tsv"),fread)
trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

for (t in 1:length(trait_list)){
trait = trait_list[t]
print(trait)
pheno_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/ukbb_",trait,".tsv"))

for(i in 1:length(ancestry_list)){
    pheno_pop_data = pheno_data[which(pheno_data$eid %in% pop_data[[i]]$FID),]
    pheno_pop_doubleid_data = pheno_pop_data
    pheno_pop_doubleid_data$FID = pheno_pop_data$eid
    pheno_pop_doubleid_data$IID = pheno_pop_data$eid
    pheno_pop_doubleid_data = pheno_pop_doubleid_data[,c(3,4,2)]

    pheno_pop_id = data.table(FID = pheno_pop_data$eid, IID = pheno_pop_data$eid)
    print(paste0(ancestry_list[i]," sample size: ",nrow(pheno_pop_id)))

    write.table(pheno_pop_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],".tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pheno_pop_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pheno_pop_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
    write.table(pheno_pop_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

    pheno_pop_scale_doubleid_data = pheno_pop_doubleid_data
    pheno_pop_scale_doubleid_data[,c(3)] = scale(pheno_pop_scale_doubleid_data[,c(3)])
    colnames(pheno_pop_scale_doubleid_data) = c("FID","IID",trait)
    write.table(pheno_pop_scale_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",ancestry_list[i],"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
    write.table(pheno_pop_scale_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",ancestry_list[i],"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

}
}

### binary traits
## T2D    
## EUR:cases: 25309 controls: 286197 
## SAS:cases: 2192 controls: 5663 
## AFR:cases: 1292 controls: 5535 
## EAS:cases: 203 controls: 1887 
## AMR:cases: 48 controls: 585
## BrC
## EUR: cases: 13973 controls: 297533
## SAS: cases: 209 controls: 7646
## AFR: cases: 173 controls: 6654
## EAS: cases: 89 controls: 2001
## AMR: cases: 16 controls: 617
## CAD
## EUR: cases: 23271 controls: 288235
## SAS: cases: 1030 controls: 6825
## AFR: cases: 259 controls: 6568
## EAS: cases: 56 controls: 2034
## AMR: cases: 22 controls: 611
## LuC
## EUR: cases: 4107 controls: 307399
## SAS: cases: 42 controls: 7813
## AFR: cases: 52 controls: 6775
## EAS: cases: 21 controls: 2069
## AMR: cases: 5 controls: 628

library(data.table)

ancestry_list = c("EUR","SAS","AFR","EAS","AMR")

pop_data = lapply(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/ancestry_info/",ancestry_list,"_id.tsv"),fread)
trait_list = c("T2D","CAD","LuC","BrC")

for (t in 1:length(trait_list)){
trait = trait_list[t]
print(trait)
pheno_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/ukbb_",trait,".tsv"))

for(i in 1:length(ancestry_list)){
    pheno_pop_data = pheno_data[which(pheno_data$eid %in% pop_data[[i]]$FID),]
    pheno_pop_doubleid_data = pheno_pop_data
    pheno_pop_doubleid_data$FID = pheno_pop_data$eid
    pheno_pop_doubleid_data$IID = pheno_pop_data$eid
    pheno_pop_doubleid_data = pheno_pop_doubleid_data[,c(3,4,2)]

    pheno_pop_id = data.table(FID = pheno_pop_data$eid, IID = pheno_pop_data$eid)
    print(paste0(ancestry_list[i], " ",trait,": cases: ", nrow(pheno_pop_data[which(unlist(pheno_pop_data[,2]) == 1),])," controls: ",nrow(pheno_pop_data[which(unlist(pheno_pop_data[,2]) == 0),])))

    write.table(pheno_pop_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],".tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pheno_pop_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
    write.table(pheno_pop_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
    write.table(pheno_pop_doubleid_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

}
}

## 2. five folds cross-validation data splits for minor population
### continuous trait
library(data.table)
library(caret)

set.seed(123)

cv=5

ancestry_list = c("EAS","AFR","SAS","AMR")
trait_list = c("HDL","LDL","TC","logTG","Height","BMI","SBP","DBP","PLT","WBC","NEU","LYM","MON","EOS","RBC","HB","HCT","MCH","MCV","ALT","ALP","GGT")

for (t in 1:length(trait_list)){
trait = trait_list[t]
print(trait)

for(i in 1:length(ancestry_list)){

pheno_pop_id = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_id.tsv"))
pheno_pop_doubleid_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleidname.tsv"))
pheno_pop_scale_doubleid_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_scale_",ancestry_list[i],"_doubleidname.tsv"))

folds = createFolds(pheno_pop_id$FID, k = cv, list = TRUE, returnTrain = TRUE)

for (s in 1:cv){
val_row = folds[[s]] 
pheno_pop_val_id = pheno_pop_id[val_row,]
pheno_pop_test_id = pheno_pop_id[-val_row,]

pheno_pop_doubleid_val_data = pheno_pop_doubleid_data[val_row,]
pheno_pop_doubleid_test_data = pheno_pop_doubleid_data[-val_row,]
colnames(pheno_pop_doubleid_val_data) = c("FID","IID",trait)
colnames(pheno_pop_doubleid_test_data) = c("FID","IID",trait)

pheno_pop_scale_doubleid_val_data = pheno_pop_scale_doubleid_data[val_row,]
pheno_pop_scale_doubleid_test_data = pheno_pop_scale_doubleid_data[-val_row,]
pheno_pop_scale_doubleid_val_data[,c(3)] = scale(pheno_pop_scale_doubleid_val_data[,c(3)])
pheno_pop_scale_doubleid_test_data[,c(3)] = scale(pheno_pop_scale_doubleid_test_data[,c(3)])
colnames(pheno_pop_scale_doubleid_val_data) = c("FID","IID",trait)
colnames(pheno_pop_scale_doubleid_test_data) = c("FID","IID",trait)

write.table(pheno_pop_val_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(pheno_pop_test_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

write.table(pheno_pop_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

write.table(pheno_pop_scale_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",ancestry_list[i],"_val_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_scale_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",ancestry_list[i],"_val_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(pheno_pop_scale_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",ancestry_list[i],"_test_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_scale_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_scale_",ancestry_list[i],"_test_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

}
}
}

### binary trait
library(data.table)
library(caret)

set.seed(123)

cv=5

ancestry_list = c("EAS","AFR","SAS","AMR")
trait_list = c("T2D","CAD","LuC","BrC")

for (t in 1:length(trait_list)){
trait = trait_list[t]
print(trait)

for(i in 1:length(ancestry_list)){

pheno_pop_id = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_id.tsv"))
pheno_pop_doubleid_data = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/",trait,"_",ancestry_list[i],"_doubleidname.tsv"))

folds = createFolds(pheno_pop_id$FID, k = cv, list = TRUE, returnTrain = TRUE)

for (s in 1:cv){
val_row = folds[[s]] 
pheno_pop_val_id = pheno_pop_id[val_row,]
pheno_pop_test_id = pheno_pop_id[-val_row,]

pheno_pop_doubleid_val_data = pheno_pop_doubleid_data[val_row,]
pheno_pop_doubleid_test_data = pheno_pop_doubleid_data[-val_row,]
colnames(pheno_pop_doubleid_val_data) = c("FID","IID",trait)
colnames(pheno_pop_doubleid_test_data) = c("FID","IID",trait)

write.table(pheno_pop_val_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(pheno_pop_test_id, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_id.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

write.table(pheno_pop_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_val_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_val_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_doubleid.tsv"), row.names=F, col.names=F, quote = F, sep = "\t")
write.table(pheno_pop_doubleid_test_data, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ukbb_data/pheno_data/",trait,"/split/",trait,"_",ancestry_list[i],"_test_",s,"_doubleidname.tsv"), row.names=F, col.names=T, quote = F, sep = "\t")

}
}
}
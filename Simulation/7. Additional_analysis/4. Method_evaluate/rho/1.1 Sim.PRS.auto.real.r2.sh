## 1. Auto with no validation dataset PRS situation
## fivepops
library(data.table)

rep_num = 5

rho_list = c(0,0.2,0.4,0.6,0.8) 
p_list = c(0.1)

sample1 = "UKB"
sample2_list = c("80K")

pop_list = c("EUR","EAS","AFR","SAS","AMR")
prs_table = list()

for(pop in c("EUR","EAS","AFR","SAS","AMR")){

prs_table[[pop]] = data.table(n = rep(rep(c(1:rep_num),each=length(sample2_list)), length(p_list)*length(rho_list)), 
                                     pop = rep(pop,rep_num * length(p_list)*length(rho_list)*length(sample2_list)), 
                                     p = rep(p_list,each = rep_num*length(rho_list)*length(sample2_list)),
                                     rho = rep(rep(rho_list, each = rep_num), length(p_list)*length(sample2_list)),
                                     sample2 = rep(sample2_list,rep_num*length(p_list)*length(rho_list)),
                                     JointPRS_auto_5 = rep(0,rep_num * length(p_list)*length(rho_list)*length(sample2_list)),
                                     PRScsx_auto_5 = rep(0,rep_num * length(p_list)*length(rho_list)*length(sample2_list)))

for (i in c(1:rep_num)){
for (p in p_list){
for (rho in rho_list){
for (sample2 in sample2_list){

    idx = which(prs_table[[pop]]$n == i & prs_table[[pop]]$pop == pop & prs_table[[pop]]$p == p & prs_table[[pop]]$rho == rho & prs_table[[pop]]$sample2 == sample2)

    ## test pheno
    test_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/test/",pop,"_sim",i,"_p",p,"_rho",rho,"_10K_doubleidname.tsv"))
    test_pheno_id = test_pheno$IID

    # JointPRS_5
    test_JointPRS_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS/sim",i,"_p",p,"_rho",rho,"/test_sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_JointPRS_5 = test_JointPRS_5[match(test_pheno_id,test_JointPRS_5$IID),]

    # PRScsx_5
    test_PRScsx_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim",i,"_p",p,"_rho",rho,"/test_sim",i,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_PRScsx_auto_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_PRScsx_5 = test_PRScsx_5[match(test_pheno_id,test_PRScsx_5$IID),]

    test_data = data.table(pheno = scale(test_pheno$pheno),
                           JointPRS_auto_5 = scale(test_JointPRS_5$SCORE1_AVG), 
                           PRScsx_auto_5 = scale(test_PRScsx_5$SCORE1_AVG))
                           
    colnames(test_data) = c("pheno","JointPRS_auto_5","PRScsx_auto_5")
    for (j in c(2,3)){
        data = data.table(status = test_data$pheno)
        data$prs <- unlist(test_data[,..j])
        linear = lm(status ~ prs, data=data)
        prs_table[[pop]][idx,j+4] = summary(linear)$`r.squared`
    }

    }

}
}
}
}

prs_table_auto = rbind(prs_table[["EUR"]],prs_table[["EAS"]],prs_table[["AFR"]],prs_table[["SAS"]],prs_table[["AMR"]])
print(prs_table_auto)

write.table(prs_table_auto,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/sim_PRS_real_auto_no_val_multi_rho_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
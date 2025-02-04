## 1. Tuning PRS methods test and compare
## fivepops
library(data.table)

rep_num = 5

h2=0.1
rho=0.8 
p=0.1

sample1 = "UKB"
sample2 = "80K"
val_sample = "10K"

pop = c("EUR","EAS","AFR","SAS","AMR")
prs_table = list()

for(pop in c("EAS","AFR","SAS","AMR")){

prs_table[[pop]] = data.table(n = c(1:rep_num), pop = rep(pop,rep_num), 
                              p = rep(p,rep_num), rho = rep(rho, rep_num), 
                              sample2 = rep(sample2,rep_num), val_sample = rep(val_sample,rep_num),
                              choose_JointPRS_tune_5 = rep("Unkown",rep_num),
                              JointPRS_tune_5 = rep(0,rep_num),
                              PRScsx_tune_5 = rep(0,rep_num),
                              PROSPER_tune_5 = rep(0,rep_num),
                              MUSSEL_tune_5 = rep(0,rep_num),
                              BridgePRS_tune_2 = rep(0,rep_num))

for (i in c(1:rep_num)){
    idx = which(prs_table[[pop]]$n == i & prs_table[[pop]]$pop == pop)

    ## test pheno
    test_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/test/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_10K_doubleidname.tsv"))
    test_pheno_id = test_pheno$IID

    # Choose_JointPRS_5
    R2_sub = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
    R2_full = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"))
    p_value = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_UKB_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_pvalue_",pop,".txt"))
    if (R2_sub > 0.01 && (R2_full - R2_sub > 0) && p_value < 0.05){
    prs_table[[pop]]$choose_JointPRS_tune_5[idx] = "yes"
    } else {
    prs_table[[pop]]$choose_JointPRS_tune_5[idx] = "no"
    }

    # JointPRS_5
    test_JointPRS_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/test_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_JointPRS_5 = test_JointPRS_5[match(test_pheno_id,test_JointPRS_5$IID),]
    JointPRS_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
    test_JointPRS_5$SCORE1_AVG = unlist(JointPRS_weight[1,1]) * unlist(scale(test_JointPRS_5[,5])) + unlist(JointPRS_weight[1,2]) * unlist(scale(test_JointPRS_5[,6])) + unlist(JointPRS_weight[1,3]) * unlist(scale(test_JointPRS_5[,7])) + unlist(JointPRS_weight[1,4]) * unlist(scale(test_JointPRS_5[,8])) + unlist(JointPRS_weight[1,5]) * unlist(scale(test_JointPRS_5[,9]))

    # PRScsx_5
    test_PRScsx_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRScsx/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/test_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_PRScsx_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_PRScsx_5 = test_PRScsx_5[match(test_pheno_id,test_PRScsx_5$IID),]
    PRScsx_weight = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/PRScsx/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_PRScsx_real_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"))
    test_PRScsx_5$SCORE1_AVG = unlist(PRScsx_weight[1,1]) * unlist(scale(test_PRScsx_5[,5])) + unlist(PRScsx_weight[1,2]) * unlist(scale(test_PRScsx_5[,6])) + unlist(PRScsx_weight[1,3]) * unlist(scale(test_PRScsx_5[,7])) + unlist(PRScsx_weight[1,4]) * unlist(scale(test_PRScsx_5[,8])) + unlist(PRScsx_weight[1,5]) * unlist(scale(test_PRScsx_5[,9]))

    # PROSPER_5
    test_PROSPER_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PROSPER/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/test_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_PROSPER_update_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_PROSPER_5 = test_PROSPER_5[match(test_pheno_id,test_PROSPER_5$IID),]

    # MUSSEL_5
    test_MUSSEL_5 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/MUSSEL/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/test_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_MUSSEL_real_EUR_EAS_AFR_SAS_AMR_prs_",pop,".sscore"))
    test_MUSSEL_5 = test_MUSSEL_5[match(test_pheno_id,test_MUSSEL_5$IID),]

    # BridgePRS_2
    test_BridgePRS_2 = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/BridgePRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/test_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_BridgePRS_real_EUR_",pop,"_prs_",pop,".sscore"))
    test_BridgePRS_2 = test_BridgePRS_2[match(test_pheno_id,test_BridgePRS_2$IID),]

    ## final
    # test result
    test_data = data.table(pheno = scale(test_pheno$pheno),
                           JointPRS_tune_5 = scale(test_JointPRS_5$SCORE1_AVG), 
                           PRScsx_tune_5 = scale(test_PRScsx_5$SCORE1_AVG), 
                           PROSPER_tune_5 = scale(test_PROSPER_5$SCORE1_AVG), 
                           MUSSEL_tune_5 = scale(test_MUSSEL_5$SCORE1_AVG),
                           BridgePRS_tune_2 = scale(test_BridgePRS_2$SCORE1_AVG))
    colnames(test_data) = c("pheno","JointPRS_tune_5","PRScsx_tune_5","PROSPER_tune_5","MUSSEL_tune_5","BridgePRS_tune_2")
    for (j in 2:6){
        data = data.table(status = test_data$pheno)
        data$prs <- unlist(test_data[,..j])
        linear = lm(status ~ prs, data=data)
        prs_table[[pop]][idx,j+6] = summary(linear)$`r.squared`
    }


}
}

prs_table_tune = rbind(prs_table[["EAS"]],prs_table[["AFR"]],prs_table[["SAS"]],prs_table[["AMR"]])
print(prs_table_tune)

write.table(prs_table_tune,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/sim_h20.1_PRS_update_real_tune_r2.csv"),quote=F,sep='\t',row.names=F,col.names=T)
# JointPRS_tune
# Step1: Estimate beta
h2=0.1
rho=0.8 
p=0.1

# sample size
sample1=UKB
sample2=80K

if [[ ${sample2} == "80K" ]]; then
sample_size1=311600; sample_size2=80000
else
echo "Please provide the available phenotype"
fi

for i in {1..5}; do
for chr in {1..22}; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho}/EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_AMR_pst_eff_a1_b0.5_phi${param_phi}_chr${chr}.txt" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_chr${chr}
#SBATCH --output=out_sim${i}_h2${h2}_p${p}_rho${rho}_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_chr${chr}.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/

if [[ "${param_phi}" == "1e-06" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover/PRScsx/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover/PRScsx/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover/PRScsx/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover/PRScsx/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho_cons=0,0,0,0,0 \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--phi=${param_phi} \
--out_dir=result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
fi

if [[ "${param_phi}" != "auto" && "${param_phi}" != "1e-06" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover/PRScsx/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover/PRScsx/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover/PRScsx/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover/PRScsx/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho_cons=1,1,1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--phi=${param_phi} \
--out_dir=result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
fi

if [[ "${param_phi}" == "auto" ]]; then
python /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/JointPRS/JointPRS.py \
--ref_dir=/gpfs/gibbs/pi/zhao/lx94/JointPRS/data/ref_data/PRScsx/1kg \
--bim_prefix=data/sim_data/geno_data/All/All_test \
--sst_file=data/sim_data/summary_data/EUR/discover/PRScsx/EUR_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_PRScsx_real.txt,data/sim_data/summary_data/EAS/discover/PRScsx/EAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AFR/discover/PRScsx/AFR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/SAS/discover/PRScsx/SAS_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt,data/sim_data/summary_data/AMR/discover/PRScsx/AMR_sim${i}_h2${h2}_p${p}_rho${rho}_${sample2}_PRScsx_real.txt \
--rho_cons=1,1,1,1,1 \
--n_gwas=${sample_size1},${sample_size2},${sample_size2},${sample_size2},${sample_size2} \
--chrom=${chr} \
--pop=EUR,EAS,AFR,SAS,AMR \
--out_dir=result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho} \
--out_name=EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real
fi
EOT
fi
done
done
done

# Step2: Organize beta by chr pop for each param in each scenario
library(data.table)

h2=0.1
rho=0.8 
p=0.1

sample1="UKB"
sample2="80K"

for (i in c(1:5)){
for (param_phi in c("1e-06","1e-04","1e-02","1e+00","auto")){

JointPRS_all <- data.table()
for(chr in 1:22){
    JointPRS_EUR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_EUR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_EAS_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_EAS_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_AFR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_AFR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_SAS_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_SAS_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))
    JointPRS_AMR_chr <- fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_AMR_pst_eff_a1_b0.5_phi",param_phi,"_chr",chr,".txt"))

    JointPRS_EUR_chr <- JointPRS_EUR_chr[,c(2,4,6)]
    names(JointPRS_EUR_chr) = c("rsID","A1","EUR")
    JointPRS_EAS_chr <- JointPRS_EAS_chr[,c(2,4,6)]
    names(JointPRS_EAS_chr) = c("rsID","A1","EAS")
    JointPRS_AFR_chr <- JointPRS_AFR_chr[,c(2,4,6)]
    names(JointPRS_AFR_chr) = c("rsID","A1","AFR")
    JointPRS_SAS_chr <- JointPRS_SAS_chr[,c(2,4,6)]
    names(JointPRS_SAS_chr) = c("rsID","A1","SAS")
    JointPRS_AMR_chr <- JointPRS_AMR_chr[,c(2,4,6)]
    names(JointPRS_AMR_chr) = c("rsID","A1","AMR")

    JointPRS_all_chr = merge(JointPRS_EUR_chr,JointPRS_EAS_chr, by = c("rsID","A1"), all = TRUE)
    JointPRS_all_chr = merge(JointPRS_all_chr,JointPRS_AFR_chr, by = c("rsID","A1"), all = TRUE)
    JointPRS_all_chr = merge(JointPRS_all_chr,JointPRS_SAS_chr, by = c("rsID","A1"), all = TRUE)
    JointPRS_all_chr = merge(JointPRS_all_chr,JointPRS_AMR_chr, by = c("rsID","A1"), all = TRUE)

    JointPRS_all = rbind(JointPRS_all,JointPRS_all_chr)
    
}

JointPRS_all[is.na(JointPRS_all)] <- 0

write.table(JointPRS_all,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_phi",param_phi,"_beta.txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step3: Calculate prs for each pop for each param in each scenario
h2=0.1
rho=0.8 
p=0.1

# sample size
sample1=UKB
sample2=80K

for i in {1..5}; do
for pop in EAS AFR SAS AMR; do
for param_phi in 1e-06 1e-04 1e-02 1e+00 auto; do
if [[ ! -e "/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho}/validate_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_${pop}_phi${param_phi}.sscore" ]]; then
        sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge,day,week
#SBATCH --requeue
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=PRS_${sample1}_${sample2}_JointPRS_real_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR
#SBATCH --output=out_PRS_${sample1}_${sample2}_JointPRS_real_${pop}_phi${param_phi}_EUR_EAS_AFR_SAS_AMR.txt

module load PLINK/2

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim${i}_h2${h2}_p${p}_rho${rho}

plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop} \
--double-id \
--threads 1 \
--score EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_phi${param_phi}_beta.txt header-read \
--score-col-nums 3 4 5 6 7 \
--out validate_EUR_EAS_AFR_SAS_AMR_${sample1}_${sample2}_JointPRS_real_${pop}_phi${param_phi}

EOT
fi
done
done
done

# Step4: Select the optimal parameter and obtain the corresponding weight
## select the optimal version
library(data.table)
library(stringr)
library(dplyr)

h2=0.1
rho=0.8 
p=0.1

sample1="UKB"
sample2="80K"
val_sample="10K"

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for (i in c(1:5)){
for (pop in c("EAS","AFR","SAS","AMR")){

    sim_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phiauto.sscore"))
    sim_JointPRS_phi1e_06_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phi1e-06.sscore"))
    sim_JointPRS_phi1e_04_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phi1e-04.sscore"))
    sim_JointPRS_phi1e_02_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phi1e-02.sscore"))
    sim_JointPRS_phi1e_00_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phi1e+00.sscore"))

    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",val_sample,"_doubleidname.tsv"))
    scale_pheno = scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    sim_JointPRS_phiauto_val = sim_JointPRS_phiauto_val[,c(1,5,6,7,8,9)]
    colnames(sim_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    sim_JointPRS_phiauto_val = scale_pheno[sim_JointPRS_phiauto_val, on = .(eid = eid)]
    sim_JointPRS_phiauto_val = sim_JointPRS_phiauto_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    sim_JointPRS_phiauto_val = na.omit(sim_JointPRS_phiauto_val)
    
    sim_JointPRS_phi1e_06_val = sim_JointPRS_phi1e_06_val[,c(1,5,6,7,8,9)]
    colnames(sim_JointPRS_phi1e_06_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    sim_JointPRS_phi1e_06_val = scale_pheno[sim_JointPRS_phi1e_06_val, on = .(eid = eid)]
    sim_JointPRS_phi1e_06_val = sim_JointPRS_phi1e_06_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    sim_JointPRS_phi1e_06_val = na.omit(sim_JointPRS_phi1e_06_val)

    sim_JointPRS_phi1e_04_val = sim_JointPRS_phi1e_04_val[,c(1,5,6,7,8,9)]
    colnames(sim_JointPRS_phi1e_04_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    sim_JointPRS_phi1e_04_val = scale_pheno[sim_JointPRS_phi1e_04_val, on = .(eid = eid)]
    sim_JointPRS_phi1e_04_val = sim_JointPRS_phi1e_04_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    sim_JointPRS_phi1e_04_val = na.omit(sim_JointPRS_phi1e_04_val)
    
    sim_JointPRS_phi1e_02_val = sim_JointPRS_phi1e_02_val[,c(1,5,6,7,8,9)]
    colnames(sim_JointPRS_phi1e_02_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    sim_JointPRS_phi1e_02_val = scale_pheno[sim_JointPRS_phi1e_02_val, on = .(eid = eid)]
    sim_JointPRS_phi1e_02_val = sim_JointPRS_phi1e_02_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    sim_JointPRS_phi1e_02_val = na.omit(sim_JointPRS_phi1e_02_val)

    sim_JointPRS_phi1e_00_val = sim_JointPRS_phi1e_00_val[,c(1,5,6,7,8,9)]
    colnames(sim_JointPRS_phi1e_00_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    sim_JointPRS_phi1e_00_val = scale_pheno[sim_JointPRS_phi1e_00_val, on = .(eid = eid)]
    sim_JointPRS_phi1e_00_val = sim_JointPRS_phi1e_00_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    sim_JointPRS_phi1e_00_val = na.omit(sim_JointPRS_phi1e_00_val)

    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val = lm(pheno ~ . + 0, data = sim_JointPRS_phiauto_val[,c(2:7)])
    lm_JointPRS_phi1e_06_val = lm(pheno ~ . + 0, data = sim_JointPRS_phi1e_06_val[,c(2:7)])
    lm_JointPRS_phi1e_04_val = lm(pheno ~ . + 0, data = sim_JointPRS_phi1e_04_val[,c(2:7)])
    lm_JointPRS_phi1e_02_val = lm(pheno ~ . + 0, data = sim_JointPRS_phi1e_02_val[,c(2:7)])
    lm_JointPRS_phi1e_00_val = lm(pheno ~ . + 0, data = sim_JointPRS_phi1e_00_val[,c(2:7)])

    sim_JointPRS_val_R2 = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val)$`r.squared`,
                                    JointPRS_phi1e_06 = summary(lm_JointPRS_phi1e_06_val)$`r.squared`, 
                                    JointPRS_phi1e_04 = summary(lm_JointPRS_phi1e_04_val)$`r.squared`,
                                    JointPRS_phi1e_02 = summary(lm_JointPRS_phi1e_02_val)$`r.squared`, 
                                    JointPRS_phi1e_00 = summary(lm_JointPRS_phi1e_00_val)$`r.squared`)
    JointPRS_val_weight = data.table(rbind(lm_JointPRS_phiauto_val$coefficient,lm_JointPRS_phi1e_06_val$coefficient,lm_JointPRS_phi1e_04_val$coefficient,lm_JointPRS_phi1e_02_val$coefficient,lm_JointPRS_phi1e_00_val$coefficient))
                         
    ## best index
    JointPRS_index = which.max(sim_JointPRS_val_R2)
    best_param = param_list[JointPRS_index]
    print(JointPRS_index)

    sim_JointPRS_optimal_weight = JointPRS_val_weight[JointPRS_index,]
    sim_JointPRS_optimal_phi = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/","EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_phi",best_param,"_beta.txt"))
 
    write.table(sim_JointPRS_optimal_weight,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_weight_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(sim_JointPRS_optimal_phi,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_beta_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}

# Step5: perform submodel test
# JointPRS: selecting between JointPRS-meta and JointPRS-tune based on R2 in validation
# we want to selecting between JointPRS-meta and JointPRS-tune
# but we compare R2 from JointPRS-auto and JointPRS-auto with linear combination as well as the f-test result between them as the selection guideline
library(data.table)
library(stringr)
library(dplyr)

h2=0.1
rho=0.8 
p=0.1

sample1="UKB"
sample2="80K"
val_sample="10K"

param_list = c("auto","1e-06","1e-04","1e-02","1e+00")

for (i in c(1:5)){
for (pop in c("EAS","AFR","SAS","AMR")){

    Sim_JointPRS_phiauto_val = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"/validate_EUR_EAS_AFR_SAS_AMR_",sample1,"_",sample2,"_JointPRS_real_",pop,"_phiauto.sscore"))
    
    scale_pheno = fread(paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/pheno_data/",pop,"/validate/",pop,"_sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",val_sample,"_doubleidname.tsv"))
    scale_pheno = scale_pheno[,c(1,3)]
    colnames(scale_pheno) = c("eid","pheno")

    ## validation
    ## JointPRS
    Sim_JointPRS_phiauto_val = Sim_JointPRS_phiauto_val[,c(1,5,6,7,8,9)]
    colnames(Sim_JointPRS_phiauto_val) = c("eid","EUR","EAS","AFR","SAS","AMR")
    Sim_JointPRS_phiauto_val = scale_pheno[Sim_JointPRS_phiauto_val, on = .(eid = eid)]
    Sim_JointPRS_phiauto_val = Sim_JointPRS_phiauto_val[,c(3:7) := lapply(.SD,scale),.SDcols = c(3:7)]
    Sim_JointPRS_phiauto_val = na.omit(Sim_JointPRS_phiauto_val)
    col_idx = c(2,which(colnames(Sim_JointPRS_phiauto_val) == pop))
    
    # JointPRS validation data select the best performed parameter
    lm_JointPRS_phiauto_val_sub = lm(pheno ~ . + 0, data = Sim_JointPRS_phiauto_val[,..col_idx])
    lm_JointPRS_phiauto_val_full = lm(pheno ~ . + 0, data = Sim_JointPRS_phiauto_val[,c(2:7)])

    R2_sub = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_sub)$`r.squared`)
    R2_full = data.table(JointPRS_phiauto = summary(lm_JointPRS_phiauto_val_full)$`r.squared`)

    p_value = anova(lm_JointPRS_phiauto_val_sub,lm_JointPRS_phiauto_val_full)$`Pr(>F)`
    p_value = na.omit(p_value)

    write.table(R2_sub,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(R2_full,paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/tuning/JointPRS_tune/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_r2_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)
    write.table(p_value, paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/Final_weight/auto/JointPRS/sim",i,"_h2",h2,"_p",p,"_rho",rho,"_",sample1,"_",sample2,"_",val_sample,"_JointPRS_real_EUR_EAS_AFR_SAS_AMR_pvalue_",pop,".txt"),quote=F,sep='\t',row.names=F,col.names=T)

}
}
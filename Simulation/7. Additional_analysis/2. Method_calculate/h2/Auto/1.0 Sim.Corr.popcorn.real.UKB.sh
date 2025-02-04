## 1. Obtain genetic correlation
## sample=UKB_90K h2=0.1 p=0.1  rho=0.8 i=1  EUR_EAS: 0.85 EUR_AFR: 0.90
## sample=UKB_90K h2=0.1 p=0.1  rho=0.8 i=2  EUR_EAS: 0.74 EUR_AFR: 0.84
## sample=UKB_90K h2=0.1 p=0.1  rho=0.8 i=3  EUR_EAS: 0.83 EUR_AFR: 0.81
## sample=UKB_90K h2=0.1 p=0.1  rho=0.8 i=4  EUR_EAS: 0.88 EUR_AFR: 0.86
## sample=UKB_90K h2=0.1 p=0.1  rho=0.8 i=5  EUR_EAS: 0.73 EUR_AFR: 0.77

## small sample size
module load miniconda
conda activate popcorn

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/method/Popcorn

h2=0.1
rho=0.8 
p=0.1

pop1=EUR

sample=UKB_90K

for i in {1..5}; do
for pop2 in EAS AFR; do

if [[ "${sample}" == "UKB_90K" ]]; then
popcorn fit -v 0 \
--cfile ./ref/${pop1}_${pop2}_all_gen_eff.cscore \
--gen_effect \
--sfile1 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop1}/discover/popcorn/${pop1}_sim${i}_h2${h2}_p${p}_rho${rho}_UKB_popcorn_real.txt \
--sfile2 /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/summary_data/${pop2}/discover_validate/popcorn/${pop2}_sim${i}_h2${h2}_p${p}_rho${rho}_90K_popcorn_real.txt \
/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/popcorn/sim${i}_h2${h2}_p${p}_rho${rho}/${pop1}_${pop2}_UKB_90K_popcorn_real_corr.txt
fi
done
done
done
done

## 2. Check genetic correlation
h2=0.1
rho=0.8 
p=0.1

pop1=EUR

sample=UKB_90K

for i in {1..5}; do
for pop2 in EAS AFR; do

if [[ "${sample}" == "UKB_90K" ]]; then
echo ${sample}_sim${i}_h2${h2}_p${p}_rho${rho}:${pop1}_${pop2}
cat /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/popcorn/sim${i}_h2${h2}_p${p}_rho${rho}/${pop1}_${pop2}_UKB_90K_popcorn_real_corr.txt
fi

done
done
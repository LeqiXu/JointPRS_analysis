
## 1. Dataset split
## discover 1-100,000; validate 100,001-110,000; test 110,001-120,000
## snplist intersection

module load PLINK/2

for pop in EUR EAS AFR SAS AMR
do
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate
mkdir /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test

## split them into discover, validate, and test for each chromosome
for chr in {1..22}
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/All/${pop}_chr${chr} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/discover_id.tsv \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop}_chr${chr}
done

for chr in {1..22}
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/All/${pop}_chr${chr} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/validate_id.tsv \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop}_chr${chr}
done

for chr in {1..22}
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/All/${pop}_chr${chr} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/test_id.tsv \
--extract /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_infor_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/${pop}_chr${chr}
done
done

## 2. Dataset chromosome merge
module load PLINK/1

for pop in EUR EAS AFR SAS AMR
do
## merge each dataset for all chromosome
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/
plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop}_chr1 \
--double-id \
--merge-list /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/${pop}_merge_list.txt \
--update-name /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop}

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/
plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop}_chr1 \
--double-id \
--merge-list /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/${pop}_merge_list.txt \
--update-name /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop}

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/
plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/${pop}_chr1 \
--double-id \
--merge-list /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/${pop}_merge_list.txt \
--update-name /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/${pop}
done

## 3. Dataset removal
for pop in EUR EAS AFR SAS AMR
do
rm -rf /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/All
done

for pop in EUR EAS AFR SAS AMR
do
for chr in {1..22}
do
rm -rf /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop}_chr${chr}*
done

for chr in {1..22}
do
rm -rf /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop}_chr${chr}*
done

for chr in {1..22}
do
rm -rf /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/test/${pop}_chr${chr}*
done
done

## discover and phenotype merge
for pop in EAS AFR SAS AMR
do
sbatch <<EOT
#!/bin/bash
#SBATCH --partition=scavenge
#SBATCH --requeue
#SBATCH --mem=100G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=${pop}_discover_validate
#SBATCH --output=out_${pop}_discover_validate.txt

module load PLINK/1

## merge testing and validation
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/
plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
--double-id \
--bmerge /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop} \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover_validate/${pop}
EOT
done

## 5. All bim file obtain
module load PLINK/1

## merge each dataset for all population
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/All

plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/EUR/test/EUR \
--double-id \
--merge-list /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/merge_list.txt \
--make-bed \
--out All_test

## 6. LD individuals participants extraction
module load PLINK/2

for pop in EUR EAS AFR SAS AMR
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/discover/${pop} \
--double-id \
--keep /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/insample_LD_id/${pop}/ref1000.id.txt \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/insample_LD_geno/${pop}
done

## 7. generate chr raw data for MUSSEL
module load PLINK/2

for pop in EUR EAS AFR SAS AMR
do
for chr in {1..22}
do
plink2 --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/insample_LD_geno/${pop} \
--double-id \
--make-bed \
--chr ${chr} \
--update-name /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist 1 2 \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/ref_data/insample_LD/MUSSEL/${pop}/raw/chr${chr}
done
done

## 8. generate rsid geno data for validation in PROSPER and MUSSEL
module load PLINK/1

for pop in EUR EAS AFR SAS AMR
do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/
plink --bfile /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop} \
--double-id \
--update-name /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/snp_map_hm3.snplist 1 2 \
--make-bed \
--out /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/validate/${pop}_rsid
done
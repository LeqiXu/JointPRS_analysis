# 1. download the dataset
#!/bin/bash
#SBATCH --partition=bigmem
#SBATCH --requeue
#SBATCH --mem=200G
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1 --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --job-name=simulation_download
#SBATCH --output=out_simulation_download.txt

module load miniconda
conda activate py_env

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/AFR/All/
wget https://dataverse.harvard.edu/api/access/datafile/6155397 -O AFR_chr10.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155019 -O AFR_chr10.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155418 -O AFR_chr11.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155408 -O AFR_chr11.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155455 -O AFR_chr12.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155404 -O AFR_chr12.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155461 -O AFR_chr13.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155399 -O AFR_chr13.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155512 -O AFR_chr14.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155400 -O AFR_chr14.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155571 -O AFR_chr15.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155409 -O AFR_chr15.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155588 -O AFR_chr16.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155398 -O AFR_chr16.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155589 -O AFR_chr17.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155402 -O AFR_chr17.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155593 -O AFR_chr18.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155405 -O AFR_chr18.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155594 -O AFR_chr19.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155401 -O AFR_chr19.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154298 -O AFR_chr1.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154299 -O AFR_chr1.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154300 -O AFR_chr1.fam
wget https://dataverse.harvard.edu/api/access/datafile/6155595 -O AFR_chr20.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155403 -O AFR_chr20.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155596 -O AFR_chr21.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155407 -O AFR_chr21.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155597 -O AFR_chr22.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155406 -O AFR_chr22.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154411 -O AFR_chr2.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154412 -O AFR_chr2.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154936 -O AFR_chr3.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154937 -O AFR_chr3.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154941 -O AFR_chr4.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154939 -O AFR_chr4.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155009 -O AFR_chr5.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154940 -O AFR_chr5.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155010 -O AFR_chr6.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155011 -O AFR_chr6.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155015 -O AFR_chr7.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155016 -O AFR_chr7.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155018 -O AFR_chr8.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155017 -O AFR_chr8.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155396 -O AFR_chr9.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155395 -O AFR_chr9.bim

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/AMR/All/
wget https://dataverse.harvard.edu/api/access/datafile/6157289 -O AMR_chr10.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155621 -O AMR_chr10.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157327 -O AMR_chr11.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155614 -O AMR_chr11.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157354 -O AMR_chr12.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155609 -O AMR_chr12.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157361 -O AMR_chr13.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155615 -O AMR_chr13.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157517 -O AMR_chr14.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155612 -O AMR_chr14.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157518 -O AMR_chr15.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155608 -O AMR_chr15.bim
wget https://dataverse.harvard.edu/api/access/datafile/6306679 -O AMR_chr16.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155610 -O AMR_chr16.bim
wget https://dataverse.harvard.edu/api/access/datafile/6306680 -O AMR_chr17.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155616 -O AMR_chr17.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157568 -O AMR_chr18.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155604 -O AMR_chr18.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157577 -O AMR_chr19.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155603 -O AMR_chr19.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155779 -O AMR_chr1.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155600 -O AMR_chr1.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155618 -O AMR_chr1.fam
wget https://dataverse.harvard.edu/api/access/datafile/6157576 -O AMR_chr20.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155605 -O AMR_chr20.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157629 -O AMR_chr21.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155617 -O AMR_chr21.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157643 -O AMR_chr22.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155619 -O AMR_chr22.bim
wget https://dataverse.harvard.edu/api/access/datafile/6155786 -O AMR_chr2.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155613 -O AMR_chr2.bim
wget https://dataverse.harvard.edu/api/access/datafile/6156804 -O AMR_chr3.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155607 -O AMR_chr3.bim
wget https://dataverse.harvard.edu/api/access/datafile/6156820 -O AMR_chr4.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155602 -O AMR_chr4.bim
wget https://dataverse.harvard.edu/api/access/datafile/6156982 -O AMR_chr5.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155601 -O AMR_chr5.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157135 -O AMR_chr6.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155606 -O AMR_chr6.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157211 -O AMR_chr7.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155620 -O AMR_chr7.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157285 -O AMR_chr8.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6155611 -O AMR_chr8.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157288 -O AMR_chr9.bed
wget https://dataverse.harvard.edu/api/access/datafile/6155599 -O AMR_chr9.bim

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/EAS/All/
wget https://dataverse.harvard.edu/api/access/datafile/6157698 -O EAS_chr10.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157645 -O EAS_chr10.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157713 -O EAS_chr11.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157647 -O EAS_chr11.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157722 -O EAS_chr12.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157665 -O EAS_chr12.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157721 -O EAS_chr13.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157648 -O EAS_chr13.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157725 -O EAS_chr14.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157664 -O EAS_chr14.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157724 -O EAS_chr15.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157662 -O EAS_chr15.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157723 -O EAS_chr16.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157652 -O EAS_chr16.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157727 -O EAS_chr17.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157659 -O EAS_chr17.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157730 -O EAS_chr18.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157660 -O EAS_chr18.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157731 -O EAS_chr19.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157644 -O EAS_chr19.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157670 -O EAS_chr1.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157656 -O EAS_chr1.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157649 -O EAS_chr1.fam
wget https://dataverse.harvard.edu/api/access/datafile/6157729 -O EAS_chr20.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157650 -O EAS_chr20.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157728 -O EAS_chr21.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157657 -O EAS_chr21.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157732 -O EAS_chr22.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157646 -O EAS_chr22.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157671 -O EAS_chr2.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157655 -O EAS_chr2.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157674 -O EAS_chr3.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157653 -O EAS_chr3.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157675 -O EAS_chr4.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157661 -O EAS_chr4.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157684 -O EAS_chr5.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157654 -O EAS_chr5.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157685 -O EAS_chr6.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157663 -O EAS_chr6.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157686 -O EAS_chr7.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157651 -O EAS_chr7.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157687 -O EAS_chr8.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157666 -O EAS_chr8.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157697 -O EAS_chr9.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157658 -O EAS_chr9.bim

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/EUR/All/
wget https://dataverse.harvard.edu/api/access/datafile/6154072 -O EUR_chr10.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154073 -O EUR_chr10.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154079 -O EUR_chr11.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154078 -O EUR_chr11.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154087 -O EUR_chr12.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154088 -O EUR_chr12.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154254 -O EUR_chr13.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154255 -O EUR_chr13.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154273 -O EUR_chr14.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154270 -O EUR_chr14.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154272 -O EUR_chr15.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154271 -O EUR_chr15.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154280 -O EUR_chr16.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154290 -O EUR_chr16.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154282 -O EUR_chr17.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154289 -O EUR_chr17.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154291 -O EUR_chr18.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154281 -O EUR_chr18.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154292 -O EUR_chr19.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154285 -O EUR_chr19.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154043 -O EUR_chr1.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154044 -O EUR_chr1.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154045 -O EUR_chr1.fam
wget https://dataverse.harvard.edu/api/access/datafile/6154284 -O EUR_chr20.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154293 -O EUR_chr20.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154283 -O EUR_chr21.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154286 -O EUR_chr21.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154287 -O EUR_chr22.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154288 -O EUR_chr22.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154046 -O EUR_chr2.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154047 -O EUR_chr2.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154049 -O EUR_chr3.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154048 -O EUR_chr3.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154053 -O EUR_chr4.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154054 -O EUR_chr4.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154061 -O EUR_chr5.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154062 -O EUR_chr5.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154063 -O EUR_chr6.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154064 -O EUR_chr6.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154066 -O EUR_chr7.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6154067 -O EUR_chr7.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154068 -O EUR_chr8.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154069 -O EUR_chr8.bim
wget https://dataverse.harvard.edu/api/access/datafile/6154070 -O EUR_chr9.bed
wget https://dataverse.harvard.edu/api/access/datafile/6154071 -O EUR_chr9.bim

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/SAS/All/
wget https://dataverse.harvard.edu/api/access/datafile/6160227 -O SAS_chr10.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157742 -O SAS_chr10.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160593 -O SAS_chr11.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157733 -O SAS_chr11.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160592 -O SAS_chr12.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157743 -O SAS_chr12.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160591 -O SAS_chr13.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157754 -O SAS_chr13.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160658 -O SAS_chr14.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157751 -O SAS_chr14.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160659 -O SAS_chr15.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157747 -O SAS_chr15.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160657 -O SAS_chr16.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157744 -O SAS_chr16.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160837 -O SAS_chr17.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157755 -O SAS_chr17.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160832 -O SAS_chr18.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157737 -O SAS_chr18.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160834 -O SAS_chr19.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157749 -O SAS_chr19.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157756 -O SAS_chr1.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157746 -O SAS_chr1.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157740 -O SAS_chr1.fam
wget https://dataverse.harvard.edu/api/access/datafile/6160833 -O SAS_chr20.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157736 -O SAS_chr20.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160836 -O SAS_chr21.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157738 -O SAS_chr21.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160835 -O SAS_chr22.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157753 -O SAS_chr22.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157832 -O SAS_chr2.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157739 -O SAS_chr2.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157904 -O SAS_chr3.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157735 -O SAS_chr3.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157915 -O SAS_chr4.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157752 -O SAS_chr4.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157936 -O SAS_chr5.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157745 -O SAS_chr5.bim
wget https://dataverse.harvard.edu/api/access/datafile/6157968 -O SAS_chr6.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157734 -O SAS_chr6.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160189 -O SAS_chr7.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157741 -O SAS_chr7.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160209 -O SAS_chr8.bed.zip
wget https://dataverse.harvard.edu/api/access/datafile/6157748 -O SAS_chr8.bim
wget https://dataverse.harvard.edu/api/access/datafile/6160222 -O SAS_chr9.bed
wget https://dataverse.harvard.edu/api/access/datafile/6157750 -O SAS_chr9.bim

cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/
wget https://dataverse.harvard.edu/api/access/datafile/6176968 -O snp_infor_1kg.zip
wget https://dataverse.harvard.edu/api/access/datafile/6176969 -O snp_infor_mega+hm3


# 2. unzip and rename the file
for pop in EUR EAS AFR SAS AMR
do
cd /gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/${pop}/All

for f in *.zip; do
    # Unzip the file into the current directory
    unzip -j "$f" 

    # Rename the extracted file to match the ZIP file's base name
    original_filename=$(unzip -Z1 "$f")
    mv "$original_filename" "${f%.zip}"
done

rm -rf *.zip

for chr in {2..22}
do
cp ${pop}_chr1.fam ${pop}_chr${chr}.fam
done

done
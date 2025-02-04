## 1. SAS and AMR LD block extraction
# Load necessary libraries
library(dplyr)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/geno_data/info/insample_LD_block")

# List all ld.bin files in the chromosome folders under the population directory
for(pop in c("EUR","EAS","AFR","SAS","AMR")){
all_files_info <- data.frame()

for (chr in 1:22){
file_paths <- list.files(path =paste0("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/data/sim_data/ref_data/insample_LD/MUSSEL/",pop,"/tmp/LD/chr",chr,"/"), 
                         pattern = "chr.*_\\d+_\\d+\\.ld\\.bin$", full.names = TRUE, recursive = TRUE)

# Extract chromosome, start, and stop numbers from file names
file_info <- data.frame(
  file = basename(file_paths),
  stringsAsFactors = FALSE
) %>%
  mutate(
    chr = paste0(gsub("chr(\\d+)_.*", "\\1", file)),
    start = as.numeric(gsub(".*_(\\d+)_(\\d+)\\.ld\\.bin", "\\1", file)),
    stop = as.numeric(gsub(".*_(\\d+)_(\\d+)\\.ld\\.bin", "\\2", file))
  ) %>%
  select(-file)  # Remove the original file column if it's not needed

all_files_info <- rbind(all_files_info, file_info)
}

# Order the data frame by chromosome and then by start number
ordered_df <- all_files_info %>%
  arrange(as.numeric(chr), start)
ordered_df$chr = paste0("chr",ordered_df$chr)

# View the ordered data frame
str(ordered_df)

write.table(ordered_df, 
            file=paste0(pop,"_block.txt"), row.names=F, col.names=T, quote=F, append=F, sep = "\t")


}
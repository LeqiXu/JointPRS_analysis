library(data.table)
library(dplyr)
library(tidyr)
library(openxlsx)

setwd("/gpfs/gibbs/pi/zhao/lx94/JointPRS/revision/result/sim_result/PRS/")

# Data preprocessing for prs_table
prs_table <- fread("sim_PRS_real_auto_no_val_r2.csv")
prs_table <- prs_table[, c("n", "pop", "p", "rho", "sample2", "JointPRS_auto_5", "PRScsx_auto_5", "SDPRX_auto_2", "XPASS_auto_2")]
colnames(prs_table) <- c("n", "pop", "p", "rho", "sample2", "JointPRS-auto", "PRS-CSx-auto", "SDPRX", "XPASS")

prs_table$pop <- factor(prs_table$pop, levels = c("EAS", "AFR", "SAS", "AMR"))

prs_table <- prs_table %>% arrange(pop, p, rho, sample2)

# Reshape to long_table
long_table <- melt(prs_table, id.vars = c("n", "pop", "p", "rho", "sample2"),
                   variable.name = "method", value.name = "r2")
long_table$method = factor(long_table$method, levels = c("JointPRS-auto","PRS-CSx-auto","SDPRX","XPASS"))
long_table$r2[which(long_table$r2 == 0)] = NA

long_table <- long_table %>%
  group_by(pop, p, rho, sample2, method) %>%
  summarise(
    mean_r2 = mean(r2, na.rm = TRUE),
    sd_r2 = sd(r2, na.rm = TRUE),
    .groups = 'drop' # This argument drops the grouping structure afterwards
  )

# Obtain auto_table
auto_table <- long_table %>%
  pivot_wider(names_from = pop, values_from = c(mean_r2, sd_r2))

auto_table$p <- factor(auto_table$p, levels = c(0.1, 0.01, 0.001, 5e-04), labels = c("0.1", "0.01", "0.001", "5 × 10⁻⁴"))
auto_table$sample2 = factor(auto_table$sample2, levels = c("80K","15K"), labels = c("80,000","15,000"))

auto_table = auto_table[,c("p", "sample2", "method", paste0(rep(c("mean_r2_","sd_r2_"),4), rep(c("EAS", "AFR", "SAS", "AMR"),each=2)))]
print(auto_table)

write.xlsx(auto_table, "sim_auto_table.xlsx", sheetName = "TableS1", rowNames = FALSE)
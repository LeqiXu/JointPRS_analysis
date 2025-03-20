# JointPRS_analysis  
This repository contains the codes used for **simulation studies, real-data analyses and main figure plot** in the **JointPRS** paper.  

## Overview  
**JointPRS** is a multi-population PRS model that only requires GWAS summary statistics and LD reference panel from multiple populations. When individual-level tuning data is available, it adpots a data-adaptive apporach that combines meta-analysis and tuning strategies.

For the **command-line tool** of **JointPRS**, please visit: [https://github.com/LeqiXu/JointPRS](https://github.com/LeqiXu/JointPRS)

## Evaluation and Comparison  
The efficacy of JointPRS is evaluated through **extensive simulations** and **real-data applications to 22 quantitative traits and four binary traits** across **five continental populations** (EUR, EAS, AFR, SAS, AMR), using data from **UK Biobank (UKBB) and All of Us (AoU)**.  

JointPRS is asses under **three data scenarios**:  
- No tuning data available
- Tuning and testing data from the same cohort
- Tuning and testing data from different cohorts  

JointPRS is compared with **six state-of-the-art PRS methods**:  
- SDPRX  
- XPASS  
- PRS-CSx  
- MUSSEL  
- PROSPER  
- BridgePRS

## Directory Structure  
- `Simulation/` – Contains scripts for **simulation studies** evaluating JointPRS and six exsiting methods under different settings.  
- `Real_data/` – Contains scripts for **real data analysis** evaluating JointPRS and six exsiting methods with 22 quantitative traits and 4 binary traits in UKBB and AoU.
- `Main_figure` - Contains scripts for **main figure plot** presenting main simulation studies and real data analysis results.

## Support
Please direct any problems or questions to Leqi Xu (leqi.xu@yale.edu).

## Citation  
Xu L, Zhou G, Jiang W, Zhang H, Dong Y, Guan L, Zhao H. JointPRS: A Data-Adaptive Framework for Multi-Population Genetic Risk Prediction Incorporating Genetic Correlation. bioRxiv. 2024 Sept 1:2023-10. (https://www.biorxiv.org/content/10.1101/2023.10.29.564615v4)

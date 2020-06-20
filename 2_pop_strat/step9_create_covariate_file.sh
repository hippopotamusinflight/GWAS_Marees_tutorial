#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# repeat plinkMDS on ownData, without ethnic outliers
plink --bfile ./outputs/HapMap_3_r3_13 \
      --extract ./outputs/indepSNP.prune.in \
      --genome \
      --out ./outputs/HapMap_3_r3_13
plink --bfile ./outputs/HapMap_3_r3_13 \
      --read-genome ./outputs/HapMap_3_r3_13.genome \
      --cluster \
      --mds-plot 10 \
      --out ./outputs/HapMap_3_r3_13_mds


# change .mds to plink covariate file format
awk '{print$1, $2, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' ./outputs/HapMap_3_r3_13_mds.mds > ./outputs/covar_mds.txt



# EOF

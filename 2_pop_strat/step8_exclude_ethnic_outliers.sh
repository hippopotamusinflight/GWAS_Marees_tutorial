#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# subset ownData.mds by comp1 and comp2 thresholds
awk '{ if ($4 <-0.04 && $5 >0.03) print $1,$2 }' ./outputs/MDS_merge2.mds > ./outputs/EUR_MDS_merge2


# extract individuals passing comp1 and comp2 thresholds
plink --bfile ./outputs/HapMap_3_r3_12 \
      --keep ./outputs/EUR_MDS_merge2 \
      --make-bed --out ./outputs/HapMap_3_r3_13


# EOF

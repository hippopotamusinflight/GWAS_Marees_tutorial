#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# extract HapMap variants from 1kG files
awk '{print$2}' ./outputs/HapMap_3_r3_12.bim > ./outputs/HapMap_SNPs.txt
plink --bfile ${resources_dir}1kG_MDS5 \
      --extract ./outputs/HapMap_SNPs.txt \
      --make-bed --out ${resources_dir}1kG_MDS6


# extract 1kG variants from HapMap files
awk '{print$2}' ${resources_dir}1kG_MDS6.bim > ${resources_dir}1kG_MDS6_SNPs.txt
plink --bfile ./outputs/HapMap_3_r3_12 \
      --extract ${resources_dir}1kG_MDS6_SNPs.txt \
      --recode \
      --make-bed --out ./outputs/HapMap_MDS


# change 1kG build map to HapMap build (update SNP coordinates)
## get HapMap build map
awk '{print$2,$4}' ./outputs/HapMap_MDS.map > ./outputs/buildhapmap.txt

## update 1kG build map
plink --bfile ${resources_dir}1kG_MDS6 \
      --update-map ./outputs/buildhapmap.txt \
      --make-bed --out ${resources_dir}1kG_MDS7


# EOF

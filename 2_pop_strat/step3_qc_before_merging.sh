#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# set reference allele for HapMap to 1kG's
awk '{print$2,$5}' ${resources_dir}1kG_MDS7.bim > ${resources_dir}1kg_ref-list.txt
plink --bfile ./outputs/HapMap_MDS \
      --reference-allele ${resources_dir}1kg_ref-list.txt \
      --make-bed --out ./outputs/HapMap-adj


# resolve strand issues

## potential strand issues
awk '{print$2,$5,$6}' ${resources_dir}1kG_MDS7.bim > ${resources_dir}1kGMDS7_tmp
awk '{print$2,$5,$6}' ./outputs/HapMap-adj.bim > ./outputs/HapMap-adj_tmp
sort ${resources_dir}1kGMDS7_tmp ./outputs/HapMap-adj_tmp | uniq -u > ./outputs/all_differences_HapMapAdj_vs_1kGMDS7.txt

## get list of SNPs to be strand flipped
awk '{print$1}' ./outputs/all_differences_HapMapAdj_vs_1kGMDS7.txt | sort -u > ./outputs/SNPs_to_be_flipped_list.txt

## flip strand for HapMap-adj
plink --bfile ./outputs/HapMap-adj \
      --flip ./outputs/SNPs_to_be_flipped_list.txt \
      --reference-allele ${resources_dir}1kg_ref-list.txt \
      --make-bed --out ./outputs/corrected_hapmap

## re-compare 1kG_MDS7.bim vs corrected_hapmap.bim
awk '{print$2,$5,$6}' ./outputs/corrected_hapmap.bim > ./outputs/corrected_hapmap_tmp
sort ${resources_dir}1kGMDS7_tmp ./outputs/corrected_hapmap_tmp | uniq -u  > ./outputs/uncorresponding_SNPs.txt

## remove problematic SNPs from both 1kG and myData
### get list of SNPs to be removed
awk '{print$1}' ./outputs/uncorresponding_SNPs.txt | sort -u > ./outputs/SNPs_for_exlusion.txt
### remove problematic SNPs
plink --bfile ./outputs/corrected_hapmap \
      --exclude ./outputs/SNPs_for_exlusion.txt \
      --make-bed --out ./outputs/HapMap_MDS2
plink --bfile ${resources_dir}1kG_MDS7 \
      --exclude ./outputs/SNPs_for_exlusion.txt \
      --make-bed --out ${resources_dir}1kG_MDS8


# EOF

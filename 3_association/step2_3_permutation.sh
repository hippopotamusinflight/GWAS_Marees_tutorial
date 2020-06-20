#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"


## get chr22 SNPs list
#awk '{ if ($4 >= 21595000 && $4 <= 21605000) print $2 }' ./outputs/HapMap_3_r3_13.bim > ./outputs/subset_snp_chr_22.txt
#
#
## extract chr22 SNPs
#plink --bfile ./outputs/HapMap_3_r3_13 \
#      --extract ./outputs/subset_snp_chr_22.txt \
#      --make-bed \
#      --out ./outputs/HapMap_subset_chr22
#
#
## plink permutations assoc
#plink --bfile ./outputs/HapMap_subset_chr22 \
#      --assoc \
#      --mperm 1000000 \
#      --out ./outputs/chr22_1M_perm_result
#
## sort by p-value
#sort -gk 4 ./outputs/chr22_1M_perm_result.assoc.mperm > ./outputs/chr22_assoc_sorted_by_pval.txt
#
#
## plink permutations logistic
#plink --bfile ./outputs/HapMap_subset_chr22 \
#      --covar ./outputs/covar_mds.txt \
#      --logistic \
#      --hide-covar \
#      --mperm 1000000 \
#      --out ./outputs/chr22_1M_perm_result

# sort by p-value
sort -gk 4 ./outputs/chr22_1M_perm_result.assoc.logistic.mperm > ./outputs/chr22_logistic_sorted_by_pval.txt


# EOF

#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# logistic regression
plink --bfile ./outputs/HapMap_3_r3_13 \
      --covar ./outputs/covar_mds.txt \
      --logistic \
      --hide-covar \
      --out ./outputs/logistic_results


# remove NA
awk '!/'NA'/' ./outputs/logistic_results.assoc.logistic > ./outputs/logistic_results_noNA.assoc.logistic


# EOF

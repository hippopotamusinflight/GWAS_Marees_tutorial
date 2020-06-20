#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

plink --bfile ./outputs/HapMap_3_r3_13 \
      --covar ./outputs/covar_mds.txt \
      --logistic \
      --hide-covar \
      --adjust \
      --out ./outputs/adjusted_logistic_results





# EOF

#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

plink --bfile ./outputs/HapMap_3_r3_13 \
      --assoc \
      --adjust \
      --out ./outputs/adjusted_assoc_results





# EOF

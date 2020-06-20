#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# merge 1kG_MDS8 and ownData
plink --bfile ./outputs/HapMap_MDS2 \
      --bmerge ${resources_dir}1kG_MDS8 \
      --allow-no-sex \
      --make-bed --out ./outputs/MDS_merge2


# EOF

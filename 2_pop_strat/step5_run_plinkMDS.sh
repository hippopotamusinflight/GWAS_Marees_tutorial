#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# run plink MDS with ownData, anchored by 1000genomes

## calculate IDB for all sample pairs
plink --bfile ./outputs/MDS_merge2 \
      --extract ./outputs/indepSNP.prune.in \
      --genome --out ./outputs/MDS_merge2

## produce n-dimensional of data substructure 
plink --bfile ./outputs/MDS_merge2 \
      --read-genome ./outputs/MDS_merge2.genome \
      --cluster \
      --mds-plot 10 \
      --out ./outputs/MDS_merge2



# EOF

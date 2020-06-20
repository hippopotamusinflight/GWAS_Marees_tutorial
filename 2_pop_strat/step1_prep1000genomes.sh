#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

# download 1000 genomes .vcf
wget -P ${resources_dir} ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20100804/ALL.2of4intersection.20100804.genotypes.vcf.gz


# convert .vcf to plink bed format
plink --vcf ${resources_dir}ALL.2of4intersection.20100804.genotypes.vcf.gz \
      --make-bed --out ${resources_dir}ALL.2of4intersection.20100804.genotypes


# assign SNPs without rsID an unique ID
plink --bfile ${resources_dir}ALL.2of4intersection.20100804.genotypes \
      --set-missing-var-ids @:#[b37]\$1,\$2 \
      --make-bed --out ${resources_dir}ALL.2of4intersection.20100804.genotypes_no_missing_IDs

# remove variants with > 0.2 missing genotypes
plink --bfile ${resources_dir}ALL.2of4intersection.20100804.genotypes_no_missing_IDs \
      --geno 0.2 \
      --allow-no-sex \
      --make-bed --out ${resources_dir}1kG_MDS


# remove individuals with > 0.2 missing genotypes
plink --bfile ${resources_dir}1kG_MDS \
      --mind 0.2 \
      --allow-no-sex \
      --make-bed --out ${resources_dir}1kG_MDS2


# remove variants with > 0.02 missing genotypes
plink --bfile ${resources_dir}1kG_MDS2 \
      --geno 0.02 \
      --allow-no-sex \
      --make-bed --out ${resources_dir}1kG_MDS3


# remove individuals with > 0.02 missing genotypes
plink --bfile ${resources_dir}1kG_MDS3 \
      --mind 0.02 \
      --allow-no-sex \
      --make-bed --out ${resources_dir}1kG_MDS4


# subset by MAF
plink --bfile ${resources_dir}1kG_MDS4 \
      --maf 0.05 \
      --allow-no-sex \
      --make-bed --out ${resources_dir}1kG_MDS5


# EOF

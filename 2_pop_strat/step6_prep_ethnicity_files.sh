#!/bin/bash

resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"

## download 1000 genomes ethnicity info
##wget -P ${resources_dir} ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20100804/20100804.ALL.panel
#
#
## convert population code to super-population code
#awk '{print$1,$1,$2}' ${resources_dir}20100804.ALL.panel > ${resources_dir}race_1kG1.txt
#sed 's/JPT/ASN/g' ${resources_dir}race_1kG1.txt > ${resources_dir}race_1kG2.txt
#sed 's/ASW/AFR/g' ${resources_dir}race_1kG2.txt > ${resources_dir}race_1kG3.txt
#sed 's/CEU/EUR/g' ${resources_dir}race_1kG3.txt > ${resources_dir}race_1kG4.txt
#sed 's/CHB/ASN/g' ${resources_dir}race_1kG4.txt > ${resources_dir}race_1kG5.txt
#sed 's/CHD/ASN/g' ${resources_dir}race_1kG5.txt > ${resources_dir}race_1kG6.txt
#sed 's/YRI/AFR/g' ${resources_dir}race_1kG6.txt > ${resources_dir}race_1kG7.txt
#sed 's/LWK/AFR/g' ${resources_dir}race_1kG7.txt > ${resources_dir}race_1kG8.txt
#sed 's/TSI/EUR/g' ${resources_dir}race_1kG8.txt > ${resources_dir}race_1kG9.txt
#sed 's/MXL/AMR/g' ${resources_dir}race_1kG9.txt > ${resources_dir}race_1kG10.txt
#sed 's/GBR/EUR/g' ${resources_dir}race_1kG10.txt > ${resources_dir}race_1kG11.txt
#sed 's/FIN/EUR/g' ${resources_dir}race_1kG11.txt > ${resources_dir}race_1kG12.txt
#sed 's/CHS/ASN/g' ${resources_dir}race_1kG12.txt > ${resources_dir}race_1kG13.txt
#sed 's/PUR/AMR/g' ${resources_dir}race_1kG13.txt > ${resources_dir}race_1kG14.txt
#
#
## give ownData ethnicity of OWN
#awk '{print$1,$2,"OWN"}' ./outputs/HapMap_MDS.fam > ./outputs/ethn_file_ownData.txt


# concatenate ethnicity files
cat ${resources_dir}race_1kG14.txt ./outputs/ethn_file_ownData.txt | sed -e '1i\FID IID race' > ./outputs/ethn_file_concatenated.txt




# EOF

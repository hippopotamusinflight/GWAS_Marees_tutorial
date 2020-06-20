steps to perform GWAS association
  
  
https://github.com/MareesAT/GWA_tutorial/  
  
#------------------------------------------------------------#  
## copy over plink bed files and covariate file  
  
$ cd 3_Association_GWAS  
$ vim step0_copy_popStrat_outputs.sh  
  
	mkdir -p ./outputs  
  
	cp ../2_Population_stratification/outputs/HapMap_3_r3_13* ./outputs  
	cp ../2_Population_stratification/outputs/covar_mds.txt ./outputs  
  
  
  
#------------------------------------------------------------#  
## association test  
  
(--assoc does not allow PC covariates  
plink --bfile HapMap_3_r3_13 --assoc --out assoc_results)  
  
  
### logistic regression  
  
$ vim step1_logistic_with_covar.sh  
  
	plink --bfile ./outputs/HapMap_3_r3_13 \  
		  --covar ./outputs/covar_mds.txt \  
		  --logistic \  
		  --hide-covar \  
		  --out ./outputs/logistic_results  
  
$ bash step1_logistic_with_covar.sh  
  
--covar: 10 covariates loaded.  
...  
1073226 variants and 109 people pass filters and QC.  
Among remaining phenotypes, 54 are cases and 55 are controls.  
Writing logistic model association results to  
./outputs/logistic_results.assoc.logistic ... done.  
  
$ less ./outputs/logistic_results.assoc.logistic  
  
	 CHR         SNP         BP   A1       TEST    NMISS         OR         STAT            P   
	   1   rs3131972     742584    A        ADD      109      1.957        1.552       0.1207  
	   1   rs3131969     744045    A        ADD      109      2.322          1.8      0.07179  
	   1   rs1048488     750775    C        ADD      108      1.986        1.591       0.1117  
  
  
### remove NAs  
  
$ less ./outputs/logistic_results.assoc.logistic  
  
		1   rs4363479  200378908    A        ADD      107         NA           NA           NA  
		...  
		2   rs1430710   82222336    C        ADD      109         NA           NA           NA  
		2   rs6547406   82222870    A        ADD      109         NA           NA           NA  
		...  
  
  
$ vim step1_logistic_with_covar.sh  
  
	awk '!/'NA'/' ./outputs/logistic_results.assoc.logistic > ./outputs/logistic_results_noNA.assoc.logistic  
  
$ bash step1_logistic_with_covar.sh  
  
$ wc -l logistic_results.assoc.logistic   
1073227  
$ wc -l logistic_results_noNA.assoc.logistic   
1073214											<-- looks like 13 SNPs had NA and were removed...  
  
  
  
  
#------------------------------------------------------------#  
## multiple testing correction (3 strategies)  
  
  
### plink --assoc --adjust  
  
$ vim step2_plink_adjust.sh  
  
	plink --bfile ./outputs/HapMap_3_r3_13 \  
		  --assoc \  
		  --adjust \  
		  --out ./outputs/adjusted_assoc_results	  
  
$ bash step2_1_plink_assoc_adjust.sh  
  
	...  
	--adjust: Genomic inflation est. lambda (based on median chisq) = 1.00965.  
	--adjust values (1073226 variants) written to  
	./outputs/adjusted_assoc_results.assoc.adjusted .  
  
$ less ./outputs/adjusted_assoc_results.assoc.adjusted  
  
 CHR         SNP      UNADJ         GC       BONF       HOLM   SIDAK_SS   SIDAK_SD     FDR_BH     FDR_BY  
   3   rs1097157   1.66e-06  1.861e-06          1          1     0.8316     0.8316     0.2871          1   
   3   rs1840290   1.66e-06  1.861e-06          1          1     0.8316     0.8316     0.2871          1   
   8    rs279466  2.441e-06  2.727e-06          1          1     0.9272     0.9272     0.2871          1   
   8    rs279460  2.441e-06  2.727e-06          1          1     0.9272     0.9272     0.2871          1   
 ...  
  
  
### plink --logistic --adjust  
  
$ vim step2_2_plink_logistic_adjust.sh   
  
	plink --bfile ./outputs/HapMap_3_r3_13 \  
		  --covar ./outputs/covar_mds.txt \  
		  --logistic \  
		  --hide-covar \  
		  --adjust \  
		  --out ./outputs/adjusted_logistic_results  
  
$ bash step2_2_plink_logistic_adjust.sh   
  
	...  
	./outputs/adjusted_logistic_results.assoc.logistic ... done.  
	--adjust: Genomic inflation est. lambda (based on median chisq) = 1.13085.  
	--adjust values (1073213 variants) written to  
	./outputs/adjusted_logistic_results.assoc.logistic.adjusted .  
  
$ less ./outputs/adjusted_logistic_results.assoc.logistic.adjusted  
  
 CHR         SNP      UNADJ         GC       BONF       HOLM   SIDAK_SS   SIDAK_SD     FDR_BH     FDR_BY  
  16  rs17688919  2.775e-05  8.107e-05          1          1          1          1     0.8571          1   
   2  rs12617737  2.934e-05  8.517e-05          1          1          1          1     0.8571          1   
   3   rs9853565  2.975e-05  8.622e-05          1          1          1          1     0.8571          1   
  11   rs2000796  4.064e-05  0.0001138          1          1          1          1     0.8571          1   
 ...  
  
  
### permutation  
- computationally intensive  
- will only practice on chr22 SNPs  
  
  
#### get chr22 SNPs list  
  
$ vim step2_3_permutation.sh  
  
	awk '{ if ($4 >= 21595000 && $4 <= 21605000) print $2 }' ./outputs/HapMap_3_r3_13.bim > ./outputs/subset_snp_chr_22.txt  
  
$ bash step2_3_permutation.sh  
  
$ wc -l ./outputs/subset_snp_chr_22.txt   
84  
  
  
#### extract chr22 SNPs  
  
$ vim step2_3_permutation.sh  
  
plink --bfile ./outputs/HapMap_3_r3_13 \  
      --extract ./outputs/subset_snp_chr_22.txt \  
      --make-bed \  
      --out ./outputs/HapMap_subset_chr22  
  
$ bash step2_3_permutation.sh  
  
	84 variants and 109 people pass filters and QC.  
  
  
#### plink permutations assoc  
  
$ vim step2_3_permutation.sh  
  
plink --bfile ./outputs/HapMap_subset_chr22 \  
      --assoc \  
      --mperm 1000000 \  
      --out ./outputs/subset_1M_perm_result  
  
$ bash step2_3_permutation.sh  
  
	1000000 max(T) permutations complete.  
	Permutation test report written to  
	./outputs/subset_1M_perm_result.assoc.mperm .  
  
$ less ./outputs/subset_1M_perm_assoc_result.assoc.mperm  
  
 CHR          SNP         EMP1         EMP2   
   1   rs12563141       0.6586            1 			<-- I thought this was only chr22 SNPs...?  
   1   rs12124123       0.4984            1   
   1    rs2796343       0.4764            1   
 ...  
  
#### sort by pvalue  
  
	sort -gk 4 ./outputs/subset_1M_perm_result.assoc.mperm > ./outputs/chr22_assoc_sorted_by_pval.txt  
  
$ less ./outputs/chr22_assoc_sorted_by_pval.txt  
  
	 CHR          SNP         EMP1         EMP2   
	  22    rs8135996      0.06889       0.9066   
	   3    rs1457588        0.032       0.9137   
	   5   rs16874721       0.1003       0.9734   
	 ...  
  
  
#### plink permutation logistc  
  
$ vim step2_3_permutation.sh  
  
	plink --bfile ./outputs/HapMap_subset_chr22 \  
		  --covar ./outputs/covar_mds.txt \  
		  --logistic \  
		  --hide-covar \  
		  --mperm 1000000 \  
		  --out ./outputs/chr22_1M_perm_result  
  
$ bash step2_3_permutation.sh  
  
	./outputs/chr22_1M_perm_logistic_result.assoc.logistic ... done.  
	27136 permutations complete.  
	...  
	1000000 max(T) permutations complete.  
	Permutation test report written to ./outputs/chr22_1M_perm_result.assoc.logistic.mperm .  
  
  
#### sort by pvalue  
  
	sort -gk 4 ./outputs/chr22_1M_perm_result.assoc.logistic.mperm > ./outputs/chr22_logistic_sorted_by_pval.txt  
  
$ less ./outputs/chr22_logistic_sorted_by_pval.txt  
  
	 CHR          SNP         EMP1         EMP2   
	  14    rs2204979      0.04211       0.8605   
	   5   rs16874721      0.06878       0.9563   
	  22    rs8135996      0.06257       0.9576   
	 ...  
  
  
  
  
#------------------------------------------------------------#  
## manhattan and qq plots  
  
$ Rscript --no-save step3_Manhattan_plot.R  
$ Rscript --no-save step4_QQ_plot.R  
  
-rw-rw-r-- 1 hippopotamus hippopotamus  33K Jun  6 11:46 Logistic_manhattan.jpeg  
-rw-rw-r-- 1 hippopotamus hippopotamus  17K Jun  6 11:47 QQ-Plot_logistic.jpeg  
  
  
  
  
#------------------------------------------------------------#  
EOF

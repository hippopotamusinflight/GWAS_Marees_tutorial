steps to perform QC step of GWAS

2020_05_31_1547-GWAS_Marees_github_tutorial_1_QC_GWAS  
  
  
https://github.com/MareesAT/GWA_tutorial/  
  
#------------------------------------------------------------#  
## check out HapMap_3_r3_1  
  
  .bed (binary)  
  
#------------------------------  
.bim  
  
$ less -S HapMap_3_r3_1.bim  
  
	1       rs2185539       0       556738  T       C  
	1       rs11510103      0       557616  G       A  
	1       rs11240767      0       718814  T       C  
	...  
	25      rs5983854       0       154871186       G       T  
	25      rs2205598       0       154871731       G       A  
	25      rs3093449       0       154879211       A       G  
	25      rs1973881       0       154883690       G       A  
  
$ wc -l *.bim  
1,457,897						<-- SNPs  
  
#------------------------------  
.fam  
  
	1328 NA06989 0 0 2 2  
	1377 NA11891 0 0 1 2  
	1349 NA11843 0 0 1 1  
	1330 NA12341 0 0 2 2  
	1444 NA12739 NA12748 NA12749 1 -9  
	...  
	1444 NA12748 0 0 1 2  
	...  
	1444 NA12749 0 0 2 1				<-- so there's families ???  
	...  
	1346 NA12043 0 0 1 2  
	1375 NA12264 0 0 1 1  
	1349 NA10854 NA11839 NA11840 2 -9  
	1459 NA12865 NA12874 NA12875 2 -9  
  
$ wc -l *.fam  
165								<-- 165 subjects  
  
  
  
#------------------------------------------------------------#  
## step 1, individual and SNP missingness  
  
  
### generate missingness stats  
$ plink --bfile HapMap_3_r3_1 --missing --out ./outputs/step1_missingness/miss_stat  
PLINK v1.90b6.17 64-bit (28 Apr 2020)          www.cog-genomics.org/plink/1.9/  
(C) 2005-2020 Shaun Purcell, Christopher Chang   GNU General Public License v3  
Logging to ./outputs/miss_stat.log.  
Options in effect:  
  --bfile HapMap_3_r3_1  
  --missing  
  --out ./outputs/step1_missingness/miss_stat  
  
15938 MB RAM detected; reserving 7969 MB for main workspace.  
1457897 variants loaded from .bim file.  
165 people (80 males, 85 females) loaded from .fam.  
112 phenotype values loaded from .fam.  
Using 1 thread (no multithreaded calculations invoked).  
Before main variant filters, 112 founders and 53 nonfounders present.  
Calculating allele frequencies... done.  
Warning: 225 het. haploid genotypes present (see ./outputs/miss_stat.hh ); many  
commands treat these as missing.  
Total genotyping rate is 0.997378.  
--missing: Sample missing data report written to ./outputs/miss_stat.imiss, and  
variant-based missing data report written to ./outputs/miss_stat.lmiss.  
  
#------------------------------  
$ less miss_stat.hh					<-- het. haploid ???  
  
	1355    NA12413 rs2034740  
	1355    NA12413 rs6641142  
	1355    NA12413 rs7059273  
	...  
  
$ wc -l miss_stat.hh  
225							<-- number of SNPs missing genotypes  
  
#------------------------------  
$ less miss_stat.imiss  
  
	FID       IID MISS_PHENO   N_MISS   N_GENO   F_MISS  
  1328   NA06989          N     4203  1457897 0.002883  
  1377   NA11891          N    20787  1457897  0.01426  
  1349   NA11843          N     1564  1457897 0.001073  
	...  
  
$ awk '$6!=0' miss_stat.imiss | wc -l  
166							<-- all subjects have at least 1 missing genotype  
  
#------------------------------  
$ less miss_stat.lmiss  
  
	 CHR         SNP   N_MISS   N_GENO   F_MISS  
	   1   rs2185539        0      165        0  
	   1  rs11510103        4      165  0.02424  
	   1  rs11240767        0      165        0  
	...  
  
$ $ awk '$3!=0' miss_stat.lmiss | wc -l  
375856						<-- number of SNPs with at least 1 person missing it  
  
  
### plot missingness histograms  
$ Rscript --no-save hist_miss.R  
pdf   
  2   
  
	histimiss.pdf  
	histlmiss.pdf  
  
  
### remove SNPs with > 20% missing  
$ plink --bfile HapMap_3_r3_1 --geno 0.2 --make-bed --out ./outputs/step1_missingness/HapMap_3_r3_2  
...  
1457897 variants loaded from .bim file.  
...  
1457897 variants and 165 people pass filters and QC. { didn't remove any SNPs }  
  
  
### remove individuals with > 20% missing  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_2 --mind 0.2 --make-bed --out ./outputs/step1_missingness/HapMap_3_r3_3  
...  
165 people (80 males, 85 females) loaded from .fam.  
...  
1457897 variants and 165 people pass filters and QC.  
  
  
### remove SNPs with > 2% missing  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_3 --geno 0.02 --make-bed --out ./outputs/step1_missingness/HapMap_3_r3_4  
...  
1457897 variants loaded from .bim file.  
...  
27454 variants removed due to missing genotype data (--geno).  
1430443 variants and 165 people pass filters and QC.  
  
  
### remove individuals with > 20% missing  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_4 --mind 0.02 --make-bed --out ./outputs/step1_missingness/HapMap_3_r3_5  
...  
165 people (80 males, 85 females) loaded from .fam.  
...  
1430443 variants and 165 people pass filters and QC.  
  
  
### check missingness stats after removal  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_5 --missing --out ./outputs/step1_missingness/miss_stat_after  
  
$ wc -l miss_stat_after.hh  
179								<-- 179 SNPs still have some individuals missing genotypes  
  
$ awk '$6!=0' miss_stat_after.imiss | wc -l  
166								<-- all patients still have at least 1 missing genotype  
  
$ awk '$3!=0' miss_stat_after.lmiss | wc -l  
348402							<-- still 348,402 SNPs with at least 1 person missing it  
  
  
### plot missingness histograms after removal  
$ Rscript --no-save step1_hist_miss_after.R  
  
	histimiss_after.pdf  
	histlmiss_after.pdf  
  
  
  
#------------------------------------------------------------#  
## step 2, check sex discrepancy  
  
$ mkdir step2_sex_discrepancy  
  
  
### check sex discrepancy  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_5 --check-sex --out ./outputs/step2_sex_discrepancy/HapMap_3_r3  
$ less HapMap_3_r3.sexcheck  
    FID       IID       PEDSEX       SNPSEX       STATUS            F  
   1328   NA06989            2            2           OK     -0.01184  
   1377   NA11891            1            1           OK            1  
   1349   NA11843            1            1           OK            1  
   1330   NA12341            2            2           OK     -0.01252	<-- what F score = discrepancy ???  
	...  
  
### visualize sex-check results  
$ Rscript --no-save step2_gender_check.R  
  
  
### delete individuals with STATUS = PROBLEM  
  
$ awk '$3!=$4' HapMap_3_r3.sexcheck   
    FID       IID       PEDSEX       SNPSEX       STATUS            F  
   1349   NA10854            2            1      PROBLEM         0.99	<-- one subject has sex discrepency  
  
$ grep "PROBLEM" ./outputs/step2_sex_discrepancy/HapMap_3_r3.sexcheck | awk '{print$1,$2}' > ./outputs/step2_sex_discrepancy/sex_discrepancy.txt  
$ less sex_discrepancy.txt  
	1349 NA10854  
  
  
$ plink --bfile ./outputs/step1_missingness/HapMap_3_r3_5 --remove ./outputs/step2_sex_discrepancy/sex_discrepancy.txt --make-bed --out ./outputs/step2_sex_discrepancy/HapMap_3_r3_6  
  
	HapMap_3_r3_6.bed  
	HapMap_3_r3_6.bim  
	HapMap_3_r3_6.fam  
  
  
### can also impute sex   
(plink --bfile HapMap_3_r3_5 --impute-sex --make-bed --out HapMap_3_r3_6)  
  
  
  
#------------------------------------------------------------#  
## step 3, autosomes only, subset MAF  
  
$ mkdir step3_autosome_MAF  
  
### autosome only  
  
#### method 1  
- make text file of all SNPs in chr 1 to 22  
$ awk '{ if ($1 >= 1 && $1 <= 22) print $2 }' ./outputs/step2_sex_discrepancy/HapMap_3_r3_6.bim > ./outputs/step3_autosome_MAF/snp_1_22.txt  
  
$ plink --bfile ./outputs/step2_sex_discrepancy/HapMap_3_r3_6 --extract ./outputs/step3_autosome_MAF/snp_1_22.txt --make-bed --out ./outputs/step3_autosome_MAF/HapMap_3_r3_7_method1  
...  
1430443 variants loaded from .bim file.  
...  
1398544 variants and 164 people pass filters and QC.  
  
  
#### method 2  
- or just use --chr 1-22 flag (https://www.cog-genomics.org/plink/1.9/filter)  
  
$ plink --bfile ./outputs/step2_sex_discrepancy/HapMap_3_r3_6 --chr 1-22 --make-bed --out ./outputs/step3_autosome_MAF/HapMap_3_r3_7_method2  
...  
1398544 out of 1430443 variants loaded from .bim file.  
...  
1398544 variants and 164 people pass filters and QC.  
  
  
### subset by MAF  
  
#### check MAF distribution  
$ plink --bfile ./outputs/step3_autosome_MAF/HapMap_3_r3_7_method2 --freq --out ./outputs/step3_autosome_MAF/MAF_check  
$ Rscript --no-save step3_MAF_check.R  
	MAF_distribution.pdf				<-- woah, majority near 0.00  
  
#### subset  
$ plink --bfile ./outputs/step3_autosome_MAF/HapMap_3_r3_7_method2 --maf 0.05 --make-bed --out ./outputs/step3_autosome_MAF/HapMap_3_r3_8  
...  
325318 variants removed due to minor allele threshold(s)  
...  
1073226 variants and 164 people pass filters and QC.  
  
  
  
#------------------------------------------------------------#  
## step 4, HWE  
  
$ mkdir step4_hwe  
  
### get HWE stats  
  
$ plink --bfile ./outputs/step3_autosome_MAF/HapMap_3_r3_8 --hardy --out ./outputs/step4_hwe/HapMap_3_r3  
$ less HapMap_3_r3.hwe  
	 CHR         SNP     TEST   A1   A2                 GENO   O(HET)   E(HET)            P   
	   1   rs3131972      ALL    A    G              2/33/77   0.2946   0.2758       0.7324  
	   1   rs3131972      AFF    A    G              1/19/36   0.3393   0.3047        0.667  
	   1   rs3131972    UNAFF    A    G              1/14/41     0.25   0.2449            1  
	...  
  
  
### plot HWE stats  
- select rows with HWE p-value < 0.00001 { really significant deviation from HWE }  
  
$ awk '{ if ($9 <0.00001) print $0 }' ./outputs/step4_hwe/HapMap_3_r3.hwe > ./outputs/step4_hwe/plink_zoom_hwe.hwe  
$ Rscript --no-save step4_hwe.R  
	histhwe_lower_than_theshold.pdf  
	histhwe.pdf  
  
  
### filter hwe for controls  
- by default --hwe only filters controls, so no need to specify cases  
- stringent p-value of 1e-6  
  
$ plink --bfile ./outputs/step3_autosome_MAF/HapMap_3_r3_8 --hwe 1e-6 --make-bed --out ./outputs/step4_hwe/HapMap_hwe_filter_step1  
...  
1073226 variants loaded from .bim file.  
...  
--hwe: 0 variants removed due to Hardy-Weinberg exact test.  
1073226 variants and 164 people pass filters and QC.  
  
  
### filter hwe for case  
- use --hwe-all to specify both cases and controls  
- less stringent p-value of 1e-10 (removes less SNPs)  
  
$ plink --bfile ./outputs/step4_hwe/HapMap_hwe_filter_step1 --hwe 1e-10 --hwe-all --make-bed --out ./outputs/step4_hwe/HapMap_3_r3_9  
(Note: --hwe-all flag deprecated.  Use "--hwe include-nonctrl".)  
  
$ plink --bfile ./outputs/step4_hwe/HapMap_hwe_filter_step1 --hwe 1e-10 include-nonctrl --make-bed --out ./outputs/step4_hwe/HapMap_3_r3_9  
{ identical output as --hwe-all }  
  
	HapMap_3_r3_9.bed  
	HapMap_3_r3_9.bim  
	HapMap_3_r3_9.fam  
  
  
  
#------------------------------------------------------------#  
## step 5, extreme heterozygosity  
  
$ mkdir step5_extreme_het  
  
### exclude high inversion regions and LD prune  
- inversions affects recombination in heterozygotes somehow... (https://doi.org/10.1371/journal.pbio.1000501)  
- not sure if causes extremely low or high heterozygosity...  
- but exclude these regions so won't affect calculation of heterozygosity mean  
  
$ plink --bfile ./outputs/step4_hwe/HapMap_3_r3_9 --exclude step5_inversion.txt --range --indep-pairwise 50 5 0.2 --out ./outputs/step5_extreme_het/indepSNP  
  
	indepSNP.log  
	indepSNP.prune.in  
	indepSNP.prune.out  
  
  
### extract pruned in SNPs  
  
$ plink --bfile ./outputs/step4_hwe/HapMap_3_r3_9 --extract ./outputs/step5_extreme_het/indepSNP.prune.in --het --out ./outputs/step5_extreme_het/R_check  
...  
1073226 variants loaded from .bim file.  
...  
104144 variants and 164 people pass filters and QC.  
  
  
### plot het rate distribution  
  
$ Rscript --no-save step5_check_heterozygosity_rate.R  
  
- spread is pretty tight, 0.335 to 0.365, mean around 0.355  
  
  
### get list of individuals +/- 3SD from het rate mean  
  
$ Rscript --no-save step5_heterozygosity_outliers_list.R  
$ less fail-het-qc.txt  
  
	"FID" "IID" "O.HOM." "E.HOM." "N.NM." "F" "HET_RATE" "HET_DST"  
	1330 "NA12342" 68049 67240 103571 0.02229 0.342972453679119 -3.66711854374478  
	1459 "NA12874" 68802 67560 104068 0.0339 0.338874582004074 -5.04839854982741  
  
$ sed 's/"// g' ./outputs/step5_extreme_het/fail-het-qc.txt | awk '{print$1, $2}'> ./outputs/step5_extreme_het/het_fail_ind.txt  
$ less het_fail_ind.txt  
  
	FID IID  
	1330 NA12342  
	1459 NA12874  
  
  
### remove het rate outliers  
  
$ plink --bfile ./outputs/step4_hwe/HapMap_3_r3_9 --remove ./outputs/step5_extreme_het/het_fail_ind.txt --make-bed --out ./outputs/step5_extreme_het/HapMap_3_r3_10  
...  
164 people (80 males, 84 females) loaded from .fam.  
...  
1073226 variants and 162 people pass filters and QC.  
  
  
  
#------------------------------------------------------------#  
## step 6, check cryptic relatedness  
  
$ mkdir step6_relatedness  
  
### check relatedness (pihat > 0.2)  
- using LD pruned in SNPs only  
  
$ plink --bfile ./outputs/step5_extreme_het/HapMap_3_r3_10 --extract ./outputs/step5_extreme_het/indepSNP.prune.in --genome --min 0.2 --out ./outputs/step6_relatedness/pihat_min0.2  
...  
IBD calculations complete.    
  
$ less pihat_min0.2  
  
   FID1     IID1   FID2     IID2 RT    EZ      Z0      Z1      Z2  PI_HAT PHE       DST     PPC   RATIO  
   1377  NA11891   1377  NA10865 PO   0.5  0.0013  0.9977  0.0010  0.4998   0  0.823854  1.0000 3611.0000  
   1349  NA11843   1349  NA10853 PO   0.5  0.0021  0.9905  0.0073  0.5026  -1  0.824896  1.0000 926.5000  
   1330  NA12341   1330  NA12335 PO   0.5  0.0000  1.0000  0.0000  0.5000   0  0.822874  1.0000 924.2500  
   1444  NA12739   1444  NA12749 PO   0.5  0.0018  0.9946  0.0037  0.5010  -1  0.824290  1.0000      NA  
	...  
  
  
### family relations  
- {ah so we do have to deal with family relations}  
  
$ awk '{ if ($8 > 0.9) print $0 }' ./outputs/step6_relatedness/pihat_min0.2.genome > ./outputs/step6_relatedness/zoom_pihat.genome  
$ less zoom_pihat.genome  
  
   FID1     IID1   FID2     IID2 RT    EZ      Z0      Z1      Z2  PI_HAT PHE       DST     PPC   RATIO  
   1377  NA11891   1377  NA10865 PO   0.5  0.0013  0.9977  0.0010  0.4998   0  0.823854  1.0000 3611.0000  
   1349  NA11843   1349  NA10853 PO   0.5  0.0021  0.9905  0.0073  0.5026  -1  0.824896  1.0000 926.5000  
   1330  NA12341   1330  NA12335 PO   0.5  0.0000  1.0000  0.0000  0.5000   0  0.822874  1.0000 924.2500  
   1444  NA12739   1444  NA12749 PO   0.5  0.0018  0.9946  0.0037  0.5010  -1  0.824290  1.0000      NA  
	...  
	  
  
### visualize relatedness  
  
Rscript --no-save step6_relatedness.R  
  
- blue = PO = parent offspring  
- green = UN = unrelated  
  
  
### include founders only  
- founders = offsprings (no parents)  
- in tutorial, treating family as cryptic relatedness (normally would use family based GWAS)  
  
$ plink --bfile ./outputs/step5_extreme_het/HapMap_3_r3_10 --filter-founders --make-bed --out ./outputs/step6_relatedness/HapMap_3_r3_11  
...  
162 people (78 males, 84 females) loaded from .fam.  
...  
Before main variant filters, 110 founders and 0 nonfounders present.  
...  
1073226 variants and 110 people pass filters and QC.  
  
  
### check relatedness again (pihat > 0.2)  
  
$ plink --bfile ./outputs/step6_relatedness/HapMap_3_r3_11 --extract ./outputs/step5_extreme_het/indepSNP.prune.in --genome --min 0.2 --out ./outputs/step6_relatedness/pihat_min0.2_in_founders  
$ less pihat_min0.2_in_founders  
  
   FID1     IID1   FID2     IID2 RT    EZ      Z0      Z1      Z2  PI_HAT PHE       DST     PPC   RATIO  
  13291  NA07045   1454  NA12813 UN    NA  0.2572  0.5007  0.2421  0.4924   0  0.839777  1.0000  9.7022  
  
- only 1 pair with pihat > 0.2  
- based on Z values, look like full sibs or DZ twins (although curious not same family ID)  
- https://www.cog-genomics.org/plink/1.9/ibd  
	Z0	P(IBD=0)  
	Z1	P(IBD=1)  
	Z2	P(IBD=2)  
	PI_HAT	Proportion IBD, i.e. P(IBD=2) + 0.5*P(IBD=1)  
  
  
### check which of pair to remove based on call rate  
  
$ plink --bfile ./outputs/step6_relatedness/HapMap_3_r3_11 --missing --out ./outputs/step6_relatedness/missing_pheno  
$ less missing_pheno.imiss  
  
  13291   NA07045          N     2552  1073226 0.002378		<-- higher rate of missing, remove  
	...  
   1454   NA12813          N     1947  1073226 0.001814  
  
  
### make remove file and remove  
  
$ vim ./outputs/step6_relatedness/0.2_low_call_rate_pihat.txt  
  
	13291   NA07045  
  
$ plink --bfile ./outputs/step6_relatedness/HapMap_3_r3_11 --remove ./outputs/step6_relatedness/0.2_low_call_rate_pihat.txt --make-bed --out ./outputs/step6_relatedness/HapMap_3_r3_12  
...  
1073226 variants and 109 people pass filters and QC.  
  
  
  
#------------------------------------------------------------#  
## next part = MDS  
  
will need  
  
../1_QC_GWAS/outputs/step6_relatedness/HapMap_3_r3_12  
../1_QC_GWAS/outputs/step5_extreme_het/indepSNP.prune.in  
  
  
  
  
#------------------------------------------------------------#  
EOF

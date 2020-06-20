steps to perform population stratification


https://github.com/MareesAT/GWA_tutorial/  
  
#------------------------------------------------------------#  
## copy over plink bed files and prune.in file  
  
$ cd 2_Population_stratification  
$ vim step0_copy_GWASqc_outputs.sh  
  
	mkdir -p ./outputs  
  
	cp ../1_QC_GWAS/outputs/step6_relatedness/HapMap_3_r3_12.* ./outputs  
	cp ../1_QC_GWAS/outputs/step5_extreme_het/indepSNP.prune.in ./outputs  
  
  
  
#------------------------------------------------------------#  
## prep 1000genomes  
  
  
### download .vcf  
- downloaded into /home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/  
  
resources$ wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/release/20100804/ALL.2of4intersection.20100804.genotypes.vcf.gz  
  
  
  
### bcftools stat 1000genomes .vcf  
  
resources$ bcftools stats ALL.2of4intersection.20100804.genotypes.vcf.gz  
  
	# Definition of sets:  
	# ID	[2]id	[3]tab-separated file names  
	ID	0	ALL.2of4intersection.20100804.genotypes.vcf.gz  
	...  
	# SN, Summary numbers:  
	#   number of records   .. number of data rows in the VCF  
	#   number of no-ALTs   .. reference-only sites, ALT is either "." or identical to REF  
	#   number of SNPs      .. number of rows with a SNP  
	#   number of MNPs      .. number of rows with a MNP, such as CC>TT  
	#   number of indels    .. number of rows with an indel  
	#   number of others    .. number of rows with other type, for example a symbolic allele or  
	#                          a complex substitution, such as ACT>TCGA  
	#   number of multiallelic sites     .. number of rows with multiple alternate alleles  
	#   number of multiallelic SNP sites .. number of rows with multiple alternate alleles, all SNPs  
	#   
	#   Note that rows containing multiple types will be counted multiple times, in each  
	#   counter. For example, a row with a SNP and an indel increments both the SNP and  
	#   the indel counter.  
	#   
	# SN	[2]id	[3]key	[4]value  
	SN	0	number of samples:	629  
	SN	0	number of records:	25488488  
	SN	0	number of no-ALTs:	9  
	SN	0	number of SNPs:	25488479  
	SN	0	number of MNPs:	0  
	SN	0	number of indels:	0  
	SN	0	number of others:	0  
	SN	0	number of multiallelic sites:	496  
	SN	0	number of multiallelic SNP sites:	496  
	# TSTV, transitions/transversions:  
	# TSTV	[2]id	[3]ts	[4]tv	[5]ts/tv	[6]ts (1st ALT)	[7]tv (1st ALT)	[8]ts/tv (1st ALT)  
	TSTV	0	17555838	7933137	2.21	17555838	7932641	2.21  
	# SiS, Singleton stats:  
	# SiS	[2]id	[3]allele count	[4]number of SNPs	[5]number of transitions	[6]number of transversions	[7]number of indels	[8]repeat-consistent	[9]repeat-inconsistent	[10]not applicable  
	SiS	0	1	25488975	17555838	7933137	0	0	0	0  
	# AF, Stats by non-reference allele frequency:  
	# AF	[2]id	[3]allele frequency	[4]number of SNPs	[5]number of transitions	[6]number of transversions	[7]number of indels	[8]repeat-consistent	[9]repeat-inconsistent	[10]not applicable  
	AF	0	0.000000	25488975	17555838	7933137	0	0	0	0  
	# QUAL, Stats by quality:  
	# QUAL	[2]id	[3]Quality	[4]number of SNPs	[5]number of transitions (1st ALT)	[6]number of transversions (1st ALT)	[7]number of indels  
	QUAL	0	998	25488479	17555838	7932641	0  
	# IDD, InDel distribution:  
	# IDD	[2]id	[3]length (deletions negative)	[4]number of sites	[5]number of genotypes	[6]mean VAF  
	# ST, Substitution types:  
	# ST	[2]id	[3]type	[4]count  
	ST	0	A>C	897210  
	ST	0	A>G	3632505  
	ST	0	A>T	833879  
	ST	0	C>A	1129650  
	ST	0	C>G	1105949  
	ST	0	C>T	5147569  
	ST	0	G>A	5151052  
	ST	0	G>C	1103814  
	ST	0	G>T	1132177  
	ST	0	T>A	833020  
	ST	0	T>C	3624712  
	ST	0	T>G	897438  
	# DP, Depth distribution  
	# DP	[2]id	[3]bin	[4]number of genotypes	[5]fraction of genotypes (%)	[6]number of sites	[7]fraction of sites (%)  
	DP		0	    3	    0	                    0.000000	                    3	                0.000012  
	DP		0	    4	    0	                    0.000000	                    3	                0.000012  
	DP		0	    5	    0	                    0.000000	                    5	                0.000020  
	...                                                                  
	DP		0	    499	    0	                    0.000000	                    491	                0.001926  
	  
	DP		0	    500	    0	                    0.000000	                    517	                0.002028  
	DP		0	    >500	0	                    0.000000	                    25318936	        99.334790  
  
  
  
### convert to plink bed format  
  
$ vim step1_prep1000genomes.sh  
  
	resources_dir="/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/"  
	plink --vcf ${resources_dir}ALL.2of4intersection.20100804.genotypes.vcf.gz \  
		  --make-bed --out ${resources_dir}ALL.2of4intersection.20100804.genotypes  
  
$ bash step1_prep1000genomes.sh  
	  
	...  
	Before main variant filters, 629 founders and 0 nonfounders present.  
	Calculating allele frequencies... done.  
	Total genotyping rate is 0.615305.  
	25488488 variants and 629 people pass filters and QC.  
	Note: No phenotypes present.  
	--make-bed to  
	/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/ALL.2of4intersection.20100804.genotypes.bed  
	+  
	/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/ALL.2of4intersection.20100804.genotypes.bim  
	+  
	/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/ALL.2of4intersection.20100804.genotypes.fam  
	... done.  
  
resources$ less -S ALL.2of4intersection.20100804.genotypes.bim  
  
	1       rs112750067     0       10327   C       T  
	1       rs117577454     0       10469   G       C  
	1       rs55998931      0       10492   T       C  
	1       rs58108140      0       10583   A       G  
	1       .       		0       11508   A       G  
	1       .       		0       11565   T       G  
	1       .       		0       12783   G       A  
  
  
  
### assign SNPs with missing rsID an unique ID  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}ALL.2of4intersection.20100804.genotypes \  
		  --set-missing-var-ids @:#[b37]\$1,\$2 \  
		  --make-bed --out ${resources_dir}ALL.2of4intersection.20100804.genotypes_no_missing_IDs  
  
$ bash step1_prep1000genomes.sh  
  
	25488488 variants loaded from .bim file.  
	10375501 missing IDs set.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	Total genotyping rate is 0.615305.  
	25488488 variants and 629 people pass filters and QC.  
  
resources$ less -S ALL.2of4intersection.20100804.genotypes_no_missing_IDs.bim  
  
	1       rs112750067     0       10327   C       T  
	1       rs117577454     0       10469   G       C  
	1       rs55998931      0       10492   T       C  
	1       rs58108140      0       10583   A       G  
	1       1:11508[b37]A,G 0       11508   A       G			{ @:#[b37]\$1,\$2 }  
	1       1:11565[b37]G,T 0       11565   T       G  
	1       1:12783[b37]A,G 0       12783   G       A  
  
  
  
### removes variants with >0.2 missing  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}ALL.2of4intersection.20100804.genotypes_no_missing_IDs \  
		  --geno 0.2 \  
		  --allow-no-sex \  
		  --make-bed --out 1kG_MDS  
	  
$ bash step1_prep1000genomes.sh   
  
	...  
	25488488 variants loaded from .bim file.  
	...  
	16481066 variants removed due to missing genotype data (--geno).  
	9007422 variants and 629 people pass filters and QC.  
  
  
  
### remove individuals with >0.2 missing  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}1kG_MDS \  
		  --mind 0.2 \  
		  --allow-no-sex \  
		  --make-bed --out ${resources_dir}1kG_MDS2  
  
$ bash step1_prep1000genomes.sh   
  
	9007422 variants loaded from .bim file.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	9007422 variants and 629 people pass filters and QC.  
  
  
  
### removes variants with >0.02 missing  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}1kG_MDS2 \  
		  --geno 0.02 \  
		  --allow-no-sex \  
		  --make-bed --out ${resources_dir}1kG_MDS3  
  
$ bash step1_prep1000genomes.sh   
  
	9007422 variants loaded from .bim file.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	766677 variants removed due to missing genotype data (--geno).  
	8240745 variants and 629 people pass filters and QC.  
  
  
  
### remove individuals with >0.02 missing  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}1kG_MDS3 \  
		  --mind 0.02 \  
		  --allow-no-sex \  
		  --make-bed --out ${resources_dir}1kG_MDS4  
  
$ bash step1_prep1000genomes.sh   
  
	8240745 variants loaded from .bim file.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	8240745 variants and 629 people pass filters and QC.  
  
  
  
### subset by MAF  
  
$ vim step1_prep1000genomes.sh  
  
	plink --bfile ${resources_dir}1kG_MDS4 \  
		  --maf 0.05 \  
		  --allow-no-sex \  
		  --make-bed --out ${resources_dir}1kG_MDS5  
  
$ bash step1_prep1000genomes.sh   
  
8240745 variants loaded from .bim file.  
629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
...  
2432435 variants removed due to minor allele threshold(s)  
(--maf/--max-maf/--mac/--max-mac).  
5808310 variants and 629 people pass filters and QC.  
  
  
  
  
#------------------------------------------------------------#  
## prep 1000 genomes for merging  
  
### extract HapMap variants from 1kG files  
  
$ vim step2_prep1000genomes_for_merging.sh  
  
	awk '{print$2}' ./outputs/HapMap_3_r3_12.bim > ./outputs/HapMap_SNPs.txt  
	plink --bfile ${resources_dir}1kG_MDS5 \  
		  --extract ./outputs/HapMap_SNPs.txt \  
		  --make-bed --out ${resources_dir}1kG_MDS6  
  
$ bash step2_prep1000genomes_for_merging.sh  
  
	5808310 variants loaded from .bim file.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	1000993 variants and 629 people pass filters and QC.  
  
  
  
### extract 1kG variants from HapMap files  
  
$ vim step2_prep1000genomes_for_merging.sh  
  
	awk '{print$2}' ${resources_dir}1kG_MDS6.bim > ${resources_dir}1kG_MDS6_SNPs.txt  
	plink --bfile ./outputs/HapMap_3_r3_12 \  
		  --extract ${resources_dir}1kG_MDS6_SNPs.txt \  
		  --recode \										<-- gives .map and .ped files  
		  --make-bed --out ./outputs/HapMap_MDS  
  
$ bash step2_prep1000genomes_for_merging.sh  
  
	1073226 variants loaded from .bim file.  
	109 people (55 males, 54 females) loaded from .fam.  
	--extract: 1000993 variants remaining.  
	...  
	1000993 variants and 109 people pass filters and QC.	<-- is this step really necessary?   
																extract HapMap variants from 1kG files   
																already found intersection btw HapMap and 1kG...  
  
  
### change 1kG build to HapMap's build (update SNP coordinates)  
  
#### get HapMap build map  
  
$ vim step2_prep1000genomes_for_merging  
  
	awk '{print$2,$4}' ./outputs/HapMap_MDS.map > ./outputs/buildhapmap.txt  
  
outputs$ less buildhapmap.txt   
  
	rs3131969 744045					{ e.g. in 1kG_MDS6, it's "1	rs3131969	0	754182		A	G"}  
	rs1048488 750775  
	rs12562034 758311  
	...  
  
  
#### update 1kG build map  
  
$ vim step2_prep1000genomes_for_merging  
  
	plink --bfile ${resources_dir}1kG_MDS6 \  
		  --update-map ./outputs/buildhapmap.txt \  
		  --make-bed --out ${resources_dir}1kG_MDS7  
  
$ bash step2_prep1000genomes_for_merging  
  
	1000993 variants loaded from .bim file.  
	629 people (0 males, 0 females, 629 ambiguous) loaded from .fam.  
	...  
	--update-map: 1000993 values updated.  
	...  
	1000993 variants and 629 people pass filters and QC.  
  
resources$ less 1kG_MDS7.bim  
  
	1       rs3131969       0       744045  A       G  
	1       rs1048488       0       750775  C       T  
	1       rs12562034      0       758311  A       G  
	...  
  
  
  
  
#------------------------------------------------------------#  
## QC before merging  
  
### set reference allele for HapMap to 1kG's  
  
$ vim step3_qc_before_merging.sh   
  
	awk '{print$2,$5}' ${resources_dir}1kG_MDS7.bim > ${resources_dir}1kg_ref-list.txt  
	plink --bfile ./outputs/HapMap_MDS \  
		  --reference-allele ${resources_dir}1kg_ref-list.txt \  
		  --make-bed --out ./outputs/HapMap-adj  
  
$ bash step3_qc_before_merging.sh  
  
	1000993 variants loaded from .bim file.  
	...  
	Warning: Impossible A1 allele assignment for variant rs11488462.  
	Warning: Impossible A1 allele assignment for variant rs4648786.  
	Warning: Impossible A1 allele assignment for variant rs28635343.  
	...  
	Warning: Impossible A1 allele assignment for variant rs4074135.  
	--a1-allele: 1000993 assignments made.  
	1000993 variants and 109 people pass filters and QC.  
  
  
(  
HapMap_MDS.bim			1       rs11488462      0       1343243 G       A  
HapMap-adj.bim			1       rs11488462      0       1343243 G       A  
  
HapMap_MDS.bim			1       rs4648786       0       1511668 C       T  
HapMap-adj.bim			1       rs4648786       0       1511668 C       T  
  
HapMap_MDS.bim			1       rs28635343      0       1549966 A       G  
HapMap-adj.bim			1       rs28635343      0       1549966 A       G  
  
  
	so... all warning are when there's no change???  
)  
  
  
  
### resolve strand issues  
  
#### potential strand issues  
  
$ vim step3_qc_before_merging.sh   
  
	awk '{print$2,$5,$6}' ${resources_dir}1kG_MDS7.bim > ${resources_dir}1kGMDS7_tmp  
	awk '{print$2,$5,$6}' ./outputs/HapMap-adj.bim > ./outputs/HapMap-adj_tmp  
	sort ${resources_dir}1kGMDS7_tmp ./outputs/HapMap-adj_tmp | uniq -u > ./outputs/all_differences_HapMapAdj_vs_1kGMDS7.txt  
  
$ bash step3_qc_before_merging.sh  
  
$ less outputs/all_differences_HapMapAdj_vs_1kGMDS7.txt  
  
	rs10006274 C T			{ 1kGMDS7.bim  
	rs10006274 G A			  HapMap-adj.bim		<-- first pair looks like different strand issue  
	rs10060593 A T			  ... }  
	rs10060593 C T									<-- this pair doesn't look like diff strand issue  
	...  
  
  
#### get list of SNPs to be strand flipped  
  
$ vim step3_qc_before_merging.sh   
  
	awk '{print$1}' all_differences_HapMapAdj_vs_1kGMDS7.txt | sort -u > SNPs_to_be_flipped_list.txt  
  
$ bash step3_qc_before_merging.sh  
  
$ less outputs/SNPs_to_be_flipped_list.txt  
  
	rs10006274  
	rs10060593  
	rs10083559  
	...  
  
$ wc -l outputs/SNPs_to_be_flipped_list.txt   
812			{ 812 SNPs to flip }  
  
  
#### flip strand for HapMap-adj  
  
$ vim step3_qc_before_merging.sh   
  
	plink --bfile ./outputs/HapMap-adj \  
		  --flip ./outputs/SNPs_to_be_flipped_list.txt \  
		  --reference-allele ${resources_dir}1kg_ref-list.txt \  
		  --make-bed --out ./outputs/corrected_hapmap  
  
$ bash step3_qc_before_merging.sh  
$ less ./outputs/corrected_hapmap  
  
	1       rs3131969       0       744045  	A       G  
	1       rs1048488       0       750775  	C       T  
	1       rs12562034      0       758311  	A       G  
	...  
	4       rs10006274      0       124165369	C       T  
	...  
	5       rs10060593      0       1061660 	A       G  
	...  
  
  
#### re-compare 1kG_MDS7.bim vs corrected_hapmap.bim  
  
$ vim step3_qc_before_merging.sh   
  
	awk '{print$2,$5,$6}' ./outputs/corrected_hapmap.bim > ./outputs/corrected_hapmap_tmp  
	sort ${resources_dir}1kGMDS7_tmp ./outputs/corrected_hapmap_tmp | uniq -u  > ./outputs/uncorresponding_SNPs.txt  
  
$ bash step3_qc_before_merging.sh  
  
$ less ./outputs/uncorresponding_SNPs.txt  
  
	rs10060593 A G  
	rs10060593 A T  
	rs10083559 T C  
	rs10083559 T G  
	rs10116901 C A  
	...  
  
$ wc -l ./outputs/uncorresponding_SNPs.txt   
84					{ 42 pairs still do not match, must remove }  
  
  
#### remove problematic SNPs  
  
$ vim step3_qc_before_merging.sh   
  
	awk '{print$1}' ./outputs/uncorresponding_SNPs.txt | sort -u > ./outputs/SNPs_for_exlusion.txt  
  
	plink --bfile ./outputs/corrected_hapmap \  
		  --exclude ./outputs/SNPs_for_exlusion.txt \  
		  --make-bed --out ./outputs/HapMap_MDS2  
	plink --bfile ${resources_dir}1kG_MDS7 \  
		  --exclude ./outputs/SNPs_for_exlusion.txt \  
		  --make-bed --out ${resources_dir}1kG_MDS8  
  
$ bash step3_qc_before_merging.sh  
  
	...  
	1000951 variants and 109 people pass filters and QC.		{ was 1000993, - 42 }  
	...  
	1000951 variants and 629 people pass filters and QC.  
	...  
  
  
  
  
#------------------------------------------------------------#  
## merging 1kG_MDS8 and ownData  
  
$ vim step4_merge_1kG_ownData.sh   
  
	plink --bfile ./outputs/HapMap_MDS2 \  
		  --bmerge ${resources_dir}1kG_MDS8 \  
		  --allow-no-sex \  
		  --make-bed --out ./outputs/MDS_merge2  
  
$ bash step4_merge_1kG_ownData.sh   
  
	109 people loaded from ./outputs/HapMap_MDS2.fam.  
	629 people to be merged from  
	...  
	738 people (55 males, 54 females, 629 ambiguous) loaded from .fam.  
  
  
  
  
#------------------------------------------------------------#  
## run plink MDS with ownData, anchored by 1000 genomes  
  
$ vim step5_run_plinkMDS.sh  
  
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
  
$ bash step5_run_plinkMDS.sh   
  
1000951 variants loaded from .bim file.  
738 people (55 males, 54 females, 629 ambiguous) loaded from .fam.  
...  
--extract: 93331 variants remaining.			{ why only using these variants??? }  
...  
IBD calculations complete.    
  
Clustering... done.                          
Cluster solution written to ./outputs/MDS_merge2.cluster1 ,  
./outputs/MDS_merge2.cluster2 , and ./outputs/MDS_merge2.cluster3 .  
Performing multidimensional scaling analysis (SVD algorithm, 10  
dimensions)... done.  
MDS solution written to ./outputs/MDS_merge2.mds .  
  
  
  
  
#------------------------------------------------------------#  
## prep ethnicity files  
  
  
### download 1000 genomes ethnicity info  
  
$ vim step6_download_1kG_ethnicity_info.sh   
  
	wget -P ${resources_dir} ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20100804/20100804.ALL.panel  
  
$ bash step6_download_1kG_ethnicity_info.sh  
  
	20100804.ALL.panel                           100%[============================================================================================>]  13.18K  24.8KB/s    in 0.5s      
  
	2020-06-05 17:10:38 (24.8 KB/s) - ‘/home/hippopotamus/Desktop/HippoStorage/M32/GWAS_analysis/resources/20100804.ALL.panel’ saved [13499]  
  
resources$ less 20100804.ALL.panel  
  
	HG00098 GBR     ILLUMINA  
	HG00100 GBR     ILLUMINA  
	HG00106 GBR     ILLUMINA  
	...  
  
  
### convert population code to super-population codes  
  
$ vim step6_download_1kG_ethnicity_info.sh   
  
	awk '{print$1,$1,$2}' ${resources_dir}20100804.ALL.panel > ${resources_dir}race_1kG1.txt  
	sed 's/JPT/ASN/g' ${resources_dir}race_1kG1.txt > ${resources_dir}race_1kG2.txt  
	sed 's/ASW/AFR/g' ${resources_dir}race_1kG2.txt > ${resources_dir}race_1kG3.txt  
	sed 's/CEU/EUR/g' ${resources_dir}race_1kG3.txt > ${resources_dir}race_1kG4.txt  
	sed 's/CHB/ASN/g' ${resources_dir}race_1kG4.txt > ${resources_dir}race_1kG5.txt  
	sed 's/CHD/ASN/g' ${resources_dir}race_1kG5.txt > ${resources_dir}race_1kG6.txt  
	sed 's/YRI/AFR/g' ${resources_dir}race_1kG6.txt > ${resources_dir}race_1kG7.txt  
	sed 's/LWK/AFR/g' ${resources_dir}race_1kG7.txt > ${resources_dir}race_1kG8.txt  
	sed 's/TSI/EUR/g' ${resources_dir}race_1kG8.txt > ${resources_dir}race_1kG9.txt  
	sed 's/MXL/AMR/g' ${resources_dir}race_1kG9.txt > ${resources_dir}race_1kG10.txt  
	sed 's/GBR/EUR/g' ${resources_dir}race_1kG10.txt > ${resources_dir}race_1kG11.txt  
	sed 's/FIN/EUR/g' ${resources_dir}race_1kG11.txt > ${resources_dir}race_1kG12.txt  
	sed 's/CHS/ASN/g' ${resources_dir}race_1kG12.txt > ${resources_dir}race_1kG13.txt  
	sed 's/PUR/AMR/g' ${resources_dir}race_1kG13.txt > ${resources_dir}race_1kG14.txt  
  
resources$ cut -d ' ' -f3 race_1kG14.txt | sort -u  
AFR  
AMR  
ASN  
EUR  
  
  
### give ownData ethnicity of OWN  
  
$ vim step6_prep_ethnicity_files.sh  
  
	awk '{print$1,$2,"OWN"}' ./outputs/HapMap_MDS.fam > ./outputs/ethn_file_ownData.txt  
  
$ bash step6_prep_ethnicity_files.sh  
  
$ less ./outputs/ethn_file_ownData.txt   
  
	1328 NA06989 OWN  
	1377 NA11891 OWN  
	1349 NA11843 OWN  
	...  
  
  
### concatenate ethnicity files  
  
$ vim step6_prep_ethnicity_files.sh  
  
	cat ${resources_dir}race_1kG14.txt ./outputs/ethn_file_ownData.txt | sed -e '1i\FID IID race' > ./outputs/ethn_file_concatenated.txt  
  
$ bash step6_prep_ethnicity_files.sh  
  
$ less ./outputs/ethn_file_concatenated.txt  
  
	FID IID race  
	HG00098 HG00098 EUR  
	HG00100 HG00100 EUR  
	HG00106 HG00106 EUR  
	...  
	1454 NA12815 OWN  
	1346 NA12043 OWN  
	1375 NA12264 OWN  
  
  
  
  
#------------------------------------------------------------#  
## plot MDS  
  
$ Rscript step7_MDS_merged.R   
  
      IID     FID SOL         C1        C2         C3           C4           C5          C6           C7           C8           C9          C10 race  
1 HG00098 HG00098   0 -0.0581226 0.0469293 0.00666338 -7.37038e-04 -0.002499530 0.004471640 -0.000404856 -0.001668910 -0.000194086  0.002558240  EUR  
2 HG00100 HG00100   0 -0.0593471 0.0477212 0.00572784  3.78147e-04 -0.004967440 0.006016500 -0.000144140 -0.001573140 -0.003624610  0.000148238  EUR  
3 HG00106 HG00106   0 -0.0587480 0.0468448 0.00662642  2.14437e-05 -0.004974110 0.000383189  0.005917300  0.001485840 -0.000901324  0.000639414  EUR  
...  
  
  
  
  
#------------------------------------------------------------#  
## exclude ethnic outliers  
  
  
### subset ownData.mds by comp1 and comp2 thresholds  
  
$ less .outputs/MDS_merge2.mds  
  
    FID       IID    SOL           C1           C2           C3           C4           C5           C6           C7           C8           C9          C10   
   1328   NA06984      0    -0.056673    0.0484244   0.00450315   -0.0046481    0.0211372   -0.0220683   0.00178486    0.0127743   -0.0380989    0.0244196   
   1328   NA06989      0   -0.0569928    0.0479001   0.00909747   -0.0109876   0.00823615   -0.0389311    -0.023994   -0.0811805   -0.0392789     0.021354   
   1330   NA12340      0   -0.0570225    0.0487898   0.00527852  -0.00913983   -0.0055688  -0.00731278    0.0192658    0.0222587   -0.0318775  -0.00545362   
	...  
  
$ vim step8_exclude_ethnic_outliers.sh   
  
	awk '{ if ($4 <-0.04 && $5 >0.03) print $1,$2 }' ./outputs/MDS_merge2.mds > ./outputs/EUR_MDS_merge2  
  
$ bash step8_exclude_ethnic_outliers.sh   
  
$ less ./outputs/EUR_MDS_merge2  
  
	1328 NA06984  
	1328 NA06989  
	1330 NA12340  
	...  
  
  
### extract individuals passing comp1 and comp2 thresholds  
  
$ vim step7_exclude_ethnic_outliers.sh   
  
	plink --bfile ./outputs/HapMap_3_r3_12 \  
		  --keep ./outputs/EUR_MDS_merge2 \  
          --make-bed --out ./outputs/HapMap_3_r3_13  
  
$ bash step7_exclude_ethnic_outliers.sh   
  
	109 phenotype values loaded from .fam.  
	...  
	1073226 variants and 109 people pass filters and QC.		<-- just practice, all individuals passed comp1 and comp2 thresholds  
  
  
  
  
#------------------------------------------------------------#  
## create covariates based on MDS  
  
### repeat plinkMDS on ownData, without ethnic outliers  
  
$ vim step9_create_covariate_file.sh   
  
	plink --bfile ./outputs/HapMap_3_r3_13 \  
		  --extract ./outputs/indepSNP.prune.in \  
		  --genome \  
		  --out ./outputs/HapMap_3_r3_13  
	plink --bfile ./outputs/HapMap_3_r3_13 \  
		  --read-genome ./outputs/HapMap_3_r3_13.genome \  
		  --cluster \  
		  --mds-plot 10 \  
		  --out ./outputs/HapMap_3_r3_13_mds  
  
$ bash step9_create_covariate_file.sh   
  
...  
IBD calculations complete.    
Finished writing ./outputs/HapMap_3_r3_13.genome .  
  
Clustering... done.                          
Cluster solution written to ./outputs/HapMap_3_r3_13_mds.cluster1 ,  
./outputs/HapMap_3_r3_13_mds.cluster2 , and  
./outputs/HapMap_3_r3_13_mds.cluster3 .  
Performing multidimensional scaling analysis (SVD algorithm, 10 dimensions)... done.  
MDS solution written to ./outputs/HapMap_3_r3_13_mds.mds .  
  
  
### change .mds to plink covariate file format  
  
$ vim step9_create_covariate_file.sh   
  
	awk '{print$1, $2, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}' ./outputs/HapMap_3_r3_13_mds.mds > ./outputs/covar_mds.txt  
  
$ bash step9_create_covariate_file.sh   
  
$ less ./outputs/covar_mds.txt  
  
	FID IID C1 C2 C3 C4 C5 C6 C7 C8 C9 C10  
	1328 NA06989 0.0160249 -0.0527081 0.0532834 -0.00151572 0.00862577 -0.00979541 0.019497 -0.0257653 0.00946611 -0.0147235  
	1377 NA11891 0.00880326 -0.0302948 -0.0051995 0.0268125 -0.0139691 -0.0156051 -0.000492102 0.00316405 0.0260371 0.0140428  
	1349 NA11843 -0.000948607 0.0140868 -0.00435938 -0.0145398 -0.0156304 0.0211412 -0.00908916 0.0145217 -0.00769973 0.0126226  
	...  
  
  
  
  
# For the next tutorial you need the following files:  
# - HapMap_3_r3_13  
# - covar_mds.txt  
  
  
#------------------------------------------------------------#  
EOF

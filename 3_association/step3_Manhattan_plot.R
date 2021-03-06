# install.packages("qqman",repos="http://cran.cnr.berkeley.edu/",lib="~" ) # location of installation can be changed but has to correspond with the library location 
library("qqman")  
results_log <- read.table("./outputs/logistic_results_noNA.assoc.logistic", head=TRUE)
jpeg("./outputs/Logistic_manhattan.jpeg")
manhattan(results_log,chr="CHR",bp="BP",p="P",snp="SNP", main = "Manhattan plot: logistic")
dev.off()

#results_as <- read.table("assoc_results.assoc", head=TRUE)
#jpeg("assoc_manhattan.jpeg")
#manhattan(results_as,chr="CHR",bp="BP",p="P",snp="SNP", main = "Manhattan plot: assoc")
#dev.off()  





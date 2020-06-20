hwe<-read.table (file="./outputs/step4_hwe/HapMap_3_r3.hwe", header=TRUE)
pdf("./outputs/step4_hwe/histhwe.pdf")
hist(hwe[,9],main="Histogram HWE")
dev.off()

hwe_zoom<-read.table (file="./outputs/step4_hwe/plink_zoom_hwe.hwe", header=TRUE)
pdf("./outputs/step4_hwe/histhwe_lower_than_theshold.pdf")
hist(hwe_zoom[,9],main="Histogram HWE: strongly deviating SNPs only")
dev.off()

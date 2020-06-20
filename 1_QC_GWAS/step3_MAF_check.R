maf_freq <- read.table("./outputs/step3_autosome_MAF/MAF_check.frq", header =TRUE, as.is=T)
pdf("./outputs/step3_autosome_MAF/MAF_distribution.pdf")
hist(maf_freq[,5],main = "MAF distribution", xlab = "MAF")
dev.off()



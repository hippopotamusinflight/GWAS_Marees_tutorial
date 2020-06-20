het <- read.table("./outputs/step5_extreme_het/R_check.het", head=TRUE)
pdf("./outputs/step5_extreme_het/heterozygosity.pdf")
het$HET_RATE = (het$"N.NM." - het$"O.HOM.")/het$"N.NM."
hist(het$HET_RATE, xlab="Heterozygosity Rate", ylab="Frequency", main= "Heterozygosity Rate")
dev.off()

gender <- read.table("./outputs/step2_sex_discrepancy/HapMap_3_r3.sexcheck", header=T,as.is=T)

pdf("./outputs/step2_sex_discrepancy/Gender_check.pdf")
hist(gender[,6],main="Gender", xlab="F")
dev.off()

pdf("./outputs/step2_sex_discrepancy/Men_check.pdf")
male=subset(gender, gender$PEDSEX==1)
hist(male[,6],main="Men",xlab="F")
dev.off()

pdf("./outputs/step2_sex_discrepancy/Women_check.pdf")
female=subset(gender, gender$PEDSEX==2)
hist(female[,6],main="Women",xlab="F")
dev.off()


indmiss<-read.table(file="./outputs/step1_missingness/miss_stat_after.imiss", header=TRUE)
snpmiss<-read.table(file="./outputs/step1_missingness/miss_stat_after.lmiss", header=TRUE)
# read data into R 

pdf("./outputs/step1_missingness/histimiss_after.pdf") #indicates pdf format and gives title to file
hist(indmiss[,6],main="Histogram individual missingness after removal") #selects column 6, names header of file

pdf("./outputs/step1_missingness/histlmiss_after.pdf") 
hist(snpmiss[,5],main="Histogram SNP missingness after removal")  
dev.off() # shuts down the current device

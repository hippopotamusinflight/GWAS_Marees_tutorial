indmiss<-read.table(file="./outputs/step1_missingness/miss_stat.imiss", header=TRUE)
snpmiss<-read.table(file="./outputs/step1_missingness/miss_stat.lmiss", header=TRUE)
# read data into R 

pdf("./outputs/step1_missingness/histimiss.pdf") #indicates pdf format and gives title to file
hist(indmiss[,6],main="Histogram individual missingness") #selects column 6, names header of file

pdf("./outputs/step1_missingness/histlmiss.pdf") 
hist(snpmiss[,5],main="Histogram SNP missingness")  
dev.off() # shuts down the current device

#install.packages("ape")
#install.packages("pegas")
#install.packages("seqinr")
#install.packages("ggplot2")
#install.packages("adegenet")
#install.packages("hierfstat")

#remove everything
rm(list=ls())

library("ape")
library("pegas")
library("seqinr")
library("ggplot2")
library("adegenet")
library("hierfstat")

#set working directory
setwd("C:/Users/UsuarioPC/Desktop/BIOINFO/Hypsiboas_ddRAD/ADEGENET")

#where am I working?
getwd()

#Open STRUCTURE file
myFile <- import2genind("outputpopulations_d_final.stru") #4224 SNPs and 33 inds


##QUESTIONS FOR STRUCTURE FILES:
### Which column contains the population factor ('0' if absent)? 
###answer:2
###Which other optional columns should be read (press 'return' when done)? 
###Which row contains the marker names ('0' if absent)? 
###Answer:1

myFile ##look at your transformed genind file


########################
help(scaleGen)
X <- scaleGen(myFile, NA.method="zero")
X[1:5,1:5]



pca1<-dudi.pca(X,cent=FALSE,scale=FALSE,scannf=FALSE,nf=3)
myCol <-c("darkgreen","darkblue","blue","green","red")
myCol<-c(rep("green",9), rep("darkgreen",2),rep("darkblue",5),rep("red",9),rep("darkolivegreen1",8))

pop_jimmy <- pop(myFile)



s.class(pca1$li,pop(myFile))
add.scatter.eig(pca1$eig[1:20], 3,1,2)

###############
###############

plot(pca1$li, col=myCol, cex=3, pch=16)
plot(pca1$li, cex=3, col=3, pch=16)
###to plot with funky colors
s.class(pca1$li,pop(myFile),xax=1,yax=2,col=myCol,axesell=FALSE,
        cstar=0,cpoint=3,grid=FALSE)


s.class(pca1$li,pop(myFile),xax=1,yax=2,col=3,axesell=FALSE,
        cstar=0,cpoint=3,grid=FALSE)


############################################
#####   to find names of outliers    #######
############################################
s.label(pca1$li)




################################################
###  NEIGHBOR-JOINING TREE COMPARED TO PCA   ###
################################################
library(ape)
tre<-nj(dist(as.matrix(X)))
plot(tre,typ="fan",cex=0.7)
plot(tre,cex=0.7, col=as.numeric(pop(myFile)))

myCol2<-colorplot(pca1$li,pca1$li,transp=TRUE,cex=4)
abline(h=0,v=0,col="grey")


plot(tre,typ="fan",show.tip=FALSE)
plot(tre,show.tip=FALSE)
tiplabels(pch=20,col=myCol,cex=2)




####################################
#####   DAPC by original pops   ####
####################################


dapc2<-dapc(X,pop(myFile))
dapc2
scatter(dapc2)
summary(dapc2)
contrib<-loadingplot(dapc2$var.contr,axis=1,thres=.07,lab.jitter=1)



####################
###  COMPOPLOT   ###
####################
compoplot(dapc2,posi="bottomright",lab="",
          ncol=1,xlab="individuals") ##using original population IDs

##lab<-pop(myFile)
##compoplot(dapc2,subset=1:50, posi="bottomright",lab="",
ncol=2, lab="lab")

##To find the potential migrant IDs:
assignplot(dapc2, subset=1:33)			
assignplot(dapc2, subset=51:100)
assignplot(dapc2, subset=101:134)

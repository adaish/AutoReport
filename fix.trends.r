###Problem data that doesn't fit into Year trends
##Solution: Put factors in the years for trends
rm(list=ls())
getwd()
install.packages("data.table")
require(data.table)
#load data
Relationship<-read.csv("data.Status.csv")
attach(Relationship)
Relationship<-data.table(Relationship)

#find which years appropiate
year<-min(Year):max(Year)

length(unique(Status))

#make an empty matrix for the new data to go in thats the length of the number of years and the number of status.
S<-matrix(NA,length(year),sum(length(unique(Status))+1))

S[,1]<-year 
Status1<-unique(Status)

for (i in 1:length(year))
{
  if(length(Relationship[which(Year==year[i] & Status==Status1[1]),Freq])>=1)
   {S[i,2]<-Relationship[which(Year==year[i] & Status==Status1[1]),Freq]}
  if(length(Relationship[which(Year==year[i] & Status==Status1[2]),Freq])>=1)
   {S[i,3]<-Relationship[which(Year==year[i] & Status==Status1[2]),Freq]}
  if(length(Relationship[which(Year==year[i] & Status==Status1[3]),Freq])>=1)
   {S[i,4]<-Relationship[which(Year==year[i] & Status==Status1[3]),Freq]}
}

S1<-S[,2:4] #take off the year
#plot graph
barplot(t(S1),ylab="Frequency",main="Number of people with different relationship status's",xlab="Year",names.arg=year,col=c("light blue","red","grey"),)
legend("topright",inset = c(0,0.95),bty = "n",xpd = TRUE, horiz = TRUE,legend=Status1,fill=c("light blue","red","grey"),col(col=c("light blue","red","grey")))

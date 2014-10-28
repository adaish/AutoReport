rm(list=ls())
setwd("~/")
update.packages()
install.packages ("RODBC")
install.packages ("data.table")

##odbc
#I have load one of the database connection 
#need to set up OBDC connection, go into "ODBC data source 64-bit"
#cLICK ADD and adda new connection- name the connection and put in the server "mscsqlsrv02"

require(RODBC)
#library(RODBC, lib.loc="Rlib")

#Two examples
Anglerfish<- odbcConnect("Anglerfish") #Name the connection/ channel
Dataplaice<- odbcConnect("Dataplaice") #Name the connection/ channel




sqlTables(Anglerfish)  #List tables and views avaliable with the database connection
sqlTables(Dataplaice)  #List tables and views avaliable with the database connection

#Fetch the query needed
GIR_Total_Closed<-sqlFetch(Anglerfish, "GIR_Total_Closed")  #collects a specific table
GIR_Total_Open<-sqlFetch(Anglerfish, "GIR_Total_Open")

#Load them into the data.table - (not dataframe)
GIR_Total_Open<-data.table(GIR_Total_Open)
GIR_Total_Closed<-data.table(GIR_Total_Closed)
GIR_Total_Closed
GIR_Total_Open

COCCountryLastMonth<-sqlFetch(Dataplaice, "COC_ByCountryByLastMonth") 
COCCountryLastMonth<-COCCountryLastMonth[rev(order(count)),]
dim(COCCountryLastMonth)
attach(COCCountryLastMonth)

#if (COCCountryLastMonth[count=<50])
#{
 # COCCountryLastMonth
#}

COCCountryLastMonth
#Removes black border from plot bars
par(lty = 0)
par(mar=c(10,10,2,2),mgp=c(8,1,0)) #set margins mar=c(bottom, left, top, and right) # mgp sets the axis label relative to the edge
#par(mgp=c(axis.title.position, axis.label.position, axis.line.position))
#plot
barplot(count,
        names=as.character(eCert_name),
        xlab='',
        ylab='',
        main=paste('Number of CoC Certificates by Country',"(",StartDate[1],")"),
        ylim=c(0,500),
        lwd=1,
        cex=1,
        cex.lab=1.4,
        cex.axis=1.4,
        cex.main=1.8,
        las=2,
        col="#f89728",
        axis.lty = 1,
       
        )
mtext('Countries',side=1, line=7)
mtext('Number of CoC Certificates',side=2, line=4)

#OTHER PIECES LEFT OVER
#data<-sqlQuery(con,"SELECT        event_id, event_type, Assessment_number, event_ReportNumber, COUNT(condition_id) AS Count_Condition, status, YEAR(Rpt_Published2) AS YEAR
#FROM            GiantSquid.dbo.SCORING_Condition_wMapped_4
#GROUP BY event_id, event_type, Assessment_number, event_ReportNumber, YEAR(Rpt_Published2), status
#HAVING        (NOT (event_type LIKE N'Public Comment Draft Report'))")  #runs a specific query
#summary(data)
#data

##GIR_Total_Closed<-sqlQuery(con, "GIR_Total_Closed")
##GIR_Total_Open<-sqlQuery(con, "GIR_Total_Open")


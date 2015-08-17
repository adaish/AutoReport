#===============Connect to SQL server using R ==========================
rm(list=ls())
#setwd("~/")
#update.packages()
#install.packages ("RODBC")
#install.packages ("data.table")

##odbc
#I have load one of the database connection 
#need to set up OBDC connection, go into "ODBC data source 64-bit"
#cLICK ADD and adda new connection- name the connection and put in the server "mscsqlsrv02"

require(RODBC);require(data.table)

#Two examples
servername<- odbcConnect("Name") #Name the connection/ channel

sqlTables(servername)  #List tables and views avaliable with the database connection

#Fetch the query needed
table1<-sqlFetch(servername, "Table1")  #collects a specific table

#Load them into the data.table - (not dataframe)
table1<-data.table(table1)
table1

table2<-sqlFetch(servername2, "table2") 
table2<-table2[rev(order(count)),]
dim(table2)
attach(table2)


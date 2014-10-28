rm(list=ls())
setwd("~/")
update.packages()
install.packages ("knitr")
install.packages ("rmarkdown")
install.packages ("RODBC")
install.packages ("data.table")
install.packages("devtools")
install.packages("dplyr")
install.packages("ggvis")

library(ggvis)
library(dplyr)
library(knitr)
?knit
knit(input)

##odbc
#I have load Angelfish connection and called it MSC for my trialling
#need to set up OBDC connection, go into "ODBC data source 64-bit"
#cLICK ADD and adda new connection- name the connection and put in the server "mscsqlsrv02"

require(data.table)

require(RODBC)
#library(RODBC, lib.loc="Rlib")

Anglerfish<- odbcConnect("Anglerfish") #Name the connection/ channel
Dataplaice<- odbcConnect("Dataplaice") #Name the connection/ channel


#data<-sqlQuery(con,"SELECT        event_id, event_type, Assessment_number, event_ReportNumber, COUNT(condition_id) AS Count_Condition, status, YEAR(Rpt_Published2) AS YEAR
#FROM            GiantSquid.dbo.SCORING_Condition_wMapped_4
#GROUP BY event_id, event_type, Assessment_number, event_ReportNumber, YEAR(Rpt_Published2), status
#HAVING        (NOT (event_type LIKE N'Public Comment Draft Report'))")  #runs a specific query
#summary(data)
#data

##GIR_Total_Closed<-sqlQuery(con, "GIR_Total_Closed")
##GIR_Total_Open<-sqlQuery(con, "GIR_Total_Open")
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
par(mgp=c(axis.title.position, axis.label.position, axis.line.position))
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

COCCountryLastMonth %>% ggvis (~eCert_name, ~count)

slider <- input_slider(0,500)
COCCountryLastMonth %>% ggvis(~eCert_name, ~count) %>%
  layer_points(fill := "red", size := slider) %>%
  layer_points(stroke := "black", fill := NA, size := slider)

layer_points(fill := "red") %>%
  layer_points(stroke := "black", fill := NA)
p <- ggvis(COCCountryLastMonth, x = count, y = eCert_name)
%>%
  layer_bars(width = 10)

#plot data as a layer?
layer_points(p)
layer_points(ggvis(mtcars, x = ~wt, y = ~mpg))

par(mfrow=c(2,2),mar=c(4,4,2,2), oma=c(4,4,2,2))
par(mar=c(5.1,5.1,4.1,2.1))


#Removes black border from plot bars
par(lty = 0)
par(lty = lty.o)     
lty.o <- par("lty") 
par(lty = 0) 

#merge text including current date
mtext(paste(CertYear[II]," ",format(Sys.time(), "%d-%m-%Y"))
      
#plot(sai_arct$Year,sai_arct$SSB,type='l',xlab='Year',ylab='Spawning Stock Biomass',main='Spawning Stock Biomass of Arctic Saithe',ylim=c(0,700000),lwd=4,cex=1.8,cex.lab=1.5, cex.axis=1.8, cex.main=2)
#points(sai_arct$Year[length(sai_arct$Year)],sai_arct$SSB[length(sai_arct$Year)],col='red',pch=16,cex=3)         # current year
#points(sai_arct$Year[length(sai_arct$Year)-1],sai_arct$SSB[length(sai_arct$Year)-1],col='black',pch=16,cex=3)   # previous year
#abline(136000,0,lty=5,lwd=2)
#legend('topright',c('SSBlim'),lty=5,cex=2,lwd=2)

COCCountryLastMonth<-data.table(COCCountryLastMonth)
COCCountryLastMonth [count==T, sum(count), "eCert_name,MSC_region"]

#setkey (GIR_Total_Closed, Rpt_Published2, condition_id)  #pre-sorting by year and condition
#setkey (GIR_Total_Open, Rpt_Published2, condition_id)    #pre-sorting by year and condition
#GIR_Total_Closed
#GIR_Total_Open

GIR_Total_Open[2:10,] #Select specific rows
setkey (GIR_Total_Open, status) # change to the setkey needs to be changed for the select- not sure why yet
setkey (GIR_Total_Closed, status) 
GIR_Total_Open["Open", ] #select just open

GIR_Total_Open["Open",mult="first"]  # select first row "open"
GIR_Total_Open["Open",mult="last"]   # select last row "open"

 
GIR_Total_Open["Open", length (condition_id)]      #length of the number of conditions open
GIR_Total_Closed["Closed", length (condition_id)]  #length of the number of conditions closed

#OR
ClosedCon<-length(GIR_Total_Closed$condition_id)
OpenCon<-length(GIR_Total_Open$condition_id)
ClosedCon
OpenCon

#################################################
#####NEW START FINAL IT WORK JUST IN R- (Rstudio is upset- contacted IT)

install.packages("devtools")
install.packages("dplyr")
install.packages("ggvis")

library(ggvis)
library(dplyr)


#FROM THE http://ggvis.rstudio.com/ggvis-basics.html WEBSITE just to start playing
#ggvis is the start of plotting
# all ggvis graphuiscas are web grapshics and need a browser to shown them. advantage can expand the graph and export
 
p <- ggvis(mtcars, x = ~wt, y = ~mpg)

#plot data as a layer?
layer_points(p)
layer_points(ggvis(mtcars, x = ~wt, y = ~mpg))


#To make life easier ggvis uses the %>% (pronounced pipe) function from the magrittr package. That allows you to rewrite the previous function call as
#re-write previous funcation
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points()

#mutate which I think means manipulate
#~ before the variable name to indicate that we don?t want to literally use the value of the mpg variable (which doesn?t exist), but instead we want we want to use the mpg variable inside in the dataset 
mtcars %>%
  ggvis(x = ~mpg, y = ~disp) %>%
  mutate(disp = disp / 61.0237) %>% # convert engine displacment to litres
  layer_points()


#add  visual qualities #stroke is a sprectum of different value
mtcars %>% ggvis(~mpg, ~disp, stroke = ~vs) %>% layer_points()
#2 colours
mtcars %>% ggvis(~mpg, ~disp, fill = ~vs) %>% layer_points()
#size of dots
mtcars %>% ggvis(~mpg, ~disp, size = ~vs) %>% layer_points()
#different shapes for groups
mtcars %>% ggvis(~mpg, ~disp, shape = ~factor(cyl)) %>% layer_points()

#if you want fixed colour or size use := instead of =
# := means raw and unscaled value 
#red dots all the same
mtcars %>% ggvis(~wt, ~mpg, fill := "red", stroke := "black") %>% layer_points()
#bigger dots with a opacity of the dots so they overlay
mtcars %>% ggvis(~wt, ~mpg, size := 300, opacity := 0.4) %>% layer_points()
#change dots to shapes one is cross dots
mtcars %>% ggvis(~wt, ~mpg, shape := "cross") %>% layer_points()


#####Interactions

#add two sliders 
#slider for size of dot and opacity
mtcars %>% 
  ggvis(~wt, ~mpg, 
    size := input_slider(10, 100),
    opacity := input_slider(0, 1)
  ) %>% 
  layer_points()

#crtl+ c to stop the visualisation

## doesn't work from the wedsite 
mtcars %>% 
  ggvis(~wt) %>% 
  layer_histograms(width =  input_slider(0, 2, step = 0.10, label = "width"),
                   center = input_slider(0, 2, step = 0.05, label = "center"))


keys_s <- left_right(10, 1000, step = 50) # u can use the arrow to control the size of the points 
mtcars %>% ggvis(~wt, ~mpg, size := keys_s, opacity := 0.5) %>% layer_points()

#> Warning: Can't output dynamic/interactive ggvis plots in a knitr document.
#> Generating a static (non-dynamic, non-interactive) version of the plot.

## Yippee plot values on the graph when u put your mouse over them
mtcars %>% ggvis(~wt, ~mpg) %>% 
  layer_points() %>% 
  add_tooltip(function(df) df$wt)































install.packages("Rtools","C\\RBuildTools\\3.1")
install.packages("shiny")

require(ggvis)
require(dplyr)
install.packages("ggvis", lib.loc="Rlib")

ggvis(FISH_StatusHabitatsEcosystems %>% ggvis(~year, ~status) %>% layer_points())
ggvis()
######################################################
#install.packages("COUNT")
#require(COUNT)
#COUNT(GIR_Total_Closed$condition_id)

FISH_StatusHabitatsEcosystems<-sqlFetch(Dataplaice, "FISH_StatusHabitatsEcosystems")

FISH_StatusHabitatsEcosystems<-data.table(FISH_StatusHabitatsEcosystems)
FISH_StatusHabitatsEcosystems

plot(FISH_StatusHabitatsEcosystems$year,FISH_StatusHabitatsEcosystems$number)

barplot(num)

setkey(FISH_StatusHabitatsEcosystems, year) #re-order by status and year
t(FISH_StatusHabitatsEcosystems)



FISH_StatusHabitatsEcosystems[  , sum (number), by=list(status,year)]
require(reshape)
melt(FISH_StatusHabitatsEcosystems,id=c("year","status"))

FISH_StatusHabitatsEcosystems<-FISH_StatusHabitatsEcosystems[status=="All scores above 80 but some might be above 90",]

#transpose data so status is rows and years are columns
fish<-matrix (NA,15,1)
for (i in 1: 15)
{
  for(j in 1:4)
{
  fish[i,j]<-FISH_StatusHabitatsEcosystems[i,number]
}
}


fish<-FISH_StatusHabitatsEcosystems[-(which(year==NA),]

fish
rbind(year,status)

FISH_StatusHabitatsEcosystems<-t(FISH_StatusHabitatsEcosystems)
melt(FISH_StatusHabitatsEcosystems,id=number)
###========

aggregate(sum(FISH_StatusHabitatsEcosystems$number),FISH_StatusHabitatsEcosystems,by=list(year,status))

aggregate()

install.packages ("data.table")
require(data.table)
library(data.table)
HE<-data.table(FISH_StatusHabitatsEcosystems)
HE1<-HE[,sum(number),by=status]
HE1[order(HE1)]



transform(airquality, Ozone = -Ozone)
transform(airquality, new = -Ozone, Temp = (Temp-32)/1.8)




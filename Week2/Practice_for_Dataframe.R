#practice for dataframe
medals = data.frame(
  Country = c("USA","GBR","CHN"), 
  Gold = c(46,27,26), 
  Silver = c(37,23,18), 
  Bronze = c(38,17,26))
medals

#query the first column by index or name
medals[1] #data.frame
medals[1] #data.frame
medals["Country"] #data.frame

#query the slice of first column by index or name
medals[[1]] #factor
medals[,1] #factor
medals$Country #factor

#query specific columns by vector with index or name
medals[c(1,3)]
medals[c("Country", "Silver")]

#query the first row by index
medals[1,]
#query specific rows by vector with ibdex
medals[c(1,3),]

medals[medals$Country != "GBR",]
medals[medals$Country == "GBR",]
medals[medals$Gold >= 27 & medals$Silver > 30,]
medals[medals$Country == "GBR",c("Country", "Silver")]

#another useful way to query data in frame by subset
subset(medals, select = c(Country, 4)) #select columns with index or name
subset(medals, subset = (Country == "GBR")) #select rows with logical condition
subset(medals, select = c(Country, Bronze), subset = (Country == "GBR")) #combine above ways to find specific columns and rows
subset(medals, select = c(Country, Gold), subset = (Gold >= 27))
subset(medals, Gold>20 & Bronze>20, select = c(Country, Gold:Silver))

#add new elements
rusData = data.frame(Country = "RUS", Gold = 19, Silver = 18, Bronze = 19)
medals = rbind(medals, rusData)
medals = append(medals, rusData) #this function is wrong! it will insert each item as new row
jpnData = data.frame(Country = "JPN", Gold = 12, Silver = 8, Bronze = 21)
medals = rbind(medals, jpnData)
#excluding(dropping) some items
medals = subset(medals, Country!="RUS")

#random display 3rows
medals[sample(1:nrow(medals), 3,replace=FALSE),]

#add a Total column
medals$Total = medals$Gold + medals$Silver + medals$Bronze
medals$Total = rowSums(medals[c(2:4)])
orig = subset(medals, select = c(-Total))
medals = orig

#sort frame by selected row
medals = medals[order(-medals$Total),]

#create the sum of columns
subTotal = colSums(medals[names(medals)[-1]])

#read the data from csv
rio2016Medals = read.csv("Rio2016.csv", header = TRUE) #file should put under my document
subset(rio2016Medals, Country == "Taiwan")
?read.csv
total = rowSums(rio2016Medals[c(2:4)])
rio2016Medals$Total = total
getwd()
setwd("C:/Users/Eric Huang/Documents/University of Sheffield/MSc Data Science/01. INF6027 Introduction to Data Science/04. Project Document for R/Datasets")
View(medals)
rio2016Medals[c(1,5)]
plot(rio2016Medals[c(1,5)])

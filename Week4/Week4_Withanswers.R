# **************************************************************#
# R/Rstudio Practical Week 4 
# Oct 2017
# Instructor: Paul Clough
# **************************************************************#

# set working directory at start of tutorial

# **************************************************************#
# Getting data
# **************************************************************#

# show datasets available within R
data() 

# Datasets available from online. e.g.
# http://www.kdnuggets.com/datasets/index.html
# data.gov.uk


#########################################################
# using base read functions: read.table() and read.csv()
#########################################################

# load in text of tab-delimited files
df <- read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", 
                 header = FALSE)

# If the previous statement doesn't work then try the following
# library(curl) # if this doesn't work try installing the package first
# df <- read.table(curl("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt"), header = FALSE)

df <- read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", 
                 header = FALSE, stringsAsFactors=FALSE) # don't convert the strings to factors


# Exercise: Try changing the names of the columns to V1€˜Col1, V2€˜Col2 and V3€˜Col3
names(df)<-c("Col1", "Col2", "Col3")

# load in CSV and tab delimited files (as data frame)
rio2016Medals<-read.csv("Rio2016.csv", header=TRUE) # default separator is ','
head(rio2016Medals)
str(rio2016Medals)

meals<-read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header=TRUE, stringsAsFactors=FALSE)

head(meals)

class(meals)

meals$SchoolName
meals[meals$SchoolName=="Carr Infant School",]

# library(curl)
# meals<-read.csv(curl("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv"), header=TRUE, stringsAsFactors=FALSE)


#####################################################
# Using the readtext package
######################################################

install.packages("readtext")    # for data preparation
library(readtext)

txt <- readtext("http://ir.shef.ac.uk/cloughie/download/inaugral.txt") # plaintext
str(txt)

txt$text

pdfDoc <- readtext("http://ir.shef.ac.uk/cloughie/download/text_analysis_in_R.pdf")
pdfDoc$text

wordDoc <- readtext("http://ir.shef.ac.uk/cloughie/download/DoingPhD.doc")
wordDoc$text

# Another option is to download first and then import file 
# Note for a Word doc we need to download as a binary file 
# Note you need permissions on the working directory to save the file

download.file("http://ir.shef.ac.uk/cloughie/download/DoingPhD.doc", mode="wb", destfile="DoingAPhD.doc")

wordDoc <- readtext("DoingAPhD.doc")
wordDoc$text


##########################################################
# Reading HTML and XML data into R with the rvest package 
##########################################################
# Good example tutorial:
# http://bradleyboehmke.github.io/2015/12/scraping-html-text.html

install.packages("rvest")
library(rvest) 

url<-"https://en.wikipedia.org/wiki/Sheffield"
x<-read_html(url)

wikiPage <- read_html(url)
wikiPage

class(wikiPage)
str(wikiPage)

h2Sections <- wikiPage %>%
  html_nodes("h2")

h2Sections

h2Sections[1]
h2Sections[2]
h2Sections[1:2]

h2Sections %>%
  html_text()

pageText <- wikiPage %>%
  html_nodes("p") %>%
  html_text()

pageText[1]

######################################################
# Gathering data from an API
######################################################

# Load data in from New York times - rtimes package
# Need to first request API key from here: http://developer.nytimes.com/
install.packages("rtimes")
library(rtimes)
nytAPIKey<-"3de20fd5fb2442ef9bf21999f577d583" # Use your own key here

# search for news articles with the query "Trump"
articles<-as_search(q="Trump", key=nytAPIKey)

articles$copyright
articles$meta

articles$data$web_url[1]
articles$data$snippet[1]

articles$data$snippet[2]
articlesToday<-as_search(q="Trump", begin_date=20171015, end_date=20171016, key=nytAPIKey)
articlesToday$data$snippet



# **************************************************************#
# Woring with data in JSON format
# **************************************************************#

install.packages("jsonlite")
library(jsonlite)

json <- '["Mario", "Peach", null, "Bowser"]'
myvec <- fromJSON(json)
myvec

json <-
  '[
{"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"}, 
{"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"},
{},
{"Name" : "Bowser", "Occupation" : "Koopa"}
]'

mydf <- fromJSON(json)
mydf

myjson <- toJSON(mydf)
myjson

# JSON data sources via APIs: https://cran.r-project.org/web/packages/jsonlite/vignettes/json-apis.html

citibike <- fromJSON("http://citibikenyc.com/stations/json")
citibike

str(citibike)
View(citibike)

stations <- citibike$stationBeanList$stationName
stations


# **************************************************************#
# Writing data
# **************************************************************#

testTable<-read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", 
                 header=FALSE)

write.table(testTable, "test.txt", sep="\t", row.names=FALSE)

meals<-read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header=TRUE, stringsAsFactors=FALSE)
write.csv(meals, "freeschoolmeals.csv", row.names=FALSE)


# **************************************************************#
# Data import with tidyverse and the readr package
# **************************************************************#

# show use of the readr() package - part of tidyverse
library(tidyverse)
testFile<-read_tsv("test.txt")
testFile

testCSVFile<-read_csv("freeschoolmeals.csv")
head(testCSVFile)

library(readxl)
excelFile<-file.path("indicator hiv estimated prevalence% 15-49.xlsx")
testExcelFile<-read_excel(excelFile, sheet="Data")
head(testExcelFile)


# **************************************************************#
# Data wrangling with dplyr package - see dplyr 'cheatsheet'
# **************************************************************#

# dplyr works on data frames which we commonly access

# discuss the %>% function of dplyr - combine multiple commands

# Based on R for Data Science these are the main dplyr functions:
# - Pick observations by their values (filter()).
# - Reorder the rows (arrange()).
# - Pick variables by their names (select()).
# - Create new variables with functions of existing variables (mutate()).
# - Collapse many values down to a single summary (summarise()).

library(tidyverse)
str(mpg)

# **************************************************************#
# Selecting rows / observations - filter() and others functions
# **************************************************************#

filter(mpg, manufacturer=="audi")
filter(mpg, displ > 2)
filter(mpg, displ >= 2)

filter(mpg, displ > 2 & cyl > 6)

filter(mpg, manufacturer=="audi", year==1999) # this does an AND between variables
filter(mpg, manufacturer=="audi" & year==1999) # this does an AND between variables

# Exercise: can you filter rows where the manufacturer is Audi OR the year of production (year) is 1999?
# filter(mpg, manufacturer=="audi" | year==1999) # this does an OR between variables

filter(mpg, (manufacturer=="audi" | manufacturer=="chevrolet"), year==1999)

filter(mpg, (manufacturer %in% c("audi","chevrolet")), year==1999)

filter(mpg, (manufacturer %in% c("audi","chevrolet")), year==1999) %>% count(manufacturer)

# take a random sample of the rows/observations
sample_frac(mpg, 0.05, replace=TRUE) # sample 5% of the data
sample_n(mpg, 10, replace=TRUE) # sample of 10 rows

# presidential
# distinct(presidential) # select distinct rows


# **************************************************************#
# arrange() - sorting data in columns
# **************************************************************#

rio2016Medals<-read.csv("Rio2016.csv", header=TRUE) # default separator is ','
arrange(rio2016Medals, Country)
arrange(rio2016Medals, desc(Country)) # arrange in descending order 

arrange(rio2016Medals, desc(Gold))

# check for the ties
arrange(rio2016Medals, desc(Gold), desc(Silver), desc(Bronze))


# **************************************************************#
# select - filter out columns
# **************************************************************#

select(mpg, manufacturer, hwy)

select(mpg, starts_with("d")) 

select(mpg, manufacturer, hwy) %>% filter(manufacturer=="chevrolet" & hwy >=20)

select(mpg, manufacturer, hwy) %>% filter(manufacturer!="chevrolet" & hwy >=20) 

select(mpg, manufacturer, hwy) %>% 
  filter(manufacturer!="chevrolet" & hwy >=20) %>%
  arrange(desc(manufacturer))


# **************************************************************#
# mutate() - adding new columns as functions of existing columns
# **************************************************************#

# mutate() adds new columns at the end of the dataset
mutate(rio2016Medals, Total=Gold+Silver+Bronze) # similar to rowSums

# mutate(rio2016Medals, "Gold-Silver Ratio"=round(Gold/Silver,2)) # Nnmber gold per silver medal


# **************************************************************#
# summarise() - reduce data frame into single row
# **************************************************************#

summarise(mpg, avg=mean(hwy))

# typically paired with group_by()
t<-group_by(mpg, year, manufacturer) # doesn't actually change anything but needed before summarise
summarise(t, count=n())

group_by(mpg, year, manufacturer) %>% summarise(count=n())
group_by(mpg, manufacturer) %>% summarise(count=n())


# **************************************************************#
# Combining datasets or data frames - joining
# **************************************************************#
install.packages("nycflights13")
library(tidyverse)
library(nycflights13)
nycflights13::airports


# airlines is a table of airline numbers and names
# flights contains flight details
# Drop unimportant variables so it's easier to understand the join results.
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)

airlines

flights2 %>% left_join(airlines, by="carrier")


# **************************************************************#
# Working with real data
# **************************************************************#

meals<-read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header=TRUE, stringsAsFactors=FALSE)
head(meals)

summary(meals$FSMTaken)
mean(meals$FSMTaken)

mean(meals$FSMTaken, na.rm=TRUE) # remove NA values when computing the mean

actualFSMTaken<-meals$FSMTaken[meals$FSMTaken!=9999]
length(actualFSMTaken)
mean(actualFSMTaken, na.rm=TRUE)

filter(meals, FSMTaken<9999)
filter(meals, FSMTaken<9999) %>% count()

filter(meals, (FSMTaken<9999 | is.na(FSMTaken))) %>% count()

# Use simple mean value to estimate missing values
y <- c(4,5,6,NA)
is.na(y)
y[is.na(y)] <- mean(y,na.rm=TRUE)
y

actualFSMTaken[is.na(actualFSMTaken)]<-floor(mean(actualFSMTaken, na.rm=TRUE))

filter(meals, (FSMTaken<9999 | is.na(FSMTaken))) %>% 
  mutate(newFSMTaken=ifelse(is.na(FSMTaken), floor(mean(FSMTaken, na.rm=TRUE)), FSMTaken))


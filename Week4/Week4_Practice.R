# 16th/Oct./2018 File control

# read a file as data frame
df = read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", header = FALSE)
str(df)

# basicly, read.table() treats character string as categories, so we need to add the attribute below:
# stringsAsFactors = FALSE
df = read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", header = FALSE, stringsAsFactors = FALSE)
str(df)
newColName = paste("Column", c(1:3), sep = Null())
names(df) = newColName #rename the column name of data frame
str(df)


rio = read.csv("Rio2016.csv")
head(rio) #read the first 6 lines
meals = read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header = TRUE, stringsAsFactors = FALSE)
head(meals)
class(meals)
meals$SchoolName
meals[meals$SchoolName == "Acomb Primary School",]


# read text file by readtext
install.packages("readtext")
library(readtext)
txt = readtext("http://ir.shef.ac.uk/cloughie/download/inaugral.txt")
str(txt)
txt$text
View(txt)

pdfDoc = readtext("http://ir.shef.ac.uk/cloughie/download/text_analysis_in_R.pdf")
pdfDoc$text

wordDoc = readtext("http://ir.shef.ac.uk/cloughie/download/DoingPhD.doc")
View(wordDoc)

# save file by download.file
download.file("http://ir.shef.ac.uk/cloughie/download/DoingPhD.doc", mode = "wb", destfile = "Download_Test.doc")
dwTestDoc = readtext("Download_Test.doc")
View(dwTestDoc)

readLines(dwTestDoc)
scan(dwTestDoc)

install.packages("rvest")
library(rvest)

urlSheff = "https://en.wikipedia.org/wiki/Sheffield"
pageSheff = read_html(urlSheff)

# get all h2 nodes from pageSheff 
h2Sections = pageSheff %>% html_nodes("h2")

# get only the texts of elements
h2Sections %>% html_text()

pageSheff %>% html_nodes("h2") %>% html_text()

# find more about rvest from:
# http://bradleyboehmke.github.io/2015/12/scraping-html-text.html
# https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/
# https://www.datacamp.com/community/tutorials/r-web-scraping-rvest 

# import the NY Times API and key
install.packages("rtimes")
library(rtimes)
nytAPIKey = "4a1dbc9e32314eb7a73320d977784167";
articles = as_search(q = "Trump", key = nytAPIKey)
articles$facets
articles$data$pub_date

articles2 = as_search(q = "Trump", key = nytAPIKey, begin_date = 20180801, end_date = 20180930)
articles2$data$pub_date
View(articles2)

# operate json by jsonlite
install.packages("jsonlite")
library(jsonlite)
strNewJson = '{"Title":"I-School Student List", "Details":
  [
    {"Name":"Eric", "Age":30, "Programme":"Data Science", "Days in week":[2,3,4]},
    {"Name":"Eason", "Age":{}, "Programme":"Information Management", "Days in week":[1,2,4]}
  ]
}'
vecNewJson = fromJSON(strNewJson) # string to JSON
View(vecNewJson)
strNewJson = toJSON(vecNewJson) # JSON to string

jsonCitybike = fromJSON("http://citibikenyc.com/stations/json")
str(jsonCitybike)
View(jsonCitybike)

# write file to work directory
testTable = read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test.txt", header = FALSE, stringsAsFactors = FALSE)
str(testTable)
write.table(testTable, "test.txt", sep = "\t", row.names = FALSE)

library(tidyverse)
testFile = read_tsv("test.txt")
View(testFile)

# write data frame to csv
meals = read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header = FALSE, stringsAsFactors = FALSE)
write.csv(meals, "freeschoolmeals.csv")

library(readxl)
excelFilePath = file.path("indicator hiv estimated prevalence% 15-49.xlsx")
tsetExcelFile = read_excel(excelFilePath, sheet="Data")

# SQL functions
selectedMpg = select(mpg, c(1:4)) # equal as mpg[c(1:4)]
selectedMpg = select(mpg, c(starts_with("d"), ends_with("r"), "model"))
countByModel = filter(selectedMpg, !(manufacturer %in% c("audi", "chevrolet")) & year == 1999) %>% # equal as where(in) syntax
  group_by(manufacturer, model) %>% # sort by row
  count(manufacturer, model) %>% # return a new table with model and count(n)
  arrange(-n, desc(manufacturer), model) %>% # sort by argument (default ascending) 
  transmute(Sum = n) %>% # replace original column
  mutate(MinusSum = -Sum) # add new column

sample_frac(mpg, 0.05, replace = TRUE) # return a random data by proportion of rows
sample_n(mpg, 3, replace = TRUE) # return a random data by number of rows

# summarise by data set
modelTotal = group_by(mpg, manufacturer, model, year) %>%
  summarise(count = n()) %>%
  arrange(desc(count), manufacturer, model, year) 

# database design
install.packages("nycflights13")
library(nycflights13)
airlineDF = nycflights13::airlines
airportDF = nycflights13::airports
flightDF = nycflights13::flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier) %>%
  left_join(airlineDF, by="carrier") %>% # left join
  select(c(-"carrier"))
lostFlightDF = filter(flightDF, !name %in% airlineDF$name)

meals = read.csv("https://data.yorkopendata.org/dataset/14b8a985-fc49-4d3e-947e-b4f12c9bf59b/resource/03b0ae33-f6fe-4431-94f8-4b811c8921ba/download/fsmdetails.csv", header = TRUE, stringsAsFactors = FALSE)
View(meals)

# find the actual mean of FSMTaken for the missing items
summary(meals$FSMTaken)
meanFSMTaken1 = mean(meals$FSMTaken) # all
meanFSMTaken2 = mean(meals$FSMTaken, na.rm = TRUE) # exclude na
excludedFake = length(meals$FSMTaken[meals$FSMTaken != 9999])
actualFSMTaken = meals$FSMTaken[meals$FSMTaken != 9999 & !is.na(meals$FSMTaken)] # exclude na and 9999
actualMeanFSMTaken = mean(actualFSMTaken) # actual mean of FSMTaken
replaceMean = floor(actualMeanFSMTaken)

filteredMeals = filter(meals, FSMTaken != 9999 | is.na(FSMTaken)) # the collection which includes ready and missing items
filteredMeals$FSMTaken[is.na(filteredMeals$FSMTaken)] = actualMeanFSMTaken
missNum = length(filteredMeals$FSMTaken[is.na(filteredMeals$FSMTaken)]) # confirm whether it is 0

# practice by for loop
for(missIndex in 1:length(filteredMeals$FSMTaken)){
  if(is.na(filteredMeals$FSMTaken[missIndex])){
    filteredMeals$FSMTaken[missIndex] = actualMeanFSMTaken
  }
}

# another way to add a new column
meals = filter(meals, FSMTaken != 9999 | is.na(FSMTaken)) %>%
  mutate(NewFSMTaken = ifelse(is.na(FSMTaken), floor(mean(FSMTaken, na.rm = TRUE)), FSMTaken))

group = group_by(meals, NewFSMTaken) %>%
  summarise(count = n()) %>%
  arrange(desc(NewFSMTaken))

top5 = meals[meals$NewFSMTaken == sort(unique(meals$NewFSMTaken), decreasing = TRUE)[5],]

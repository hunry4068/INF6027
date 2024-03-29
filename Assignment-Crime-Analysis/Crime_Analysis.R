# UK Crime Analysis

#- Initialize Environment ----

# WD setting
getwd()
setwd("C:/Users/Eric Huang/Documents/GitHub/INF6027/Datasets")

# enable packages
library(dplyr) # data manipulation
library(tidyr) # extract(), separate()

library(rgdal) # ReadOGR()
library(lubridate) # months()
library(stringr) # str_detect()

library(cartogram) # cartogram()
library(ggplot2) # ggplot()
library(gridExtra) # grid.arrange()
library(corrplot) # corrplot()
library(tmap) # tmap(), qtm()
library(ggmap) # ggmap()
library(leaflet) # leaflet()

#- Data Collecting and Cleaning ----
#-- read the Sheffield shapefile from UK Data Service (https://borders.ukdataservice.ac.uk/bds.html) ----

# data address: https://borders.ukdataservice.ac.uk/ukborders/servlet/download/dynamic/019F47A21BAC0EFA61154711987306152/15471198736486188636267083719431/BoundaryData.zip
sheffLSOA = readOGR(dsn = "./BoundaryData", layer = "england_lsoa_2011")

#-- read South Yorkshire street crime data from Data.Police.UK (https://data.police.uk/data/) ----

# data address: https://policeuk-data.s3.amazonaws.com/download/ef3bb0f9852deca6befdce43b877eb674a2038d5.zip
# Important: R is basically pass-by-value so the variable is not changed by the function;
# so it needs to pass the return value to the variable by eval.parent(substitute(returnVar <- valueVar))
readCrimesData = function(initDate, endDate, byYear = FALSE){
  date = initDate
  df = data.frame()
  
  repeat{
    origRow = nrow(df)
    currentFormat = format(date, "%Y-%m")
    endFormat = format(endDate, "%Y-%m")
    print(paste("Current date:", currentFormat, ", esitmeated end date:", endFormat))
    
    path = paste("CrimeData/South-Yorkshire-Street/", currentFormat, "-south-yorkshire-street.csv", sep = "")
    newData = read.csv(path, header = TRUE)
    df = rbind(df, newData)
    print(paste("Original data rows:[", origRow, "], add ", currentFormat, " data with [", nrow(newData), "] rows, new rows: [", nrow(df), "]", sep = ""))
    
    if(currentFormat == endFormat){
      # apply eval.parent(substitute(returnVar <- valueVar)) to implication pass-by-reference
      # eval.parent(substitute(bindData <- df))
      # 
      # break
      return(df)
    }
    else if(byYear != TRUE){
      date = date %m+% months(1)
    }
    else{
      date = date %m+% months(12)
    }
  }
}

southYorkshireStreetCrimes = readCrimesData(as.Date("2015-12-01"), as.Date("2018-11-01"))
southYorkshireStreetCrimesByYear = readCrimesData(as.Date("2011-06-01"), as.Date("2017-06-01"), TRUE)

#-- read cctv data from Sheffield City Council (https://data.sheffield.gov.uk/) ----

# data address: https://data.sheffield.gov.uk/api/views/jzyb-3sy3/rows.csv?accessType=DOWNLOADfr
sheffCameras = read.csv("https://data.sheffield.gov.uk/api/views/4d37-a5ib/rows.csv?accessType=DOWNLOAD", header = TRUE)
# clean data: remove invalid camera data
sheffCameras = sheffCameras %>%
  filter(!is.na(sheffCameras$Easting) & !is.na(sheffCameras$Northing))

#-- read population data with genders from Office of National Statisitcs (https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates) ----

# data with estimate population and density (integerated data)
# original data address: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareapopulationdensity

readPopulationData = function(initYear = 2011, endYear = 2017){
  year = initYear
  df = data.frame()
  
  repeat{
    origRow = nrow(df)
    print(paste("Current year:", year, ", esitmeated end year:", endYear))
    
    path = paste("PopulationData/Pop_", year, ".csv", sep = "")
    newData = read.csv(path, header = TRUE) %>% mutate(Year = year)
    
    df = rbind(df, newData)
    print(paste("Original data rows:[", origRow, "], add ", year, " data with [", nrow(newData), "] rows, new rows: [", nrow(df), "]", sep = ""))
    
    if(year == endYear){
      # to fix in the future
      # colNames = colnames(df)
      # startIndex = grep("Population.all", colNames)
      # 
      # for (colIndex in startIndex:ncol(df)) {
      #   df[colIndex] = as.numeric(gsub(",", "", as.character(df[colIndex])))
      # }
      df$Population.all = as.numeric(gsub(",", "", as.character(df$Population.all)))
      df$Littles = as.numeric(gsub(",", "", as.character(df$Littles)))
      df$Teens = as.numeric(gsub(",", "", as.character(df$Teens)))
      df$Twenties = as.numeric(gsub(",", "", as.character(df$Twenties)))
      df$Thirties = as.numeric(gsub(",", "", as.character(df$Thirties)))
      df$Fourties = as.numeric(gsub(",", "", as.character(df$Fourties)))
      df$Fifties = as.numeric(gsub(",", "", as.character(df$Fifties)))
      df$Sixties = as.numeric(gsub(",", "", as.character(df$Sixties)))
      df$Seventies = as.numeric(gsub(",", "", as.character(df$Seventies)))
      df$Eighties = as.numeric(gsub(",", "", as.character(df$Eighties)))
      df$Nineties = as.numeric(gsub(",", "", as.character(df$Nineties)))
      
      # apply eval.parent(substitute(returnVar <- valueVar)) to implication pass-by-reference
      # eval.parent(substitute(bindData <- df))
      # 
      # break
      
      return(df)
    }
    else year = year + 1
  }
}
sheffPopulation = readPopulationData()

# oringinally single data)
# sheffPopulation = read.csv("./PopulationData/June_2017_LSOA_Population_summary.csv") %>%
#   rename(Density = People_per_Sq_Km)
# sheffPopulation$Population.all = as.numeric(gsub(",", "", as.character(sheffPopulation$Population.all)))
# sheffPopulation$Density = as.numeric(gsub(",", "", as.character(sheffPopulation$Density)))
# sheffPopulation$Population.female = as.numeric(gsub(",", "", as.character(sheffPopulation$Population.female)))
# sheffPopulation$Population.male = as.numeric(gsub(",", "", as.character(sheffPopulation$Population.male)))
# View(sheffPopulation)

#- Data Processing ----
#-- frequently using variables ----

# extract Sheffield LSOA codes for subsequent filtering
sheffLSOAcodes = as.vector(unique(sheffLSOA@data$code))

# convert the polygons of LSOA from NAD83 / UTM zone 12N to WGS84 to meet leaflet's format
sheffLSOAWithWGS84 = 
  spTransform(sheffLSOA, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# filter street crimes by Sheffield's LSOA codes
sheffStreetCrimes = 
  southYorkshireStreetCrimes[southYorkshireStreetCrimes$LSOA.code %in% sheffLSOAcodes, ]

# group by LSOA code and join with sheffLSOA
groupCrimesByLSOACode = sheffStreetCrimes %>%
  group_by(LSOA.code) %>%
  summarise(Number = n())
sheffLSOA@data = left_join(sheffLSOA@data, groupCrimesByLSOACode, by = c("code" = "LSOA.code"))
View(sheffLSOA@data)

# extract Sheffield crime types for subsequent filtering and
crimeTypes = as.vector(unique(sheffStreetCrimes$Crime.type))

# create variable for single crime type analysis
singleCrimeType = crimeTypes[1]

# using extract to separate data from a column into multiple new column with regular expression
sheffCameras.extracted = sheffCameras %>% extract(Coordinates, into = c("lat", "lon"), "^[(](.*),\\s+(.*)[)]$")
# convert data type by as.numeritc and as.character (to avoid R transfer the data into list)
sheffCameras.extracted$lat = sheffCameras.extracted$lat %>% as.numeric()
sheffCameras.extracted$lon = sheffCameras.extracted$lon %>% as.numeric()

#-- frequently using functions ----

# calculate the portion of data
getPercentage = function(x, digits = 2, format = "f"){
  paste0(formatC(x * 100, digits = digits, format = format), "%")
  # as.numeric(format(x * 100, digits = digits, format = format))
}

# read Sheffield crime data with crime types, months, and LSOA codes 
readSheffieldCrimes = function(types = vector(), months = vector(), lsoaCodes = vector()){
  data = sheffStreetCrimes
  if(length(types) > 0) data = data %>% filter(Crime.type %in% types)
  if(length(months) > 0) data = data %>% filter(Month %in% months)
  if(length(lsoaCodes) > 0) data = data %>% filter(LSOA.code %in% lsoaCodes)
  
  returnValue(as.data.frame(data))
}

# read Sheffield cirme data with population data (for correnation and regression)
readCrimeDataWithPopulationByYear = function(crimeType = "", lsoaCode = ""){
  crimeData = southYorkshireStreetCrimesByYear
  if(crimeType != "") crimeData = crimeData %>% filter(Crime.type == crimeType)
  if(lsoaCode != "") crimeData = crimeData %>% filter(LSOA.code == lsoaCode)
  
  sheffCrimeData = crimeData[crimeData$LSOA.code %in% sheffLSOAcodes, ] %>%
    separate(Month, c("Year"), "-", extra = "drop") %>% # separate character into only one column by setting extra = "drop"
    select(Crime.type, LSOA.code, Year) %>%
    mutate(Year = as.numeric(as.character(Year))) %>%
    group_by(LSOA.code, Year) %>%
    summarise(Crime.number = n())
  
  populationData = readPopulationData()
  if(lsoaCode != "") populationData = populationData %>% filter(LSOA.code == lsoaCode)
  
  integratedData = left_join(populationData, sheffCrimeData, by = c("LSOA.code", "Year")) %>%
    mutate_if(is.numeric, funs(replace(., is.na(.), 0))) %>% # replace numeric variable from na to 0
    arrange(Year)
  
  return(integratedData)
}

#-- estimate missing data ----

evalCrimes = southYorkshireStreetCrimes
evalCrimes$LSOA.code[evalCrimes$LSOA.code == ""] = as.factor(NA)

# the portion of the missing data only takes 4.06% with 23982 of all with;
# also, later the crime data will join with Sheffield's areas,
# so do not need any manipulation of missing data
evalCrimes = arrange(
  evalCrimes %>%
    group_by(LSOA.code) %>%
    summarise(Number = n(), Percentage = getPercentage(n()/nrow(evalCrimes))),
  desc(Percentage)
)
View(evalCrimes)

# meanwhile, if we focus on the type of 
total = evalCrimes %>%
  group_by(Crime.type) %>%
  summarise(Total = n())
missing = evalCrimes %>%
  filter(is.na(LSOA.code)) %>%
  group_by(Crime.type) %>%
  summarise(Missing = n())
missingRateByType = left_join(total, missing, by = "Crime.type")
missingRateByType["Missing.rate"] = c(missingRateByType["Missing"] / missingRateByType["Total"] * 100)
missingRateByType = missingRateByType %>% arrange(desc(Missing.rate))
View(missingRateByType)

#- Grid and chart ----

ggsave("./SavedGraphs/01.1_Bar_Sheffield_crime_types_201512_201811.png", width = 5, height = 5)

#-- plot Sheffield street crime types by bar chart ----

groupCrimesByType = sheffStreetCrimes %>%
  rename(Type = Crime.type) %>%
  group_by(Type) %>%
  summarise(Number = n(), Percentage = getPercentage(n()/nrow(sheffStreetCrimes))) %>%
  arrange(Number)
groupCrimesByType$Type = factor(groupCrimesByType$Type, levels = unique(groupCrimesByType$Type))

ggplot(groupCrimesByType, aes(x = Type, y = Number)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Sheffield street crime types 2015/12-2018/11") +
  xlab("Crime type") + ylab("Crime number")

#-- plot Sheffield street crime types with months by stacked bar chart and line chart ----

groupCrimesByTypeAndMonth = sheffStreetCrimes %>%
  rename(Type = Crime.type) %>%
  group_by(Type, Month) %>%
  summarise(Number = n()) %>%
  arrange(Month, desc(Number), Type)
# set the order of the levels of the factor as they originally occur in the vector, the levels vector should be distinct
groupCrimesByTypeAndMonth$Type = factor(groupCrimesByTypeAndMonth$Type, levels = unique(groupCrimesByTypeAndMonth$Type))

# plot by stacked bar chart
ggplot(groupCrimesByTypeAndMonth, aes(x = Month, y = Number)) +
  geom_bar(aes(fill = Type), stat = "identity") +
  coord_flip() +
  ggtitle("Sheffield street crime types with months 2015/12-2018/11") + 
  xlab("Month") + ylab("Crime number") + guides(fill = guide_legend(title = "Crime type"))

# plot by line chart
ggplot(groupCrimesByTypeAndMonth, aes(x = Month, y = Number, color = Type, group = Type)) +
  geom_line() +
  coord_flip() +
  ggtitle("Sheffield street crime types with months 2015/12-2018/11") + 
  xlab("Month") + ylab("Crime number") + guides(fill = guide_legend(title = "Crime type"))

# plot by line chart only 2018
groupCrimesByTypeAndMonth2018 = groupCrimesByTypeAndMonth %>%
  filter(str_detect(Month, "^2018"))
ggplot(groupCrimesByTypeAndMonth2018, aes(x = Month, y = Number, color = Type, group = Type)) +
  geom_line() +
  coord_flip() +
  ggtitle("Sheffield street crime types with months 2018") + 
  xlab("Month") + ylab("Crime number") + guides(fill = guide_legend(title = "Crime type"))

#-- try to transform the month into a continuous variable for displaying by stacked area chart ----

groupCrimesForStockedChart = sheffStreetCrimes
groupCrimesForStockedChart$Month = as.numeric(gsub("-", "", as.character(sheffStreetCrimes$Month)))
groupCrimesForStockedChart = groupCrimesForStockedChart %>%
  rename(Type = Crime.type) %>%
  group_by(Type, Month) %>%
  summarise(Number = n())
groupCrimesForStockedChart = arrange(groupCrimesForStockedChart, Month, desc(Number), Type)
groupCrimesForStockedChart$Type = factor(groupCrimesForStockedChart$Type, levels = unique(groupCrimesForStockedChart$Type))

ggplot(data = groupCrimesForStockedChart,
       aes(x = Month, y = Number, fill = Type, colour = Type)) +
  geom_area() +
  coord_flip() +
  ggtitle("Sheffield street crimes by month and type")

#-- plot a single street crime type with months by bar chart ----

# plot line chart for single street crime type with year and month
groupSingleCrimeForLineChart = groupCrimesByTypeAndMonth %>%
  filter(Type == singleCrimeType) %>% 
  separate("Month", c("Year", "Month"), sep = "-")
# remove 2015-12
groupSingleCrimeForLineChart = groupSingleCrimeForLineChart[c(-1),]

ggplot(groupSingleCrimeForLineChart, aes(x = Month, y = Number, color = Year, group = Year)) +
  geom_line() +
  ggtitle(paste(singleCrimeType, "with years and months 2016/01-2018/11")) +
  ylab("Crime number")

ReadParticularCrime = function(type){
  groupSingleCrimeForBarChart = groupCrimesByTypeAndMonth %>%
    filter(Type == type)
  ggplot(data = groupSingleCrimeForBarChart, aes(x = Month, y = Number)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    ggtitle(paste("Sheffield", type, "with month 2015/12-2018/11")) +
    ylab("Crime number")
  
  for(indexItem in 1: nrow(groupSingleCrimeForBarChart)){
    yearGroup = 1 + (indexItem-1) %/% 12
    groupSingleCrimeForBarChart$Year[indexItem] = yearGroup
  }
  
  crimeByYear1 = groupSingleCrimeForBarChart %>%
      filter(Year == 1)
  print(summary(crimeByYear1))
  plot1 = qplot(Month, Number, data = crimeByYear1 %>% select(Month, Number)) + 
    # coord_flip() +
    ggtitle("First year")
  
  crimeByYear2 = groupSingleCrimeForBarChart %>%
      filter(Year == 2)
  print(summary(crimeByYear2))
  plot2 = qplot(Month, Number, data = crimeByYear2 %>% select(Month, Number)) + 
    # coord_flip() +
    ggtitle("Second year")
  
  crimeByYear3 = groupSingleCrimeForBarChart %>%
      filter(Year == 3)
  print(summary(crimeByYear3))
  plot3 = qplot(Month, Number, data = crimeByYear3 %>% select(Month, Number)) + 
    # coord_flip() +
    ggtitle("Third year")
    
  grid.arrange(plot1, plot2, plot3, nrow = 1)
}
ReadParticularCrime(singleCrimeType)

#- Correlation and Linnear Regression ----
#-- plot correlation grid to comapre crime number with population and density ----

coorCrimeAndPopulation = function(crimeType = ""){
  crimeAndPopulation = readCrimeDataWithPopulationByYear(crimeType) %>%
    subset(select = -c(LSOA.code, LSOA.name, Year))
    # mutate(Littles.rate = Littles / Population.all) %>%
    # mutate(Teens.rate = Teens / Population.all) %>%
    # mutate(Twenties.rate = Twenties / Population.all) %>%
    # mutate(Thirties.rate = Thirties / Population.all) %>%
    # mutate(Fourties.rate = Fourties / Population.all) %>%
    # mutate(Fifties.rate = Fifties / Population.all) %>%
    # mutate(Sixties.rate = Sixties / Population.all) %>%
    # mutate(Seventies.rate = Seventies / Population.all) %>%
    # mutate(Eighties.rate = Eighties / Population.all) %>%
    # mutate(Nineties.rate = Nineties / Population.all) %>%
    
  crimeTitle = ifelse(crimeType == "", "All crimes", paste(crimeType, "crime"))
  corrplot(cor(crimeAndPopulation), method = "color",
           type = "lower",
           title = paste("Population cross", crimeTitle),
           tl.col = "black",
           # Margin added here
           mar = c(0, 0, 2, 0),
           diag = FALSE)
  
  # check the p-value of the variable
  cor.test(x = crimeAndPopulation$Thirties, y = crimeAndPopulation$Crime.number)
}
coorCrimeAndPopulation(singleCrimeType)

#-- regression tset ----

# data = readSheffieldCrimes(c(singleCrimeType))
# 
# groupByLSOACode = data %>%
#   group_by(LSOA.code) %>%
#   summarise(Number = n()) %>%
#   arrange(desc(Number))
# View(groupByLSOACode)
#
# crimeDataByAreas = list()
# for (index in 1:length(top5Areas)) {
#   dataByarea = data %>%
#     filter(LSOA.code == top5Areas[index]) %>%
#     group_by(Month) %>%
#     summarise(Number = n()) %>%
#     arrange(Month) %>%
#     mutate(Sequence = row_number()) %>%
#     as.data.frame()
#   crimeDataByAreas[[top5Areas[index]]] = dataByarea
# }
# View(dataByAreas[[1]])
# 
# ggplot(data = dataByAreas[[5]], aes(x = Sequence, y = Crime.number)) + geom_point()  +
#   stat_smooth(method = "lm", col = "dodgerblue3") +
#   theme(panel.background = element_rect(fill = "white"),
#         axis.line.x=element_line(),
#         axis.line.y=element_line()) +
#   ggtitle("Linear Model Fitted to Data")

#-- implement by Anti-social behaviour with top 5 crime areas ----
# top 5 areas
# E01033264 3202
# E01033265 2335
# E01007944 1201
# E01033268 1191
# E01033269 1132

top5Areas = c("E01033264",
              "E01033265",
              "E01007944",
              "E01033268",
              "E01033269")

top3Areas = list("E01033268", # Sheffield 075G / 518
              "E01033270", # Sheffield 022H / 499
              "E01007905") # Sheffield 027C / 490
names(top3Areas) = c("Sheffield 075G", "Sheffield 022H", "Sheffield 027C")
area = top3Areas[3]

ggplot(data = readCrimeDataWithPopulationByYear(singleCrimeType, area), 
       aes(x = Thirties, y = Crime.number)) + geom_point()  +
  stat_smooth(method = "lm", col = "dodgerblue3") +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(),
        axis.line.y=element_line()) +
  ggtitle(paste("Linear Model for Anti-social behaviour with Thirties in", names(area)))

#- Map ----
#-- demo tmap with crime level ----

# qtm(sheffLSOA, fill = "Number", alpha = 0.5) # simple way to plot map

tmap_mode("view")
tm_shape(sheffLSOA) + tm_fill("Number", alpha=0.5, style="kmeans", border.col = "black") + tm_borders(alpha=0.5)

sheffiCarto = cartogram(sheffLSOA, weight = "Number", itermax = 10, prepar = "adjust")
tm_shape(sheffiCarto) + tm_fill("Number", style = "jenks", alpha = 0.3) + tm_borders(alpha=0.5) + tm_layout(frame = F)

#-- plot tmap with multiple maps with different years' crime level ----

plotCrimeMapsBy3Year = function(crimeType = ""){
  crimes = data.frame()
  if(crimeType == "") crimes = readSheffieldCrimes()
  else crimes = readSheffieldCrimes(c(crimeType))
  groupCrimes = crimes %>%
    group_by(LSOA.code) %>%
    summarise(Number = n())
  
  label = vector()
  for (yearth in 1:3) {
    regexpr = paste(as.character(2014 + yearth), "-12|^", as.character(2015 + yearth), "-(?!.*12)", sep = "")
    label[yearth] = paste("Year", yearth, ".Number", sep = "")
    yearGroup = crimes %>%
      filter(str_detect(Month, regexpr)) %>%
      group_by(LSOA.code) %>%
      summarise(Number = n())
    colnames(yearGroup)[2] = label[yearth]
    
    groupCrimes = left_join(groupCrimes, yearGroup, "LSOA.code" = "LSOA.code")
  }
  sheffLSOAForMaps = sheffLSOA
  sheffLSOAForMaps@data = sheffLSOAForMaps@data %>%
    subset(select = -c(Number)) %>%
    left_join(groupCrimes, by = c("code" = "LSOA.code"))
  View(sheffLSOAForMaps@data)
  
  tmap_mode("view")
  tm_shape(sheffLSOAForMaps) + 
    tm_fill(c("Number", label), title = c("Total", "Year1", "Year2", "Year3"), convert2density = FALSE, alpha = .9) +
    # tm_fill("Number", convert2density = TRUE, alpha = .9) +
    tm_borders(alpha = .3)
}
plotCrimeMapsBy3Year()

#-- demo ggmap with the distribution of cameras ----

qmplot(lon, lat, data = sheffCameras.extracted, color = I("red"), size = I(1), darken = .1)

#-- demo leaflet with Sheffield LSOA Shape ----

leaflet(sheffLSOAWithWGS84) %>%
  addTiles() %>%
  addPolygons()

#-- plot leaflet with all street crimes (high risk to shut down due to a great number of dots) ----

plotAllStreetCrimes = function(){
  leaflet(sheffStreetCrimes) %>%
    addTiles() %>%
    addCircleMarkers(lng = sheffStreetCrimes$Longitude, lat = sheffStreetCrimes$Latitude, popup = sheffStreetCrimes$Crime.type, radius = 2, stroke = FALSE, fillOpacity = 0.75)
}
plotAllStreetCrimes()

#-- plot leaflet with crime or camera spots ----

# spotTypes = c("Camera", "Density", "Population.all", "Population.male", "Population.female")
spotTypes = c("Camera", names(sheffPopulation %>% select(-c("LSOA.code","LSOA.name", "Year"))))
plotCrimeMapWithSpots = function(spotType, crimeType){
  # filter and join data ----
  crimeData = sheffStreetCrimes
  if(crimeType != "") crimeData = sheffStreetCrimes %>% filter(Crime.type == crimeType)
  
  spotData = data.frame()
  if(spotType == spotTypes[1]){
    crimeData = crimeData %>%
      # filter(Month == "2017-06") %>% 
      group_by(LSOA.code) %>%
      summarise(Number = n())
    
    sheffLSOAWithWGS84@data = sheffLSOAWithWGS84@data %>%
      subset(select = (-c(Number))) %>%
      left_join(crimeData, by = c("code" = "LSOA.code"))
    
    spotData = sheffCameras.extracted
  }
  else{
    sheffLSOAWithWGS84@data = sheffLSOAWithWGS84@data %>%
      left_join(sheffPopulation %>% filter(Year == 2017), by = c("code" = "LSOA.code"))
    View(sheffLSOAWithWGS84@data)
    # only Jun. 2017 crime data join population data
    spotData = crimeData %>%
      filter(Month == "2017-06") %>% 
      select(Longitude, Latitude) %>%
      rename(lon = Longitude, lat = Latitude)
  }
  
  # set title ----
  titleDic = as.list(c("crime and camera spots",
                       "population and crime spots",
                       paste(casefold(spotTypes[-1:-2]), "and crime spots")))
  names(titleDic) = spotTypes
  title = paste("Sheffield", titleDic[[spotType]])
  
  # set bins ----
  binDic = list(# c(0, 25, 50, 75, 100, 125, 150, 175, 200, 250), # single month crimes
                c(0, 100, 250, 500, 1000, 2000, 4000, 6000, 8000, 10000), # total crimes
                c(0, 500, 1000, 2000, 3000, 4000, 5000, 6000), # population.all
                c(0, 50, 100, 200, 300, 400, 500, 600, 700, 800), # littles
                c(0, 50, 100, 250, 500, 1000, 1500, 2000, 2500, 3000), # teens
                c(0, 100, 250, 500, 1000, 2000, 2500, 3000, 3500, 4000), # twenties
                c(0, 50, 100, 200, 300, 400, 500, 600, 700, 800), # thirties
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000), # fourties
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000), # fifties
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000), # sixties
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000), # seventies
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000), # eighties
                c(0, 10, 20, 50, 100, 200, 400, 600, 800, 1000) # nineties
                )
  names(binDic) = spotTypes
  bins = binDic[[spotType]]
  
  # set fill refer column ----
  # columnDic = list("Number", "Density", "Population.all", "Population.male", "Population.female")
  columnDic = as.list(c("Number", spotTypes[-1]))
  names(columnDic) = spotTypes
  fillCol = sheffLSOAWithWGS84@data[[columnDic[[spotType]]]]
  
  # set label for identifying region name and number ----
  labelUnit = ifelse(spotType == spotTypes[1], "crimes", "people")
  labelFormat = paste("<strong>%s</strong><br/>%g ", labelUnit, "</sup>", sep = "")
  
  labels = sprintf(labelFormat, sheffLSOAWithWGS84$name, fillCol) %>%
    lapply(htmltools::HTML)
  
  # plot leaflet ----
  # set fill color for identifying crime level
  pal = colorBin("YlOrRd", domain = fillCol, bins = bins)
  View(sheffLSOAWithWGS84)
  myMap = leaflet(sheffLSOAWithWGS84) %>%
    addTiles() %>%
    setView(lat = 53.385, lng = -1.477, zoom = 12) %>% # set default focus coordinates
    addCircleMarkers(data = spotData,  clusterOptions = markerClusterOptions()) %>%
    # addCircles()
    addPolygons(fillColor = ~pal(fillCol),
                weight = 1,
                opacity = .5,
                color = "black",
                dashArray = "3",
                fillOpacity = 0.5,
                highlight = # active hightlight by hovering over each region
                  highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.5,
                    bringToFront = TRUE),
                label = labels, # active label by hovering over each region
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px, 8px"),
                  textsize = "15px",
                  direction = "auto"))
  myMap %>%
    addLegend(pal = pal, values = ~fillCol, opacity = 0.3, title = title, position = "topright")
}
plotCrimeMapWithSpots(spotTypes[6], singleCrimeType)

#- ----


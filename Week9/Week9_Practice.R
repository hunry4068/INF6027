# 20th 0f Nov. 2018 Spatial data visualization

install.packages("tmap")
library(tmap)
install.packages("rgdal")
library(rgdal)

setwd("C:/Users/Eric Huang/Documents/University of Sheffield/MSc Data Science/01. INF6027 Introduction to Data Science/04. Project Document for R/Datasets")
sheffieldShape = readOGR(dsn = "./BoundaryData", layer = "england_lsoa_2011")
head(sheffieldShape@data, n = 2)
head(sheffieldShape@data, n = 1)

# represent a map with basic graph
tmap_mode("plot")
qtm(sheffieldShape)

# represent a map with control panel
tmap_mode("view")
qtm(sheffieldShape)

# remove the fill with claerer shape
qtm(sheffieldShape, fill = NULL)

# import the map data source
deprivation2015 = read.csv("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/467774/File_7_ID_2015_All_ranks__deciles_and_scores_for_the_Indices_of_Deprivation__and_population_denominators.csv", header = TRUE)
View(deprivation2015)

library(tidyverse)

# choose specific columns for practice and replace the names
deprivation2015Pop = deprivation2015 %>% 
  select(LSOA.name..2011.,
          LSOA.code..2011., Total.population..mid.2012..excluding.prisoners.,
          Dependent.Children.aged.0.15..mid.2012..excluding.prisoners.,
          Population.aged.16.59..mid.2012..excluding.prisoners.,
          Older.population.aged.60.and.over..mid.2012..excluding.prisoners.)
names(deprivation2015Pop)[names(deprivation2015Pop) == "LSOA.name..2011."] = "LSOA_name"
names(deprivation2015Pop)[names(deprivation2015Pop) == "LSOA.code..2011."] = "LSOA_code"      
names(deprivation2015Pop)[names(deprivation2015Pop) == "Total.population..mid.2012..excluding.prisoners."] = "Total_population"      
names(deprivation2015Pop)[names(deprivation2015Pop) == "Dependent.Children.aged.0.15..mid.2012..excluding.prisoners."] = "Child_population"
names(deprivation2015Pop)[names(deprivation2015Pop) == "Population.aged.16.59..mid.2012..excluding.prisoners."] = "MidAge_population"
names(deprivation2015Pop)[names(deprivation2015Pop) == "Older.population.aged.60.and.over..mid.2012..excluding.prisoners."] = "Elderly_population"

# integrate the data for later using
sheffieldShape@data = left_join(sheffieldShape@data, deprivation2015Pop, by = c("code" = "LSOA_code"))
qtm(sheffieldShape, fill = "Total_population")

tm_shape(sheffieldShape) +
  tm_fill("Elderly_population", style = "kmeans", border.col = "black") +
  tm_borders(alpha = 0.5)

tmap_mode("view")
tm_shape(sheffieldShape) +
  tm_fill("Elderly_population", alpha = 0.5, style = "kmeans", border.col = "black") +
  tm_borders(alpha = 0.5)

sheffMidAge = 
  tm_shape(sheffieldShape) +
  tm_fill("MidAge_population", alpha = 0.5, style = "kmeans", border.col = "black") +
  tm_borders(alpha = 0.5)
sheffMidAge + tm_scale_bar()

tm_shape(sheffieldShape) +
  tm_fill(c("Total_population", "Child_population", "MidAge_population", "Elderly_population"), title = c("Total pop. (mid 2012)", "Child pop.", "Adult pop.", "Elderly pop."), convert2density = TRUE) +
  tm_borders(alpha = .5)

crimes = read.csv("2018-09-south-yorkshire-street.csv", header = TRUE)
View(crimes)
crimes %>%
  filter(LSOA.code == "E01007321")

numCrimeByLSOA = crimes %>%
  select(LSOA.code, LSOA.name, Crime.type) %>%
  group_by(LSOA.code) %>%
  summarise(Num.crimes = n())
sheffieldShape@data = left_join(sheffieldShape@data, numCrimeByLSOA, by = c("code" = "LSOA.code"))
tmap_mode("view")
qtm(sheffieldShape, fill = "Num.crimes", alpha = .5)

install.packages("cartogram")
library(cartogram)

sheffCarto = cartogram(sheffieldShape, weight = "Num.crimes", itermax = 10, prepare = "adjust")
tm_shape(sheffCarto) +
  tm_fill("Num.crimes", style = "jenks") +
  tm_borders() +
  tm_layout(frame = F)

# **************************************************************#
# R/Rstudio Practical Week 9 
# Nov 2018
# Instructor: Paul Clough
# **************************************************************#


# **************************************************************#
# Mapping in R with the tmap package
# **************************************************************#

# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html
# https://www.jstatsoft.org/article/view/v084i06/v84i06.pdf
# https://geocompr.robinlovelace.net/ 

install.packages("tmap")
library(tmap)

install.packages("rgdal")
library(rgdal)

# create sp or SpatialPolygonsDataframe object 
sheffieldShape<-readOGR(dsn="./BoundaryData", layer="england_lsoa_2011")

head(sheffieldShape@data, n=2)

head(sheffieldShape@polygons, n=1)

qtm(sheffieldShape)

tmap_mode("view") # change the map to be interactive
qtm(sheffieldShape)

qtm(sheffieldShape, fill=NULL)

tmap_mode("plot")

# Colouring the thematic map

# read in the 2015 deprivation indices
deprivation2015<-read.csv("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/467774/File_7_ID_2015_All_ranks__deciles_and_scores_for_the_Indices_of_Deprivation__and_population_denominators.csv", header=TRUE)
View(deprivation2015)
# For the moment let's jsut pull out some population variables (the variable names are rather long)

library(tidyverse)

deprivation2015Pop<-deprivation2015 %>% select(LSOA.name..2011., LSOA.code..2011., Total.population..mid.2012..excluding.prisoners., Dependent.Children.aged.0.15..mid.2012..excluding.prisoners., Population.aged.16.59..mid.2012..excluding.prisoners., Older.population.aged.60.and.over..mid.2012..excluding.prisoners.)

head(deprivation2015Pop)

# let's shorten the variable names
names(deprivation2015Pop)[names(deprivation2015Pop)=="LSOA.name..2011."]<-"LSOA_name"
names(deprivation2015Pop)[names(deprivation2015Pop)=="LSOA.code..2011."]<-"LSOA_code"
names(deprivation2015Pop)[names(deprivation2015Pop)=="Total.population..mid.2012..excluding.prisoners."]<-"Total_population"
names(deprivation2015Pop)[names(deprivation2015Pop)=="Dependent.Children.aged.0.15..mid.2012..excluding.prisoners."]<-"Child_population"
names(deprivation2015Pop)[names(deprivation2015Pop)=="Population.aged.16.59..mid.2012..excluding.prisoners."]<-"MidAge_population"
names(deprivation2015Pop)[names(deprivation2015Pop)=="Older.population.aged.60.and.over..mid.2012..excluding.prisoners."]<-"Elderly_population"
head(deprivation2015Pop)

# We can easily join the deprivation data to the Sheffield shape file using  a join via the LSOA code
sheffieldShape@data<-left_join(sheffieldShape@data, deprivation2015Pop, by=c('code'='LSOA_code'))

# This is the quick tmap function to create a static thematic or horopleth map
qtm(sheffieldShape, fill="Total_population")

# This is the fuller tmap command that produces a static thematic or choropleth map
tm_shape(sheffieldShape) +
  tm_fill("Elderly_population", style="kmeans", border.col = "black") + 
  tm_borders(alpha=0.5)

tmap_mode("view")
tm_shape(sheffieldShape) +
  tm_fill("Elderly_population", alpha=0.5, style="kmeans", border.col = "black") + 
  tm_borders(alpha=0.5)

# Exercise
tm_shape(sheffieldShape) +
  tm_fill("MidAge_population", style="kmeans", border.col = "black") + 
  tm_borders(alpha=.5)


sheffElderly<-tm_shape(sheffieldShape) +
  tm_fill("Elderly_population", alpha=0.5, style="kmeans", border.col = "black") + 
  tm_borders(alpha=0.5)

sheffElderly + 
  tm_scale_bar()

tmap_mode("plot")
sheffElderly + 
  tm_scale_bar() + 
  tm_compass(position=c("right", "top"))

# Plotting multiple maps at once ....
tm_shape(sheffieldShape) +
  tm_fill(c("Total_population", "Child_population", "MidAge_population", "Elderly_population"), title=c("Total population (mid 2012)", "Child population", "Adult population", "Elderly population"),
          convert2density=TRUE) + 
  tm_borders(alpha=.5) 


# **************************************************************#
# Analysing crime data from the UK Police
# **************************************************************#

# Now let's get to work on the police.gov.uk dataset
# We have individual crimes reported by their LSOA
# Simplest is to group the crimes across the datset by LSOA

crimes<-read.csv("2017-09-south-yorkshire-street.csv", header=TRUE)
View(crimes)

crimes %>%
  filter(LSOA.code=="E01007321")

numCrimesByLSOA<-crimes %>% 
  select(LSOA.code, LSOA.name, Crime.type) %>%
  group_by(LSOA.code) %>%
  summarise(Num.crimes=n())

numCrimesByLSOA

sheffieldShape@data<-left_join(sheffieldShape@data, numCrimesByLSOA, by=c('code'='LSOA.code'))

tmap_mode("view") # This turns the tmap map interative
qtm(sheffieldShape, fill="Num.crimes")

sheffieldShape[is.na(sheffieldShape@data$Num.crimes)]<-0
qtm(sheffieldShape, fill="Num.crimes", alpha=0.5)

tm_shape(sheffieldShape) +
  tm_fill("Num.crimes", alpha=0.5, style="kmeans", border.col = "black") + 
  tm_borders(alpha=0.5)


# **************************************************************#
# Creating cartograms
# **************************************************************#


install.packages("cartogram")
library(cartogram)

# May take a while to run
sheffCarto<-cartogram(sheffieldShape, weight="Num.crimes", itermax=10, prepare="adjust")

tm_shape(sheffCarto) +
  tm_fill("Num.crimes", style="jenks") + 
  tm_borders() + tm_layout(frame=F)



# **************************************************************#
# Plotting points on a map using ggmap
# **************************************************************#

# install.packages("tidyverse")
# install.packages("tidyr")
library(tidyverse)
library(tidyr)

# get speed cameras
sheffieldCameras<-read.csv("https://data.sheffield.gov.uk/api/views/jzyb-3sy3/rows.csv?accessType=DOWNLOAD", header=TRUE)

head(sheffieldCameras)
str(sheffieldCameras)

# We will use the extract() function
sheffieldCameras.extracted<-cameras %>% extract(Coordinates, into=c("lat", "lon"), '^[(](.*),\\s+(.*)[)]$')
head(sheffieldCameras.extracted)
str(sheffieldCameras.extracted)

# Need to convert the variable to numeric (as currently character)
sheffieldCameras.extracted$lat<-as.numeric(as.character(sheffieldCameras.extracted$lat))
sheffieldCameras.extracted$lon<-as.numeric(as.character(sheffieldCameras.extracted$lon))
str(sheffieldCameras.extracted)

install.packages("ggmap")
library(ggmap)

qmplot(lon, lat, data=sheffieldCameras.extracted, colour = I('red'), size = I(2), darken = .1)


# **************************************************************#
# Interactive maps with Leaflet
# **************************************************************#

install.packages("leaflet")
library(leaflet)


nyc<-c(lon=-74.0059, lat=40.7128)

leaflet() %>%
  addTiles() %>%
  setView(lat = 40.7128, lng = -74.0059, zoom = 7) 


leaflet() %>%
  addTiles() %>%
  setView(lat = 40.7128, lng = -74.0059, zoom = 13) %>%
  addMarkers(lng = -73.985428, lat = 40.748817, popup = "Empire State Building")

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lng=crimes$Longitude, lat=crimes$Latitude,
                       popup=crimes$Crime.type, 
                       radius=2, stroke=FALSE, fillOpacity=0.75)


# let's create a similar thematic map we had before for the Sheffield data
# See: https://rstudio.github.io/leaflet/choropleths.html

# First we need to change the map projection for leaflet to make 
# use of the data we have

leaflet(sheffieldShape) %>%
  addTiles() %>%
  addPolygons()

transformedSheffieldShape <- spTransform(sheffieldShape, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

leaflet(transformedSheffieldShape) %>%
  addTiles() %>%
  addPolygons()
  
# Now define a palette of colours
bins <- c(0, 1000, 2000, 3000, 4000, 5000)
pal <- colorBin("YlOrRd", domain=sheffieldShape$Total_population, bins=bins)

leaflet(transformedSheffieldShape) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Total_population), 
              weight = 2,
              opacity = 1,
              color = "black",
              dashArray = "3",
              fillOpacity = 0.7)

# Now highlight the regions as the mouse hovers over it

leaflet(transformedSheffieldShape) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Total_population), 
              weight = 2,
              opacity = 1,
              color = "black",
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE))

# Finally, add some labels

labels <- sprintf(
  "<strong>%s</strong><br/>%g people</sup>",
  sheffieldShape$LSOA_name, sheffieldShape$Total_population
) %>% lapply(htmltools::HTML)

myMap<-leaflet(transformedSheffieldShape) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(Total_population), 
              weight = 2,
              opacity = 1,
              color = "black",
              dashArray = "3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto"))

myMap

myMap %>%
addLegend(pal = pal, values = ~Total_population, opacity = 0.7, title = NULL,
          position = "bottomright")

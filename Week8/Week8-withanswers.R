# **************************************************************#
# R/Rstudio Practical Week 8 
# Nov 2018
# Instructor: Paul Clough
# **************************************************************#

# **************************************************************#
# Exploring time-series data
# **************************************************************#

library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)

library(nycflights13)
flights

flightsEdited<-flights %>%
  mutate(date=make_date(year, month, day))
  
flightsEdited %>% 
  select(year, month, day, date) %>% 
  head

# Might need to use this instead if you get errors
# flightsEdited %>% 
#   dplyr::select(year, month, day, date) %>% 
#   head

daily<-flightsEdited %>%
  group_by(date) %>%
  summarise(n=n())

head(daily)

ggplot(daily, aes(date, n)) + geom_line()

daily<-flights %>%
  select(year, month, day) %>%
  mutate(date=make_date(year, month, day)) %>%
  group_by(date) %>%
  summarise(n=n())

# check - Line 39 of the script doesn't actually append the weekday column to the data frame
updatedFlightsEdited<-flightsEdited %>%
  mutate(weekday=wday(date, label=TRUE)) %>%
  mutate(month=month(date, label=TRUE)) 

head(updatedFlightsEdited)

# Exercise: select just the data for January and plot
janFlights<-updatedFlightsEdited %>%
  filter(month=="Jan") %>%
  group_by(date) %>%
  summarise(n=n())

ggplot(janFlights, aes(date, n)) + geom_line()

# group data by day
updatedFlightsEdited %>%
  group_by(weekday) %>%
  summarise(n=n())

# group data by month - when you run the function on line 59 it throws an error, because 'weekday' is unknown.
updatedFlightsEdited %>%
  group_by(month) %>%
  summarise(n=n())


# **************************************************************#
# Correlation matrix
# **************************************************************#

# Can also see this resource:
#  https://www.analyticsvidhya.com/blog/2016/03/questions-ggplot2-package-r/

# correlation plot
data("mtcars")
str(mtcars)

mcor<-cor(mtcars)
round(mcor, digits=2)

install.packages("corrplot") # if problems then download from CRAN and install from local file
library(corrplot)
corrplot(mcor)

install.packages("GGally")
library(GGally)
ggcorr(mtcars)

# Exercise - test pairs of variables for correlation
# cor.test(mtcars$cyl, mtcars$disp) # check correlation between pairs

# **************************************************************#
# Network graphs
# **************************************************************#

# install and load network graph packages
install.packages("igraph")
install.packages("geomnet")
install.packages("ggnetwork")

library(GGally)
library(geomnet)
library(ggnetwork)
library(igraph)

# create simple graph manually (using igraph)
gDirected<-graph(c(1,2, 2,3, 2, 4, 1,4, 5,5, 3,6))
gDirected
plot(gDirected)

gUndirected<-graph(c(1,2, 2,3, 2, 4, 1,4, 5,5, 3,6), directed=FALSE)
gUndirected
plot(gUndirected)


nodes<-read.csv("Dataset1-Media-Example-NODES.csv", header=T, as.is=T)
links<-read.csv("Dataset1-Media-Example-EDGES.csv", header=T, as.is=T)
head(nodes)
head(links)
View(nodes)

net<-graph_from_data_frame(d=links, vertices=nodes, directed=T)
net

V(net)$media
E(net)

plot(net, edge.arrow.size=.4,vertex.label=V(net)$media, vertex.color=V(net)$media.type)


# email - just by way of example (not expected to follow or reproduce!)

data(email, package = 'geomnet')
email$edges<-email$edges[, c(1,5,2:4,6:9)]
emailnet<-fortify(
  as.edgedf(subset(email$edges, nrecipients < 54)),
  email$nodes)

set.seed(10312016)
ggplot(data = emailnet,
       aes(from_id = from_id, to_id = to_id)) +
  geom_net(layout.alg = "fruchtermanreingold",
           aes(colour = CurrentEmploymentType,
               group = CurrentEmploymentType,
               linewidth = 3 * (...samegroup.. / 8 + .125)),
           ealpha = 0.25,
           size = 4, curvature = 0.05,
           directed = TRUE, arrowsize = 0.5) +
  scale_colour_brewer("Employment Type", palette = "Set1") +
  theme_net() +
  theme(legend.position = "bottom")

# **************************************************************#
# Heatmap
# **************************************************************#

nba<-read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")
head(nba)
str(nba)

# do some data manipulation ready to plot
row.names(nba) <- nba$Name
head(nba)

nba<-nba[,2:20]
head(nba)

nbaMatrix <- data.matrix(nba)
heatmap(nbaMatrix, Rowv=NA, Colv=NA, col=heat.colors(256), scale="column", margins=c(5,10))


# Just for info - the below could be used to plot all variables in a dataset
# install.packages("tabplot")
# install.packages("ffbase")
# library(tabplot)
# tableplot(mtcars)


# **************************************************************#
# Interactive plots - plotly
# **************************************************************#

install.packages("plotly")
library(plotly)

plot_ly(z=volcano, type="surface")

p<-plot_ly(z=volcano, type="surface")
layout(p, title="Mt Eden in Auckland")

p<-plot_ly(midwest, x=~percollege, color=~state, type="box")
layout(p, title="US colleges")

layout(p, title="US colleges", xaxis=list(title="Percent of college people educated"))

data("women")
p<-ggplot(data=women, mapping=aes(x=height, y=weight)) + geom_point()
p

# plot_ly(women, x=women$height, y=women$weight, type="scatter", mode="markers")
plot_ly(women, x=~height, y=~weight, type="scatter", mode="markers")

# Check - Line 195 attach("economics") needs to be attach(economics) otherwise it throws an error looking for a file and this is likewise for Iris on line 203.
attach(economics)
data(economics)
unemp<-plot_ly(economics, x=date, y=unemploy, mode="line")
layout(unemp, title="Number of umemployed over time")

# unemployment<-ggplot(economics, aes(date,unemploy)) + geom_line()
# ggplotly(unemployment)

attach(iris)
data(iris)
library(ggplot2)
p<-ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species, shape=Species)) + 
  geom_point(size=6, alpha=0.6)
ggplotly(p)


# Again this is just by way of example and not for you to fully understand now
df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2011_us_ag_exports.csv")

# specify the format of the hover over box
df$hover <- with(df, paste(state, '<br>', "Beef", beef, "Dairy", dairy, "<br>",
                           "Fruits", total.fruits, "Veggies", total.veggies,
                           "<br>", "Wheat", wheat, "Corn", corn))

# give state boundaries a white border
l <- list(color = toRGB("white"), width = 2)

# specify some map projection/options
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

plot_ly(df, z = df$total.exports, text = df$hover, locations = df$code, type = 'choropleth',
        locationmode = 'USA-states', color = df$total.exports, colors = 'Purples',
        marker = list(line = l), colorbar = list(title = "Millions USD")) %>%
  layout(title = '2011 US Agriculture Exports by State<br>(Hover for breakdown)', geo = g)



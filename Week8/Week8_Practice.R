# 13th of Nov. 2018 Data Visualization

library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)

library(nycflights13)

# Represent a line chart by date and freq of flights
flights

flightsEdited = flights %>%
  mutate(date = make_date(year, month, day))

flightsEdited %>%
  select(year, month, day, date) %>%
  head()

daily = flightsEdited %>%
  group_by(date) %>%
  summarise(count = n())

dailyPanel = ggplot(daily, aes(date, count))
dailyPanel + geom_line()

updatedFlightsEdited = flightsEdited %>%
  mutate(weekday = wday(date, label = TRUE)) %>%
  mutate(month = month(date, label = TRUE))

# represent a correlation grid by the varibles of mtcars with ggcorr  
data("mtcars")
str(mtcars)
mcor = cor(mtcars)
round(mcor, digits = 2)
install.packages("corrplot")
library(corrplot)
corrplot(mcor)
cor.test(mtcars$cyl, mtcars$mpg)

# represent another kind of grid with ggcorr
install.packages("GGally")
library(GGally)
ggcorr(mtcars)

# represent a network of a graph with plot
install.packages("igraph")
install.packages("geomnet")
install.packages("ggnetwork")
library(igraph)
library(geomnet)
library(ggnetwork)
library(GGally)

# graph with direct
gDirected = graph(c(1,2, 2,3, 2, 4, 1,4, 5,5, 3,6), directed = TRUE)
gDirected
plot(gDirected)

# graph without direct
gUndirected = graph(c(1,2, 2,3, 2, 4, 1,4, 5,5, 3,6), directed = FALSE)
gUndirected
plot(gUndirected)

# represent a network graph by nodes and links
nodes = read.csv("Dataset1-Media-Example-NODES.csv", header = T, as.is = T)
head(nodes)

links = read.csv("Dataset1-Media-Example-EDGES.csv", header = T, as.is = T)
head(links)

net = graph_from_data_frame(d = links, vertices = nodes, directed = T)
net
V(net)$media
E(net)
plot(net, edge.arrow.size = .4, vertex.label = V(net)$media, vertex.color = V(net)$media.type)

data(email, package = "geomnet")
email$edges = email$edges[, c(1,5,2:4,6:9)]
emailnet = fortify(
  as.edgedf(subset(email$edges, nrecipients < 54)),
  email$nodes
)
set.seed(10312016)

# a crazy code!! it show the mail network but it's really hard to understand 
emailnetPanel = ggplot(emailnet, aes(from_id = from_id, to_id = to_id))
emailnetPanel + 
  geom_net(layout.alg = "fruchtermanreingold", 
           aes(colour = CurrentEmploymentType, 
               group = CurrentEmploymentType,
               linewidth = 3 * (...samegroup.. / 8 + .125)),
           ealpha = 0.25, size = 4, curvature = 0.05, directed = TRUE, arrowsize = 0.5) +
  scale_color_brewer("Employment Type", palette = "Set1") +
  theme_net() +
  theme(legend.position = "bottom")

nba = read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep = ",")
head(nba)

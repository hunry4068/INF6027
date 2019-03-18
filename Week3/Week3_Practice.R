
# 10th/Oct./2018 Practice for visualization
View(installed.packages())# return installed packages as a data frame

R.home("library") # return the location of package or document

library("tidyverse") # load a package

data("women") #add dataset

View(women)

summary(women$height) # return the summary from a data frame or vector

# return a Separated info from a vector
mean(women$height)
median(women$height)
max(women$height)
min(women$weight)

# separate the Plots window for better visualization in comparison
par(mfrow=c(2,2))

hist(women$height) # return a vector as a histogram
hist(women$height, breaks = 5.5, main = "Female", xlab = "height", ylab = "number" )
hist(women$weight, breaks = 5.5, main = "Female", xlab = "weight", ylab = "number" )

plot(women$height) # draw a data frame or vector as a plot
plot(women, type = "p", xlab="H", ylab="W")

#??? This shows a strong positive relationship between height and weight (although this is not prove any kind of cause-effect relationship). You should typically check if a correlation is statistically significant or not 
# generally, as the number closer to 1, as the positive relationship stronger 
cor(women$weight, women$height)

#??? calculate the pvalue and confidence interval of the correlation
cor.test(women$weight, women$height)

?mpg
data("mpg")
View(mpg)

# see the output of data frame as string
str(mpg)

# return frequency of the contents of vector as a table
tabManufacturer = table(mpg$manufacturer)
View(tabManufacturer)
class(tabManufacturer)

# return cell proportions as table
propManufacturer = prop.table(tabManufacturer)
round(propManufacturer, 2) # cell proportions (to 2 decimal places)
round(propManufacturer*100, 1) # cell percentages (to 2 decimal places) 

tabModel = table(mpg$model)
View(tabModel)

propModel = prop.table(tabModel)*100 
View(propModel)
round(propModel, 1)

tabClass = table(mpg$manufacturer, mpg$class)
View(tabClass)
propClass = prop.table(tabClass)
round(propClass*100, 1)

# Pairs for drawing a matrix
# The formula attribute is used to select which variables to display in the scatterplot (~ means 'by').
pairs(formula=~hwy+displ+cyl, data=mpg, main="Simple Scatterplot Matrix")

# firstly trans the manuf to table for grouping;
# and then trans it as data frame for easier manipulation
manufac = as.data.frame(table(mpg$manufacturer))

colnames(manufac) = c("Manufacturer", "Frequency") # set column names

manufac = manufac[order(-manufac$Frequency),] # descending order data
max = max(manufac$Frequency)
min = min(manufac$Frequency)
max
min
sum = summary(manufac)
View(sum)
manuInfo = list(Data = manufac, Maxium = max, Minium = min, Summary = sum)

# ggplot
ggplot(data = women) + 
  geom_line(mapping = aes(x = height, y = weight, size = 1)) + 
  ggtitle("GGPlot - Women's weight and height") + 
  xlab("Height") + 
  ylab("Weight") + 
  geom_point(mapping = aes(x = height, y = weight))

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = manufacturer)) + 
  coord_flip() + 
  ggtitle("Count of cars by manufacturer")

par(mfrow = c(2,1))

# bar chart with Sperate each manufacturer by tranmission types
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = mpg$manufacturer, fill = mpg$trans)) + 
  coord_flip() + 
  ggtitle("Count of cars by manufacturer") + 
  xlab("Manufacturer")+ 
  ylab("Count") + 
  labs(fill = "Transmission")

# based on the above instance and display the data as proportion rather than count
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = mpg$manufacturer, fill = mpg$trans), position = "fill") + 
  coord_flip() + 
  ggtitle("Count of cars by manufacturer") + 
  xlab("Manufacturer")+ 
  ylab("Count") + 
  labs(fill = "Transmission")

# practice
afterMillennium = subset(mpg, mpg$class == "compact" & mpg$year > 2000)

# add one more dimension by facet_wrap
ggplot(data = afterMillennium, position="fill") + 
  geom_bar(mapping = aes(x = afterMillennium$model, fill = afterMillennium$displ)) + 
  coord_flip() + 
  ggtitle("Count of cars by manufacturer and model") + 
  xlab("Model") +
  ylab("Manufacturer") + 
  labs(fill = "Displ") +
  facet_wrap(~afterMillennium$manufacturer, ncol = 4)


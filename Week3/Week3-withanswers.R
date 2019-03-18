# **************************************************************#
# R/Rstudio Practical Week 3 
# 5th Oct 2017
# Instructor: Paul Clough
# **************************************************************#

# **************************************************************#
# Packages in R
# **************************************************************#

installed.packages()
View(installed.packages())
library(tidyverse) # if tidyverse is not installed this will raise an error

# only need to do this if tidyverse is not already installed and can 
# use the RStudio menu options or type in the Console window
install.packages("tidyverse") 

library(tidyverse)

# **************************************************************#
# Using R to explore data with built-in functions
# **************************************************************#

library(MASS)

data("women")
women
summary(women)

hist(women$height)

# We can change the title, number of bins etc. Note I have added the
# parameter/argument names into this function call to make it easier to 
# see what the values are bding used for
hist(x=women$height, breaks=4, main="Histogram showing women's heights", xlab="Height")

par(mfrow=c(1,2))
hist(x=women$height, breaks=4, main="Heights", xlab="Height")
hist(x=women$weight, breaks=2, main="Weights", xlab="Weight")

par(mfrow=c(1,1)) # set the Window back again to viewing single graphs

plot(women) # uses the default scatterplot settings
cor(women$weight, women$height)
cor.test(women$weight, women$height, method="spearman")


# **************************************************************#
# Getting familar with the mpg dataset
# **************************************************************#

?mpg
View(mpg)
str(mpg)

# Frequency tables are the most basic and effective way to understand 
# distribution across categories.
mytable<-table(mpg$manufacturer) # one-way table
mytable

prop.table(mytable) # cell proportions
round(prop.table(mytable), 2) # cell proportions (to 2 decimal places)
round(prop.table(mytable)*100, 2) # cell percentages (to 2 decimal places)

mytable<-table(mpg$manufacturer, mpg$class) 
mytable

# Exercise: Try producing the above table using percentages rather than counts.

round(prop.table(table(mpg$manufacturer, mpg$class))*100, 1)

# Generate a basic Scatterplot Matrix
pairs(formula=~hwy+displ+cyl,data=mpg, main="Simple Scatterplot Matrix")

manufac<-as.data.frame(table(mpg$manufacturer))
manufac[order(-manufac$Freq),]
summary(manufac$Freq)

# **************************************************************#
# Using ggplot() to visualise the data
# **************************************************************#

# Starting with the simpler dataset

ggplot(data=women, aes(x=height, y=weight))

ggplot(data=women, mapping=aes(x=height, y=weight)) + geom_point()
ggplot(data=women) + geom_point(mapping=aes(x=height, y=weight))

ggplot(data=women) + geom_line(mapping=aes(x=height, y=weight))

ggplot(data=women) + 
  geom_point(mapping=aes(x=height, y=weight)) + 
  ggtitle("Height vs. weight") + 
  xlab("Height of person") + 
  ylab("Weight of person")

ggplot(data=women) + 
geom_point(mapping=aes(x=height, y=weight), col="steelblue", size=3) + 
ggtitle("Height vs. weight") + 
xlab("Height of person") + 
ylab("Weight of person")

# Now we move to the mpg dataset

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=manufacturer))

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=manufacturer)) +
  coord_flip()

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=manufacturer)) +
  xlab("Manufacturer") +
  ggtitle("Count of cars by manufacturer") + 
  coord_flip()

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=mpg$manufacturer, fill=mpg$trans)) +
  xlab("Manufacturer") +
  labs(fill="Transmission") +
  coord_flip()

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=mpg$manufacturer, fill=mpg$trans), position="fill") +
  xlab("Manufacturer") +
  labs(fill="Transmission") +
  coord_flip()

ggplot(data=mpg) +
  geom_bar(mapping=aes(x=mpg$manufacturer, fill=mpg$trans), position="fill") +
  xlab("Manufacturer") +
  labs(fill="Transmission") +
  coord_flip() + 
  facet_wrap(~drv, ncol=3)


# Exercise: Draw a scatterplot of displ (x) against hwy (y) using ggplot 
# using geom_point(). Add in a title, labels for the axes and also add 
# in a third category for the class of vehicle

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  xlab("Displacement (in litres)") +
  ylab("Highway efficiency (in miles per gallon)") +
  ggtitle("Highway efficiency vs displacement")


# Exercise: Perform a correlation test to check the relationship 
# between displ and hwy and check for statistical significance.

cor(mpg$displ, mpg$hwy)
cor.test(mpg$displ, mpg$hwy, method="kendall")


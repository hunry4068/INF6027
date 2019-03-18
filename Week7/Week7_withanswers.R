# **************************************************************#
# R/Rstudio Practical Week 7 
# Oct 2018
# Instructor: Paul Clough
# **************************************************************#

# **************************************************************#
# Simple linear regression - initial example
# **************************************************************#

library(tidyverse)
library(MASS)
data("women")
str(women)
summary(women)

ggplot(data = women, aes(x = weight, y = height)) + geom_point()

cor.test(women$weight, women$height)
shapiro.test(women$weight)

qqnorm(log(women$weight))
qqline(log(women$weight))

womenModel<-lm(formula=height~weight, data=women)

summary(womenModel)

ggplot(data = women, aes(x = weight, y = height)) + 
  geom_point() +
  geom_abline(mapping=aes(slope=womenModel$coefficients[2], intercept=womenModel$coefficients[1]), color='red')

plot(womenModel, which=1)

layout(matrix(1:6, ncol=2, byrow=TRUE))
plot(womenModel, 1:6)
par(mfrow=c(1,1))

newWomen<-data.frame(weight=c(130, 170))
predict(womenModel, newdata=newWomen)
predict(womenModel, newdata=newWomen, interval="confidence")
predict(womenModel, newdata=newWomen, interval="prediction")

shapiro.test(women$weight)
shapiro.test(women$height)

# Exercise - prediction with the faithful dataset - how is dataset represented?
# Create plot of attributes of the data to identify possible relationships between 
# variables. Try to predict number of eruptions. How accurate is the model?
# http://www.r-tutor.com/elementary-statistics/simple-linear-regression/prediction-interval-linear-regression

# data("faithful")
# str(faithful)
# summary(faithful)
# faithfulModel<-lm(formula=eruptions~waiting, data=faithful)
# predict(faithfulModel, newdata=data.frame(waiting=c(80)), interval='confidence')


# **************************************************************#
# Simple linear regression - another example
# **************************************************************#

?mpg
View(mpg)

ggplot(data = mpg) +
  geom_histogram(mapping=aes(x=displ), fill='red') +
  geom_histogram(mapping=aes(x=hwy), fill='green') 


install.packages("cowplot")
library(cowplot)
plot1<-ggplot(data = mpg) + geom_histogram(mapping=aes(x=displ), fill='red')
plot2<-ggplot(data = mpg) + geom_histogram(mapping=aes(x=hwy), fill='green') 
cowplot::plot_grid(plot1, plot2)

par(mfrow=c(1,2)) # set the Output window to be 1 row and 2 columns
hist(x=mpg$displ, breaks=8, main="Displacement", xlab="displ")
hist(x=mpg$hwy, breaks=8, main="Highway efficiency", xlab="hwy")
par(mfrow=c(1,1)) # reset the Output window

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(mapping=aes(color=class))

cor.test(mpg$displ, mpg$hwy)

hwyDisplModel<-lm(formula=hwy~displ, data=mpg)
summary(hwyDisplModel)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(mapping=aes(color=class)) +
  geom_abline(mapping=aes(slope=hwyDisplModel$coefficients[2], intercept=hwyDisplModel$coefficients[1]), color='red')

summary(mpg$hwy) # use this to find the mean etc. for hwy

newCarData<-data.frame(displ=c(2.2,4,6.3,12))
predict(hwyDisplModel, newdata=newCarData, interval='confidence')

# Explore the residual and actual predictions
plot(hwyDisplModel, pch=16, which=1)

# Create data frame where we line up predicted vs actual values
hwyPred<-hwyDisplModel$fitted.values
mpgSubset<-data.frame(displ=mpg$displ, hwy=mpg$hwy, pred=hwyPred)
View(mpgSubset)


# **************************************************************#
# Multiple linear regression
# **************************************************************#

data("mtcars")
?mtcars
View(mtcars)


mpgModel<-lm(formula=mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb, data=mtcars)
summary(mpgModel)
plot(mpgModel, which=1)

mpgPredictions<-data.frame(mpg=mtcars$mpg, pred=mpgModel$fitted.values)
mpgPredictions

ggplot(data = mpgPredictions, aes(x = mpgPredictions$mpg, y = mpgPredictions$pred)) +
  geom_point() +
  geom_abline(mapping=aes(slope=1,intercept=0), color='red')

reducedModel<-step(mpgModel, direction="backward")
summary(reducedModel)
# anova(reducedModel, mpgModel)

# Exercise: try building a simple linear regression with just the wt variable – how does the 
# quality and fit of the model compare with using all variables and the selected subset using step()?

# wtModel<-lm(formula=mpg~wt, data=mtcars)
# summary(wtModel)


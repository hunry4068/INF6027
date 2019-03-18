# 6th of Nov. Data Prediction with R

library(tidyverse)
library(MASS)
data("women")
str(women)
summary(women)

womenGGPlot = ggplot(data = women, aes(x = weight, y = height))
womenGGPlot + geom_point()

cor.test(women$weight, women$height)
womenModel = lm(data = women, formula = height~weight)

summary(womenModel)
lm(formula = height ~ weight, data = women)

ggplot(data = women, aes(x = weight, y = height)) +
  geom_point() + 
  geom_abline(mapping = aes(slope = womenModel$coefficients[2], intercept = womenModel$coefficients[1]), color = 'red')

plot(womenModel, which = 1)

layout(matrix(1:6, ncol = 2, byrow = TRUE))
plot(womenModel, 1:6)

newWomen = data.frame(weight = c(130, 170))
predict(womenModel, newdata = newWomen)

predict(womenModel, newdata = newWomen, interval = "confidence")
predict(womenModel, newdata = newWomen, interval = "prediction")

shapiro.test(women$weight)
shapiro.test(women$height)

?mpg
View(mpg)
ggplot(data = mpg) + 
  geom_histogram(mapping = aes(x = displ), fill = 'red') +
  geom_histogram(mapping = aes(x = hwy), fill = 'green')

# similar to apply ggplot
install.packages('cowplot')
library(cowplot)
plot1 = ggplot(data = mpg) + geom_histogram(mapping = aes(x = displ), fill = "red")
plot2 = ggplot(data = mpg) + geom_histogram(mapping = aes(x = hwy), fill = "green")
cowplot::plot_grid(plot1, plot2)

par(mfrow = c(1,2)) # set the output window to be 1 row and 2 columns
hist(x = mpg$displ, breaks = 8, main = 'Displacement', xlab = 'displ')
hist(x = mpg$hwy, breaks = 8, main = 'Highway efficiency', xlab = 'hwy')
par(mfrow = c(1,1)) # reset the output window

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class))

cor.test(mpg$hwy, mpg$displ)

hwyDisplModel = lm(data = mpg, formula = hwy~displ)
summary(hwyDisplModel)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_abline(mapping = aes(slope = hwyDisplModel$coefficients[2], intercept = hwyDisplModel$coefficients[1]), color = 'red')
newCarData = data.frame(displ = c(2.2,4,6.3,12))
predict(hwyDisplModel, newdata = newCarData, interval = 'confidence')

hwyPred = hwyDisplModel$fitted.values
mpgSubset = data.frame(displ = mpg$displ, hwy = mpg$hwy, pred = hwyPred)
View(mpgSubset)

ggplot(data = mpgSubset, aes(x = hwy, y = pred)) +
  geom_point(mapping = aes())

data('mtcars')
?mtcars
View(mtcars)
mtModel = lm(data = mtcars, formula = mpg~cyl+disp+hp+drat+wt+qsec+vs+am+gear+carb)
summary(mtModel)             
plot(mtModel, which = 1)

mgpPredictions = data.frame(mpg = mtcars$mpg, pred = mtModel$fitted.values)
plot(mtModel)

ggplot(data = mgpPredictions, aes(x = mpg, y = pred)) +
  geom_point() +
  geom_abline(mapping = aes(slope = 1, intercept = 0), color = 'red')

# apply dimensionality reduction by step

mpgBackward = step(mtModel, direction = 'backward')
summary(mpgBackward)

mpgForward = step(mtModel, direction = 'forward')
summary(mpgForward)
?step

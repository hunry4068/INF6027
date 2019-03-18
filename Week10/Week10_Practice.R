# 27th of Nov. 2018

#install.packages("mlbench")
library(mlbench)
data("PimaIndiansDiabetes2", package = "mlbench")
summary(PimaIndiansDiabetes2)

# apply the ggpairs to show the distribution of data and correlationship
#install.packages("GGally")
library(GGally)
ggpairs(PimaIndiansDiabetes2)

#install.packages("Amelia")
library(Amelia)
missmap(PimaIndiansDiabetes2)

#install.packages("skimr")
library(skimr)
skimmed = skim_to_wide(PimaIndiansDiabetes2)
View(skimmed)

anyNA(PimaIndiansDiabetes2)
is.na(PimaIndiansDiabetes2)

pima.filtered.data = na.omit(PimaIndiansDiabetes2)
anyNA(pima.filtered.data)
print(table(PimaIndiansDiabetes2$diabetes))
print(table(pima.filtered.data$diabetes)) # half data lose, it may be problematic

# one way to replace na by mean
x = PimaIndiansDiabetes2$insulin
x[is.na(x)] = mean(x, na.rm = TRUE)
head(x)

# another way to avoid bias
y = PimaIndiansDiabetes2$insulin
y[is.na(y)] = sample(y[!is.na(y)], sum(is.na(y)), TRUE)
head(y)

#install.packages("missForest")
library(missForest)

filtered.data = missForest(PimaIndiansDiabetes2)
str(filtered.data)
pima.filtered.data =filtered.data$ximp
head(pima.filtered.data)
anyNA(pima.filtered.data)

head(PimaIndiansDiabetes2, 3)
head(filtered.data$ximp, 3)
test = missForest(PimaIndiansDiabetes2$insulin)

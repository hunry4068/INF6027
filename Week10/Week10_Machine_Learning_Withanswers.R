# **************************************************************#
# R/Rstudio Practical Week 10 (Machine Learning)
# Nov 2018
# Instructor: Paul Clough
# **************************************************************#

# Basic introduction to classification and clustering

# **************************************************************#
# Classification
# **************************************************************#

# https://rpubs.com/ezgi/classification
# https://www.r-bloggers.com/random-forest-classification-of-mushrooms/

# http://www.sthda.com/english/articles/36-classification-methods-essentials/
# https://www.machinelearningplus.com/machine-learning/caret-package/


# **************************************************************#
# Start with initial analysis / exploration of the datasets to
# look at how many variables, whether there are missing values etc.
# **************************************************************#

# Explain the dataset
# https://www.rdocumentation.org/packages/mlbench/versions/2.1-1/topics/PimaIndiansDiabetes

data(PimaIndiansDiabetes2, package = "mlbench")
summary(PimaIndiansDiabetes2)

# Scale the data in vars
# RUFCdata_clean.scaled<-scale(RUFCdata_clean[,-c(1,2,3,4)]) # apply scaling to numeric values

# Probably all we need - great overview (check for categorical data)
install.packages("GGally")
library(GGally)
ggpairs(PimaIndiansDiabetes2)

# Scatterplot Matrices from the lattice Package 
# pairs(formula=~., data=PimaIndiansDiabetes2, main="Diabetes")

# Use Amelia package to show missing values and NAs
# https://www.r-bloggers.com/ggplot-your-missing-data-2/
  
install.packages("Amelia")
library(Amelia)
missmap(PimaIndiansDiabetes2)

# We see some problems with the insulin and triceps variables
# These are NAs
head(PimaIndiansDiabetes2$insulin)

# Can also explore the data values using the skimr package
install.packages("skimr")
library(skimr)
skimmed <- skim_to_wide(PimaIndiansDiabetes2)
View(skimmed)


# **************************************************************#
# Deal with missing values
# **************************************************************#

anyNA(PimaIndiansDiabetes2)

is.na(PimaIndiansDiabetes2)

pima.filtered.data <- na.omit(PimaIndiansDiabetes2)
anyNA(pima.filtered.data)
head(pima.filtered.data)

print(table(PimaIndiansDiabetes2$diabetes))
print(table(pima.filtered.data$diabetes))

# imputation using mean value
x<-PimaIndiansDiabetes2$insulin
x[is.na(x)]<-mean(x, na.rm=TRUE)
head(x)

# imputation using randomly selected value
y<-PimaIndiansDiabetes2$insulin
y[is.na(y)]<-sample(y[!is.na(y)], sum(is.na(y)), TRUE)
head(y)

install.packages("missForest")
library(missForest)

filtered.data <- missForest(PimaIndiansDiabetes2)
str(filtered.data)
pima.filtered.data <- filtered.data$ximp
head(pima.filtered.data)

anyNA(pima.filtered.data)

print(table(PimaIndiansDiabetes2$diabetes))
print(table(pima.filtered.data$diabetes))

# use amelia() to impute missing values
#  data.filtered <- amelia(PimaIndiansDiabetes2, noms="diabetes", m=3)
#  head(data.filtered$imputations$imp3)

# **************************************************************#
# Transform/scale the values
# **************************************************************#

install.packages("tidyverse")
library(tidyverse)

x <- pima.filtered.data %>% select(diabetes)

pima.scaled.data <- scale(pima.filtered.data[,-9]) # apply scaling to numeric values only
head(pima.scaled.data)

pima.scaled.data <- cbind(pima.scaled.data, x)
View(pima.scaled.data)

# **************************************************************#
# Set up the data - training and test sets
# **************************************************************#

install.packages("caret")
library(caret)

set.seed(123)

data.split <- pima.scaled.data$diabetes %>%
  createDataPartition(p=0.8, list=FALSE)

train.data <- pima.scaled.data[data.split, ]
test.data <- pima.scaled.data[-data.split, ]

summary(train.data)
summary(test.data)
print(table(train.data$diabetes))
print(table(test.data$diabetes))


# **************************************************************#
# Using caret to perform classification 
# **************************************************************#

# define training control
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

# Run all classifiers on the training data
nb.model <- train(diabetes~., data=train.data, method="nb", metric=metric, trControl=control)
lda.model <- train(diabetes~., data=train.data, method="lda", metric=metric, trControl=control)
cart.model <- train(diabetes~., data=train.data, method="rpart", metric=metric, trControl=control)
knn.model <- train(diabetes~., data=train.data, method="knn", metric=metric, trControl=control)
svm.model <- train(diabetes~., data=train.data, method="svmRadial", metric=metric, trControl=control)
rf.model <- train(diabetes~., data=train.data, method="rf", metric=metric, trControl=control)

results <- resamples(list(nb=nb.model, 
                          lda=lda.model, 
                          cart=cart.model, 
                          knn=knn.model, 
                          svm=svm.model, 
                          rf=rf.model))
summary(results)

# estimate performance on new unseen data
knn.predictions <- predict(knn.model, test.data)

confusionMatrix(knn.predictions, test.data$diabetes, positive = "pos")


# **************************************************************#
# Classification using decision trees
# **************************************************************#

install.packages("rpart")
library(rpart)

# Do this to allow for reproducibility
set.seed(123)

# Build the decision tree
rpart.model<-rpart(diabetes~., data=train.data, method="class")

# Plot the decision tree
par(xpd=NA)
plot(rpart.model, main="Classification Tree for diabetes (training data)")
text(rpart.model, digits=2, cex=0.6)

# Another way of plotting the model
print(rpart.model, digits=2)

# Make predictions
rpart.predictions<-rpart.model %>% predict(test.data, type="class")
mean(rpart.predictions == test.data$diabetes)

# Could do this instead
# print(caret::confusionMatrix(data = rpart.predictions,  
#                             reference = test.data$diabetes,
#                             positive = 'pos'))


# **************************************************************#
# Random Forest example
# **************************************************************#

install.packages("randomForest")
library(randomForest)  

#  Build the model
rf.model = randomForest(diabetes ~ ., ntree = 100, data = train.data)

print(rf.model)

# Look at the importance of variables
varImpPlot(rf.model,  
           sort = T,
           n.var=10,
           main="Top 10 - Variable Importance")

rf.predictions = predict(rf.model, train.data)

# Create Confusion Matrix
print(caret::confusionMatrix(data = rf.predictions,  
                             reference = train.data$diabetes,
                             positive = 'pos'))

rf.predictions = predict(rf.model, test.data)

# Create Confusion Matrix
print(caret::confusionMatrix(data = rf.predictions,  
                             reference = test.data$diabetes,
                             positive = 'pos'))

rf.model2 = randomForest(diabetes ~ glucose+insulin, ntree = 100, data = train.data)
rf.predictions2 = predict(rf.model2, test.data)
print(caret::confusionMatrix(data = rf.predictions2,  
                             reference = test.data$diabetes,
                             positive = 'pos'))


# **************************************************************#
# Example - classifying edible mushrooms
# **************************************************************#
# https://archive.ics.uci.edu/ml/datasets/Mushroom
# https://www.kaggle.com/uciml/mushroom-classification
# https://www.r-bloggers.com/random-forest-classification-of-mushrooms/
# https://rpubs.com/arun_infy13/93236

mushroom.data <- read.csv("mushrooms.csv", head=TRUE)
mushroom.data<-mushroom.data[,-1]
head(mushroom.data)

anyNA(mushroom.data)

# Could also run the missmap function to check
missmap(mushroom.data)

summary(mushroom.data)

set.seed(123)

library(caret)

mushroom.data.split <- mushroom.data$class %>%
  createDataPartition(p=0.8, list=FALSE)

mushroom.train.data <- mushroom.data[mushroom.data.split, ]
mushroom.test.data <- mushroom.data[-mushroom.data.split, ]

print(table(mushroom.train.data$class))
print(table(mushroom.test.data$class))

# library(randomForest)  
mushroom.rf.model = randomForest(class~., ntree = 100, data = mushroom.train.data)

# Variable Importance
varImpPlot(mushroom.rf.model,  
           sort = T,
           n.var=10,
           main="Top 10 - Variable Importance")

# Build model
mushroom.rf.predictions = predict(mushroom.rf.model, mushroom.test.data)

# Create Confusion Matrix
print(caret::confusionMatrix(data = mushroom.rf.predictions,  
                             reference = mushroom.test.data$class))


# **************************************************************#
# Clustering - we don't cover this but included in case you're
# interested
# **************************************************************#

# https://www.datanovia.com/en/blog/cluster-analysis-in-r-practical-guide/
  
# Classification example - use diabetes dataset
install.packages("FactoMineR")
library("FactoMineR")

install.packages("factoextra")
library("factoextra")

# Copy the data without the target variable
x <- pima.scaled.data[,-9]

# Perform Principal Component Analysis (PCA)
fviz_pca_ind(prcomp(x), title = "Diabetes data", palette = "jco",
             habillage = pima.scaled.data$diabetes,
             addEllipses = TRUE,
             geom = "point", ggtheme = theme_classic(),
             legend = "bottom")

# identify the variables which are loading the dimensions
fviz_contrib(prcomp(x), choice="var", axes=2, top=20, 
             fill = "lightgray", color = "black") + 
  theme_minimal() +
  theme(axis.text.x = element_text(angle=90))


# Perform multiople correspondance analysis (MCA) - a form of PCA
# that can be used on categorical data
library(FactoMineR)
library(factoextra)

res.mca <- MCA(mushroom.data, graph=FALSE)

# This shows that edible mushrooms tend to group with no odour and adundant
# The poisonous ones are pungent and smooth
fviz_mca_var(res.mca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # Avoid text overlapping
             ggtheme = theme_minimal())

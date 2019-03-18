# **************************************************************#
# R/Rstudio Practical Week 1 
# 21 Sept 2017
# Instructor: Paul Clough
# **************************************************************#


# **************************************************************#
# Recap
# **************************************************************#

x<-c(0.5, 0.7) # numeric vector (decimal)
x<-c(TRUE, FALSE) # logical vector
x<-c("a", "b", "c", "d", "e") # character vector
x<-c(1 + (0+0i), 2 + (0+4i)) # complex number vector

# Exercise: What happens with a vector or matrix if you try and combine data of different types? 
# Try the following R command a<-c("a", 1). What class is a? Why is this?

x<-c(3,4,6,7,-2,-1)

# Exercise: Try and do the following tasks: (i) select the first element; 
# (ii) select the last element; (iii) select the second and third element; 
# (iv) select all elements whose value is < 1.


# **************************************************************#
# Logical operations
# **************************************************************#

2==3 # is two equal to three? (FALSE)
2==2 # is two equal to two? (TRUE)
"Sam"=="Hilary" # the above also work for strings
"Sam"!="Hilary" # use of the not (!) operator (this returns TRUE)
c(3,4,6,7,-2,-1) > 1 # logical operators are vectorised - they get applied to all vector elements
x>1 & x<=4 # we can combine logical operators (in this case with AND or &)
x>1 | x<=4 # we can combine logical operators (in this case with OR or |)


# **************************************************************#
# Lists
# **************************************************************#

a<-list("a", 1, c(4,5,6)) # this creates a new list
a[[1]] # access the first element of the list (by index position)
a[[3]] # access the third element of the list (by index position)
a[c(1,3)] # access the first and third elements of the list (by index position)
names(a)=c("One", "Two", "Three") # give names to the index positions 

a[["One"]] # access the first element by its name
a$One # this does the same as the previous command

# Exercise: Can you select the first and third elements using their name?

a<-list(One="a", Two=1, Three=c(4,5,6)) # a new list example
b<-list(text="Data Science is cool", sequence=1:10, data=iris) # another list example


# **************************************************************#
# Data frames
# **************************************************************#

medals<-data.frame(Country=c("USA", "GBR", "CHN"), 
                      Gold=c(46,27,26), 
                      Silver=c(37,23,18), 
                      Bronze=c(38,17,26))

medals # display the contents of the data frame
medals$Gold # select the elements of the column called Gold - returns vector
medals[[2]] # select the second column (called Gold) - returns vector

medals["Gold"] # the single [] returns a data frame - test below
class(medals["Gold"]) 

medals[c("Country", "Gold")] # select the columns called Country and Gold - returns data frams
medals[c(1,2)] # same as above buting using index positions

medals[1,]  # select the first row - returns data frame

# Exercise: Can you select the first and third rows (and return as data frame)? 


# Exercise: Can you select the first and third rows and the first and third columns (and return as data frame)?


medals$Country # select the column called Country - returns vector
class(medals$Country)

# Selecting data that matches conditions
medals[medals$Country=="GBR",] # return the rows where Country is Japan (as data frame)
medals[medals$Country=="CHN" | medals$Country=="GBR",] # return the rows where Country is Japan OR Great Britian (as data frame)
medals[medals$Gold>=27,] # return the rows where Gold medals won were >= 20 (as data frame)


# Use of subset to select rows and columns - first select columns
subset(medals, select=Gold) # return a subset of the data frame - just the Gold column
subset(medals, select=c(Country, Gold)) # the same as this command: medals[c("Country", "Gold")]

# Use of subset - select rows matching expression
subset(medals, subset=(Country=="USA"))

# Use of subset and select together - return specific rows and columns
subset(medals, select=c(Country, Gold), subset=(Country=="USA"))

# Exercise: Select countries who won 27 or more gold medals and return the Country 
# and Gold columns using the subset() command

# adding single row
newCountry<-data.frame(Country="RUS", Gold=19, Silver=18, Bronze=19)
medals<-rbind(medals, newCountry)

View(medals)


# Computing totals across rows and columns

# Add new column for totals of the Gold, Silver and Bronze medals
medals$Total<-medals$Gold + medals$Silver + medals$Bronze

# If you want to remove the Total column you could do this
medals<-subset(medals, select=c(Country, Gold, Silver, Bronze))

# There's other ways to compute totals etc. over data frames, for example:
# https://www.computerworld.com/article/2486425/business-intelligence/business-intelligence-4-data-wrangling-tasks-in-r-for-advanced-beginners.html?page=2
medals<-transform(medals, Total=Gold+Silver+Bronze)

medals$Total<-mapply(sum, medals$Gold, medals$Silver, medals$Bronze)

medals$Total<-rowSums(medals[c(2,3,4)]) # or using Column names
medals$Total<-rowSums(medals[c("Gold","Silver","Bronze")])

medals[order(medals$Bronze),] # Sort the medals by Bronze (ascending)
medals[order(-medals$Bronze),] # Sort the medals by Bronze (descending)

# Compute the totals of all medals for Gold, Silver and Bronze and Total columns
colSums(medals[c("Gold","Silver","Bronze","Total")])


# **************************************************************#
# Loading in data from CSV files
# **************************************************************#

# load in complete medal table from file (csv file)
rio2016Medals<-read.csv("Rio2016.csv", header=TRUE)
View(rio2016Medals)

head(rio2016Medals)

# Exercise: Similar to what we did before try and compute the total number of 
# medals won for each country and add this as a fifth column to rio2016Medals.

# Exercise: Now try ordering the rows by the total number of medals won.

# Exercise: Try using order() to sort the data first by the number of total medals won 
# (in descending order) and then by the number of gold medals won (also in descending order).

# Exercise: Calculate the total number of gold, silver and bronze medals won at Rio 2016.
# Also, can you work out the overall number of medals won by all countries in the Olympic 
# Games in 2016?

# Exercise: Now have a go at these tutorials: 
# http://www.r-tutor.com/r-introduction/data-frame
# https://www.analyticsvidhya.com/blog/2016/02/complete-tutorial-learn-data-science-scratch/


# **************************************************************#
# Optional
# **************************************************************#

library(MASS)
data("women")


# That's all folks!

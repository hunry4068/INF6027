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

a<-c("a", 1) # vector but with different element data types
class(a) # This shows the vector is class character
str(a) #  This produces the following: chr [1:2] "a" "1"

m<-matrix(c("a", 1), nrow=1) # matrix but with different element data types
class(matrix(c("a", 1), nrow=1)) # This shows the class of the matrix
str(m) # This produces the following: chr [1, 1:2] "a" "1"

# Exercise: Try and do the following tasks: (i) select the first element; 
# (ii) select the last element; (iii) select the second and third element; 
# (iv) select all elements whose value is < 1.

x<-c(3,4,6,7,-2,-1) # create a vector
x[1] # access first element
x[6] # access the last (6th) element
x[c(2,3)] # access the second and third elements
x[x<1] # return elements where the value is < 1
x[where=x<1] # same as above but we can specify 'where=' to make it more readable


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

# we could have also done this when we created the list using the following:
# a<-list(One="a", Two=1, Three=c(4,5,6))

a[["One"]] # access the first element by its name
a$One # this does the same as the previous command

# Exercise: Can you select the first and third elements using their name?

a[c("One", "Three")] # performs the above exercise question

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

medals[c(1,3),] #  performs the previous exercise question

# Exercise: Can you select the first and third rows and the first and third columns (and return as data frame)?

medals[c(1,3),c(1,3)] # performs the previous exercise question

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
subset(medals, subset=(Country=="USA" | Country=="GBR"))

# Use of subset and select together - return specific rows and columns
subset(medals, select=c(Country, Gold), subset=(Country=="USA"))

# Select just the countries who won 27 or more gold medals using the subset command and return Country and Gold columns
subset(medals, select=c(Country, Gold), subset=(Gold >= 27))

# adding single row
newCountry<-data.frame(Country="RUS", Gold=19, Silver=18, Bronze=19)
medals<-rbind(medals, newCountry)

# Exercise: Add rows to medals for Germany and Japan (you can overwrite the newcountry.df data with the new values)
newCountry<-data.frame(Country=c("GER", "JPN"), 
                          Gold=c(17,12), 
                          Silver=c(10,8), 
                          Bronze=c(15,21))
medals<-rbind(medals, newCountry)

View(medals)

# Adding column totals
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
# Loading in data from CSV file
# **************************************************************#

# load in complete medal table from file (csv file)
rio2016Medals<-read.csv("Rio2016.csv", header=TRUE)
head(rio2016Medals)

# Exercise: compute total number of gold, silver and bronze medals scored
rio2016Medals$Total<-rowSums(rio2016Medals[c("Gold","Silver","Bronze")])

# Exercise: order the rows by the total of medals won
rio2016Medals[order(-rio2016Medals$Total, -rio2016Medals$Gold),]

# Exercise: compute total number of gold, silver and bronze medals scored

colSums(rio2016Medals[c("Gold","Silver","Bronze","Total")])

# Now have a go at this tutorial: 
# http://www.r-tutor.com/r-introduction/data-frame


# **************************************************************#
# Optional
# **************************************************************#

library(MASS)


# That's all folks!

# **************************************************************#
# R/Rstudio Practical Week 1 
# 21 Sept 2017
# Instructor: Paul Clough
# **************************************************************#


# **************************************************************#
# First examples in R
# **************************************************************#


2+3 # simple addition

1:5 # create a sequence of numbers from 1 to 5 in increments of 1
seq(1,5) # produces the same as above
seq(from=1, to=5) # the same as above but specifying the names of arguments
seq(from=1, to=5, by=2) # the same but this time we can specify how many to increment by

x<-2+3 # assign addition to variable x
x<-(3+4) # another additio bu including parentheses
y<-(2*3)+4 # assign calculation to y
z<-x+y # we can now do things with the variables, such as add their values

# Exercise: see what other basic operators are available: 
# http://www.dummies.com/programming/r/how-to-do-basic-arithmetic-in-r/


# **************************************************************#
# Functions
# **************************************************************#

# R comes with many in-built functions (and we can load more via packages).
# We've already used seq() before

myseq<-seq(1,10) # create sequence of numbers from 1 to 10 (increment of 1)
sum(myseq) # now add together the numbers of the vector myseq
?sum # look at the help for the sum() function
sum(1:10) # add the sequence of numbers 1 to 10
sum(seq(1,10)) # the same as above

# Exercise: Try calculating the mean value of myseq manually and using the mean() function
mean(myseq) # 5.5

# Exercise: Find out what other basic built-in maths functions are available:
# http://www.statmethods.net/management/functions.html

t<-seq(from=0, to=10, by=0.1) # produce a sequence of numbers (x values)
y<-sin(t) # compute sin() of each value (y values)
plot(y) # plot x and y values (in this case x is just a numeric value)

plot(x=t, y=y, type="l") # make the graph prettier and use argument names


# You can also create your own functions
f<-function(x) x/(1-x) # this is our own function
f(2)
f(4)


# **************************************************************#
# Classes/modes of variables and objects
# **************************************************************#

class(3.14) # can also use the mode() function
class("hello")
class(f)


# **************************************************************#
# Vectors
# **************************************************************#

x<-c(1.2, 2.3, 0.2, 1.1) # this creates a vector of 4 elements and assigns to variable x

class(x)
length(x)
str(x) # type of vector then dimensions (and indices) then the values

x[1]
x[4]

# Exercise: What happens if you try and access an element outside of the length of the 
# vector (e.g. index position 10)? Note: NA means Not Available
x[10] # returns NA

x[1:2]
x[c(1,2)]

x[-1] # everything except the first value
x[-2] # everything except the second value

x[1]<-1.0 # assign new value to first element in vector

x[x>2] # return subset of x where all values > 2

# Operators are vectorised - this means the operator is applied to each element
x.doubled <-x*2 # this multiplies every element in x by 2 (called vectorisation)

# Exercise: can you square each value in x and assign it to x.squared?
x.squared <-x*x

mean(x)
summary(x)

sort(x)
sort(x, decreasing=TRUE)
append(x, 5.2)
append(x, c(5.2, 7.3))
x<-append(x, c(5.2, 7.3))

# Exercise: Compute the mean value of the updated vector x and check its length.
mean(x) # 3.6875
length(x) # 8

name<-c("Tom", "Dick", "Harry")
str(name) # type of vector then dimensions (and indices) then the values

names(name)=c("One", "Two", "Three")
name[1]
name["One"]


typeof(name)
class(name)
str(name) 

# Exercise: Can you select the first and third elements from the names vector?
name[c(1,3)]
name[c("One", "Three")]

# Exercise: create a named vector with the number of days in each month.
# How many days are there in a year? Which month has the least number of days?

days<-c(31,28,31,30,31,30,31,31,30,31,30,31) # this is for a non-leap year
names(days)=c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
sum(days) # 365
min(days)
days[days==min(days)]

# Now have a go at this tutorial: 
# http://www.r-tutor.com/r-introduction/vector



# **************************************************************#
# Matrices
# **************************************************************#

A = matrix(
c(2, 4, 3, 1, 5, 7), # the data elements 
nrow=2,              # number of rows 
ncol=3,              # number of columns 
byrow = TRUE)        # fill matrix by rows 

p<- matrix(c(1,2,3,4,5,6), nrow=2)
r<-matrix(c(1,3,2,4,5,6), ncol=2) 

p[1,2] # entry in row 1 and column 2
p[1,] # return row 1 and all columns
p[,1] # return all rows for column 1
p*2
sum(p[1,]) # sum values in the first row
sum(p[,1]) # sum values in the first column

sum(p[,1]) + sum(p[1,]) # add totals of first row and first column
sum(c(p[,1], p[1,])) # same as the previous line

rownames(p)<-c("Row1","Row2") # set the row names
colnames(p)<-c("Col1", "Col2", "Col3") # set the column names

# Exercise: Select the second row in the matrix p using its name ("Row2").
p["Row2",]

colnames(p)<-NULL # reset or remove the column names 
p<-p[,-3]
p<-cbind(p, c(5,6))
p<-rbind(p, c(7,9,11))

# Exercise: Can you add a name for the new row (Row3)?
rownames(p)<-c("Row1","Row2","Row3")

# Exercise: create medal table for Olympics or football stats
# https://www.cbssports.com/olympics/news/2016-rio-olympics-medal-tracker/

medals<- matrix(c(46,37,38,27,23,17,26,18,26), nrow=3, byrow=TRUE)
rownames(medals)<-c("USA", "GBR", "CHN")
colnames(medals)<-c("Gold", "Silver", "Bronze")
sort(medals[,"Bronze"])

# If we had added an additional row/column we could do this
#medals<-medals[,-4] # remove the forth column
#medals<-medals[-4,] # remove the forth row

# Now have a go at this tutorial: 
# http://www.r-tutor.com/r-introduction/matrix


# That's all folks!

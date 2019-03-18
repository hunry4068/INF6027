#create a 2level list
studentInfo = list(
  Name="Eric", 
  Age="30", 
  Modules=list(
    INF6027="Introduction to Data Science", 
    INF6029="Data Analysis", 
    INF6033="Data and Society"))

anotherModules = list(
  INF6060="Information Retrieval",
  INF6901="Digital Literacy Skills",
  INF6903="Academic Writing")

studentInfo$Modules = append(studentInfo$Modules, anotherModules)

studentInfo[["Age"]]
studentInfo$Modules$INF6060

name = studentInfo$Name
age = studentInfo$Age

#print the modules by for loop
for (index in 1:length(studentInfo$Modules)){
  if(index == 1){
    print(paste("Name:", name, ", Age:", age))
  }
    print(paste0("Module", index, ": ", studentInfo$Modules[index]))
}

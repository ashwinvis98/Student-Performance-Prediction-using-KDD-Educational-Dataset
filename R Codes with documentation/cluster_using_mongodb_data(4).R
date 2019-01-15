#R Code to read the dataset from MongoDB and building a clustering algorithm to predict the difficulty of a problem

#loading all the necessary packages required
library("rpart")
library("readr")
library("jsonlite")
library("mongolite")
library("tidyr")
library("plyr")

#setting up mongodb connection with the desired credentials
mongo <- mongo(collection = "test", db = "ashwin_db", url = "mongodb://admin:bitwise2017@13.78.179.80:27017/admin",verbose = TRUE)

#giving an empty query to read all the data in the mongodb database 
df = mongo$find('{}')

#reading the lengths of list of induvidual students 
l1 <- sapply(df$Hints, length)

#replicating the induvidual student id based on the length of the induvidual student records
xx<- unlist(rep(df$Anon_Student_Id, l1))

sample <- df[,-1] 

#saving a new datafram 'df.new' with only the student id
df.new <- data.frame(Anon_Student_Id = xx)

#Entering the data of all students rowwise using 'rbind' function
for(j in 1:ncol(sample)){
  x <- data.frame(unlist(sample[,j]))
  df.new <- cbind(df.new,x)
}
#saving the column names of the new dataset as the previous one 
colnames(df.new) <- names(df)
df.new <- na.omit(df.new)

#giving an input whose difficulty is predicted
input <- data.frame(No_Step = 5, Problem_View = 60, Step_Duration__sec_ = 60, Hints = 0, Incorrects = 2, count_subskills = 67, count_ktracedskills=45 )

#add the input to the existing dataset
df.new <- rbind.fill(df.new,input)

#create a clustering algorithm with the predictor variables as total duration, hints, number of attempts, skills required to solve
#using kmeans clustering algorithm, generate 3 clusters using the above variables 
fit <- kmeans(df.new[,c(4,6,8,11,12)], 3) 
#save the cluster data as a dataframe with the column name as category and add it to the working dataset  
Fit <-data.frame(unlist(fit$cluster))
colnames(Fit) <- c("category")
course <- cbind(df.new,Fit)
#giving names to the cluster based on the number of points in the cluster as the difficulty  
course$Diff_level[course$category==1]="Easy"
course$Diff_level[course$category==2]="Hard"
course$Diff_level[course$category==3]="Medium"
print("Difficulty of the problem = ")
print(tail(course$Diff_level,1))
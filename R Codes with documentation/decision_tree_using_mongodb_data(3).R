#R Code to read the dataset from MongoDB and building a decision tree algorithm 

#loading all the necessary packages required
library("rpart")
library("readr")
library("jsonlite")
library("mongolite")
library("tidyr")
library("plyr")

#setting up mongodb connection with the desired credentials
mongo <- mongo(collection = "test", db = "ashwin_db", url = "mongodb://admin:bitwise2017@13.78.179.80:27017/admin",verbose = TRUE)

#giving a query to read all the data in the mongodb database 
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

#building the decision tree which predicts percentage of correct first attempts with number of steps,hints and  duration as the preictor variables  
decisiontree <- rpart(Percent_First_Attempts ~ No_Step + Step_Duration__sec_ +Hints, data=df.new, method="anova") 

#saving the model in RDS 
saveRDS(decisiontree,file ="/home/bitwise/ashwin/performance_modelinfo.RData" )

#checking with an iput whether decision tree is working or not
input <- data.frame(No_Step = 5, Problem_View = 60, Step_Duration__sec_ = 60, Hints = 0, Incorrects = 2, count_subskills = 67, count_ktracedskills=45 )
predict(performance,input, method = "anova")

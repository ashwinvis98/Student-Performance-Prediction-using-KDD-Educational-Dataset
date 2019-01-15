#R code to process the original data, feature engineering and create the working dataset 

#setting up the working directory to that of the dataset
setwd("/datadrive/dataset/KDD")    

#installing the necessary packages for preprocessing
library("stringr")
library("dplyr")

#Reading a .csv file which consists of the dataset
train_data <- read.table(file = "bridge_to_algebra_2008_2009_train.txt", header = TRUE, sep="\t")

#Feature Engineering for adding a count of the skills required per step
train_data$Count.KC.SubSkills  <- str_count(train_data$KC.SubSkills., '~~') + 1
train_data$KC.KTracedSkills  <- str_count(train_data$KC.KTracedSkills., '~~') + 1

#Removing unnecessary variables and rows having NA value 
train_data <- train_data[,-c(1,6,7,8,9,10,12,13,18,19,20,21)]
train_data <- na.omit(train_data)

#New variable to calculate the number of steps in a problem
totalproblems <- data.frame(No.Step = rep(1, nrow(train_data)), train_data[,])

totalproblems <- totalproblems %>%
  group_by(Anon.Student.Id, Problem.Name, Problem.Hierarchy ) %>%
  summarise_all(funs(sum))

#Adding a new column to predict the number of complex problems based on aggregate method 

totalproblems$complex1 <- totalproblems$No.Step/mean(totalproblems$No.Step)
totalproblems$complex2 <- totalproblems$Count.KTracedSkills./mean(totalproblems$Count.KTracedSkills.)
totalproblems$complex3 <- totalproblems$Count.SubSkills./mean(totalproblems$Count.SubSkills.)
totalproblems$Complex <- ave(totalproblems$complex1,totalproblems$complex2,totalproblems$complex3)
totalproblems$Complexity <- totalproblems$Complex/3
totalproblems$No.Complex.Step <- totalproblems$Complexity*totalproblems$No.Step

#Removing the unnecessary columns after finding the number of complex steps 
totalproblems$complex1 <- NULL
totalproblems$complex2 <- NULL
totalproblems$complex3 <- NULL
totalproblems$Complex <- NULL

#Creating a new variable which calculates the percentage of correct first attempts which will be used to create a decision tree model
totalproblems$Percent.First.Attempts <- totalproblems$Correct.First.Attempt/totalproblems$No.Step

totalproblems$No.Complex.Step <- round(totalproblems$No.Complex.Step)
totalproblems$Percent.First.Attempts <- round(totalproblems$Percent.First.Attempts, 3)

#Saving the dataset to a .csv file after all the preprocessing
write.csv(totalproblems,file = '/home/bitwise/ashwin/totalproblems.csv')
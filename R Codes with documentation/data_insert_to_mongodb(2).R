#R Code for converting the dataset in table format to a nested JSON format which unique student ids and importing the JSON list to MongoDB 

#importing necessary R packages
library("rjson")
library("readr")
library("jsonlite")
library("mongolite")
library("tidyr")
library("plyr")
library("data.table")

#setting up a connection to MongoDB with the given credentials 
mongo <- mongo(collection = "sample", db = "ashwin_db", url = "mongodb://admin:bitwise2017@13.78.179.80:27017/admin",verbose = TRUE)

#setting the working directory to the file to the location of the preprocessed dataset  
setwd("/home/bitwise/ashwin")

#Function to save the dataset in a list format with the data of all students under their unique student id
convert_groupings <- function(key_df){
  key_df <- as.list(key_df)
  key_df$Anon.Student.Id <- unique(key_df$Anon.Student.Id)
  key_df
}

#Reading the preprocessed dataset from working directory  
sample <- read.csv("totalproblems.csv", header = TRUE)
sample$X <- NULL

#splitting the student id from the dataset so that the 'convert_groupings' function can be applied 
sample_list <- split(sample, sample$Anon.Student.Id)
sample_list <- lapply(sample_list, convert_groupings)

#Converting the list to JSON format and uploading the data to MongoDB studentwise   
for(i in sample_list){
  sample_json <- jsonlite::toJSON(i, auto_unbox = T, pretty = T)
  mongo$insert(fromJSON(sample_json))
}



#Example of a test case
#input = {"No_Step":5, "Problem_View": 60, "Step_Duration__sec_": 60, "Hints":0 , "Incorrects" : 2, "count_subskills": 67, "count_ktracedskills":45 }


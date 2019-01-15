#' @title student_performance
#' @description Package which makes use of the KDD-Cup 2010 Education dataset to predict a student performance with models built based on the dataset.
#' The package has functions like predicting the performance of student during his course session, predicting what is the difficulty level of the problem, etc.
#' @return Percentage of Correct First Attempts, Difficulty level of a problem  
#' @param Percent_First_Attempts  Percentage of correct first attempts
#' @param No_steps Number of steps to a problem
#' @param  Problem_View Number of time a problem is viewed
#' @param Total_Duration__Sec_ Total duration to solve a problem in secs
#' @param Hints Total hints taken to solve a problem
#' @param Incorrects Total incorrect steps while solving a problem
#' @param count_ktracedskills count of knowleddge traced skills
#' @param count_subskills count of subskills already existing in a student
#' @keywords Student_performance kDD MongoDB
#' @examples 
#' predict(performance,input, method = "anova")
#' 

library("roxygen2")
library("rpart")
library("jsonlite")
library("plyr")
library("mongolite")

#setting up mongodb connection with the desired credentials
mongo <- mongo(collection = "test", db = "ashwin_db", url = "mongodb://admin:bitwise2017@13.78.179.80:27017/admin",verbose = TRUE)

#' @export
#' @return connection health
health_check = function() {
  if(mongo$count()>0) {
    print("MongoDB has data")
  } else {
    print("MongoDB has no data")
  }
}

#' @export
#' @description builds the decision tree based on data from mongodb 
build_tree = function(){
  df = mongo$find('{}')
  l1 <- sapply(df$Hints, length)
  xx<- unlist(rep(df$Anon_Student_Id, l1))
  sample <- df[,-1] 
  df.new <- data.frame(Anon_Student_Id = xx)
  for(j in 1:ncol(sample)){
    x <- data.frame(unlist(sample[,j]))
    df.new <- cbind(df.new,x)
  }
  colnames(df.new) <- names(df)
  df.new <- na.omit(df.new)
  
  decisiontree <- rpart(Percent_First_Attempts ~ No_Step + Step_Duration__sec_ +Hints, data=df.new, method="anova") 
  saveRDS(decisiontree,file ="/home/bitwise/ashwin/performance_modelinfo.RData" )
}

#' @export
#' @description gives prediction of performance of student and difficulty level of that problem
predict_performance = function(input){
  df = mongo$find('{}')
  l1 <- sapply(df$Hints, length)
  xx<- unlist(rep(df$Anon_Student_Id, l1))
  sample <- df[,-1] 
  df.new <- data.frame(Anon_Student_Id = xx)
  for(j in 1:ncol(sample)){
    x <- data.frame(unlist(sample[,j]))
    df.new <- cbind(df.new,x)
  }
  colnames(df.new) <- names(df)
  df.new <- na.omit(df.new)
  df.new <- rbind.fill(df.new,input)
  
  fit <- kmeans(df.new[,c(4,6,8,11,12)], 3) 
  Fit <-data.frame(unlist(fit$cluster))
  colnames(Fit) <- c("category")
  course <- cbind(df.new,Fit) 
  course$Diff_level[course$category==1]="Easy"
  course$Diff_level[course$category==2]="Hard"
  course$Diff_level[course$category==3]="Medium"
  print("Difficulty of the problem = ")
  print(tail(course$Diff_level,1))
  
  performance=readRDS("/home/bitwise/ashwin/performance_modelinfo.RData")
  print("Performance = ")
  predict(performance,input, method = "anova")
}

#' @export
#' @return outputs of test cases
check_test = function() {
  #input1 A medium problem with moderate performance
  input <- data.frame(No_Step = 5, Problem_View = 60, Step_Duration__sec_ = 60, Hints = 0, Incorrects = 2, count_subskills = 67, count_ktracedskills=45 )
  predict_performance(input)
}
#input <- data.frame(No_Step = 5, Problem_View = 60, Step_Duration__sec_ = 60, Hints = 0, Incorrects = 2, count_subskills = 67, count_ktracedskills=45 )



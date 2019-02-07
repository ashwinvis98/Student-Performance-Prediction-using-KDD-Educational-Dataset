# Student-Performance-Prediction-using-KDD-Educational-Dataset
Prediction of student performance on mathematical problems from logs of student interaction with Intelligent Tutoring Systems. The goal is to build a model which will predict the performance of a student which relates to the probability of getting the answers to a problem in the first attempt.

The data is stored in a MongoDB repository and is pulled everytime to build the model within R. 

KDD is the name of the package that has two inbuilt functions. One is used build the models which predicts the student performance and problem complexity. A regression tree classifier is built to classify the students performance in a scale of 0-1 as percentage. A KNN classifier model is built to classify the problems as Easy, Medium and Hard. The other function is used to predict the output when a input is given based on above mentioned models.    

After the package is built, it is saved as kdd_0.0.0.9000.tar.gz file. The R package (KDD) and the models built are stored in a docker container built based on openCPU image. HTTP requests can be given to make use of the predict function.      

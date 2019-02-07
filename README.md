# Student-Performance-Prediction-using-KDD-Educational-Dataset
Prediction of student performance on mathematical problems from logs of student interaction with Intelligent Tutoring Systems. The goal is to build a model which will predict the performance of a student which relates to the probability of getting the answers to a problem in the first attempt.

KDD is the name of the package that has inbuilt functions to build the models which predicts the student performance and problem complexity. A regression tree classifier is built to classify the students performance in a scale of 0-1 as percentage. A KNN classifier model is built to classify the problems as Easy, Medium and Hard.

The data is stored in a MongoDB repository and is pulled everytime to build the model within R. 

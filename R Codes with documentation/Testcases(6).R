install.packages("kdd")
library(kdd)

#input1 A medium problem with moderate performance
input <- data.frame(No_Step = 5, Problem_View = 60, Step_Duration__sec_ = 60, Hints = 0, Incorrects = 2, count_subskills = 67, count_ktracedskills=45 )
predict_performance(input)

#input2 An easy problem with average performance
input <- data.frame(No_Step = 10, Problem_View = 82, Step_Duration__sec_ = 106, Hints = 2, Incorrects = 5, count_subskills = 88, count_ktracedskills=65 )
predict_performance(input)

#input3 An easy problem with least performance
input <- data.frame(No_Step = 10, Problem_View = 55, Step_Duration__sec_ = 63, Hints = 2, Incorrects =0, count_subskills = 47, count_ktracedskills=37 )
predict_performance(input)

#input4 A medium problem with least performance
input <- data.frame(No_Step = 2, Problem_View = 102, Step_Duration__sec_ = 165, Hints = 7, Incorrects = 12, count_subskills =98, count_ktracedskills=88 )
predict_performance(input)

#input5 A hard problem
input <- data.frame(No_Step =25,Problem_View = 123, Step_Duration__sec_ = 195, Hints = 7, Incorrects = 12, count_subskills =106, count_ktracedskills=122 )
predict_performance(input)

#input6 No ktraced subskills provided as input
input <- data.frame(No_Step =25,Problem_View = 123, Step_Duration__sec_ = 195,  Incorrects = 12, count_subskills =106, count_ktracedskills=122 )
predict_performance(input)

#input7 No hints provided as input
input <- data.frame(No_Step =25,Problem_View = 123, Step_Duration__sec_ = 195, Hints = 7, Incorrects = 12, count_subskills =106 )
predict_performance(input)

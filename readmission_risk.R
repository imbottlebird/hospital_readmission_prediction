library(caret)
library(rpart)
library(rpart.plot) 
library(caTools)
library(dplyr)

readmission = read.csv("readmission.csv")
readmission$readmission = as.factor(readmission$readmission)
str(readmission)

set.seed(144)
split = createDataPartition(readmission$readmission, p = 0.75, list = FALSE)
readm.train <- readmission[split,]
readm.test <- readmission[-split,]

str(readmission)
str(readm.train)

#cp=0.001 won't prune the tree
readm.mod = rpart(readmission ~ .,
                  data = readm.train, 
                  method = "class", 
                  cp=0.001)
prp(readm.mod)

#predict the readmission
pred <- predict(readm.mod, newdata = readm.test, type = "class")

#confusion matrix. first arg=row, second arg=col - ex. [row,col]
confusion.matrix = table(readm.test$readmission, pred)
confusion.matrix


# Confusion Matrix:
# TN FP 
# FN TP

#- the "loss" of a false positive is 1,200 USD (the cost per intervention)
#- the "loss" of a false negative is 35,000 USD (the cost per 30-day unplanned readmission)
#B) Define the loss matrix for CART Model
LossMatrix = matrix(0,2,2)
inter.cost=800
LossMatrix[1,2] = inter.cost
LossMatrix[2,1] = 7550
#the final table:
LossMatrix

readm.mod.2 = rpart(readmission~.,
                  data = readm.train,
                  parms=list(loss=LossMatrix),
                  cp=0.001)

prp(readm.mod.2, digits=3)

#make predictions.
pred.2 = predict(readm.mod.2, newdata=readm.test, type="class")
#view the confusion matrix.
confusion.matrix.2 = table(readm.test$readmission, pred.2)
confusion.matrix.2
readm.test$readmission

#original confusion matrix
confusion.matrix

#####Cost and benefit
total.cost <- (sum(confusion.matrix.2[,2])*inter.cost+
           sum(confusion.matrix.2[2,1]+(confusion.matrix.2[2,2]*0.75))*35000)
total.cost

readm.pat <-sum(confusion.matrix.2[2,1]+(confusion.matrix.2[2,2]*0.75))
readm.pat

# Computation of accuracy, TPR and FPR for both models
accuracy <- sum(diag(confusion.matrix))/sum(confusion.matrix)
accuracy
accuracy.2 <- sum(diag(confusion.matrix.2))/sum(confusion.matrix.2)
accuracy.2

TPR <- confusion.matrix[2,2]/sum(confusion.matrix[2,])
TPR
TPR.2 <- confusion.matrix.2[2,2]/sum(confusion.matrix.2[2,])
TPR.2

FPR <- confusion.matrix[1,2]/sum(confusion.matrix[1,])
FPR
FPR.20 <- confusion.matrix.2[1,2]/sum(confusion.matrix.2[1,])
FPR.20




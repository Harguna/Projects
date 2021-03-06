library(quantregForest)
library(nnet)
library(randomForest)
library(RWeka)
library(rpart)
library(arm)
library(brnn)

iterations = 10
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()

modelName <- "combo1"

InputDataFileName="E:/101510028/regressionDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=15 #round(runif(1,1,15),0)
  inputs <-sample(inputs,n)
  
  #-------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)]
  test_labels <- dataset[(totalDataset * training/100):totalDataset,c(target)]
  
  x<- data.matrix(trainDataset)
  model <- brnn(x, train_labels, neurons= 10)
  
  Predicted1 <- predict(model, testDataset)
  Actual <- as.double(unlist(test_labels))
  
  #--------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  a= 16
  b= 656689
  c= 632762
  
  model   <- nnet(formula, trainDataset, size=a, linout=TRUE, skip=TRUE, MaxNWts=b, trace=FALSE, maxit=c)
  
  Predicted2 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model   <- randomForest(formula, trainDataset, ntree=700, mtry=2)
  
  Predicted3 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  trainDataSet <- dataset[1:(totalDataset * training/100),c(inputs,target)]
  testDataSet <- dataset[(totalDataset * training/100):totalDataset,c(inputs,target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model <- M5Rules(formula, trainDataSet)
  
  Predicted4 <- predict(model, testDataSet)
  Actual <- as.double(unlist(testDataSet[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  
  
  
  Predicted <- (Predicted1 + Predicted2 + Predicted3 + Predicted4)/4
  
  r <- cor(Actual,Predicted )
  r <- round(r,2)
  r
  
  R <- r * r 
  R <- round(R,2)
  R
  
  mae <- mean(abs(Actual-Predicted))
  mae <- round(mae,2)
  mae
  
  accuracy <- mean(abs(Actual-Predicted) <=100)
  accuracy <- round(accuracy,4) *100
  accuracy
  
  arr_mae[i] <- mae
  arr_r[i] <- r
  arr_R[i] <- R
  arr_acc[i] <- accuracy
}

data <- cbind(arr_r, arr_R, arr_acc, arr_mae)
write.csv(data, file=paste("E:/101510028/",modelName,"-regression.csv",sep=''), row.names=TRUE)


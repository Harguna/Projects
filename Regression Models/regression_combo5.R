library(quantregForest)
library(nnet)
library(pls)
library(rpart)

iterations = 10
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()

modelName <- "combo5"

InputDataFileName="E:/101510028/regressionDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  dataset <- dataset[sample(nrow(dataset)),]
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=15 
  inputs <-sample(inputs,n)
  
  #--------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  
  model   <- lm(formula, trainDataset)
  
  Predicted1 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #--------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)]
  test_labels <- dataset[(totalDataset * training/100):totalDataset,c(target)]
  
  x<- data.matrix(trainDataset)
  model <-  quantregForest(x, train_labels, nthreads = 5, keep.inbag = FALSE, mtry= round(runif(1,5,15)))
  
  Predicted2 <- predict(model, testDataset)
  Actual <- as.double(unlist(test_labels))
  
  #---------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  a= 16
  b= 656689
  c= 632762
  
  model   <- nnet(formula, trainDataset, size=a, linout=TRUE, skip=TRUE, MaxNWts=b, trace=FALSE, maxit=c)
  
  Predicted3 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  trainDataSet <- dataset[1:(totalDataset * training/100),c(inputs,target)]
  testDataSet <- dataset[(totalDataset * training/100):totalDataset,c(inputs,target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model <- pcr(formula, n, data = trainDataSet, validation = "CV", method = pls.options()$pcralg)
  
  Predicted4 <- predict(model, testDataSet, ncomp=15)
  Actual <- as.double(unlist(testDataSet[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  
  model   <- rpart(formula, trainDataset, method="anova", control = rpart.control(minsplit = 90,cp=0.0001))
  
  Predicted5 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #---------------------------------------------------------------------------------------------------------#
  
  Predicted <- (Predicted1 + Predicted2[,2] + Predicted3 + Predicted4[1:3581] +Predicted5)/5
  
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


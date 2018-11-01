library(randomForest)
library(hmeasure)
library(car)
library(kernlab)
library(caret)
library(glmnet)
library(rpart)

iterations=1
sens = list()
spec = list()
reca = list()
prec = list()
acc = list()
modelName <- "combo5"

InputDataFileName="E:/101510028/classificationDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      


totalDataset <- nrow(dataset)
target  <- names(dataset)[1]

for (i in 1:iterations){
  dataset <- dataset[sample(nrow(dataset)),] 
  inputs <- setdiff(names(dataset),target)
  n <- length(inputs)
  
  #-----------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)] 
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model  <- randomForest(trainDataset, train_labels, ntree=500, mtry=2)
  
  Predicted1 <- round(as.numeric(predict(model, testDataset)))
  PredictedProb1 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #-----------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model  <- multinom(formula, trainDataset,trace=FALSE, maxit=1000)
  
  Predicted2 <- round(as.numeric(predict(model, testDataset))-1)
  PredictedProb2 <- predict(model, testDataset, type="probs")
  Actual <- as.double(unlist(testDataset[target]))
  
  #-----------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  train_labels<- dataset[1:(totalDataset * training/100),c(target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model <- train(formula, trainDataset, method="glmnet")
  
  Predicted3 <- round(as.numeric(predict(model, testDataset)))
  PredictedProb3 <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  #-----------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  
  model <- rpart(formula, trainDataset, method="class", parms=list(split="information"), control=rpart.control(usesurrogate=0, maxsurrogate=0))
  Predicted4 <- predict(model, testDataset, type="class")
  PredictedProb4 <- predict(model, testDataset, type= "prob")[,1]
  Actual <- as.double(unlist(testDataset[target]))
  
  #-----------------------------------------------------------------------------------------------------#
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  
  model <- ada(formula, trainDataset, control=rpart::rpart.control(maxdepth=30, cp=0.010000, minsplit=20,xval=10), iter=50)
  
  Predicted5 <- (predict(model, testDataset))
  PredictedProb5 <- predict(model, testDataset, type= "prob")[,2]
  Actual <- as.double(unlist(testDataset[target]))
  
  #-----------------------------------------------------------------------------------------------------#
  
  for(j in 1:length(Predicted1)){
    a=0 #0's
    b=0 #1's
    if (Predicted1[j]==0){
      a=a+1
    }
    if(Predicted1[j]==1){
      b=b+1
    }
    if (Predicted2[j]==0){
      a=a+1
    }
    if(Predicted2[j]==1){
      b=b+1
    }
    if (Predicted3[j]==0){
      a=a+1
    }
    if(Predicted3[j]==1){
      b=b+1
    }
    if (Predicted4[j]==0){
      a=a+1
    }
    if(Predicted4[j]==1){
      b=b+1
    }
    if (Predicted5[j]==0){
      a=a+1
    }
    if(Predicted5[j]==1){
      b=b+1
    }
    if(a>b){
      Predicted[j]=0
    }
    if(b>a){
      Predicted[j]=1
    }
  }
  
  PredictedProb = (PredictedProb1 + PredictedProb2 + PredictedProb3 + PredictedProb4 + PredictedProb5)/5
  
  ConfusionMatrix <- misclassCounts(Predicted,Actual)$conf.matrix
  
  EvaluationsParameters <- round(HMeasure(Actual,PredictedProb)$metrics,3)
  
  accuracy <- round(mean(Actual==Predicted) *100,2)
  sens[i] <- EvaluationsParameters$Sens
  spec[i] <- EvaluationsParameters$Spec
  prec[i] <- EvaluationsParameters$Precision
  reca[i] <- EvaluationsParameters$Recall
  acc[i] <- accuracy
  
  EvaluationsParameters$Accuracy <- accuracy
  rownames(EvaluationsParameters[i])=modelName
  
}
data <- cbind(sens, spec, prec, reca, acc)
write.csv(data, file=paste("E:/101510028/",modelName,"-classification.csv",sep=''), row.names=TRUE)

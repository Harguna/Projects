library(nnet)
library(hmeasure)
iterations=10
sens = list()
spec = list()
reca = list()
prec = list()
acc = list()
modelName <- "nnet"

InputDataFileName="E:/101510028/classificationDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      


totalDataset <- nrow(dataset)
target  <- names(dataset)[1]

for (i in 1:iterations){
  dataset <- dataset[sample(nrow(dataset)),] 
  inputs <- setdiff(names(dataset),target)
  n <- length(inputs)
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model  <-nnet(formula, trainDataset, size=10, linout=TRUE, skip=TRUE, MaxNWts=10000, trace=FALSE, maxit=100)
  
  Predicted <- round(as.numeric(predict(model, testDataset)))
  PredictedProb <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
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
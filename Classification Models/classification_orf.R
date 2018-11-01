library(obliqueRF)
library(hmeasure)
library(kernlab)
library(caret)
library(class)
library(gmodels)
iterations=3
sens = list()
spec = list()
reca = list()
prec = list()
acc = list()
modelName <- "orf"

InputDataFileName="E:/101510028/classificationDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      


totalDataset <- nrow(dataset)
target  <- names(dataset)[1]

for (i in 1:iterations){
  
  dataset <- dataset[sample(nrow(dataset)),] 
  inputs <- setdiff(names(dataset),target)
  n <- length(inputs)
  
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)]
  test_labels <- dataset[(totalDataset * training/100):totalDataset,c(target)]

  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  model  <- obliqueRF(data.matrix(trainDataset), data.matrix(train_labels), mtry = 2, ntree = 100)
  Predicted <- round(as.numeric(predict(model, testDataset)))
  
  CrossTable(x= test_labels, y = Predicted, prop.chisq = FALSE)
  
}
data <- cbind(sens, spec, prec, reca, acc)
write.csv(data, file=paste("E:/101510028/",modelName,"-classification.csv",sep=''), row.names=TRUE)

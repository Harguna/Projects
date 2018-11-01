library(kernlab)
library(caret)
library(class)
library(gmodels)
iterations = 10
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()

modelName <- "knn"

InputDataFileName="E:/101510028/classificationDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=21
  inputs <-sample(inputs,n)
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)]
  test_labels <- dataset[(totalDataset * training/100):totalDataset,c(target)]
  
  model   <-  knn(train = trainDataset, test = testDataset, cl= train_labels, k=50 )

  CrossTable(x= test_labels, y = model, prop.chisq = FALSE)
  
}

data <- cbind(arr_r, arr_R, arr_acc, arr_mae)
write.csv(data, file=paste("E:/101510028/",modelName,"-regression.csv",sep=''), row.names=TRUE)
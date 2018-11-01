library(brnn)
library(arm)
iterations = 10
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()

modelName <- "brnn"

InputDataFileName="E:/101510028/regressionDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=15 
  inputs <-sample(inputs,n)
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs)]
  train_labels <- dataset[1:(totalDataset * training/100),c(target)]
  test_labels <- dataset[(totalDataset * training/100):totalDataset,c(target)]
  
  x<- data.matrix(trainDataset)
  model <- brnn(x, train_labels, neurons= 10)
  
  Predicted <- predict(model, testDataset)
  Actual <- as.double(unlist(test_labels))
  
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
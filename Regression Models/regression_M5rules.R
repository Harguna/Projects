library(RWeka)
iterations = 10
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()


modelName <- "M5rules"

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
  trainDataSet <- dataset[1:(totalDataset * training/100),c(inputs,target)]
  testDataSet <- dataset[(totalDataset * training/100):totalDataset,c(inputs,target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))

  model <- M5Rules(formula, trainDataSet)
  
  Predicted <- predict(model, testDataSet)
  Actual <- as.double(unlist(testDataSet[target]))
  
  r <- cor(Actual,Predicted)
  r <- round(r,2)
  
  R <- r * r 
  R <- round(R,2)
  
  mae <- mean(abs(Actual-Predicted))
  mae <- round(mae,2)
  
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
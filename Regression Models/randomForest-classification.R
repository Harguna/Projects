library(randomForest)
iterations = 10
#arr_inputs= list()
arr_r=list()
arr_mae=list()
arr_R=list()
arr_acc=list()

modelName <- "randomForest"

InputDataFileName="E:/101510028/classificationDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=21#round(runif(1,1,15),0)
  inputs <-sample(inputs,n)
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  
  model   <- randomForest(formula, trainDataset, ntree=200, mtry=2)
  
  Predicted <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  
  
  accuracy <- mean(abs(Actual-Predicted) <=100)
  accuracy <- round(accuracy,4) *100
  
  arr_acc[i] <- accuracy
}

data <- cbind(arr_acc)#, arr_inputs)
write.csv(data, file=paste("E:/101510028/",modelName,"-classification.csv",sep=''), row.names=TRUE)

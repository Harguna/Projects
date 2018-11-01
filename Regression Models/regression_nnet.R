library(nnet)
iterations = 10
#f1= list()
#f2= list()
#f3= list()
#f4= list()
#f5= list()
arr_a=list()
arr_b=list()
arr_c=list()
arr_r=list()
arr_R=list()
arr_acc=list()
arr_mae=list()

modelName <- "neuralNetwork"

InputDataFileName="E:/101510028/regressionDataSet.csv"

training = 70      

dataset <- read.csv(InputDataFileName)      
dataset <- dataset[sample(nrow(dataset)),]

totalDataset <- nrow(dataset)


for(i in 0:iterations){
  target  <- names(dataset)[1]
  inputs <- setdiff(names(dataset),target)
  n=15#round(runif(1,1,15),0)
  inputs <-sample(inputs,n)
  trainDataset <- dataset[1:(totalDataset * training/100),c(inputs, target)]
  testDataset <- dataset[(totalDataset * training/100):totalDataset,c(inputs, target)]
  formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))
  a=round(runif(1,10,100),0)
  b=round(runif(1,1,1000000),0)
  c=round(runif(1,1,1000000),0)
  model   <- nnet(formula, trainDataset, size=a, linout=TRUE, skip=TRUE, MaxNWts=b, trace=FALSE, maxit=c)
  
  Predicted <- predict(model, testDataset)
  Actual <- as.double(unlist(testDataset[target]))
  
  r <- cor(Actual,Predicted )
  r <- round(r,2)
  
  R <- r * r 
  R <- round(R,2)
  
  mae <- mean(abs(Actual-Predicted))
  mae <- round(mae,2)
  
  accuracy <- mean(abs(Actual-Predicted) <=100)
  accuracy <- round(accuracy,4) *100

  arr_mae[i] <- mae 
  #f1[i] <- inputs[1]
  #f2[i] <- inputs[2]
  #f3[i] <- inputs[3]
  #f4[i] <- inputs[4]
  #f5[i] <- inputs[5]
  arr_a[i] <- a
  arr_b[i] <- b
  arr_c[i] <- c
  arr_r[i] <- r
  arr_R[i] <- R
  arr_acc[i] <- accuracy
}

data <- cbind(arr_a, arr_b, arr_c, arr_r, arr_R, arr_acc, arr_mae)#,  f1, f2, f3, f4, f5)
write.csv(data, file=paste("E:/101510028/",modelName,"-regression.csv",sep=''), row.names=TRUE)

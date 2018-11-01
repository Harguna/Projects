library(randomForest)
library(varSelRF)
library(Boruta)
library(MXM)

InputDataFileName="E:/101510028/classificationDataSet.csv"
data <- read.csv(InputDataFileName)      
data <- data[sample(nrow(data)),]
target  <- names(dataset)[1]
inputs <- setdiff(names(data),target)
trainDataset <- data[,c(inputs)]
train_labels <- data[,c(target)]

formula <- as.formula(paste(target, "~", paste(c(inputs), collapse = "+")))

forest <- randomForest(trainDataset, train_labels, ntree = 200, importance = TRUE)
model = randomVarImpsRF(trainDataset, train_labels,forest, numrandom = 1,usingCluster = FALSE)
write.csv(model, file=paste("E:/101510028/","randomVArImp.csv",sep=''), row.names=TRUE)

Boruta.Short <- Boruta(train_labels~ ., data = trainDataset , maxRuns = 12)
x=attStats(Boruta.Short)
write.csv(x, file=paste("E:/101510028/","boruta.csv",sep=''), row.names=TRUE)

x=SES(train_labels, trainDataset, max_k = 3, threshold = 0.05, test = NULL, ini = NULL,wei = NULL, user_test = NULL, hash = FALSE, hashObject = NULL, robust = FALSE,ncores = 2, logged = FALSE)
summary(x)

x=MMPC(train_labels, trainDataset, max_k = 3, threshold = 0.05, test = NULL, ini = NULL,wei = NULL, user_test = NULL, hash = FALSE, hashObject = NULL, robust = FALSE,ncores = 1, backward = FALSE, logged = FALSE)
summary(x)


library(FSelector)

InputDataFileName= "E:/101510028/regressionDataSet.csv"
data <- read.csv(InputDataFileName)
data <- data[sample(nrow(data)),]

wts <- information.gain(Class~., data)
write.csv(wts, file=paste("E:/101510028/fselector_results.csv", sep = ''), row.names = TRUE)

wts <- relief(Class~., data)
write.csv(wts, file=paste("E:/101510028/relief_results.csv", sep = ''), row.names = TRUE)

wts <- gain.ratio(Class~., data)
write.csv(wts, file=paste("E:/101510028/gain_ratio_results.csv", sep = ''), row.names = TRUE)

wts <- symmetrical.uncertainty(Class~., data)
write.csv(wts, file=paste("E:/101510028/symmetrical_uncertainity_results.csv", sep = ''), row.names = TRUE)

wts <- oneR(Class~., data)
write.csv(wts, file=paste("E:/101510028/oneR_results.csv", sep = ''), row.names = TRUE)


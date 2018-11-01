  library(forecast)
  library(tseries)
  library(MLmetrics)
  d<- Book1
  attach(d)
  close<-d["C"]
  close <- as.numeric(as.character(unlist(close)))
  plot(close)
  adf.test(diff(close))    #<0.05
  diff_close <- diff(close)
  plot(diff_close)
                                                                                                                j=1
  p_values<- list()
  a_values <- list()
  count=0
  for (i in seq(1,319)){
    traindata <- close[1:(10+i)]
    para <- auto.arima(traindata)
    as.character(para)
    para <- substr(para,start = 7, stop = 11)
    para <- strsplit(para, ",")
    para <- list(para)
    para <- unlist(para)
    x <- as.numeric(para[1])
    y <- as.numeric(para[2])
    print (y)
    z <- as.numeric(para[3])
    predicted <- predict(arima(traindata, order = c(x,y,z)), n.ahead = 1 )
    predicted <- as.character(predicted)
    p <-round(as.numeric(predicted[1]),2)
    a <- close[10+i+1]
    p_values[i] <-  p
    a_values[i] <-  a
    j=j+1
    count=count+1
  }

  x <- list()
  for (i in 1:319){
    x[i] <- abs(as.numeric(p_values[i]) - as.numeric(a_values[i]) )
  }
  
  plot(1:319,x,type = 'l',col='red')
  
  f<-list()
  for (i in 1:319){
    f[i] <-abs(as.numeric(close[10+i+1])-as.numeric(close[10+i]))- as.numeric(x[i])
  }

  plot(1:319,p_values,type = 'l',col='red')
  lines(1:319,a_values,col='green')

  RMSE(as.numeric(p_values), as.numeric(a_values))


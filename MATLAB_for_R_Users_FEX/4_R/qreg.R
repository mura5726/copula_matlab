## Perform quantile regression in R
# Copyright 2013 MathWorks, Inc.

## Set required packages
require(timeSeries)
packageExist<-require(quantmod)
if(!packageExist){install.packages("quantmod")}
packageExist<-require(quantreg)
if(!packageExist){install.packages("quantreg")}

## Prepare/pre-process data
stkRetn<-diff(Stock)/Stock[-length(Stock)]
idxRetn<-diff(Index)/Index[-length(Index)]
DataSet<-cbind(timeSeries(idxRetn), stkRetn)
colnames(DataSet)<-c('Index','Stock')

## Run quantile regression
fit<-rq(Stock~Index, tau=Tau, data=DataSet)
coef <- fit$coefficients
## Sample portfolio optimization analysis
# Copyright 2013 MathWorks, Inc.

## Download and clean up time-series data

tryCatch({

# Define symbol list
symList <- c('SPY','EEM','TLT','COY','GSP','RWR');

# Get symbol data, get data from 5 years ago to current date
require(quantmod)
getSymbols(symList, index.class='Date', return.class='timeSeries', 
           from=as.Date('2009-10-01'), to=as.Date('2013-06-24'));

# verify that the downloaded data is in an OHLC format
rapply(sapply(symList,as.symbol),is.OHLC)

# combine and synchronize adjusted closes for each symbol
# 6 is the column no. for "adjusted closing price"
adjClose<-cbind(SPY[,6],EEM[,6],TLT[,6],COY[,6],GSP[,6],RWR[,6])

# for(sym in sapply(symList,as.symbol)) adjClose<-cbind(adjClose,eval(sym)[,6])

# remove the ".Adjusted" column labels
colnames(adjClose)<-strsplit(colnames(adjClose),".Adjusted")

# clean up workspace so only combined data remains
rm(list=symList)
rm(SPY);rm(sym)

# Save workspace for easy loading later
save.image("RTSData")

}, warning = function(err) {
  
  print("Loading data due to datafeed failure")
  load("C:/Work/Seminar/MATLAB for R Users/RExamples/RTSData")

}, error = function(err) {

print("Loading data due to datafeed failure")
load("C:/Work/Seminar/MATLAB for R Users/RExamples/RTSData")

})

# Convert prices to returns, and remove NAs
adjReturns <- diff(log(adjClose))
adjReturns <- na.omit(adjReturns)

# Compute covariance matrix
mu <- colMeans(adjReturns)
sigma <- cov(adjReturns)

require('fPortfolio')
require(Rglpk) # this is the GNU Linear Programming Kit
rtnData <- 100 * returns(adjClose, method="discrete")

## CVaR portfolio optimization
spec=portfolioSpec()
setType(spec)<-"CVaR"
setAlpha(spec)<-0.05
setSolver(spec)="solveRglpk"

ptm <- proc.time();
pfolio<-minriskPortfolio(data=rtnData,spec=spec,constraints="LongOnly");
proc.time() - ptm

print(pfolio)

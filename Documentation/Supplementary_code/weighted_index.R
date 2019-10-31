###    Supplementary code for Christensen and OHara (2019)
###    called by main source code for paper

####   Code for creating market cap weighted indexes
####   of named sites and providers

##  the libraries should already be loaded in the main code
##  but just in case, eh?
library(pdfetch)
#library(tidyverse)
#library(xts)
#library(readr)


#############################################################
###   FETCH DATA FROM YAHOO FINANCE 
###   FOR THE LAST TRADING DAY BEFORE EVENT PERIOD
###   this has already been done and data is saved in the ImportableData folder
###   however, this code will retrieve it from scratch

 Companies <- c("Comcast", "Charter", "AT&T", "Verizon", "Century", "Google", "Microsoft", "Apple", "Facebook", "Yahoo", "AOL")
# Tickers <- c("CMCSA", "CHTR", "T", "VZ", "CTL", "GOOGL", "MSFT", "AAPL", "FB")
# From <- c("2013-03-28", "2013-03-28", "2013-04-26", "2013-03-28", "2013-05-02", "2013-04-18", "2013-04-11", "2013-04-12", "2013-04-30")
# To   <- c("2013-03-29", "2013-03-29", "2013-04-28", "2013-03-29", "2013-05-03", "2013-04-19", "2013-04-12", "2013-04-13", "2013-05-01")
# 
# ticker.dat <- data.frame(Tickers, From, To)
# 
# get.price <- function(ticker, from, to){pdfetch_YAHOO(ticker, fields = c("close"), from= as.Date(from), to = as.Date(to))}
# 
# price.dat <- mapply(get.price, ticker = Tickers, from = From, to = To)
# 
# ###  Add Yahoo and AOL manually
# 
# Yahoo <- 26.52
# AOL <- 40.34
# 
# price.dat = c(price.dat, Yahoo, AOL)
# 
# price.mat <- data.frame(Company = Companies, Date = c(From, "2013-05-01", "2013-05-01"), Price = price.dat)
# 
# write.csv(price.mat, "../ImportableData/MC.pricemat.csv", row.names = FALSE)

######################################################################

price.mat <- read_csv("../ImportableData/MC.pricemat.csv")
price.dat <- price.mat$Price

###  Shares outstanding data comes from SEC 10K filings 
###  for the closest date to the beginning of the event period
###  these can be found in the OriginalData folder
Shares_Outstanding <- c(2129486037, 101250955, 5380000000, 2861117414, 609046043, 271123286, 8351106590, 939058000, 1749622219, 1082634754, 77451455)


# MCapData <- cbind(Companies, Prices, Shares_Outstanding)
# names(MCapData) <- c("Companies", "Prices", "Shares Outstanding")

MarketCap <- price.dat * Shares_Outstanding
MCapData <- data.frame(Companies = Companies, MarketCap = MarketCap)
names(MCapData) <- c("Companies", "MarketCap")

rm(Tickers, From, To, Companies, MarketCap, price.dat, Shares_Outstanding)



###################################################################################
#Do some math and make two weighted portfolios (one for sites and one for providers) 

sites <- c("Google", "Microsoft", "Apple", "Facebook", "AOL", "Yahoo")
providers <- c("Comcast", "Charter", "ATT", "Verizon", "Century")

#Compute total market cap for the groups 
PMT <- sum(MCapData[1:5,2])
#PMT <- sum(select(MCapData, one_of(providers))[1:length(providers),2])
SMT <- sum(MCapData[6:11,2])

## create weights for each stock
p.weights <- matrix(MCapData[1:5,2]/ PMT, nrow(Returns), length(providers), byrow = TRUE)
s.weights <- matrix(MCapData[6:11,2]/ PMT, nrow(Returns), length(sites), byrow = TRUE)

## weight returns of stocks
w.pReturns <- Returns[,2:6 ] * p.weights
w.sReturns <- Returns[,7:12 ] * s.weights

## sum across weighted returns to get indexes
Named <- rowSums(w.sReturns)
Provider <- rowSums(w.pReturns)


w.Index.Returns <- data.frame(Date = Dates, Named, Provider)

###  clean stuff up
rm(MCapData, p.weights, price.mat, s.weights, ticker.dat, w.pReturns, w.sReturns)
rm(siteIndex, providerIndex)
rm(AOL, SMT, PMT, Yahoo, get.price)
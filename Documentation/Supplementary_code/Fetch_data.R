### Script to import data from Yahoo finance 
### and save in RawData folder
### Start and end dates for the periods are assigned in the main code

########################
##  Estimation data

     ##  Import most of the data from Yahoo Finance
Data <- pdfetch_YAHOO(c("^GSPC", "^NDXT", "CMCSA", "CHTR", 
                            "T", "VZ", "CTL", "GOOGL", "MSFT", "AAPL", "FB"), 
                          fields = c("close"), from= Data.Start, 
                          to = Data.End, interval = "1d")

names(Data) <- c("SP500", "Nasdaq", "Comcast", "Charter", 
                     "ATT", "Verizon", "Century" , "Google", 
                     "Microsoft", "Apple", "Facebook")

    ##   AOL data is compiled from... somewhere else
    ##   as it no longer trades
AOL_Data <- as.data.frame(read_csv("../OriginalData/AOLData.csv"))
AOL_Data <- mutate(AOL_Data, Date = as.Date(Date, format = "%m/%d/%y"))
row.names(AOL_Data) <- AOL_Data$Date
AOL.xts <- as.xts(select(AOL_Data, -Date), dateFormat = "Date")

Data <- merge(Data, AOL.xts)


    ##  Yahoo data is compiled from somewhere else
    ##  for reasons known only to Jenna
Yahoo_Data <- as.data.frame(read_csv("../OriginalData/YahooData.csv"))
Yahoo_Data <- mutate(Yahoo_Data, Date = as.Date(Date, format = "%m/%d/%y"))
row.names(Yahoo_Data) <- Yahoo_Data$Date
Yahoo.xts <- as.xts(select(Yahoo_Data, -Date, -Symbol), dateFormat = "Date")

Data <- merge(Data, Yahoo.xts)

Data.df <- as.data.frame(Data)

write.csv(Data.df, "../ImportableData/ImportData.csv")

rm(AOL_Data, Yahoo_Data, AOL.xts, Yahoo.xts, Data, Data.df)



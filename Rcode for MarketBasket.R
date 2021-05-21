library(arules)
library(arulesViz)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(plyr)
library(dplyr)

#This is to pull the data into R
OnlineOrders <- read_excel("C:/Users/dmehling/Documents/R/Online Orders.xlsx")

#complete.cases(data) will return a logical vector indicating which rows have no missing values. 
#Then use the vector to get only rows that are complete using OnlineOrders[,].
OnlineOrders <-OnlineOrders[complete.cases(OnlineOrders), ]

#mutate function is from dplyr package. It is used to edit or add new columns to dataframe. 
#Here itemdescription column is being converted to factor column. as.factor converts column to factor column. 
#%>% is an operator with which you may pipe values to another function or expression
OnlineOrders %>% mutate(itemdescription = as.factor(itemdescription))

#Converts character data to date. Store Date_Iso as date in new variable
OnlineOrders$Date_Iso <- as.Date(OnlineOrders$Date_Iso)

#Convert and edit OrderNumber into numeric
OrderNumber <- as.numeric(as.character(OnlineOrders$OrderNumber))

#Binds new column OrderNumber into dataframe OnlineOrders
cbind(OnlineOrders,OrderNumber)

#ddply(dataframe, variables_to_be_used_to_split_data_frame, function_to_be_applied)
#The R function paste() concatenates vectors to character and separated results using collapse=[any optional charcater string ]. Here ',' is used
OnlineData <- ddply(OnlineOrders,c("OrderNumber","Date_Iso"),
                    function(df1)paste(df1$itemdescription,
                    collapse = ","))

OnlineData
#set column OrderNumber of dataframe transactionData  
OnlineData$OrderNumber <- NULL
#set column Date_Iso of dataframe transactionData
OnlineData$Date_Iso <-NULL
#Rename column to items
colnames(OnlineData) <- c("items")

OnlineData

#OnlineData: Data to be written
#"C:/Users/dmehling/Documents/R/OnlineOrdersMarketBasket.csv": location of file with file name to be written to
#quote: If TRUE it will surround character or factor column with double quotes. If FALSE nothing will be quoted
#row.names: either a logical value indicating whether the row names of x are to be written along with x, or a character vector of row names to be written.
write.csv(OnlineData, "C:/Users/dmehling/Documents/R/OnlineOrdersMarketBasket.csv",quote = FALSE,row.names = FALSE)

#sep tell how items are separated. In this case you have separated using ','
OOD <- read.transactions('C:/Users/dmehling/Documents/R/OnlineOrdersMarketBasket.csv', format = 'basket', sep=',')

# Min Support as 0.001, confidence as 0.8.
basket.rules <- apriori(OOD, parameter = list(supp=0.001, conf=0.8,maxlen=10))

## Write rules to CSV file
write.csv(basket.rules, "C:/Users/dmehling/Documents/R/OnlineOrdersMarketBasketRULES.csv",  sep = ",")


























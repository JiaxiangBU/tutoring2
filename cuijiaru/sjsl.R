setwd("C:/Users/lianxiang/Desktop")
X1<-read.csv("X1.csv")
library(zoo)
library(sandwich)
library(party)
install.packages("randomForest")
library(randomForest)
output.forest <- randomForest(roe ~ net_profit_ratio + gross_profit_rate + net_profits, data=X1, importance=TRUE, mtry=2, ntree=100,proximity=TRUE)
print(output.forest) 
print(importance(output.forest,type = 2))
varImpPlot(output.forest)



output.forest <- randomForest(roe ~ net_profit_ratio + gross_profit_rate + net_profits+eps+business_income+bips+arturnover+arturndays+inventory_turnover+inventory_days+currentasset_turnover+currentasset_days+mbrg+nprg+nav+targ+epsg+seg+currentratio+quickratio+cashratio+icratio+sheqratio+adratio+cf_sales+rateofreturn+cf_nm+cf_liabilities+cashflowratio, data=X1, importance=TRUE, mtry=2, ntree=100,proximity=TRUE)
这句就做不出来了。

library(party)
bn<-cforest(roe ~ net_profit_ratio + gross_profit_rate + net_profits, data=X1)
也做不出来
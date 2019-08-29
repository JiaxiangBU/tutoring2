## ----message=FALSE, warning=FALSE, include=FALSE-------------------------
library(tidyverse)
library(readr)
data <- read_csv("X1.csv")
data <- 
data %>% 
  select(-name)
library(knitr)
library(skimr)

## ------------------------------------------------------------------------
data %>% 
  head()

## ------------------------------------------------------------------------
skim(data)

## ------------------------------------------------------------------------
library(rpart)
library(rpart.plot)
library(lattice)
library(caret)
set.seed(1000)
train_index <- sample(nrow(data),0.7*nrow(data),replace = F)
train <- data[train_index,]
test <- data[-train_index,]
nrow(train)
nrow(test)

## ------------------------------------------------------------------------
bfit <- rpart(roe ~ ., train,method = "anova")
rpart.plot(x = bfit)

## ------------------------------------------------------------------------
library(randomForest)
rf1 <- randomForest(
  roe ~ ., 
  data=train, 
  importance=TRUE, 
  mtry=2, 
  ntree=100,
  proximity=TRUE)
print(rf1) 
print(importance(rf1,type = 2))
varImpPlot(rf1)

## ----message=FALSE, warning=FALSE, include=FALSE-------------------------
purl("code.Rmd")


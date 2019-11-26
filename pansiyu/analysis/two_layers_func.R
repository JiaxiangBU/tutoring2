library(ROCR)
###rank snps
rankByPvalue <- function(Data) {
  model = lm(MPB ~ ., data = Data)
  coef = as.data.frame(summary(model)$coefficients)
  coefSort = coef[sort(coef$"Pr(>|t|)", index.return = T)$ix,]
  rank_r1 = rownames(coefSort)
  rank_r1 = rank_r1[rank_r1 != '(Intercept)']
  return(rank_r1)
}

###得到累积的AUC
getAUC <- function(Data, rank_r1) {
  auc <- c()
  #prob_data <- data.frame(matrix(NA,nrow(Data),ncol(Data)))
  for (i in seq_along(rank_r1)) {
    #folds=createFolds(r1Data$MPB,k=nrow(Data))
    pre <- c()
    prob <- c()
    for (j in 1:nrow(Data)) {
      data_train <- Data[-j,]
      data_test <- Data[j,]
      flt = paste0('MPB_binary~', paste(rank_r1[1:i], collapse = "+"))
      # MPB_binary~age
      model = glm(formula(flt), data = data_train, family = binomial())
      prob <-
        c(prob,
          predict(model, newdata = data_test, type = "response"))
    }
    #prob_data$rank_r1[i] <- prob
    pre <- prediction(prob, Data$MPB_binary)
    auc_value <- performance(pre, measure = "auc")
    auc[i] <- auc_value@y.values[[1]]
  }
  return(auc)
}

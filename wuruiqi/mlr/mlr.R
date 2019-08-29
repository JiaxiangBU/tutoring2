library(lightgbm)
library(mlr)
library(catboost)


# 将lightgbm加入mlr算法库，以回归为例
## 定义学习器
makeRLearner.regr.lightgbm = function() {
  makeRLearnerRegr(
    cl = "regr.lightgbm",
    package = "lightgbm",
    par.set = makeParamSet(
      
      makeIntegerLearnerParam(id ="num_iterations", default=100,lower=1),
      makeIntegerLearnerParam(id ="verbose",default=1),
      makeDiscreteLearnerParam(id = "boosting", default = "gbdt", values = c("gbdt", "dart","goss")), 
      makeNumericLearnerParam(id = "learning_rate", default = 0.1, lower = 0), 
      makeIntegerLearnerParam(id = "max_depth", default = -1, lower = -1),  
      makeIntegerLearnerParam(id = "min_data_in_leaf", default = 20, lower = 0), 
      makeIntegerLearnerParam(id = "num_leaves", default=31, lower=1),
      makeNumericLearnerParam(id = "feature_fraction", default = 1, lower = 0, upper = 1), 
      makeNumericLearnerParam(id = "bagging_fraction", default = 1, lower = 0, upper = 1),
      makeNumericLearnerParam(id = "bagging_freq", default = 0, lower = 0), 
      makeNumericLearnerParam(id = "min_gain_to_split", default = 0, lower = 0),
      makeLogicalLearnerParam(id="use_missing",default=TRUE,tunable = FALSE),
      makeNumericLearnerParam(id = "min_sum_hessian", default=10)
      
    ),
    par.vals = list(objective="regression"),
    properties = c("numerics", "weights","missings"),
    name = "LightGBM",
    short.name = "lightgbm",
    note = "First try at this"
  )
}

## 定义train方法
trainLearner.regr.lightgbm = function(.learner, .task, .subset, .weights = NULL,  ...) {
  f = getTaskDesc(.task)
  data = getTaskData(.task, .subset,target.extra = TRUE)
  lgb.data = lgb.Dataset(as.matrix(data$data), label = data$target)
  lightgbm::lgb.train(data = lgb.data,objective="regression",
                      verbosity = -1, 
                      verbose = -1,
                      record = TRUE,...)
  
}

## 定义预测方法
predictLearner.regr.lightgbm= function(.learner, .model, .newdata, ...) {
  predict(.model$learner.model, as.matrix(.newdata))
}

## 注册新方法
registerS3method("makeRLearner", "regr.lightgbm", makeRLearner.regr.lightgbm)
registerS3method("trainLearner", "regr.lightgbm", trainLearner.regr.lightgbm)
registerS3method("predictLearner", "regr.lightgbm", predictLearner.regr.lightgbm)

## 测试
tmp <- data.frame(v1 = rnorm(100,mean = 0),v2 = rnorm(100,mean = 100),v3 = rnorm(100,mean = 10))
lrn.lightgbm <- makeLearner('regr.lightgbm')
task.tmp <- makeRegrTask(data = tmp,target = 'v3')
mod <- mlr::train(learner = lrn.lightgbm,task = task.tmp)
pred <- predict(mod,task = task.tmp)

# 自定义一个分类算法

makeRLearner.classif.lightgbm = function() {
  makeRLearnerClassif(
    cl = "classif.lightgbm",
    package = "lightgbm",
    par.set = makeParamSet(
      makeIntegerLearnerParam(id ="nrounds", default=100,lower=1), # alias:
      makeIntegerLearnerParam(id ="verbose",default=1),
      makeDiscreteLearnerParam(id = "boosting", default = "goss", values = c("gbdt", "dart","goss")), 
      makeNumericLearnerParam(id = "learning_rate", default = 1, lower = 0), 
      makeIntegerLearnerParam(id = "max_depth", default = -1, lower = -1),  
      makeIntegerLearnerParam(id = "min_data_in_leaf", default = 20, lower = 0), 
      makeIntegerLearnerParam(id = "num_leaves", default=31, lower=1),
      makeNumericLearnerParam(id = "feature_fraction", default = 1, lower = 0, upper = 1), 
      makeNumericLearnerParam(id = "bagging_fraction", default = 1, lower = 0, upper = 1),
      makeNumericLearnerParam(id = "bagging_freq", default = 0, lower = 0), 
      makeNumericLearnerParam(id = "min_gain_to_split", default = 0, lower = 0),
      makeLogicalLearnerParam(id="use_missing",default=TRUE,tunable = FALSE),
      makeNumericLearnerParam(id = "min_sum_hessian", default=10),
      makeIntegerLearnerParam(id = 'num_class',default = 2,tunable = FALSE)
      # makeNumericLearnerParam(id = 'metric',default = 'multi_error'),
    ),
    par.vals = list(objective="multiclass"),
    properties = c("numerics", "weights","missings"),
    name = "LightGBM",
    short.name = "lightgbm",
    note = "First try at this"
  )
}


trainLearner.classif.lightgbm = function(.learner, .task, .subset, .weights = NULL,  ...) {
  f = getTaskDesc(.task)
  data = getTaskData(.task, .subset,target.extra = TRUE)
  lgb.data = lgb.Dataset(as.matrix(data$data), label = data$target)
  lightgbm::lgb.train(data = lgb.data,objective="multiclass",
                      verbosity = -1, 
                      verbose = -1,
                      record = TRUE,...)
  
}



predictLearner.classif.lightgbm= function(.learner, .model, .newdata, ...) {
  predict(.model$learner.model, as.matrix(.newdata))
}



registerS3method("makeRLearner", "classif.lightgbm", makeRLearner.classif.lightgbm)
registerS3method("trainLearner", "classif.lightgbm", trainLearner.classif.lightgbm)
registerS3method("predictLearner", "classif.lightgbm", predictLearner.classif.lightgbm)

lrn.classif.lightgbm <- makeLearner('classif.lightgbm',predict.type = 'response')
task.iris <- makeClassifTask(data = iris,target = 'Species')
mod <- mlr::train(learner = lrn.classif.lightgbm,task = task.iris)


# 加入catboost算法，regr.catboost

makeRLearner.regr.catboost = function() {
  makeRLearnerRegr(
    cl = "regr.catboost",
    package = "catboost",
    par.set = makeParamSet(
      makeIntegerLearnerParam(id ="iterations", default=100,lower=1),
      makeIntegerLearnerParam(id ="border_count",default=128,lower = 1),
      makeNumericLearnerParam(id = "learning_rate", default = 0.1, lower = 0), 
      makeIntegerLearnerParam(id = "depth", default = 6, lower = 1,upper = 16),  
      makeNumericLearnerParam(id = "rsm", default = 0.9, lower = 0, upper = 1)
      
    ),
    par.vals = list(loss_function = 'Logloss'), # MultiClassOneVsAll
    properties = c("numerics", "weights","missings"),
    name = "catboost",
    short.name = "catboost",
    note = "First try at catboost"
  )
}

trainLearner.regr.catboost = function(.learner, .task, .subset, .weights = NULL,  ...) {
  f = getTaskDesc(.task)
  data = getTaskData(.task, .subset,target.extra = TRUE)
  train_pool <- catboost.load_pool(data = as.matrix(data$data), 
                                   label = data$target)
  catboost::catboost.train(learn_pool = train_pool, test_pool = NULL)
  
}


predictLearner.regr.catboost= function(.learner, .model, .newdata, ...) {
  predict(.model$learner.model, catboost.load_pool(as.matrix(.newdata)))
}



registerS3method("makeRLearner", "regr.catboost", makeRLearner.regr.catboost)
registerS3method("trainLearner", "regr.catboost", trainLearner.regr.catboost)
registerS3method("predictLearner", "regr.catboost", predictLearner.regr.catboost)


tmp <- data.frame(v1 = rnorm(100,mean = 0),v2 = rnorm(100,mean = 100),v3 = rnorm(100,mean = 10))
lrn.catboost <- makeLearner('regr.catboost')
task.tmp <- makeRegrTask(data = tmp,target = 'v3')
mod <- mlr::train(learner = lrn.catboost,task = task.tmp)
pred <- predict(mod,task = task.tmp)

### classif.catboost


makeRLearner.classif.catboost = function() {
  makeRLearnerRegr(
    cl = "classif.catboost",
    package = "catboost",
    par.set = makeParamSet(
      makeIntegerLearnerParam(id ="iterations", default=100,lower=1),
      makeIntegerLearnerParam(id ="border_count",default=128,lower = 1),
      makeNumericLearnerParam(id = "learning_rate", default = 0.1, lower = 0), 
      makeIntegerLearnerParam(id = "depth", default = 6, lower = 1,upper = 16),  
      makeNumericLearnerParam(id = "rsm", default = 0.9, lower = 0, upper = 1)
      
    ),
    par.vals = list(loss_function = 'MultiClass'), # MultiClassOneVsAll
    properties = c("numerics", "weights","missings"),
    name = "catboost",
    short.name = "catboost",
    note = "First try at catboost"
  )
}



trainLearner.classif.catboost = function(.learner, .task, .subset, .weights = NULL,  ...) {
  f = getTaskDesc(.task)
  data = getTaskData(.task, .subset,target.extra = TRUE)
  train_pool <- catboost.load_pool(data = as.matrix(data$data), 
                                   label = data$target)
  catboost::catboost.train(learn_pool = train_pool, test_pool = NULL)
  
}



predictLearner.classif.catboost= function(.learner, .model, .newdata, ...) {
  pool_pred <- catboost.load_pool(as.matrix(.newdata),label = NULL)
  catboost::catboost.predict(.model$learner.model, pool_pred)
}


registerS3method("makeRLearner", "classif.catboost", makeRLearner.classif.catboost)
registerS3method("trainLearner", "classif.catboost", trainLearner.classif.catboost)
registerS3method("predictLearner", "classif.catboost", predictLearner.classif.catboost)

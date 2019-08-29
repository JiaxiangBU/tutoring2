
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"></ul></div>

参考 https://xgboost.readthedocs.io/en/latest/tutorials/dart.html


```python
import xgboost as xgb
# read in data
dtrain = xgb.DMatrix('../../xgboost/demo/data/agaricus.txt.train')
dtest = xgb.DMatrix('../../xgboost/demo/data/agaricus.txt.test')
# specify parameters via map
param = {'booster': 'dart',
         'max_depth': 5, 'learning_rate': 0.1,
         'objective': 'binary:logistic', 'silent': True,
         'sample_type': 'uniform',
         'normalize_type': 'tree',
         'rate_drop': 0.1,
         'skip_drop': 0.5}
num_round = 50
bst = xgb.train(param, dtrain, num_round)
# make prediction
# ntree_limit must not be 0
preds = bst.predict(dtest, ntree_limit=num_round)
```

    [16:56:42] 6513x127 matrix with 143286 entries loaded from ../../xgboost/demo/data/agaricus.txt.train
    [16:56:42] 1611x127 matrix with 35442 entries loaded from ../../xgboost/demo/data/agaricus.txt.test
    


```python
print(bst.booster)
```

    dart
    

`.booster`这个参数是 Python 3 的。

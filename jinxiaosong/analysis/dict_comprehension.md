```python
some_list = ['fpd_0','fpd_5','fpd_10','ever4_pd10']
some_dict = {'fpd_0_mean':'{:.2%}', 'fpd_5_mean':'{:.2%}', 'fpd_10_mean':'{:.2%}', 'ever4_pd10_mean':'{:.2%}'}
```


```python
output_list = {i+'_mean':'{:.2%}' for i in some_list}
```


```python
output_list == some_dict
```




    True




```python
# use pandas
import pandas as pd
output_list = pd.Series(['{:.2%}' for i in some_list], index = [i+'_mean' for i in some_list]).to_dict()
output_list == some_dict
```




    True



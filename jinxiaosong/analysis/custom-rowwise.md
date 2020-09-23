```python
import pandas as pd
import numpy as np
```


```python
df = pd.DataFrame(
    {
        'dt':['1','2','3'],
        'A':[10,10,10],
        'B':[20,20,20],
        'C':[10,10,10]
    }
)
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>dt</th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>10</td>
      <td>20</td>
      <td>10</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>10</td>
      <td>20</td>
      <td>10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>3</td>
      <td>10</td>
      <td>20</td>
      <td>10</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.set_index('dt').T.apply(lambda x: x/sum(x)).T
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
    <tr>
      <th>dt</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>0.25</td>
      <td>0.5</td>
      <td>0.25</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.25</td>
      <td>0.5</td>
      <td>0.25</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.25</td>
      <td>0.5</td>
      <td>0.25</td>
    </tr>
  </tbody>
</table>
</div>



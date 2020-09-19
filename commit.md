
``` r
list(untracked = "jinxiaosong/analysis/some_join.ipynb",
     untracked = "jinxiaosong/data/pivot_help.xlsx")
    # add @slsongge data
```

``` python
import pandas as pd
```

``` python
df_raw = pd.read_excel("../data/pivot_help.xlsx")
# df_raw.head()
```

``` python
df_raw.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 276 entries, 0 to 275
    Data columns (total 4 columns):
     #   Column   Non-Null Count  Dtype 
    ---  ------   --------------  ----- 
     0   cut      276 non-null    object
     1   color    276 non-null    object
     2   clarity  276 non-null    object
     3   n        276 non-null    int64 
    dtypes: int64(1), object(3)
    memory usage: 8.8+ KB

``` python
#### 衍生占比【这段代码用了两次聚合，一次merge，太麻烦了，我想要进行优化】
df_gb_cut_sum = df_raw.groupby('cut')['n'].agg(['sum']).reset_index()
df_gb_cut_color_sum = df_raw.groupby(['cut','color'])['n'].agg(['sum']).reset_index()

df_join = df_gb_cut_color_sum.merge(df_gb_cut_sum, how='left', on='cut')
df_join['prob'] = df_join['sum_x'] / df_join['sum_y']
```

``` python
df_join.head(10)
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

<th>

</th>

<th>

cut

</th>

<th>

color

</th>

<th>

sum\_x

</th>

<th>

sum\_y

</th>

<th>

prob

</th>

</tr>

</thead>

<tbody>

<tr>

<th>

0

</th>

<td>

Fair

</td>

<td>

D

</td>

<td>

163

</td>

<td>

1610

</td>

<td>

0.101242

</td>

</tr>

<tr>

<th>

1

</th>

<td>

Fair

</td>

<td>

E

</td>

<td>

224

</td>

<td>

1610

</td>

<td>

0.139130

</td>

</tr>

<tr>

<th>

2

</th>

<td>

Fair

</td>

<td>

F

</td>

<td>

312

</td>

<td>

1610

</td>

<td>

0.193789

</td>

</tr>

<tr>

<th>

3

</th>

<td>

Fair

</td>

<td>

G

</td>

<td>

314

</td>

<td>

1610

</td>

<td>

0.195031

</td>

</tr>

<tr>

<th>

4

</th>

<td>

Fair

</td>

<td>

H

</td>

<td>

303

</td>

<td>

1610

</td>

<td>

0.188199

</td>

</tr>

<tr>

<th>

5

</th>

<td>

Fair

</td>

<td>

I

</td>

<td>

175

</td>

<td>

1610

</td>

<td>

0.108696

</td>

</tr>

<tr>

<th>

6

</th>

<td>

Fair

</td>

<td>

J

</td>

<td>

119

</td>

<td>

1610

</td>

<td>

0.073913

</td>

</tr>

<tr>

<th>

7

</th>

<td>

Good

</td>

<td>

D

</td>

<td>

662

</td>

<td>

4906

</td>

<td>

0.134937

</td>

</tr>

<tr>

<th>

8

</th>

<td>

Good

</td>

<td>

E

</td>

<td>

933

</td>

<td>

4906

</td>

<td>

0.190175

</td>

</tr>

<tr>

<th>

9

</th>

<td>

Good

</td>

<td>

F

</td>

<td>

909

</td>

<td>

4906

</td>

<td>

0.185283

</td>

</tr>

</tbody>

</table>

</div>

``` python
df_raw.groupby('cut').apply(lambda x: x.groupby('color')['n'].sum()/x['n'].sum())
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

<th>

color

</th>

<th>

D

</th>

<th>

E

</th>

<th>

F

</th>

<th>

G

</th>

<th>

H

</th>

<th>

I

</th>

<th>

J

</th>

</tr>

<tr>

<th>

cut

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

<th>

</th>

</tr>

</thead>

<tbody>

<tr>

<th>

Fair

</th>

<td>

0.101242

</td>

<td>

0.139130

</td>

<td>

0.193789

</td>

<td>

0.195031

</td>

<td>

0.188199

</td>

<td>

0.108696

</td>

<td>

0.073913

</td>

</tr>

<tr>

<th>

Good

</th>

<td>

0.134937

</td>

<td>

0.190175

</td>

<td>

0.185283

</td>

<td>

0.177538

</td>

<td>

0.143090

</td>

<td>

0.106400

</td>

<td>

0.062576

</td>

</tr>

<tr>

<th>

Ideal

</th>

<td>

0.131502

</td>

<td>

0.181105

</td>

<td>

0.177532

</td>

<td>

0.226625

</td>

<td>

0.144541

</td>

<td>

0.097118

</td>

<td>

0.041576

</td>

</tr>

<tr>

<th>

Premium

</th>

<td>

0.116235

</td>

<td>

0.169458

</td>

<td>

0.169023

</td>

<td>

0.212022

</td>

<td>

0.171126

</td>

<td>

0.103546

</td>

<td>

0.058589

</td>

</tr>

<tr>

<th>

Very Good

</th>

<td>

0.125228

</td>

<td>

0.198643

</td>

<td>

0.179109

</td>

<td>

0.190283

</td>

<td>

0.150968

</td>

<td>

0.099652

</td>

<td>

0.056117

</td>

</tr>

</tbody>

</table>

</div>

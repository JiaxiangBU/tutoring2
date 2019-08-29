
<h1>Table of Contents<span class="tocSkip"></span></h1>
<div class="toc"><ul class="toc-item"></ul></div>


```python
import pandas as pd
import numpy as np
```


```python
df = pd.read_json("../refs/database.json")
len(df.index)
# 只取用两个，方便执行快。
n_max = 2
df = df.loc[0:(n_max-1),['id','nutrients']]
```


```python
print(df.index.size)
print(df.describe())
```

    2
                    id
    count     2.000000
    mean   1008.500000
    std       0.707107
    min    1008.000000
    25%    1008.250000
    50%    1008.500000
    75%    1008.750000
    max    1009.000000
    


```python
df.head()
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
      <th>id</th>
      <th>nutrients</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1008</td>
      <td>[{'value': 25.18, 'units': 'g', 'description':...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1009</td>
      <td>[{'value': 24.9, 'units': 'g', 'description': ...</td>
    </tr>
  </tbody>
</table>
</div>



本身一个样本有多个 json 元素。

这样写避免了中间变量。


```python
pd.concat([pd.DataFrame(df.iloc[i,].nutrients).assign(**{'id':df.iloc[i,].id}) for i in range(df.index.size)])
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
      <th>description</th>
      <th>group</th>
      <th>units</th>
      <th>value</th>
      <th>id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Protein</td>
      <td>Composition</td>
      <td>g</td>
      <td>25.180</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Total lipid (fat)</td>
      <td>Composition</td>
      <td>g</td>
      <td>29.200</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Carbohydrate, by difference</td>
      <td>Composition</td>
      <td>g</td>
      <td>3.060</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Ash</td>
      <td>Other</td>
      <td>g</td>
      <td>3.280</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Energy</td>
      <td>Energy</td>
      <td>kcal</td>
      <td>376.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Water</td>
      <td>Composition</td>
      <td>g</td>
      <td>39.280</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Energy</td>
      <td>Energy</td>
      <td>kJ</td>
      <td>1573.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Fiber, total dietary</td>
      <td>Composition</td>
      <td>g</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Calcium, Ca</td>
      <td>Elements</td>
      <td>mg</td>
      <td>673.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Iron, Fe</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.640</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Magnesium, Mg</td>
      <td>Elements</td>
      <td>mg</td>
      <td>22.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Phosphorus, P</td>
      <td>Elements</td>
      <td>mg</td>
      <td>490.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Potassium, K</td>
      <td>Elements</td>
      <td>mg</td>
      <td>93.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Sodium, Na</td>
      <td>Elements</td>
      <td>mg</td>
      <td>690.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Zinc, Zn</td>
      <td>Elements</td>
      <td>mg</td>
      <td>2.940</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Copper, Cu</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.024</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Manganese, Mn</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.021</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Selenium, Se</td>
      <td>Elements</td>
      <td>mcg</td>
      <td>14.500</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Vitamin A, IU</td>
      <td>Vitamins</td>
      <td>IU</td>
      <td>1054.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Retinol</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>262.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Vitamin A, RAE</td>
      <td>Vitamins</td>
      <td>mcg_RAE</td>
      <td>271.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Vitamin C, total ascorbic acid</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Thiamin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.031</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Riboflavin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.450</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Niacin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.180</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Pantothenic acid</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.190</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Vitamin B-6</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.074</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Folate, total</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>18.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Vitamin B-12</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.270</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Folic acid</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>207</th>
      <td>Dihydrophylloquinone</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>208</th>
      <td>Vitamin K (phylloquinone)</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>2.800</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>209</th>
      <td>Folic acid</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>210</th>
      <td>Folate, food</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>18.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>211</th>
      <td>Folate, DFE</td>
      <td>Vitamins</td>
      <td>mcg_DFE</td>
      <td>18.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>212</th>
      <td>Betaine</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.700</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>213</th>
      <td>Tryptophan</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.320</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>214</th>
      <td>Threonine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.886</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>215</th>
      <td>Isoleucine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.546</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>216</th>
      <td>Leucine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.385</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>217</th>
      <td>Lysine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.072</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>218</th>
      <td>Methionine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.652</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>219</th>
      <td>Cystine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.125</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>220</th>
      <td>Phenylalanine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.311</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>221</th>
      <td>Tyrosine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.202</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>222</th>
      <td>Valine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.663</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>223</th>
      <td>Arginine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.941</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>224</th>
      <td>Histidine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.874</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>225</th>
      <td>Alanine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.703</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>226</th>
      <td>Aspartic acid</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.600</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>227</th>
      <td>Glutamic acid</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>6.092</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>228</th>
      <td>Glycine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.429</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>229</th>
      <td>Proline</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.806</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>230</th>
      <td>Serine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.456</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>231</th>
      <td>Vitamin E, added</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>232</th>
      <td>Vitamin B-12, added</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>233</th>
      <td>Cholesterol</td>
      <td>Other</td>
      <td>mg</td>
      <td>105.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>234</th>
      <td>Fatty acids, total saturated</td>
      <td>Other</td>
      <td>g</td>
      <td>21.092</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>235</th>
      <td>Fatty acids, total monounsaturated</td>
      <td>Other</td>
      <td>g</td>
      <td>9.391</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>236</th>
      <td>Fatty acids, total polyunsaturated</td>
      <td>Other</td>
      <td>g</td>
      <td>0.942</td>
      <td>1009</td>
    </tr>
  </tbody>
</table>
<p>399 rows × 5 columns</p>
</div>



这样写方便理解。


```python
df_tidy = pd.DataFrame()
for i in range(0,n_max):
    u = pd.DataFrame(df.iloc[i,].nutrients)
    u['id'] = df.iloc[i,].id
    df_tidy = df_tidy.append(u)
df_tidy   
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
      <th>description</th>
      <th>group</th>
      <th>units</th>
      <th>value</th>
      <th>id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Protein</td>
      <td>Composition</td>
      <td>g</td>
      <td>25.180</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Total lipid (fat)</td>
      <td>Composition</td>
      <td>g</td>
      <td>29.200</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Carbohydrate, by difference</td>
      <td>Composition</td>
      <td>g</td>
      <td>3.060</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Ash</td>
      <td>Other</td>
      <td>g</td>
      <td>3.280</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Energy</td>
      <td>Energy</td>
      <td>kcal</td>
      <td>376.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>5</th>
      <td>Water</td>
      <td>Composition</td>
      <td>g</td>
      <td>39.280</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>6</th>
      <td>Energy</td>
      <td>Energy</td>
      <td>kJ</td>
      <td>1573.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>7</th>
      <td>Fiber, total dietary</td>
      <td>Composition</td>
      <td>g</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>8</th>
      <td>Calcium, Ca</td>
      <td>Elements</td>
      <td>mg</td>
      <td>673.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>9</th>
      <td>Iron, Fe</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.640</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>10</th>
      <td>Magnesium, Mg</td>
      <td>Elements</td>
      <td>mg</td>
      <td>22.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>11</th>
      <td>Phosphorus, P</td>
      <td>Elements</td>
      <td>mg</td>
      <td>490.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>12</th>
      <td>Potassium, K</td>
      <td>Elements</td>
      <td>mg</td>
      <td>93.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>13</th>
      <td>Sodium, Na</td>
      <td>Elements</td>
      <td>mg</td>
      <td>690.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>14</th>
      <td>Zinc, Zn</td>
      <td>Elements</td>
      <td>mg</td>
      <td>2.940</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>15</th>
      <td>Copper, Cu</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.024</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>16</th>
      <td>Manganese, Mn</td>
      <td>Elements</td>
      <td>mg</td>
      <td>0.021</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>17</th>
      <td>Selenium, Se</td>
      <td>Elements</td>
      <td>mcg</td>
      <td>14.500</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>18</th>
      <td>Vitamin A, IU</td>
      <td>Vitamins</td>
      <td>IU</td>
      <td>1054.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>19</th>
      <td>Retinol</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>262.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>20</th>
      <td>Vitamin A, RAE</td>
      <td>Vitamins</td>
      <td>mcg_RAE</td>
      <td>271.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>21</th>
      <td>Vitamin C, total ascorbic acid</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>22</th>
      <td>Thiamin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.031</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>23</th>
      <td>Riboflavin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.450</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>24</th>
      <td>Niacin</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.180</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>25</th>
      <td>Pantothenic acid</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.190</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>26</th>
      <td>Vitamin B-6</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.074</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>27</th>
      <td>Folate, total</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>18.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>28</th>
      <td>Vitamin B-12</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.270</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>29</th>
      <td>Folic acid</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1008</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>207</th>
      <td>Dihydrophylloquinone</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>208</th>
      <td>Vitamin K (phylloquinone)</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>2.800</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>209</th>
      <td>Folic acid</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>210</th>
      <td>Folate, food</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>18.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>211</th>
      <td>Folate, DFE</td>
      <td>Vitamins</td>
      <td>mcg_DFE</td>
      <td>18.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>212</th>
      <td>Betaine</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.700</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>213</th>
      <td>Tryptophan</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.320</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>214</th>
      <td>Threonine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.886</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>215</th>
      <td>Isoleucine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.546</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>216</th>
      <td>Leucine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.385</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>217</th>
      <td>Lysine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.072</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>218</th>
      <td>Methionine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.652</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>219</th>
      <td>Cystine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.125</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>220</th>
      <td>Phenylalanine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.311</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>221</th>
      <td>Tyrosine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.202</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>222</th>
      <td>Valine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.663</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>223</th>
      <td>Arginine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.941</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>224</th>
      <td>Histidine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.874</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>225</th>
      <td>Alanine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.703</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>226</th>
      <td>Aspartic acid</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.600</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>227</th>
      <td>Glutamic acid</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>6.092</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>228</th>
      <td>Glycine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>0.429</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>229</th>
      <td>Proline</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>2.806</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>230</th>
      <td>Serine</td>
      <td>Amino Acids</td>
      <td>g</td>
      <td>1.456</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>231</th>
      <td>Vitamin E, added</td>
      <td>Vitamins</td>
      <td>mg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>232</th>
      <td>Vitamin B-12, added</td>
      <td>Vitamins</td>
      <td>mcg</td>
      <td>0.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>233</th>
      <td>Cholesterol</td>
      <td>Other</td>
      <td>mg</td>
      <td>105.000</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>234</th>
      <td>Fatty acids, total saturated</td>
      <td>Other</td>
      <td>g</td>
      <td>21.092</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>235</th>
      <td>Fatty acids, total monounsaturated</td>
      <td>Other</td>
      <td>g</td>
      <td>9.391</td>
      <td>1009</td>
    </tr>
    <tr>
      <th>236</th>
      <td>Fatty acids, total polyunsaturated</td>
      <td>Other</td>
      <td>g</td>
      <td>0.942</td>
      <td>1009</td>
    </tr>
  </tbody>
</table>
<p>399 rows × 5 columns</p>
</div>




code reproduction <https://lexparsimon.github.io/coronavirus/>

``` bash
$ jupyter nbconvert --to markdown wuruiqi/coronavirus.ipynb
[NbConvertApp] Converting notebook wuruiqi/coronavirus.ipynb to markdown
[NbConvertApp] Writing 3648 bytes to wuruiqi\coronavirus.md
```

`wuruiqi/coronavirus.ipynb` 这是复现的 notebook，我 reformat 了代码。

``` python
import numpy as np

# initialize the population vector from the origin-destination flow matrix
N_k = np.abs(np.diagonal(OD) + OD.sum(axis=0) - OD.sum(axis=1))
locs_len = len(N_k)  # number of locations
SIR = np.zeros(
    shape=(locs_len, 3)
)  # make a numpy array with 3 columns for keeping track of the S, I, R groups
SIR[:, 0] = N_k  # initialize the S group with the respective populations

first_infections = np.where(
    SIR[:, 0] <= thresh, SIR[:, 0] // 20, 0
)  # for demo purposes, randomly introduce infections
SIR[:, 0] = SIR[:, 0] - first_infections
SIR[:, 1] = SIR[:, 1] + first_infections  # move infections to the I group

# row normalize the SIR matrix for keeping track of group proportions
row_sums = SIR.sum(axis=1)
SIR_n = SIR / row_sums[:, np.newaxis]

# initialize parameters
beta = 1.6
gamma = 0.04
public_trans = 0.5  # alpha
R0 = beta / gamma
beta_vec = np.random.gamma(1.6, 2, locs_len)
gamma_vec = np.full(locs_len, gamma)
public_trans_vec = np.full(locs_len, public_trans)

# make copy of the SIR matrices
SIR_sim = SIR.copy()
SIR_nsim = SIR_n.copy()

# run model
print(SIR_sim.sum(axis=0).sum() == N_k.sum())
from tqdm import tqdm_notebook

infected_pop_norm = []
susceptible_pop_norm = []
recovered_pop_norm = []
```

    ---------------------------------------------------------------------------
    
    NameError                                 Traceback (most recent call last)
    
    <ipython-input-7-aa271ab2f1eb> in <module>
          2 
          3 # initialize the population vector from the origin-destination flow matrix
    ----> 4 N_k = np.abs(np.diagonal(OD) + OD.sum(axis=0) - OD.sum(axis=1))
          5 locs_len = len(N_k)  # number of locations
          6 SIR = np.zeros(
    
    
    NameError: name 'OD' is not defined

> For this analysis, we will use the aggregated \(OD\) flow matrix of a
> typical day obtained from GPS data provided by local ride sharing
> company gg as a proxy for the mobility patterns in Yerevan city.

这是 OD 的定义。 需要在 <https://www.ggtaxi.com/signin> 下载。

> Next, we need the population counts in each 250×250 m grid cell, which
> we approximate by proportionally scaling the extracted flow counts so
> that the total inflows in different locations sum up to approximately
> half of Yerevan’s population of 1.1 million. This is actually a bold
> assumption, but since varying this portion yielded very similar
> results, we will stick to it.

然后下载后的数据做一个计数矩阵，进行标准化处理即可。 这部分你可以把数据下载下来后，我这边处理。

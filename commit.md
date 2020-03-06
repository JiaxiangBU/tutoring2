
PCA on Capelle-Blancard et al. (2019)

![image](https://user-images.githubusercontent.com/15884785/76081809-e527e280-5fe4-11ea-9f68-b09389c7e1be.png)

处理方法为

1.  先PCA得到每个变量和 PCs 的 loading

2.  取行最大 rowMax，每个 PC 中的 loading 只保留行最大的，其他设为0
    
    > Three principal components extract most of the variance from the
    > original dataset. Control corruption (0.90), rule of law (0.91),
    > voice (0.83), effectiveness (0.90), political stability (0.60) and
    > security and regulatory quality (0.86) have **the highest factor
    > loading** on the first compo nent. This component is labeled
    > “governance quality index” (GOVI). This GOVI dimension explains
    > most of the variance from the dataset: 46.69% (Capelle-Blancard et
    > al. 2019)
    
    > Specifically, the first component, which represents the first
    > composite index: “governance quality index” (GOVI) is computed as
    > follows: GOVI = 0.19∗corruption + 0.20∗rule + 0.16∗voice +
    > 0.19∗effectiveness + 0.08∗stability + 0.18∗regulatory.
    > (Capelle-Blancard et al. 2019)

3.  处理后，对 PCs 再进行标准化。
    
    > normalized sum of squared loading (Capelle-Blancard et al. 2019)
    
    ``` r
    library(magrittr)
    ```
    
        ## Warning: package 'magrittr' was built under R version 3.6.1
    
    ``` r
    c(.9,.91,.83,.9,.6,.86) %>% 
        magrittr::raise_to_power(2) %>% 
        {./sum(.)}
    ```
    
        ## [1] 0.1911910 0.1954633 0.1626068 0.1911910 0.0849738 0.1745740
    
    取平方和做分母。

4.  最后对PCs对方差的解释占比作为PCs的权重，构建 ESGGI
    
    > For example, the weighting of the first intermediate composite
    > index is 0.45 (45%), calculated as follows: 5.65/(5.65 + 3.52 +
    > 3.27) (Capelle-Blancard et al. 2019)
    
    > ESGGI = 0.45∗GOVI + 0.30∗SODI + 0.25∗ENVI (Capelle-Blancard et al.
    > 2019)

这种处理方法可以这么认为。

1.  首先不是所有权重都使用，类似于 OLS 和 Lasso 的区别，把小的权重设为0，做了正则化的处理，保证指数更泛化。
2.  其次最后取平方和做分母，相当于做标准化。

<div id="refs" class="references">

<div id="ref-CAPELLEBLANCARD2019156">

Capelle-Blancard, Gunther, Patricia Crifo, Marc-Arthur Diaye, Rim
Oueghlissi, and Bert Scholtens. 2019. “Sovereign Bond Yield Spreads and
Sustainability: An Empirical Analysis of Oecd Countries.” *Journal of
Banking & Finance* 98: 156–69.
<https://doi.org/https://doi.org/10.1016/j.jbankfin.2018.11.011>.

</div>

</div>

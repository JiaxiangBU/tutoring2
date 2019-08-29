
> Within its own design and scope, cross‐validation is in reality a
> sub‐optimal simulation of test set validation, **crippled** by a
> critical sampling variance omission, as it **manifestly** is based on
> one data set only (training data set). Other re‐sampling validation
> methods are shown to suffer from the same deficiencies. (Esbensen and
> Geladi 2010)

和我的想法一样，就是说 k-fold 始终是局部最优，是 train 组的 bias 和 variance 最小化，而非总体 (train 和
test) 一起的最小化。 Esbensen and Geladi (2010) 说的 one data set only (training
data set) 和 deficiencies 就是这个意思。

<div id="refs" class="references">

<div id="ref-Esbensen2010">

Esbensen, Kim H., and Paul Geladi. 2010. “Principles of Proper
Validation: Use and Abuse of Re-Sampling for Validation.” *Journal of
Chemometrics* 24 (3‐4): 168–87. <https://doi.org/10.1002/cem.1310>.

</div>

</div>

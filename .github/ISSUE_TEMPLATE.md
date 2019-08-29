简单描述你的问题和希望产生的输出结果。
事先可以在以下项目查看是否已经有解决方案



相关问题，assign 给对应 owner，打上对应的标签 label 等。

问题解决后，记得 close。

### 简述问题

...

### 希望输出的结果

...

### 过程中产生的报错 (可选)

...

遇到报错的时候，推荐采用 debugging 思路，定位具体报错信息和报错的函数或者对象，具体可以参考例子
https://jiaxiangbu.github.io/learn_rstudioapi/analysis/rstudio-and-api-learning-notes.html#section-6.2

在书写 Rmd 文档时，

1. `library` 放在前面，先让第三方包 import，这样可以让后面的函数顺利执行。
1. 导入数据用相对路径，避免其他使用者需要重新修改路径。如果使用`here`函数，`?here::here` 查看使用方法
1. 不要重复定义函数，已经定义，使用 `source` 调用。
1. 文档编码是编码 `GBK`的，修改为 `UTF-8`，方法是在 RStudio 点击左上角的 <kbd>File</kbd>，点击 <kbd>Save with Encoding</kbd>，选择 `UTF-8`
1. 代码注意缩进，或者 <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>A</kbd>  reformat 代码
1. 很多 bug 都是书写不规范导致的，先 debug 一下看看。



### 有关联的问题

直接把链接复制在此。

### 复现代码和数据

首次提问，可以建立自己全拼文件夹，见 https://github.com/JiaxiangBU/tutoring
在当前文件夹下，

把反馈的**截图**代码和输入数据上传，我在你的代码上进行修改。

1. 数据传  `output` 文件夹
1. 代码 (`.Rmd`, `.md`) 文档传 `analysis` 文件夹
    1. `.md` 可以展示目前代码状况，不需要我执行代码就可以看到结果，方便快速查看问题。
1. 命名的规范如，`190101-who_am_i-name.postfix`

我们接下来反馈的时候给上有复现的代码和数据，这样我可以很快给你 debug。

1. 相关的 commit 回复到 对应的 issue，这样方便之后跟踪每个问题
1. 一个模块一个模块的解决，基本上一个问题，建立一个独立的issue，不同文档归属到对应的issue
1. 使用 [GitHub Markdown](https://guides.github.com/features/mastering-markdown/) 代码方式，保证 issue 的整洁

代码尽量避免截图，因为无法复制截图复现，因此更好的方式复制代码。

如果是 R 代码，按照以下输入

```r
...
````

如果是 SQL 代码，按照以下输入

```sql
...
```




### Todos

1. [ ] assign 给对应 owner
1. [ ] 打上对应标签
1. [ ] 问题解决后记得 close


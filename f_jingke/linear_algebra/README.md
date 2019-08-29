矩阵运算
================
李家翔
2018-11-20

  
![Ax= y](https://latex.codecogs.com/png.latex?Ax%3D%20y "Ax= y")  
  
![A^{-1}Ax=
A^{-1}y](https://latex.codecogs.com/png.latex?A%5E%7B-1%7DAx%3D%20A%5E%7B-1%7Dy
"A^{-1}Ax= A^{-1}y")  
  
![x= A^{-1}y](https://latex.codecogs.com/png.latex?x%3D%20A%5E%7B-1%7Dy
"x= A^{-1}y")  

不支持[`alignat`](https://stackoverflow.com/questions/48511527/how-to-display-math-in-an-rmd-file-on-github)

  
![x + y
= 35](https://latex.codecogs.com/png.latex?x%20%2B%20y%20%3D%2035
"x + y = 35")  
  
![4x + 2y
= 94](https://latex.codecogs.com/png.latex?4x%20%2B%202y%20%3D%2094
"4x + 2y = 94")  

参考

1.  [R](https://jiaxiangli.netlify.com/2018/01/linear-transformation/#deta-0)
2.  [Python](https://docs.scipy.org/doc/numpy/reference/generated/numpy.linalg.solve.html)

<!-- end list -->

``` r
A <- matrix(c(1,1,4,2),nrow = 2,byrow = T)
y <- matrix(c(35,94),nrow = 2,byrow = T)
A
```

    ##      [,1] [,2]
    ## [1,]    1    1
    ## [2,]    4    2

``` r
y
```

    ##      [,1]
    ## [1,]   35
    ## [2,]   94

``` r
solve(A)
```

    ##      [,1] [,2]
    ## [1,]   -1  0.5
    ## [2,]    2 -0.5

``` r
solve(A) %*% y
```

    ##      [,1]
    ## [1,]   12
    ## [2,]   23

``` r
# validation
12*4+23*2
```

    ## [1] 94

1.  ![\\surd](https://latex.codecogs.com/png.latex?%5Csurd "\\surd")
    矩阵的定义函数
2.  ![\\surd](https://latex.codecogs.com/png.latex?%5Csurd "\\surd")
    逆矩阵求解的函数
3.  ![\\surd](https://latex.codecogs.com/png.latex?%5Csurd
    "\\surd")矩阵相乘的函数

<!-- end list -->

``` python
import numpy as np
# Get np.array functions
A = np.array([[1,1], [4,2]])
y = np.array([35,94])
x = np.linalg.solve(A, y)
print(A)
print(y)
print(x)
print(4*12+2*23)
```

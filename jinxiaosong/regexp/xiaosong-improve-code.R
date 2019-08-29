library(tidyverse)

#### 按照要求提取长字符串中的部分字符串，要求如下：
## 1、若存在标识符，则按照要求返回标识符后的第n到m位字符
## 2、若不存在，则返回-9999
## 3、若标识符后面需要提取的字符串为m-n个9，则返回-9999
## 4、若标识符后面需要提取的字符中存在任何一个非数值，则返回-9999
## 5、若标识符前面是任何字母（除“ADD”），那么视为该字符串不存在该标识符

my_subset02 <- function(col, pattern, add1, add2) {
    
    ### 参数解释
    # col：数据框的某一列，每一行都是一个长字符串
    # pattern：标识符，一个长字符串中需要根据不同的标识符去提取标识符后面各自的指定位置的字符串
    # add1：标识符后需要截取字符串的开始位置
    # add1：标识符后需要截取字符串的结束位置
    
    loc = unlist(lapply(col, function(x) {str_locate(x, pattern)[2]})) # 获取标识符的位置（末）
    res = str_sub(col, loc + add1, loc + add2)                         # 提取标识符后的字符串
    res_inf = str_dup('9', add2 - add1 + 1)                            # 构建m-n个9
    res_error = str_detect(res, '[^\\d]')                              # 判断提取的字符串是否存在非数值
    res = case_when(
        res %in% c(NA, res_inf) ~ '-9999',
        res_error == T ~ '-9999',
        TRUE ~ res
    )
}

#### my_subset01作用与my_subset02一样
my_subset01 <- function(col, pattern, add1, add2) {
    loc = unlist(lapply(col, function(x) {str_locate(x, pattern)[2]}))
    res = case_when(
        loc %in% NA ~ '-9999',
        str_sub(col, loc + add1, loc + add2) == str_dup('9', add2 - add1 + 1) ~ '-9999',
        str_detect(str_sub(col, loc + add1, loc + add2), '[^\\d]') == T ~ '-9999',
        TRUE ~ str_sub(col, loc + add1, loc + add2)
    )
}

#### 示例
df <- data.frame(s = c('123AA21234','123AA11234','123AA29999','123AA2//34','123ADDAA21234','123DAA21234'))
df_new <- df %>% 
    mutate(s_new = my_subset02(col = s, pattern = '(?:ADDAA2|[^A-Za-z]AA2)', add1 = 1, add2 = 3))
df_new
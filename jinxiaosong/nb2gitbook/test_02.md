
# 加载模块


```python
import qgrid
import random
import warnings
import numpy as np
import pandas as pd
import seaborn as sns
from sklearn import metrics
from functools import reduce
import matplotlib.pyplot as plt
from pyecharts.charts import Bar, Line, Page
from pyecharts import options as opts

%matplotlib inline
warnings.filterwarnings('ignore')
pd.set_option('display.max_columns', 50)
```

## 封装函数


```python
def liftchart_num(data, score_bins, loan_cnt, bad_rate, bad_rate_cum, cover, auc, ks):
    bar = (
        Bar(init_opts=opts.InitOpts(width="900px", height="400px"))
        .add_xaxis(list(data[score_bins]))
        .add_yaxis("样本量", list(data[loan_cnt]), color="#1f77b4")
        .extend_axis(yaxis=opts.AxisOpts(axislabel_opts=opts.LabelOpts(formatter="{value}%")))
#         .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
        .set_global_opts(
            toolbox_opts=opts.ToolboxOpts(),
            legend_opts=opts.LegendOpts(pos_top="7%"),
            datazoom_opts=opts.DataZoomOpts(range_start=0,range_end=100),
            title_opts=opts.TitleOpts(title="%s" % score_bins, 
                                      subtitle='COVER={0:.3f}   AUC={1:.3f}   KS={2:.3f}'.format(cover,auc,ks))
        )
    )
    
    line = (
        Line()
        .add_xaxis(data[score_bins])
        .add_yaxis("每段首逾率", list(data[bad_rate]), yaxis_index=1, 
                   linestyle_opts=opts.LineStyleOpts(color="#DE47C8", width=3),
                   itemstyle_opts=opts.ItemStyleOpts(color="#DE47C8"))
        .add_yaxis("累积首逾率", list(data[bad_rate_cum]), yaxis_index=1,
                   linestyle_opts=opts.LineStyleOpts(color="#ff7f0e", width=3),
                   itemstyle_opts=opts.ItemStyleOpts(color="#ff7f0e"))
#         .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
    ); bar.overlap(line); return bar


def liftchart_cat(data, score_bins, loan_cnt, bad_rate, bad_rate_all, cover):
    bar = (
        Bar(init_opts=opts.InitOpts(width="1000px", height="400px"))
        .add_xaxis([str(x) for x in data[score_bins]])
        .add_yaxis("样本量", list(data[loan_cnt]), color="#1f77b4")
        .extend_axis(yaxis=opts.AxisOpts(axislabel_opts=opts.LabelOpts(formatter="{value}%")))
#         .set_series_opts(label_opts=opts.LabelOpts(is_show=False))
        .set_global_opts(
            title_opts=opts.TitleOpts(title="%s" % score_bins, subtitle='COVER={0:.3f}'.format(cover)),
            legend_opts=opts.LegendOpts(pos_top="7%"),
            toolbox_opts=opts.ToolboxOpts(),
            datazoom_opts=opts.DataZoomOpts(range_start=0,range_end=100)
        )
    )
    
    line = (
        Line()
        .add_xaxis([str(x) for x in data[score_bins]])
        .add_yaxis("每段首逾率", list(data[bad_rate]), yaxis_index=1, 
                   linestyle_opts=opts.LineStyleOpts(color="#ff7f0e", width=3),
                   itemstyle_opts=opts.ItemStyleOpts(color="#ff7f0e"))
         .set_series_opts(
#           label_opts=opts.LabelOpts(is_show=False)
            markline_opts=opts.MarkLineOpts(data=[opts.MarkLineItem(y=bad_rate_all, name="整体首逾率")])
        )
    ); bar.overlap(line); return bar


def liftchart(data, xvars, yvar, uv, g=10):
    
    data_tmp = data.copy()
    page = Page()
    for xvar in xvars:
        
        ######## 可视化离散型变量
        if data_tmp[xvar].nunique() <= uv or data_tmp[xvar].dtype == 'object':
            
            ## 处理缺失值与-9999999
#             data_tmp[xvar] = data_tmp[xvar].astype('str')
            cover = 1 - sum(pd.isnull(data_tmp[xvar])) / len(data_tmp)
            bad_rate_all = round(data_tmp[yvar].mean()*100, 2)
#             data_tmp[xvar].replace('-9999999', '-999', inplace=True)
    
            result_cat = data_tmp \
                .groupby(xvar, as_index=False)[yvar] \
                .agg({'good' : lambda x: sum(x==0), 
                      'bad'  : lambda x: sum(x==1), 
                      'total': lambda x: len(x)}) \
                .fillna(0)
    
            result_cat['bad_rate'] = (result_cat['bad'] / result_cat['total']).map(lambda x: '{:.2f}'.format(x*100))
        
            plot_cat = liftchart_cat(result_cat, xvar, 'total', 'bad_rate', bad_rate_all, cover); page.add(plot_cat)
        
        ######## 可视化连续性变量
        else:
            
            data_tmp[xvar+'_bin'] = np.where(data_tmp[xvar] < 0, '999999999', pd.qcut(data_tmp[xvar], q=g, duplicates='drop', precision=1).astype('str'))
            
            result_num = data_tmp \
                .groupby(xvar+'_bin', as_index=False)[yvar] \
                .agg({'good' : lambda x: sum(x==0), 
                      'bad'  : lambda x: sum(x==1), 
                      'total': lambda x: len(x)}) \
                .fillna(0)
            
            result_num['bins_fst'] = result_num[xvar+'_bin'].apply(lambda x: float(x.split(',')[0].replace('(', '')))
            result_num = result_num.sort_values('bins_fst').reset_index(drop=True)
            
            data_tmp_g0 = data_tmp[data_tmp[xvar] > 0]
            score_median = data_tmp_g0[xvar].median()
            fst_rate_g = data_tmp_g0.loc[data_tmp_g0[xvar] > score_median, yvar].mean()
            fst_rate_l = data_tmp_g0.loc[data_tmp_g0[xvar] < score_median, yvar].mean()
            
            if fst_rate_g < fst_rate_l:
                
                result_num = result_num \
                    .assign(**{'is_neg_999': result_num[xvar+'_bin'] == '999999999', 
                               'is_nan'    : result_num[xvar+'_bin'] == 'nan'}) \
                    .sort_values(['is_neg_999', 'is_nan', 'bins_fst'], ascending=[1, 1, 0])

            result_num = result_num \
                .assign(bad_cum  = result_num['bad'].cumsum(),
                        good_cum = result_num['good'].cumsum(),
                        bad_rate = result_num['bad'] / result_num['total'])
            
            result_num['bad_rate_cum'] = result_num['bad_cum'] / result_num['total'].cumsum()
            result_num[['bad_rate','bad_rate_cum']] = result_num[['bad_rate','bad_rate_cum']].applymap(lambda x: '{:.2f}'.format(x*100))
            result_num.replace(to_replace=['999999999'], value=['-999'], inplace=True)
#             result_num[xvar+'_bin'] = result_num[xvar+'_bin'].str.replace('\\.0', '')
            
            #### 计算AUC、KS和IV
            result_num_woe = result_num[~result_num[xvar+'_bin'].isin(['-999','nan'])]
            result_num_woe.reset_index(drop=True, inplace=True)
            
            result_num_woe = result_num_woe \
                .assign(bad_rate_woe  = result_num_woe['bad'] / result_num_woe['bad_cum'][len(result_num_woe)-1],
                        good_rate_woe = result_num_woe['good'] / result_num_woe['good_cum'][len(result_num_woe)-1])
            
            result_num_woe['woe_v'] = np.log(result_num_woe['bad_rate_woe'] / result_num_woe['good_rate_woe'])
            result_num_woe['woe_w'] = result_num_woe['bad_rate_woe'] - result_num_woe['good_rate_woe']
            
            pred, real = data_tmp.loc[data_tmp[xvar] >= 0, xvar], data_tmp.loc[data_tmp[xvar] >= 0, yvar]
            fpr, tpr, thresholds = metrics.roc_curve(real, pred, pos_label=1)
            
            cover = 1 - sum(pd.isnull(data_tmp[xvar])) / len(data_tmp)
            auc = metrics.auc(fpr, tpr)
            ks  = max(abs(tpr - fpr))
            iv  = sum(result_num_woe['woe_w'] * result_num_woe['woe_v'])
            
            plot_num = liftchart_num(result_num, xvar+'_bin', 'total', 'bad_rate', 'bad_rate_cum', cover, auc, ks); page.add(plot_num)
#     return result_num_woe
    return page
```

# 构建数据


```python
df_raw = pd.DataFrame(
    {'x': [random.randint(0,100) for _ in range(1000)],
     'y': [random.randint(0,1) for _ in range(1000)]}
)
```

## 数据处理


```python
df_raw.rename(columns={'x':'test_x'}, inplace=True)
```

# 可视化


```python
p_all = liftchart(df_raw, xvars=['test_x'], yvar='y', uv=20, g=10)
p_all.render_notebook()
```





<script>
    require.config({
        paths: {
            'echarts':'https://assets.pyecharts.org/assets/echarts.min'
        }
    });
</script>

        <div id="9666c783c95b46a1b490de96884ad600" style="width:900px; height:400px;"></div>

<script>
        require(['echarts'], function(echarts) {
                var chart_9666c783c95b46a1b490de96884ad600 = echarts.init(
                    document.getElementById('9666c783c95b46a1b490de96884ad600'), 'white', {renderer: 'canvas'});
                var option_9666c783c95b46a1b490de96884ad600 = {
    "animation": true,
    "animationThreshold": 2000,
    "animationDuration": 1000,
    "animationEasing": "cubicOut",
    "animationDelay": 0,
    "animationDurationUpdate": 300,
    "animationEasingUpdate": "cubicOut",
    "animationDelayUpdate": 0,
    "color": [
        "#1f77b4",
        "#c23531",
        "#2f4554",
        "#61a0a8",
        "#d48265",
        "#749f83",
        "#ca8622",
        "#bda29a",
        "#6e7074",
        "#546570",
        "#c4ccd3",
        "#f05b72",
        "#ef5b9c",
        "#f47920",
        "#905a3d",
        "#fab27b",
        "#2a5caa",
        "#444693",
        "#726930",
        "#b2d235",
        "#6d8346",
        "#ac6767",
        "#1d953f",
        "#6950a1",
        "#918597"
    ],
    "series": [
        {
            "type": "bar",
            "name": "\u6837\u672c\u91cf",
            "data": [
                97,
                96,
                101,
                104,
                97,
                101,
                104,
                83,
                115,
                102
            ],
            "barCategoryGap": "20%",
            "label": {
                "show": true,
                "position": "top",
                "margin": 8
            }
        },
        {
            "type": "line",
            "name": "\u6bcf\u6bb5\u9996\u903e\u7387",
            "connectNulls": false,
            "yAxisIndex": 1,
            "symbolSize": 4,
            "showSymbol": true,
            "smooth": false,
            "step": false,
            "data": [
                [
                    "(90.0, 100.0]",
                    "50.52"
                ],
                [
                    "(79.0, 90.0]",
                    "47.92"
                ],
                [
                    "(68.0, 79.0]",
                    "52.48"
                ],
                [
                    "(59.0, 68.0]",
                    "40.38"
                ],
                [
                    "(50.0, 59.0]",
                    "52.58"
                ],
                [
                    "(41.0, 50.0]",
                    "54.46"
                ],
                [
                    "(29.7, 41.0]",
                    "52.88"
                ],
                [
                    "(19.0, 29.7]",
                    "51.81"
                ],
                [
                    "(9.0, 19.0]",
                    "53.91"
                ],
                [
                    "(-0.1, 9.0]",
                    "57.84"
                ]
            ],
            "hoverAnimation": true,
            "label": {
                "show": true,
                "position": "top",
                "margin": 8
            },
            "lineStyle": {
                "width": 3,
                "opacity": 1,
                "curveness": 0,
                "type": "solid",
                "color": "#DE47C8"
            },
            "areaStyle": {
                "opacity": 0
            },
            "itemStyle": {
                "color": "#DE47C8"
            }
        },
        {
            "type": "line",
            "name": "\u7d2f\u79ef\u9996\u903e\u7387",
            "connectNulls": false,
            "yAxisIndex": 1,
            "symbolSize": 4,
            "showSymbol": true,
            "smooth": false,
            "step": false,
            "data": [
                [
                    "(90.0, 100.0]",
                    "50.52"
                ],
                [
                    "(79.0, 90.0]",
                    "49.22"
                ],
                [
                    "(68.0, 79.0]",
                    "50.34"
                ],
                [
                    "(59.0, 68.0]",
                    "47.74"
                ],
                [
                    "(50.0, 59.0]",
                    "48.69"
                ],
                [
                    "(41.0, 50.0]",
                    "49.66"
                ],
                [
                    "(29.7, 41.0]",
                    "50.14"
                ],
                [
                    "(19.0, 29.7]",
                    "50.32"
                ],
                [
                    "(9.0, 19.0]",
                    "50.78"
                ],
                [
                    "(-0.1, 9.0]",
                    "51.50"
                ]
            ],
            "hoverAnimation": true,
            "label": {
                "show": true,
                "position": "top",
                "margin": 8
            },
            "lineStyle": {
                "width": 3,
                "opacity": 1,
                "curveness": 0,
                "type": "solid",
                "color": "#ff7f0e"
            },
            "areaStyle": {
                "opacity": 0
            },
            "itemStyle": {
                "color": "#ff7f0e"
            }
        }
    ],
    "legend": [
        {
            "data": [
                "\u6837\u672c\u91cf",
                "\u6bcf\u6bb5\u9996\u903e\u7387",
                "\u7d2f\u79ef\u9996\u903e\u7387"
            ],
            "selected": {
                "\u6837\u672c\u91cf": true
            },
            "show": true,
            "top": "7%"
        }
    ],
    "tooltip": {
        "show": true,
        "trigger": "item",
        "triggerOn": "mousemove|click",
        "axisPointer": {
            "type": "line"
        },
        "textStyle": {
            "fontSize": 14
        },
        "borderWidth": 0
    },
    "xAxis": [
        {
            "show": true,
            "scale": false,
            "nameLocation": "end",
            "nameGap": 15,
            "gridIndex": 0,
            "inverse": false,
            "offset": 0,
            "splitNumber": 5,
            "minInterval": 0,
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "width": 1,
                    "opacity": 1,
                    "curveness": 0,
                    "type": "solid"
                }
            },
            "data": [
                "(90.0, 100.0]",
                "(79.0, 90.0]",
                "(68.0, 79.0]",
                "(59.0, 68.0]",
                "(50.0, 59.0]",
                "(41.0, 50.0]",
                "(29.7, 41.0]",
                "(19.0, 29.7]",
                "(9.0, 19.0]",
                "(-0.1, 9.0]"
            ]
        }
    ],
    "yAxis": [
        {
            "show": true,
            "scale": false,
            "nameLocation": "end",
            "nameGap": 15,
            "gridIndex": 0,
            "inverse": false,
            "offset": 0,
            "splitNumber": 5,
            "minInterval": 0,
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "width": 1,
                    "opacity": 1,
                    "curveness": 0,
                    "type": "solid"
                }
            }
        },
        {
            "show": true,
            "scale": false,
            "nameLocation": "end",
            "nameGap": 15,
            "gridIndex": 0,
            "axisLabel": {
                "show": true,
                "position": "top",
                "margin": 8,
                "formatter": "{value}%"
            },
            "inverse": false,
            "offset": 0,
            "splitNumber": 5,
            "minInterval": 0,
            "splitLine": {
                "show": false,
                "lineStyle": {
                    "width": 1,
                    "opacity": 1,
                    "curveness": 0,
                    "type": "solid"
                }
            }
        }
    ],
    "title": [
        {
            "text": "test_x_bin",
            "subtext": "COVER=1.000   AUC=0.471   KS=0.069"
        }
    ],
    "toolbox": {
        "show": true,
        "orient": "horizontal",
        "itemSize": 15,
        "itemGap": 10,
        "left": "80%",
        "feature": {
            "saveAsImage": {
                "show": true,
                "title": "save as image",
                "type": "png"
            },
            "restore": {
                "show": true,
                "title": "restore"
            },
            "dataView": {
                "show": true,
                "title": "data view",
                "readOnly": false
            },
            "dataZoom": {
                "show": true,
                "title": {
                    "zoom": "data zoom",
                    "back": "data zoom restore"
                }
            }
        }
    },
    "dataZoom": {
        "show": true,
        "type": "slider",
        "realtime": true,
        "start": 0,
        "end": 100,
        "orient": "horizontal",
        "zoomLock": false
    }
};
                chart_9666c783c95b46a1b490de96884ad600.setOption(option_9666c783c95b46a1b490de96884ad600);
        });
    </script>





```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 28 17:45:08 2018

@author: olivia_deyu
"""
import pandas as pd
import numpy as np
import xgboost as xgb
import warnings
warnings.filterwarnings('ignore')
from xgboost import XGBClassifier
from xgboost import cv, DMatrix
from sklearn import metrics
import matplotlib.pyplot as plt
from matplotlib.pylab import rcParams
from sklearn.externals import joblib


# Fit Model ------------------------------------------------------------------------------------------
def train_model(df, predictors, resp, params, idcol, useTrainCV = True, trvalsplit = 'random', trvalsplitRatio = 0.8):
    print ('Train/Val evnetRate over all: %s' %resp,  df[resp].mean())
    if trvalsplit == 'random':
        # 随机分配 train / val
        train = df.sample(frac = trvalsplitRatio, random_state = 1)
        val = df[~df[idcol].isin(train[idcol])]
    elif trvalsplit == 'timeSeries':
        # 按时间序列分配 train /val
        train = df.sort(columns='applied_at').head(int(len(df)*trvalsplitRatio))
        val = df[~df[idcol].isin(train[idcol])]
    else:
        print ('Specify methods of train/val split !')
    print ('---------- train/val -------------')
    print ('eventRate on train: ', train[resp].mean(), '; sampleSize on train: ', train.shape, train.applied_at.min(), train.applied_at.max())
    print ('eventRate on val: ', val[resp].mean(),   '; sampleSize on val: ' , val.shape, val.applied_at.min(), val.applied_at.max())

    xgbC = XGBClassifier(**params)
    model, fts_imp = modelfit(xgbC, train, val, predictors, resp, useTrainCV = True) #

    return model, fts_imp


def modelfit(alg, dtrain, dval, predictors, resp, useTrainCV = True, cv_folds=5, early_stopping_rounds=20):
    if useTrainCV:
        xgb_param = alg.get_xgb_params()
        xgtrain = DMatrix(dtrain[predictors].values, label=dtrain[resp].values)
        cvresult = cv(xgb_param, xgtrain, num_boost_round=alg.get_params()['n_estimators'], nfold=cv_folds,
            metrics=(['auc']), early_stopping_rounds=early_stopping_rounds , verbose_eval = 100) #True, )
        alg.set_params(n_estimators=cvresult.shape[0])
        print (cvresult, cvresult.shape)

    # Fit the algorithm on the data and save the model
    alg.fit(dtrain[predictors], dtrain[resp], eval_metric='auc')
    print ('Model params: -----------')
    print (alg.n_estimators, alg.max_depth, alg.learning_rate)
    # joblib.dump(alg, '%s.pkl' %pklname)

    # Predict training set:
    dtrain_predictions = alg.predict(dtrain[predictors])
    dtrain_predprob = alg.predict_proba(dtrain[predictors])[:,1]
    # Predict validation Set:
    dval_predprob = alg.predict_proba(dval[predictors])[:,1]

    # Print Model Report:
    print ("\nModel Report")
    print ("Accuracy : %.4g" % metrics.accuracy_score(dtrain[resp].values, dtrain_predictions))
    print ("AUC Score (Train): %f" % metrics.roc_auc_score(dtrain[resp], dtrain_predprob))
    print ("AUC Score (Validation): %f" % metrics.roc_auc_score(dval[resp], dval_predprob))

    # Print Feature Importance:
    feat_imp = pd.Series(alg.get_booster().get_fscore(), predictors).order(ascending=False, na_position='last')
    # feat_imp = pd.Series(alg.booster().get_fscore(), predictors).sort(ascending=False)
    feat_imp = feat_imp[feat_imp > 0]
    print ('----------- Feature importance -------------')
    print (feat_imp)

    return alg, feat_imp


# Univariate Chart ------------------------------------------------------------------------------------------
rcParams['figure.figsize'] = 12,8
def uniVarChart(df, feature, resp, n_bins = 10, dfltValue = -99999, dftrain = False, dftest = False, drawAll = True, drawTrTe = False):
    """
    Draw Univariate-Chart for certain feature on all/train/test sample respectively

    Parameters
    ----------
    df : pd.DataFrame
        at least contains feature and resp
    feature : string, feature need to draw
    resp : string, resp column
        only contains 0/1 value
    n_bins: int, default 10
        only works with numeric data
    dfltValue : numeric, default value for this feature
    dftrain : pd.DataFrame
        at least contains feature and resp
    dftest : pd.DataFrame
        at least contains feature and resp
    drawAll : boolean
        if True then draw univariate chart on all sample
    drawTrTe : boolean
        if True then draw univariate chart on train and test samples respectively

    Returns
    -------
    fig : figure
    """
    idx = (df[feature] != dfltValue)

    if n_bins > df[feature].nunique():
        predictions, predictionsTr, predictionsTe = [], [], []
        qq, qqTr, qqTe = [], [], []

        n_bins = df[feature].nunique()
        feature_grid = sorted(df.loc[idx, feature].unique().tolist())
        for feature_val in feature_grid:
            predictions.append(df.loc[df[feature] == feature_val, resp].mean())
            qq.append(df.loc[df[feature] == feature_val, resp].count())
        if drawTrTe:
            for feature_val in feature_grid:
                predictionsTr.append(dftrain.loc[dftrain[feature] == feature_val, resp].mean())
                predictionsTe.append(dftest.loc[dftest[feature] == feature_val, resp].mean())
                qqTr.append(dftrain.loc[dftrain[feature] == feature_val, resp].count())
                qqTe.append(dftest.loc[dftest[feature] == feature_val, resp].count())
            predictionsTr = np.round(predictionsTr, 3)
            predictionsTe = np.round(predictionsTe, 3)
        else:
            pass

        fig1 = plt.figure(11)
        xindex = list(range(1, len(feature_grid)+1))
        if drawAll:
            plt.plot(xindex, predictions, 'bo-', label = '%s' %'all')
            plt.gcf().text(0.6, 0.60, 'all Data Sample: %s' %qq, fontsize=9)
        else:
            pass
        if drawTrTe:
            plt.plot(xindex, predictionsTr, 'co-', label = '%s' %'train')
            plt.plot(xindex, predictionsTe, 'mo-', label = '%s' %'test')
            plt.gcf().text(0.6, 0.55, 'Train Data Sample: %s' %qqTr, fontsize=9)
            plt.gcf().text(0.6, 0.50, 'Train Data eventR: %s' %predictionsTr, fontsize=9)
            plt.gcf().text(0.6, 0.45, 'Test Data Sample: %s' %qqTe, fontsize=9)
            plt.gcf().text(0.6, 0.40, 'Test Data eventR: %s' %predictionsTe, fontsize=9)
        else:
            pass
        plt.axhline(y=df[resp].mean(), color='k', linestyle='-.', label = 'eventR_all')
        plt.axhline(y=df.loc[df[feature] == dfltValue, resp].mean(), color='r', linestyle='--', label = 'dflVal_eventR')
        plt.gcf().text(0.6, 0.7,  'Categorical value:', fontsize=9)
        plt.gcf().text(0.6, 0.65, 'feature grid: %s' %[str(int(x)) for x in feature_grid], fontsize=9)
        plt.subplots_adjust(right=0.59)
    else:
        feature_grid = sorted(list(set(df.loc[idx, feature].describe(percentiles = [.1,.2,.3,.4,.5,.6,.7, .8,.9])[3:].values)))
        feature_grid[-1] = feature_grid[-1]+1
        df['tmp'] = 99999
        _tmp = pd.cut(df.loc[idx, feature], feature_grid, include_lowest = True)
        df.loc[idx, 'tmp'] = _tmp
        df.loc[idx, 'tmp_lbl'] = _tmp.cat.codes
        tt = df[idx].groupby(['tmp', 'tmp_lbl'])[resp].agg({'mean', 'count', 'sum'})
        tt.rename(columns={'mean':'allEvntR', 'count':'allSpl', 'sum':'allEvnt'}, inplace = True)
        if drawTrTe:
            # Train sample
            dftrain['tmp'] = 99999
            _tmp = pd.cut(dftrain.loc[idx, feature], feature_grid, include_lowest = True)
            dftrain.loc[idx, 'tmp'] = _tmp
            dftrain.loc[idx, 'tmp_lbl'] = _tmp.cat.codes
            ttr = dftrain[idx].groupby(['tmp', 'tmp_lbl'])[resp].agg({'mean', 'count', 'sum'})
            ttr.rename(columns={'mean':'trEvntR', 'count':'trSpl', 'sum':'trEvnt'}, inplace = True)
            # Test sample
            dftest['tmp'] = 99999
            _tmp = pd.cut(dftest.loc[idx, feature], feature_grid, include_lowest = True)
            dftest.loc[idx, 'tmp'] = _tmp
            dftest.loc[idx, 'tmp_lbl'] = _tmp.cat.codes
            tte = dftest[idx].groupby(['tmp', 'tmp_lbl'])[resp].agg({'mean', 'count', 'sum'})
            tte.rename(columns={'mean':'teEvntR', 'count':'teSpl', 'sum':'teEvnt'}, inplace = True)
            _aa = pd.concat([tt, ttr, tte], axis = 1)
        else:
            _aa = tt
        _aa = _aa.sortlevel(1)

        if len(feature_grid) != len(_aa['allEvntR'])+1:
            strss = '\n有的分段内没有数据！！！-----------------------------------'
        else:
            strss = '\n'
        print (strss)
        fig1 = plt.figure(11)
        xindex = list(_aa.index.get_level_values('tmp_lbl'))
        if drawAll:
            plt.plot(xindex, _aa['allEvntR'], 'bo-', label = '%s' %'all')
        else:
            pass
        if drawTrTe:
            plt.plot(xindex, _aa['trEvntR'], 'co-', label = '%s' %'train')
            plt.plot(xindex, _aa['teEvntR'], 'mo-', label = '%s' %'test')
        else:
            pass
        plt.axhline(y=df[resp].mean(), color='k', linestyle='-.', label = 'eventR_all')
        plt.axhline(y=df.loc[df[feature] == dfltValue, resp].mean(), color='r', linestyle='--', label = 'dflVal_eventR')
        plt.gcf().text(0.6, 0.7, '%s' %strss, fontsize=10)
        plt.gcf().text(0.6, 0.3, '%s' %_aa, fontsize=10)
        plt.subplots_adjust(right=0.59)
        plt.subplots_adjust(right=0.59)


    plt.title('Univariate Chart of %s' %feature)
    plt.ylabel('evnet Rate')
    plt.legend(fontsize = 10, loc = 4, framealpha = 0.5)
    plt.grid()
    plt.show()

    return fig1


# PDP_chart --------------------------------------------------------------------------------------------------
import copy
def pdpChart(model, df, var, predictors, n_bins, dfltValue, maxVal):
    """
    Draw PDP-Chart for certain feature

    Parameters
    ----------
    model : trained model
    df : pd.DataFrame
        contains all features used in model
    var : string, feature need to draw
    predictors : list of string
        all features used in model
    n_bins: int
        only works with numeric data
    dfltValue : numeric, default value for this feature
    maxVal : boolean or numeric
        designed max value for this feature

    Returns
    -------
    fig : figure
    """
    idx = (df[var] != dfltValue)

    if n_bins > df[var].nunique():
        n_bins = df[var].nunique()
        feature_grid = [dfltValue] + sorted(df.loc[idx, var].unique().tolist())
    else:
        feature_grid = range(n_bins)
        if maxVal==0:
            feature_grid = [dfltValue] + [df.loc[idx, var].min()+val*(maxVal-df.loc[idx, var].min())/n_bins for val in feature_grid]
        else:
            #feature_grid = [dfltValue] + [df.loc[idx, var].min()+val*(df.loc[idx, var].max()-df.loc[idx, var].min())/n_bins for val in feature_grid]
            try:
                feature_grid = [dfltValue] + list(pd.qcut(df.loc[idx, var], q=n_bins, retbins=True)[1])
            except Exception, e:
                e = str(e)
                start = e.find("[")
                end = e.find("]")
                edge = eval(e[start: end+1])
                if len(set(edge)) == 1:
                    return
                feature_grid = [dfltValue] + sorted(list(set(edge)))
                if var=="v5_loan_cnt":
                    feature_grid.remove(0)
    #print feature_grid
    if df.shape[0] > 10000:
        x_small = df.sample(n = 10000, random_state = 77)
    else:
        x_small = df

    predictions = []
    for feature_val in feature_grid:
        x_copy = x_small.copy()
        x_copy[var] = feature_val
        predictions.append(model.predict(xgb.DMatrix(x_copy[predictors])).mean())

    xindex = feature_grid[1:]
    #print var, xindex
    if var == "period_max_allloan":
        xindex = xindex[:-1]
        predictions = predictions[:-1]
    plt.plot(range(len(xindex)), predictions[1:], 'bo-', label = '%s' %var)
    plt.xticks(range(len(xindex)), xindex)
    plt.axhline(y=model.predict(xgb.DMatrix(x_small[predictors])).mean(), color='k', linestyle='--', label = 'scoreAvg')
    plt.axhline(y=predictions[0], color='r', linestyle='--', label = 'dfltValue')
    plt.title('pdp Chart of %s' %var)
    plt.ylabel('Score')
    plt.legend(fontsize = 10, loc = 4, framealpha = 0.5)
    plt.grid()


def pdpCharts9(model, df, collist, predictors, n_bins = 10, dfltValue = -99999, maxValRatio = 1):
    """
    Draw PDP-Chart for certain features

    Parameters
    ----------
    model : trained model
    df : pd.DataFrame
        contains all features used in model
    collist : list of string, features need to draw
    predictors : list of string
        all features used in model
    n_bins: int, default 10
        only works with numeric data
    dfltValue : numeric, default -99999
        default value for this feature,
    maxValRatio : numeric, default 1
        assign max value with x quantile

    Returns
    -------
    fig : figure with at most 9 subplots
    """
    plt.figure(figsize=(16,8))
    lenth = len(collist)
    cntPlt = int(np.ceil(lenth/9.0))
    figlist = []
    for i in list(range(1, cntPlt+1)):
        print i
        fig = plt.figure(i)
        figlist.append(fig)
        j = 1
        for col in collist[(i-1)*9:i*9]:
            plt.subplot(3, 3, j)
            pdpChart(model, df, col, predictors, n_bins, dfltValue = dfltValue, maxVal = df[col].quantile(maxValRatio))
            j+=1
        plt.tight_layout()
        plt.show()

    return figlist


# liftChart ------------------------------------------------------------------------------------------
rcParams['figure.figsize'] = 16,8
def cal_rate(df, resp, lenth):
    return pd.DataFrame.from_dict(
    {
            'cntLoan' : len(df),
            'event' : df[resp].sum(),
            #'rate'    : len(df)/lenth,
            'eventRate' : df[resp].mean()
        },
    orient = 'index').T


def show_result(df, var, resp, n_bins, pre=''):
    """
    Draw Lift-Chart and AccumLift-Chart for certain score

    Parameters
    ----------
    df : pd.DataFrame
        at least contains score and resp
    var : string, score need to draw
    resp : string, resp column
        only contain 0/1 value
    n_bins: int

    Returns
    -------
    fig : 2 figures
    """
    df['bkl_%s' %var] = pd.qcut(df[var], n_bins)
    lenth = len(df)
    r1 = df.groupby('bkl_%s' %var).apply(lambda x: cal_rate(x, resp, lenth)).reset_index(level = 1, drop = True)
    #r1['accumRate'] = r1['rate'].cumsum()
    r1['acmLoan'] = r1['cntLoan'].cumsum()
    r1['acmEvent'] = r1['event'].cumsum()
    r1['acmEventRate'] = r1['acmEvent']/r1['acmLoan']
    print (r1)

    # plot lift_chart - marginal
    plt.subplot(1, 2, 1)
    # xtickss = r1.index
    r1.index = range(1, n_bins+1)
    plt.plot(r1.index, r1['eventRate'], marker='o',
             label='sample: %d,Auc of %s %s:%.3f' %(df.shape[0],pre,var, np.round(metrics.roc_auc_score(df[resp], df[var]), 3)))# linestyle='--'
    plt.title('EventRate in %d Quantiles' %n_bins)
    plt.ylabel('eventRate')
    plt.grid(True)
#   plt.xticks(r1.index, xtickss, rotation = 70)
    plt.legend(fontsize = 13, loc = 2, framealpha = 0.5)

    # plot lift_chart - accumulative
    plt.subplot(1, 2, 2)
    plt.plot(r1.index, r1['acmEventRate'], marker='o',
             label='Auc of %s  %s:%.3f' %(pre, var, np.round(metrics.roc_auc_score(df[resp], df[var]), 3)))# linestyle='--'
    plt.title('Accum-EventRate in %d Quantiles' %n_bins)
    plt.ylabel('accumEventRate')
    # plt.xticks(r1.index, xtickss, rotation = 70)
    plt.grid(True)
    plt.legend(fontsize = 13, loc = 2, framealpha = 0.5)
    plt.tight_layout()


# TDR_analysis ------------------------------------------------------------------------------------------
from collections import Counter
def tdr_rule(df, predictors, score, n_bins = 10, dfltValue = -99999):
    '''
    Turn Down Rules on all sample

    Parameters
    ----------
    df : pd.DataFrame, dataframe of all sample
    predictors : list of string, names of all features
    score : string, model score
    n_bins: numeric, default 10
        defines the number of equal-width bins in the range of df[col]
    dfltValue: numeric, default -99999

    Returns
    -------
    dict_rule : dict
    eg: {'feature_name':
            {'lst': list of bin edges,
             'mean': {mean of score in each bin},
             'min': min of means in all bins}
    '''
    data = df.copy()
    dict_rule={}
    for col in predictors:
        temp_dict={}
        data.sort(columns=col,inplace=True)
        data.reset_index(drop=True,inplace=True)
        bins=pd.qcut(data.index,n_bins)

        group =data.groupby(bins)[col].agg([max]).reset_index(level=[0])
        group["max"]=group["max"].apply(lambda x: round(x,2))
        lst=sorted(list(set(group["max"])))
        if lst[0] == dfltValue:
            lst[0] = dfltValue
        else:
            lst.insert(0,dfltValue)
        temp_dict["lst"]=lst

        bins=pd.cut(data[col],lst)
        group = data.groupby(bins)[score].agg(["mean","count"]).reset_index(level=[0])
        group["mean"]=group["mean"].apply(lambda x: np.round(x,4))

        temp_dict["min"]=group["mean"].min()
        bb=group[["mean"]]
        cc=bb.to_dict()
        temp_dict["mean"]=cc["mean"]
        dict_rule[col]=temp_dict

    return dict_rule


def tdr_result(df, predictors, idcol, score, dict_rule, dfltValue, topX = 10):
    """
    list TurnDown Reason for each sample

    Parameters
    ----------
    df : pd.DataFrame,
        normally dataframe of turn-down samples
    predictors : list of string
    idcol : string,
        name of id column, eg: loan_id
    score : model score
    dict_rule : dictionary
        turn-down rules generated on all sample
    dfltValue : numeric,
        default value for these predictors
    topX : numeric, default 10
        display top x turn-down reasons for each sample

    Returns
    -------
    dict_result : dict
    eg: dict{loan_id:
                {'top5Rsns': [('loan_amt_max', 0.4663),
                            ('zhima_score', 0.3278),
                            ('delq_days_max', 0.1085),
                            ('last_repay_day', 0.0),
                            ('last_repay_itv', 0.0)],
                 'v5': 0.5167027077367229},
    """
    data = df.copy()
    #print (dict_rule)
    # 计算每一个的用户的每一个特征对score的影响
    dict_result={}
    for _,row in data.iterrows():
        temp={}
        for col in predictors:
            for k,p in zip(list(range(len(dict_rule[col]["lst"]))),dict_rule[col]["lst"]):
                if row[col] <=p :
                    if k < 1: k = 1
                    else:pass
                    temp[col]=dict_rule[col]["mean"][k-1]-dict_rule[col]["min"]
                    break
        temp=sorted(temp.items(),key = lambda x:x[1],reverse = True)
        tmp={}
        tmp[score]=row[score]
        tmp['top%dRsns'%topX]=temp[:topX]
        dict_result[row[idcol]]=tmp

    return dict_result


def tdr_analysis(df, predictors, idcol, score, dict_rule, dfltValue, topX = 10):
    """
    计算拒绝样本中排名前三的拒绝原因的 top3最常出现特征及占比
    """
    dict_result = tdr_result(df, predictors, idcol, score, dict_rule, dfltValue, topX = topX)
    # print (dict_result)
    lenth = len(dict_result)
    top1var,top2var,top3var = [], [], []
    for i in dict_result.keys():
        top1var.append(dict_result[i]['top%dRsns'%topX][0][0])
        top2var.append(dict_result[i]['top%dRsns'%topX][1][0])
        top3var.append(dict_result[i]['top%dRsns'%topX][2][0])
    top1Rsn = [(i, cnt/lenth) for (i, cnt) in Counter(top1var).most_common(3)]
    top2Rsn = [(i, cnt/lenth) for (i, cnt) in Counter(top2var).most_common(3)]
    top3Rsn = [(i, cnt/lenth) for (i, cnt) in Counter(top3var).most_common(3)]
    print ('3 most-common candidates in top1Reason (variable, frequency): -------- \n', top1Rsn)
    print ('3 most-common candidates in top2Reason (variable, frequency): -------- \n', top2Rsn)
    print ('3 most-common candidates in top3Reason (variable, frequency): -------- \n', top3Rsn)


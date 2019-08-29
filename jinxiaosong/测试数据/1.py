# -*- coding: utf-8 -*-
"""
Created on Thu Mar 29 19:19:59 2018

@author: LHL
"""
'''读入数据'''

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
class Point:  
    x =''  
    y =''  
      
    def __init__(self,x,y):  
        self.x = x #横坐标
        self.y = y #纵坐标
  
    def show(self):  
        print (self.x," ",self.y)

#求外包矩形，减少后续判断步骤忙不      
def getPolygonBounds(points):     
    length = len(points)  
    #top down left right 都是point类型  
    top = down = left = right = points[0]  
    for i in range(1,length):  
        if points[i].y > top.y:  
            top = points[i]  
        elif points[i].y < down.y:  
            down = points[i]  
        else:  
            pass  
        if points[i].x > right.x:  
            right = points[i]  
        elif points[i].x < left.x:  
            left = points[i]  
        else:  
            pass  
    point0 = Point(left.x,top.y)  
    point1 = Point(right.x,top.y)  
    point2 = Point(right.x,down.y)  
    point3 = Point(left.x,down.y)  
    polygonBounds = [point0,point1,point2,point3]  
    return polygonBounds

#poly1 = getPolygonBounds(polygonBounds) 
#print ("矩形外包是："  )
#for i in range(0,len(poly1)):  
#    poly1[i].show()

#判断点是否在外包矩形内
def isPointInRect(point,polygonBounds):  
    if point.y >= polygonBounds[3].y and\
       point.y <= polygonBounds[0].y and\
       point.x >= polygonBounds[3].x and\
       point.x <= polygonBounds[2].x:\
       return True  
    else:  
        return False 

def angle2D(point,point_begin,point_end):
    #根据向量求夹角,arccos向量的积（点乘）除以向量的模
    x1=point_begin.x-point.x
    y1=point_begin.y-point.y
    x2=point_end.x-point.x
    y2=point_end.y-point.y
    x=np.array([x1,y1])
    y=np.array([x2,y2])
    Lx=np.sqrt(x.dot(x))
    Ly=np.sqrt(y.dot(y))
    cos_angle=x.dot(y)/(Lx*Ly)
    angle=np.arccos(cos_angle)*180/np.pi
    if (x1*y2 - x2*y1)>0:
        return(angle)
    else:
        return(-angle)
 
#角度和法判断点是否在区域内，并返回坐标    
def anglejudge(point,point_begin,point_end):
    PolygonBounds=getPolygonBounds(point_begin)    
    '''判断是否在外包矩形内，在的话进一步判断，不在则记录数据index'''
    angle=0;
    if isPointInRect(point,PolygonBounds):
        '''遍历所有外包定点'''
        for j in range(0,len(point_begin)):
            if (point_begin[j].x-point.x)*(point_end[j].x-point.x)>=0 \
                and(point_begin[j].y-point.y)*(point_end[j].y-point.y)>=0 \
                and(point_begin[j].x-point.x)*(point_end[j].y-point.y)==(point_begin[j].y-point.y)*(point_end[j].x-point.x):
                #print(i,'点在外包多边形上')
                return(True)
            else:
                angle+=angle2D(point,point_begin[j],point_end[j])
                #print(angle)
        if round(angle)/360>=1 and round(angle)%360<0.001:
            #print(i,'在框选区域内')
            return(True)
        else:
            #print(i,'不在框选区域内b')
            return(False)
    else:
        #print(i,'不在框选区域内a')
        return(False)

#def anglejudge(point,point_begin,point_end):
#    PolygonBounds=getPolygonBounds(point_begin)    
#    '''判断是否在外包矩形内，在的话进一步判断，不在则记录数据index'''
#    angle=0;
#    point_in_index=[]
#    for i in range(0,len(point)):
#        '''遍历所有点'''
#        if isPointInRect(point[i],PolygonBounds):
#            '''遍历所有外包定点'''
#            for j in range(0,len(point_begin)):
#                if (point_begin[j].x-point[i].x)*(point_end[j].x-point[i].x)>=0 \
#                    and(point_begin[j].y-point[i].y)*(point_end[j].y-point[i].y)>=0 \
#                    and(point_begin[j].x-point[i].x)*(point_end[j].y-point[i].y)==(point_begin[j].y-point[i].y)*(point_end[j].x-point[i].x):
#                    #print(i,'点在外包多边形上')
#                    point_in_index.append(i)
#                else:
#                    angle+=angle2D(point[i],point_begin[j],point_end[j])
#                    #print(angle)
#                    if round(angle%360)<0.001:
#                        #print(i,'在框选区域内')
#                        point_in_index.append(i)
#                    else:
#                        print(i,'不在框选区域内b')
#        else:
#            print(i,'不在框选区域内a')    
#        print(point_in_index)
        
def on_press(event):
    pos=[event.xdata,event.ydata]
    global AllpolygonBounds
    if not pos[1] is None:
        AllpolygonBoundsx.append(event.xdata)
        AllpolygonBoundsy.append(event.ydata)
        AllpolygonBounds.append(Point(event.xdata,event.ydata))
    else:
        print('plise click again')       
    if len(AllpolygonBoundsx)==1:
        plt.scatter(event.xdata,event.ydata,s=10)
    else:
        plt.plot(AllpolygonBoundsx[-2:],AllpolygonBoundsy[-2:])
    fig.canvas.draw()



path='D:\\测试数据\\'
filename='界头庙测试数据.xls'
data=pd.read_excel('%s%s'%(path,filename))
#选取参与图像绘制的数据所在列
data.rename(columns={data.columns[2]:'实际功率',data.columns[5]:'实际风速'},inplace=True)
#设置绘图风格
plt.style.use('ggplot')
# 设置中文编码和负号的正常显示
fig = plt.figure('抠图画布')
plt.rcParams['font.sans-serif'] = 'Microsoft YaHei'
plt.rcParams['axes.unicode_minus'] = False
plt.scatter(data.loc[:,'实际风速'],data.loc[:,'实际功率'],s=1)
plt.title('实发散点图')
plt.xlabel('实际风速')
plt.ylabel('实际功率')
plt.tick_params(top = 'off', right = 'off')
#plt.scatter(polygonBounds[0])
'''实现图形框选的交互界面'''
AllpolygonBoundsx=[]
AllpolygonBoundsy=[]
AllpolygonBounds=[]      
fig.canvas.mpl_connect("button_press_event", on_press)

#角度和判别法

point_begin=AllpolygonBounds
point_end=AllpolygonBounds[1:]
point_end.append(AllpolygonBounds[0])
point_in_index=[]
for i in range(1,len(data)):
    point=Point(data.loc[i,'实际风速'],data.loc[i,'实际功率'])
    if anglejudge(point,point_begin,point_end):
        point_in_index.append(i)

data.loc[point_in_index,:]    
fig = plt.figure('扣点后数据')        
plt.scatter(data.loc[point_in_index,'实际风速'],data.loc[point_in_index,'实际功率'],s=1)
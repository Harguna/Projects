import matplotlib.pyplot as plt
#import nsepy
import pandas as pd
from nsepy import get_history
from datetime import date
import numpy as np


# algorithm on TCS and INFY stock prices between 2015-2016. (Daily Data)

tcs_data = get_history(symbol="TCS", start=date(2015,1,1), end=date(2016,1,1))
tcs_data = pd.DataFrame(tcs_data)
write = pd.ExcelWriter('E:/START/ML Projects/nsepy-master/docs/tcs_data.xlsx')
tcs_data.to_excel(write)
write.save()

infy_data = get_history(symbol="INFY", start=date(2015,1,1), end=date(2016,1,1))
infy_data = pd.DataFrame(infy_data)
write = pd.ExcelWriter('E:/START/ML Projects/nsepy-master/docs/infy_data.xlsx')
infy_data.to_excel(write)
write.save()

tcs = pd.read_excel('E:/START/ML Projects/nsepy-master/docs/tcs_data.xlsx')
tcs_close = tcs['Close']
print(tcs_close.head())

infy = pd.read_excel('E:/START/ML Projects/nsepy-master/docs/infy_data.xlsx')
infy_close = infy['Close']
print(infy_close.head())

##############################################################################################################
#Part 1

#Task 1
for i in range(4,53,12):
    rolmean = tcs_close.rolling(window=i).mean()
    plt.plot(tcs_close)
    plt.plot(rolmean)
    plt.show()
    
for i in range(4,53,12):
    rolmean = infy_close.rolling(window=i).mean()
    plt.plot(infy_close)
    plt.plot(rolmean)
    plt.show()
        

# Task 2
print(len(tcs_close), len(infy_close))
size = 10    
for i in range(len(tcs_close)-size):
    plt.plot(tcs_close[i:size+i])
    plt.show()
    
for i in range(len(infy_close)-size):
    plt.plot(infy_close[i:size+i])
    plt.show()

    
#Task 3.1  on TCS data
#vol_shock --> 0 for no shock,  1 for shock
#vol_sign --> 0 for decrease, 1 for increase
    
vol_shock = list()
vol_sign = list()
tcs_vol = tcs['Volume']

for i in range(1, len(tcs_close)):
    if(float(abs(tcs_vol[i]-tcs_vol[i-1]))/tcs_vol[i-1] > 0.1):
        vol_shock.append(1)
        if(float(tcs_vol[i]-tcs_vol[i-1])/tcs_vol[i-1] > 0):
            vol_sign.append(1)
        else:
            vol_sign.append(0)
    else:
        vol_shock.append(0)
        vol_sign.append(np.nan)

print(vol_shock)
print(vol_sign)


#Task 3.2   on TCS data
#price_shock --> 0 for no shock,  1 for shock
#price_sign --> 0 for decrease, 1 for increase

price_shock = list()
price_sign = list()

for i in range(0, len(tcs_close)-1):
    if(float(abs(tcs_close[i+1]-tcs_close[i]))/tcs_close[i] > 0.02):
        price_shock.append(1)
        if(float(tcs_close[i+1]-tcs_close[i])/tcs_close[i] > 0):
            price_sign.append(1)
        else:
            price_sign.append(0)
    else:
        price_shock.append(0)
        price_sign.append(np.nan)

print(price_shock)
print(price_sign)


#Task 3.3

#same as previous point (repeated task)
        

#Task 3.4
#pwov = price shock without volume shock  --> 1 yes, 0 no

pwov = list()
for i in range(len(tcs_close)-1):
    if price_shock[i] == 1 and vol_shock[i] == 0:
        pwov.append(1)
    else:
        pwov.append(0)
print(pwov)
        
#############################################################################################################

#Part 2  1

#2
from bokeh.plotting import figure, show
tcs_plot = figure()
r = [i for i in range(len(tcs_close))]
tcs_plot.line(r, tcs_close, line_width = 2, color = 'blue')
show(tcs_plot)

#3
#alternate vol shock lists to get indices between two volume shocks
x = 0
shocks1 = list()
shocks2 = list()
for i in range(len(vol_shock)):
    if vol_shock[i] == 1:
        x = x + 1
        if x%2 == 1:
            shocks1.append(i)
        if x%2 == 0:
            shocks2.append(i)
         
#coloring between shocks1[i]  and shocks2[i]
from bokeh.plotting import figure, show        
from bokeh.models.glyphs import Segment
glyph = Segment(x0=0, y0=tcs_close[0], x1=1, y1=tcs_close[1], line_color="#f4a582", line_width=3)          
shock_col = figure()
shock_col.line(range(0,len(tcs_close)), tcs_close, line_width = 2, color = 'blue')
shock_col.add_glyph(glyph)
show(shock_col)
      

#4
#since data is of one year, 52 week moving average = data average
from bokeh.plotting import figure, show
avg = np.mean(tcs_close)
from bokeh.models import ColumnDataSource, LinearColorMapper
from bokeh.models import ColorBar
from bokeh.transform import linear_cmap
from bokeh.palettes import Spectral6

source = ColumnDataSource(dict(x=range(len(list(tcs_close))),y=list(tcs_close)))

if abs(max(tcs_close)-avg) > abs(min(tcs_close)-avg):
    h = max(tcs_close)
else: 
    h = min(tcs_close)

gradplot = figure()
mapper = LinearColorMapper(palette= ['#084594', '#2171b5', '#4292c6', '#6baed6', '#9ecae1', '#c6dbef', '#deebf7', '#f7fbff'], low=avg, high=h)
gradplot.scatter(range(len(list(tcs_close))), list(tcs_close), color = {'field': 'y', 'transform':mapper })
color_bar = ColorBar(color_mapper=mapper['transform'], width=8,  location=(0,0))
gradplot.add_layout(color_bar, 'right')
show(gradplot)

 
#5
pwov_index = [i for i in range(len(pwov)) if pwov[i] == 1]
tcs_plot = figure()
tcs_plot.line(range(len(tcs_close)), tcs_close, line_width = 2, color = 'blue')
tcs_plot.circle(pwov_index, list(tcs_close[pwov_index]), color='red')
show(tcs_plot)


#6
from bokeh.plotting import figure, show
from statsmodels.tsa.stattools import pacf
vals = pacf(tcs_close)
pacfplot = figure()
pacfplot.scatter(range(len(vals[:10])), vals[:10], line_width = 2, color = 'blue')
show(pacfplot)


import numpy as np
# AFL_weight vs AFL : acc对比
# -*- coding: utf-8 -*-
import matplotlib.pyplot as plt

names = ['4', '5', '6', '7','8','9','10']
x = range(len(names))
# x = range(,10)
plt.rcParams['font.sans-serif'] = ['SimHei']  # 显示汉字


y_14 = [0.8412, 0.9219, 0.9398, 0.9465, 0.9528, 0.9543, 0.9578, 0.9579, 0.9634, 0.9642]  # 1RU
y_24 = [0.8369, 0.9178, 0.9311, 0.9379, 0.9475, 0.9518, 0.9558, 0.9545, 0.9612, 0.9608]  # 2RU
y_34 = [0.6397, 0.8527, 0.8952, 0.9092, 0.9276, 0.9333, 0.9424, 0.9480, 0.9501, 0.9525]  # 3RU
plt.plot(x, y_14, color='orangered', marker='o', linestyle='-', label='A1')
plt.plot(x, y_24, color='blueviolet', marker='D', linestyle='-.', label='A2')
plt.plot(x, y_34, color='green', marker='*', linestyle=':', label='A3')
plt.legend()  # 显示图例
# plt.xticks(x, names, rotation=45)
# plt.xticks(x, names)
plt.xticks(x, names)
plt.xlabel("Maximum number of vehicles")  # X轴标签
plt.ylabel("Action probability")  # Y轴标签
plt.show()






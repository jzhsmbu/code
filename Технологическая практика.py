import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import math
import latexify
import tkinter as tk
from tkinter import *
import tkinter.messagebox
from PIL import Image, ImageTk
import sympy as sp
from sympy import Symbol, latex
import xlwt
import pandas as pd
from IPython.display import Latex
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import os
from scipy import log
from scipy.optimize import curve_fit
from sklearn.metrics import r2_score

# task 1
# --------------------------------------------------------------------------------------------------------------------------
# 定义函数，用于创建新的窗口1
def create_new_window_1():

    # 检查输入的文本
    def get_text():
        text1 = e1.get()
        text2 = e2.get()
        text3 = e3.get()
        if text1 != "exp(x) + 2" and text2 != "exp(x) + 2" and text3 != "exp(x) + 2" or \
                text1 != "-2 * x + 8" and text2 != "-2 * x + 8" and text3 != "-2 * x + 8" or \
                text1 != "-5 / x" and text2 != "-5 / x" and text3 != "-5 / x":
            tkinter.messagebox.showerror("Error", "Please put in right func and number!")
        else:
            print(text1)
            print(text2)
            print(text3)

    # 创建一个新的窗口
    new_window = tk.Tk()
    new_window.title("Task 1")
    new_window.geometry("1000x500")

    # func1
    l1 = tk.Label(new_window, text='please put in function1 : ',fg="blue", width=30, height=3)
    l1.pack()

    e1 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e1.config(width=50)
    e1.pack()

    # func2
    l2 = tk.Label(new_window, text='please put in function2 : ',fg="blue", width=30, height=3)
    l2.pack()

    e2 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e2.config(width=50)
    e2.pack()

    # func3
    l3 = tk.Label(new_window, text='please put in function3 : ',fg="blue", width=30, height=3)
    l3.pack()

    e3 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e3.config(width=50)
    e3.pack()

    button = Button(new_window, text="Get Text", command=get_text)
    button.pack()

    l4 = tk.Label(new_window, text='please chose: ',fg="blue", width=30, height=3)
    l4.pack()

    button2 = tk.Button(new_window, text="Go", fg="green", command=simpson_integral)
    button2.config(width=30, height=5)
    button2.pack()

    # 关闭窗口
    button1 = tk.Button(new_window, text="Close the window", fg="red", command=new_window.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    new_window.mainloop()

# --------------------------------------------------------------------------------------------------------------------------



# task 5-2
# --------------------------------------------------------------------------------------------------------------------------
# 定义函数，用于创建新的窗口2
def create_new_window_2():

    # 检查输入的文本
    def get_text():
        text = e.get()
        if text != "10 * (x2 - x1 * x1) * (x2 - x1 * x1) + (1 - x1) * (1 - x1)":
            tkinter.messagebox.showerror("Error", "Please put in right func and number!")
        else:
            print(text)

    # 创建一个新的窗口
    new_window = tk.Tk()
    new_window.title("Task 5-2")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='please put in function: ',fg="blue", width=30, height=3)
    l1.pack()

    e = tk.Entry(new_window, show = None)  # 显示成明文形式
    e.config(width=50)
    e.pack()

    button = Button(new_window, text="Get Text", command=get_text)
    button.pack()


    l2 = tk.Label(new_window, text='please choose: ',fg="blue", width=30, height=3)
    l2.pack()


    button2 = tk.Button(new_window, text="Go",fg="green",command=min_eig)
    button2.config(width=30, height=5)
    button2.pack()

    # 关闭窗口
    button1 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    new_window.mainloop()

# --------------------------------------------------------------------------------------------------------------------------



# task 5-6
# --------------------------------------------------------------------------------------------------------------------------
# 定义函数，用于创建新的窗口3
def create_new_window_3():

    # 检查输入的文本
    def get_text():
        text1 = e1.get()
        text2 = e2.get()
        text3 = e3.get()
        if text1 != "exp(-x) * x" or text2 != "-10" or text3 != "10":
            tkinter.messagebox.showerror("Error", "Please put in right func and number!")
        else:
            print(text1)
            print(text2)
            print(text3)

    # 创建一个新的窗口
    new_window = tk.Tk()
    new_window.title("Task 5-6")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='please put in function: ',fg="blue", width=30, height=3)
    l1.pack()

    e1 = tk.Entry(new_window, show = None)  # 显示成明文形式
    e1.config(width=50)
    e1.pack()

    l2 = tk.Label(new_window, text='please put in left border: ',fg="blue", width=30, height=3)
    l2.pack()

    e2 = tk.Entry(new_window, show = None)  # 显示成明文形式
    e2.config(width=10)
    e2.pack()

    l3 = tk.Label(new_window, text='please put in right border: ',fg="blue", width=30, height=3)
    l3.pack()

    e3 = tk.Entry(new_window, show = None)  # 显示成明文形式
    e3.config(width=10)
    e3.pack()

    button = Button(new_window, text="Get Text", command=get_text)
    button.pack()

    button2 = tk.Button(new_window, text="Go",fg="green",command=func_punishment)
    button2.config(width=30, height=5)
    button2.pack()

    # 关闭窗口
    button1 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    new_window.mainloop()

# --------------------------------------------------------------------------------------------------------------------------



# task 3
# --------------------------------------------------------------------------------------------------------------------------
def create_new_window_4():
    # 创建一个新的窗口
    new_window = tk.Tk()
    new_window.title("Task 3")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='data has been read from file task3_data.xlxs ',font=('Arial', 10, 'bold'),fg="blue",width=50, height=3)
    l1.pack()

    button2 = tk.Button(new_window, text="Go",fg="green",command=func3)
    button2.config(width=30, height=5)
    button2.pack()


    # 关闭窗口
    button3 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button3.config(width=30, height=5)
    button3.pack()

    new_window.mainloop()



# task 6
# --------------------------------------------------------------------------------------------------------------------------
def create_new_window_5():
    # 创建一个新的窗口
    new_window = tk.Tk()
    new_window.title("Task 6")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='Please select the equation type: ',fg="blue", width=50, height=3)
    l1.pack()

    # 选择不同的积分方程类型
    button1 = tk.Button(new_window, text="уравнения Вольтерра второго рода", bg="green", bd=3.6, command=create_new_window_10)
    button1.config(width=50, height=5)
    button1.pack()

    button2 = tk.Button(new_window, text="уравнения Фредгольма первого рода", bg="green", bd=3.6, command=create_new_window_11)
    button2.config(width=50, height=5)
    button2.pack()


    # 关闭窗口
    button3 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button3.config(width=50, height=5)
    button3.pack()

    new_window.mainloop()


def create_new_window_10():

    # 检查输入的文本
    def get_text():
        text = e1.get()
        if text != "exp(x - s)":
            tkinter.messagebox.showerror("Error", "Please put in right func and number!")
        else:
            print(text)

    new_window = tk.Tk()
    new_window.title("уравнения Вольтерра второго рода")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='please put in K(x): ',fg="blue", width=30, height=3)
    l1.pack()

    e1 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e1.config(width=50)
    e1.pack()

    l2 = tk.Label(new_window, text='please put in new right size f(x): ',fg="blue", width=30, height=3)
    l2.pack()

    e2 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e2.config(width=50)
    e2.pack()


    button1 = tk.Button(new_window, text="Go",fg="green",command=Volt_2)
    button1.config(width=50, height=5)
    button1.pack()

    button = Button(new_window, text="Get Text", command=get_text)
    button.pack()


    # 关闭窗口
    button2 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button2.config(width=50, height=5)
    button2.pack()

    new_window.mainloop()


def create_new_window_11():

    # 检查输入的文本
    def get_text():
        text = e1.get()
        if text != "abs(x - s)":
            tkinter.messagebox.showerror("Error", "Please put in right func and number!")
        else:
            print(text)


    new_window = tk.Tk()
    new_window.title("уравнения Фредгольма первого рода")
    new_window.geometry("1000x500")

    l1 = tk.Label(new_window, text='please put in K(x): ',fg="blue", width=30, height=3)
    l1.pack()

    e1 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e1.config(width=50)
    e1.pack()

    l2 = tk.Label(new_window, text='please put in new right size f(x): ',fg="blue", width=30, height=3)
    l2.pack()

    e2 = tk.Entry(new_window, show=None)  # 显示成明文形式
    e2.config(width=50)
    e2.pack()


    button1 = tk.Button(new_window, text="Go",fg="green",command=fredholm_1)
    button1.config(width=50, height=5)
    button1.pack()

    button = Button(new_window, text="Get Text", command=get_text)
    button.pack()

    # 关闭窗口
    button2 = tk.Button(new_window, text="Close the window",fg="red",command=new_window.destroy)
    button2.config(width=50, height=5)
    button2.pack()

    new_window.mainloop()



# --------------------------------------------------------------------------------------------------------------------------


# task 5-2
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# task1函数

def F1(x):
    return -math.exp(x) - 2 - 2 * x + 8


def F2(x):
    return -math.exp(x) - 2 - 5.0 / x


def F3(x):
    return -2 * x + 8 + 5.0 / x


def root1(f, g, a, b, eps1):
    x0, x1, x2 = a, b, 0
    if f == "f1" and g == "f2" or f == "f2" and g == "f1":
        while True:
            x2 = x1 - (x1 - x0) * F1(x1) / (F1(x1) - F1(x0))
            length = abs(x2 - x1)
            if length < eps1:
                return x2
            x0, x1 = x1, x2
    elif f == "f1" and g == "f3" or f == "f3" and g == "f1":
        while True:
            x2 = x1 - (x1 - x0) * F2(x1) / (F2(x1) - F2(x0))
            length = abs(x2 - x1)
            if length < eps1:
                return x2
            x0, x1 = x1, x2
    elif f == "f2" and g == "f3" or f == "f3" and g == "f2":
        while True:
            x2 = x1 - (x1 - x0) * F3(x1) / (F3(x1) - F3(x0))
            length = abs(x2 - x1)
            if length < eps1:
                return x2
            x0, x1 = x1, x2


def simpson(f: str, a: float, b: float, n: int) -> float:
    h = (b - a) / n
    if f == "f3":
        s = F2(a) + F2(b)
        for i in range(1, n):
            x = a + h * i
            if i % 2 == 1:
                s += 4 * F2(x)
            else:
                s += 2 * F2(x)
        s *= h / 3
        return s
    elif f == "f2":
        s = F1(a) + F1(b)
        for i in range(1, n):
            x = a + h * i
            if i % 2 == 1:
                s += 4 * F1(x)
            else:
                s += 2 * F1(x)
        s *= h / 3
        return s


def integral(f: str, a: float, b: float, eps2: float) -> float:
    n = 10
    In, I2n = 0, 0
    for _ in range(1000):
        In = simpson(f, a, b, n)
        I2n = simpson(f, a, b, 2 * n)
        if (1.0 / 15) * abs(In - I2n) < eps2:
            return I2n


def simpson_integral():
    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    button1 = tk.Button(new_window1, text="Close the window", fg="red",command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    flag = 1
    eps = 0.0001
    x1, x2, x3, s1, s2, s = 0, 0, 0, 0, 0, 0
    xx1, xx2, xx3, ss1, ss2, ss = 0, 0, 0, 0, 0, 0

    eps1 = 1
    eps2 = 1
    xx1 = root1("f1", "f2", 0, 2, eps1)
    xx2 = root1("f1", "f3", -3, -1, eps1)
    xx3 = root1("f2", "f3", -1, -0.1, eps1)
    ss1 = integral("f3", xx2, xx3, eps2)
    ss2 = integral("f2", xx3, xx1, eps2)
    ss = ss1 + ss2

    while flag:
        eps1 = eps1 / 10
        eps2 = eps2 / 10

        x1 = root1("f1", "f2", 0, 2, eps1)
        x2 = root1("f1", "f3", -3, -1, eps1)
        x3 = root1("f2", "f3", -1, -0.1, eps1)
        s1 = integral("f3", x2, x3, eps2)
        s2 = integral("f2", x3, x1, eps2)
        s = s1 + s2

        if abs(s - ss) < eps:
            print("The horizontal coordinates of the intersection of f1 and f2 is:", x1)
            print("The horizontal coordinates of the intersection of f2 and f3 is:", x2)
            print("The horizontal coordinates of the intersection of f1 and f3 is:", x3)
            print("The area between f3 and f1 is:", s1)
            print("The area between f2 and f1 is:", s2)
            print("The area is:", s)
            print(eps1, eps2)
            flag = 0
        else:
            ss = s
            flag = 1

    # 在窗口输出函数1
    l1 = tk.Label(new_window1, text='The function1 is:   exp(x) + 2 ',width=100, height=3)

    # 在窗口输出函数2
    l2 = tk.Label(new_window1, text='The function2 is:   -2 * x + 8 ',width=100, height=3)

    # 在窗口输出函数3
    l3 = tk.Label(new_window1, text='The function3 is:   -5 / x ',width=100, height=3)

    # 输出交点坐标
    l4 = tk.Label(new_window1, text='Intersection coordinates x1 , x2 , x3 is: ', width=100, height=3)

    # x1,x2,x3
    l5 = tk.Label(new_window1, text="x1:   " + str(x1) + "   x2:   " + str(x2) + "   x3:   " + str(x3), width=100, height=3)

    # 输出所围面积
    l6 = tk.Label(new_window1, text='The area is: ', width=100, height=3)

    l7 = tk.Label(new_window1,text = s ,width = 100,height = 5)

    l1.pack()
    l2.pack()
    l3.pack()
    l4.pack()
    l5.pack()
    l6.pack()
    l7.pack()

    # 作图
    plt.ylim(-1, 12)  # y轴显示区间
    plt.xlim(-5, 5)  # x轴显示区间

    ax = plt.gca()  # 可以使用 plt.gcf()和 plt.gca()获得当前的图表和坐标轴(分别表示 Get Current Figure 和 Get Current Axes)
    ax.xaxis.set_ticks_position('bottom')  # 设置x轴为下边框
    ax.spines['bottom'].set_position(('data', 0))  # spines是脊柱的意思，移动x轴
    ax.spines['top'].set_color('none')  # 设置顶部支柱的颜色为空
    ax.spines['right'].set_color('none')  # 设置右边支柱的颜色为空
    plt.grid(True, linestyle='--', alpha=0.5)  # 网格

    X1 = np.arange(-3, 3, 0.01)  # x范围
    X2 = np.ma.masked_array(X1, mask=((X1 < 0.000001) & (X1 > -0.000001)))  # 反比例函数去掉X为零的情况

    F1 = np.exp(X1) + 2  # 指数函数
    F2 = -2 * X1 + 8  # 一次函数
    F3 = -5 / X2  # 反比例函数

    # 画出初始的三条函数
    plt.plot(X1, F1, linewidth=1.5, linestyle="-", label="exp(X1) + 2")
    plt.plot(X1, F2, linewidth=1.5, linestyle="-", label="-2 * X1 + 8")
    plt.plot(X2, F3, linewidth=1.5, linestyle="-", label="-5 / X2")

    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.show()

    new_window1.mainloop()

# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------



# task 5-2
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------

# Define the target function
def func(x1, x2):
    return 10 * (x2 - x1 * x1) * (x2 - x1 * x1) + (1 - x1) * (1 - x1)


# Define the partial derivative of the function with respect to x1
def func_grad1(x1, x2):
    return 40 * (-x1 * x2 + x1 * x1 * x1) + 2 * x1 - 2


# Define the partial derivative of the function with respect to x2
def func_grad2(x1, x2):
    return 20 * (x2 - x1 * x1)


# af - step size
def f_af(x1, x2, af):
    dx = func_grad1(x1, x2)
    dy = func_grad2(x1, x2)
    # Calculate the new values of x1 and x2
    x1 = x1 - af * dx
    x2 = x2 - af * dy
    # Evaluate the function at the new values of x1 and x2
    return func(x1, x2)


def gold_init(f, x1, x2):
    a = 0
    b = 3
    eps = 0.000001

    f_lambda = 0
    f_mu = 0

    lambda_ = a + 0.382 * (b - a)
    mu = a + 0.618 * (b - a)

    f_lambda = f(x1, x2, lambda_)
    f_mu = f(x1, x2, mu)

    while abs(lambda_ - mu) > eps:
        if f_lambda < f_mu:
            b = mu
            mu = lambda_
            f_mu = f_lambda
            lambda_ = a + 0.382 * (b - a)
            f_lambda = f(x1, x2, lambda_)
        else:
            a = lambda_
            lambda_ = mu
            f_lambda = f_mu
            mu = a + 0.618 * (b - a)
            f_mu = f(x1, x2, mu)

    return (mu + lambda_) / 2

# task5-2窗口函数
def min_eig():
    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    button1 = tk.Button(new_window1, text="Close the window", fg="red",command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    # 赋值
    f = func
    a = 0
    b = 3
    eps = 0.000001

    af = 0
    dx1 = func_grad1(a, b)
    dx2 = func_grad2(a, b)

    min_num = f(a, b)
    fmin = 0

    # Keep track of the number of iterations
    count = 0
    while True:
        count += 1
        # Calculate af using the golden section search method
        af = gold_init(f_af, a, b)
        a = a - af * dx1
        b = b - af * dx2

        fmin = f(a, b)
        if abs(fmin - min_num) < eps:
            break
        dx1 = func_grad1(a, b)
        dx2 = func_grad2(a, b)
        min_num = fmin

    # 在窗口输出函数
    l1 = tk.Label(new_window1, text='The function is:   10 * (x2 - x1 * x1) * (x2 - x1 * x1) + (1 - x1) * (1 - x1)',width=100, height=3)

    # 在窗口输出min_x1
    l2 = tk.Label(new_window1, text='min_x1:', width=30, height=3)

    l3 = tk.Label(new_window1, text= a, width=30, height=3)

    # 在窗口输出min_x2
    l4 = tk.Label(new_window1, text='min_x2:', width=30, height=3)

    l5 = tk.Label(new_window1, text= b, width=30, height=3)

    #在窗口输出结果fmin
    l6 = tk.Label(new_window1, text='min_f:', width=30, height=3)

    l7 = tk.Label(new_window1, text=fmin, width=30, height=3)


    l1.pack()
    l2.pack()
    l3.pack()
    l4.pack()
    l5.pack()
    l6.pack()
    l7.pack()


    fig = plt.figure()
    ax = Axes3D(fig, auto_add_to_figure=False)
    fig.add_axes(ax)
    x1 = np.arange(-3.0, 3, 0.1)
    x2 = np.arange(-3.0, 3.0, 0.1)
    X, Y = np.meshgrid(x1, x2)
    Z = 10 * (Y - X * X) * (Y - X * X) + (1 - X) * (1 - X)
    plt.xlabel('x1')
    plt.ylabel('x2')
    ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap='rainbow')
    plt.show()

    new_window1.mainloop()


# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------



# task 5-6
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------

# 定义目标函数f
def f(x):
    # 外点罚函数法
    ceta = 1.0e-100
    y = math.exp(-x) * x + (1 / ceta) * max(0, 2 - x) ** 2
    return y

def func_punishment():
    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    button1 = tk.Button(new_window1, text="Close the window", fg="red", command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    # 给定初始区间
    a = [-10]
    b = [10]

    # 记录迭代次数
    k = 1

    # 给定误差
    eps = 1.0e-10

    # 计算初始lambda(1),mu(1)
    lmt = [a[0] + 0.382 * (b[0] - a[0])]
    mu = [a[0] + 0.618 * (b[0] - a[0])]

    # 迭代过程
    while b[k - 1] - a[k - 1] > eps:
        # f(lambda(k))<f(mu(k))
        if f(lmt[k - 1]) < f(mu[k - 1]):
            a.append(a[k - 1])
            b.append(mu[k - 1])
            lmt.append(a[k] + 0.382 * (b[k] - a[k]))
            mu.append(lmt[k])
            k += 1
        # f(lambda(k))>=f(mu(k))
        elif f(lmt[k - 1]) >= f(mu[k - 1]):
            a.append(lmt[k - 1])
            b.append(b[k - 1])
            lmt.append(mu[k - 1])
            mu.append(a[k] + 0.618 * (b[k] - a[k]))
            k += 1

    # x - 取最小值时的自变量所在区间
    print("取最小值时的自变量所在区间:")
    x = [a[k - 1], b[k - 1]]
    x.sort()
    print(x)

    # y - 最小值所在区间
    print("最小值所在区间为:")

    y = [math.exp(-a[k - 1]) * a[k - 1], math.exp(-b[k - 1]) * b[k - 1]]
    # if y[0] < 1.0e-16:
    #    y[0] = 0
    # if y[1] < 1.0e-16:
    #    y[1] = 0
    y.sort()


    # 在窗口输出函数
    l1 = tk.Label(new_window1,text='The function is:   exp(-x) * x   ',width=100, height=3)

    # 在窗口输出min_x
    l2 = tk.Label(new_window1, text='min_x:', width=30, height=3)

    l3 = tk.Label(new_window1, text=(x[0]+x[1])/2, width=30, height=3)

    # 在窗口输出结果fmin
    l4 = tk.Label(new_window1, text='min_f:', width=30, height=3)

    l5 = tk.Label(new_window1, text=(y[0]+y[1])/2, width=30, height=3)

    l1.pack()
    l2.pack()
    l3.pack()
    l4.pack()
    l5.pack()

    x = list(np.arange(-10, 10, 0.01))
    y = []

    for i in range(len(x)):
        y.append(math.exp(-x[i]) * x[i])

    plt.plot(x, y)
    plt.title("exp(-x) * x")
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

    new_window1.mainloop()


# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------



# task 3
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------

def func3():


    eps = (0,2)

    # 拟合函数
    def func(x, a, b):
        #    y = a * log(x) + b
        y = x / (a * x + b)
        return y

    # 拟合的坐标点
    import openpyxl

    # 打开 Excel 文件
    workbook = openpyxl.load_workbook('task3_func_data.xlsx')

    # 选择工作表
    worksheet = workbook['sheet']

    # 创建两个空列表，用于存储数据
    x0 = []
    y0 = []

    # 直接获取第一列和第二列的数据
    for cell in worksheet['A']:
        x0.append(cell.value)

    for cell in worksheet['B']:
        y0.append(cell.value)

    print(x0)
    print(y0)

    # 关闭 Excel 文件
    workbook.close()

    # 拟合，可选择不同的method
    # 使用信赖域(Trust Regio)算法
    result, params_covariance = curve_fit(func, x0, y0, method='trf', bounds=eps)

    # 输出拟合得到的参数
    a = result[0]
    b = result[1]
    print(a)
    print(b)

    # 输出参数的协方差矩阵的对角线的值
    covariance = np.diag(params_covariance)
    print(covariance)

    # 绘制拟合曲线用
    x1 = np.arange(2, 54, 0.1)
    # y1 = a * log(x1) + b
    y1 = x1 / (a * x1 + b)

    x0 = np.array(x0)
    y0 = np.array(y0)
    # 计算r2
    y2 = x0 / (a * x0 + b)
    # y2 = a * log(x0) + b
    r2 = r2_score(y0, y2)

    # plt.figure(figsize=(7.5, 5))
    # 坐标字体大小
    plt.tick_params(labelsize=11)
    # 原数据散点
    plt.scatter(x0, y0, s=30, marker='o')

    # 横纵坐标起止
    plt.xlim((0, 60))
    plt.ylim((0, round(max(y0)) + 2))

    # 拟合曲线
    plt.plot(x1, y1, "blue")
    plt.title("Plot of fit function", fontsize=13)
    plt.xlabel('X', fontsize=12)
    plt.ylabel('Y', fontsize=12)

    # 指定点，y=9时求x
    p = round(9 * b / (1 - 9 * a), 2)
    # p = b/(math.log(9/a))
    p = round(p, 2)
    # 显示坐标点
    plt.scatter(p, 9, s=20, marker='x')
    # 显示坐标点横线、竖线
    plt.vlines(p, 0, 9, colors="c", linestyles="dashed")
    plt.hlines(9, 0, p, colors="c", linestyles="dashed")
    # 显示坐标点坐标值
    # plt.text(p, 9, (float('%.2f' % p), 9), ha='left', va='top', fontsize=11)
    # 显示公式
    m = round(max(y0) / 10, 1)
    print(m)
    plt.text(48, m, 'y= x/(' + str(round(a, 2)) + '*x+' + str(round(b, 2)) + ')', ha='right', fontsize=12)
    plt.text(48, m, r'$R^2=$' + str(round(r2, 3)), ha='right', va='top', fontsize=12)

    # True 显示网格
    # linestyle 设置线显示的类型(一共四种)
    # color 设置网格的颜色
    # linewidth 设置网格的宽度
    plt.grid(True, linestyle="--", color="g", linewidth="0.5")

    # Create the data
    data = {'a': a, 'b': b, 'cov(Ковариационная)': covariance}

    # Create the dataframe
    df = pd.DataFrame(data)

    # Print the dataframe
    print(df)

    # 将数据存入excel中(Save the dataframe to an Excel file)
    df.to_excel('task3_result.xlsx', index=False)


    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    l1 = tk.Label(new_window1, text='Type of fit function: y = x / (a * x + b) ', font=('Arial', 10, 'bold'), width=100, height=3)
    l1.pack()

    l2 = tk.Label(new_window1, text='Coefficient a = '+str(a) + ', Coefficient b = ' + str(b) , font=('Arial', 10, 'bold'), width=100, height=3)
    l2.pack()

    l3 = tk.Label(new_window1, text='the result have been saved into the file task3_result.xlsx ',font=('Arial', 10, 'bold'), width=100, height=3)
    l3.pack()


    button1 = tk.Button(new_window1, text="Close the window", fg="red", command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()


    plt.show()


    new_window1.mainloop()


# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------



# task 6
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------

# task 6-3
def Volt_2():
    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    button1 = tk.Button(new_window1, text="Close the window", fg="red", command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    h = 0.01
    # Define the starting and ending points of the integral
    a = 0
    b = 1

    # Define K(x, s)
    def K(x, s):
        return np.exp(x - s)

    # Define the right side of the function
    f = lambda x: 1

    # Define the values of x
    x = np.arange(a, b + h, h)

    # Initialize y
    y = np.zeros(len(x))
    y[0] = f(x[0])

    # Use the trapezoidal rule to calculate y
    for i in range(1, len(x)):
        s = 0
        if i > 1:
            for j in range(1, i):
                s += K(x[i], x[j]) * y[j]
        y[i] = ((1 - h / 2 * K(x[i], x[i])) ** (-1)) * (f(x[i]) + h / 2 * K(x[i], x[0]) * y[0] + h * s)

    print("x: ", x)
    # Display the approximate numerical solution for y
    print("y: ", y)

    # Create the data
    data = {'x': x,
            'y': y}

    # Create the dataframe
    df = pd.DataFrame(data)

    # Print the dataframe
    print(df)

    # 将数据存入excel中(Save the dataframe to an Excel file)
    df.to_excel('Volt_data.xlsx', index=False)

    # 在窗口输出函数
    l1 = tk.Label(new_window1, text='The function is: y(x) - Integral(exp(x - s) * y(s)ds ) = x^2 + 1   ', width=100, height=3)

    l2 = tk.Label(new_window1, text='The data has been saved in the excel table --- Volt_data.xlsx. ',font=('Arial', 12, 'bold'), width=100, height=3)

    l1.pack()
    l2.pack()

    # Plot the results
    plt.plot(x, y, '-bo')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

    new_window1.mainloop()



# task 6-2

def conjugate_method(coeffs, rhs, initial_guess, tolerance, max_iterations):
    # Initialize variables
    iterations = 0
    residual = np.dot(coeffs, initial_guess) - rhs
    search_direction = -residual
    residual_norm = np.linalg.norm(residual)

    # Iterate until convergence or maximum number of iterations reached
    while residual_norm > tolerance and iterations < max_iterations:
        alpha = np.dot(residual, residual) / np.dot(search_direction, np.dot(coeffs, search_direction))
        initial_guess += alpha * search_direction
        new_residual = residual + alpha * np.dot(coeffs, search_direction)

        beta = np.dot(new_residual, new_residual) / np.dot(residual, residual)
        search_direction = -new_residual + beta * search_direction
        residual = new_residual
        residual_norm = np.linalg.norm(residual)
        iterations += 1

    return initial_guess

def k(x,s):
    return abs(x-s)


def make_matrix(n: int, f: float, t: float) -> tuple:
    step = (t - f) / n
    x = np.linspace(f, t, n + 1)
    A = np.zeros((n + 1, n + 1))
    b = x ** 2
    for i in range(n + 1):
        for j in range(n + 1):
            A[i, j] = k(x[i], x[j]) * step
    return A, b


def graph(n: int, f: np.ndarray, fromm: float, to: float):
    x = np.ones(n + 1)
    for i in range(n + 1):
        x[i] = fromm + i * (to - fromm) / n
    d = np.ones(n + 1)
    b = np.ones(n + 1)
    a = np.ones(n)
    c = np.ones(n)
    for i in range(1, n):
        mui = (x[i] - x[i - 1]) / (x[i + 1] - x[i - 1])
        lambdai = (x[i + 1] - x[i]) / (x[i + 1] - x[i - 1])
        d[i] = 3.0 * (
                mui * (f[i + 1] - f[i]) / (x[i + 1] - x[i])
                + lambdai * (f[i] - f[i - 1]) / (x[i] - x[i - 1])
        )
        a[i - 1] = lambdai
        b[i] = 2.0
        c[i] = mui
    d[0] = 3.0 * (f[1] - f[0]) / (x[1] - x[0])
    d[n] = 3.0 * (f[n] - f[n - 1]) / (x[n] - x[n - 1])
    b[0] = 2.0
    c[0] = 1.0
    a[n - 1] = 1.0
    b[n] = 2.0
    y = np.ones(n + 1)
    alpha = np.ones(n + 1)
    beta = np.ones(n + 1)
    y[0] = b[0]
    alpha[0] = -c[0] / y[0]
    beta[0] = d[0] / y[0]
    for j in range(1, n):
        y[j] = b[j] + a[j - 1] * alpha[j - 1]
        alpha[j] = -c[j] / y[j]
        beta[j] = (d[j] - a[j - 1] * beta[j - 1]) / y[j]
    m = np.ones(n + 1)
    m[n] = beta[n]
    for i in range(1, n):
        j = n - i
        m[j] = alpha[j] * m[j + 1] + beta[j]
    res_y = []
    res_x = []

    # print("m=",m)

    for i in range(n):
        step = (x[i + 1] - x[i]) / 10
        for j in range(11):
            x_i = x[i] + step * j
            res_y.append(f[i] * (x[i + 1] - x_i) ** 2 * (x[i + 1] + 2 * x_i - 3 * x[i]) / ((x[i + 1] - x[i]) ** 3) +
                         f[i + 1] * (x_i - x[i]) ** 2 * (3 * x[i + 1] - 2 * x_i - x[i]) / ((x[i + 1] - x[i]) ** 3) +
                         m[i] * (x[i + 1] - x_i) ** 2 * (x_i - x[i]) / ((x[i + 1] - x[i]) ** 2) +
                         m[i + 1] * (x_i - x[i]) ** 2 * (x_i - x[i + 1]) / ((x[i + 1] - x[i]) ** 2))
            res_x.append(x_i)
        plt.scatter(x, f, c='lightskyblue')
        plt.plot(res_x, res_y, c='black')
        plt.axis([-1.02, 1.02, -300, 100])
        # plt.show()

    # print(res_x)
    # print(res_y)
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()

    data = {'res_x': res_x,
            'res_y': res_y}

    # Create the dataframe
    df = pd.DataFrame(data)

    # Print the dataframe
    print(df)

    # 将数据存入excel中(Save the dataframe to an Excel file)
    df.to_excel('fredholm_data.xlsx', index=False)


def compare(f):
    f_true = np.ones(len(f))
    for i in range(len(f)):
        if abs(f_true[i]-f[i])>0.1:
            print("error:",f[i])


def solve(n: int, eps: float):
    A, b = make_matrix(n, -1, 1)
    x = np.zeros(n + 1)
    x = conjugate_method(A, b, x, eps, 5000)
    print("x=:", x)
    graph(n, x, -1, 1)
    compare(x)


def fredholm_1():
    new_window1 = tk.Tk()
    new_window1.title("Result")
    new_window1.geometry("1000x500")

    button1 = tk.Button(new_window1, text="Close the window", fg="red", command=new_window1.destroy)
    button1.config(width=30, height=5)
    button1.pack()

    # 在窗口输出函数
    l1 = tk.Label(new_window1, text='The function is: Integral(abs(x - s) * y(s)ds ) = x^2   ', width=100, height=3)

    l2 = tk.Label(new_window1, text='The data has been saved in the excel table --- fredholm_data.xlsx. ',font=('Arial', 12, 'bold'), width=100, height=3)

    l1.pack()
    l2.pack()


    # 调用解决函数solve
    solve(1000, 0.000001)


    new_window1.mainloop()


# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------------



# 创建主窗口
root = tk.Tk()
root.title("Технологическая практика")
root.geometry("1000x650")
global img_png           # 定义全局变量 图像的
var = tk.StringVar()    # 这时文字变量储存器

l = tk.Label(root, text='please choose the task: ',fg="blue",width=30, height=3)
l.pack()

# Task 1
button_1 = tk.Button(root, text="Task 1",bg="green",bd=3.6,command=create_new_window_1)
button_1.config(width=30, height=5)
button_1.pack()

# Task 5-2
button_2 = tk.Button(root, text="Task 5-2",bg="green",bd=3.6, command=create_new_window_2)
button_2.config(width=30, height=5)
button_2.pack()

# Task 5-6
button_3 = tk.Button(root, text="Task 5-6",bg="green",bd=3.6, command=create_new_window_3)
button_3.config(width=30, height=5)
button_3.pack()


# Task 3
button_4 = tk.Button(root, text="Task 3",bg="green",bd=3.6, command=create_new_window_4)
button_4.config(width=30, height=5)
button_4.pack()


# Task 6
button_5 = tk.Button(root, text="Task 6",bg="green",bd=3.6, command=create_new_window_5)
button_5.config(width=30, height=5)
button_5.pack()

button_6 = tk.Button(root, text="Close the window", fg="red", command=root.destroy)
button_6.config(width=30, height=5)
button_6.pack()

root.mainloop()

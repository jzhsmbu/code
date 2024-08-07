setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa4")
dat <- read.csv("TrainingData.csv")
dat <- dat[complete.cases(dat), ]

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
x <- ts(dat$Значение,start = c(2017,1),frequency = 12)
plot(x)

# 稳定性检验
library(aTSA)
adf.test(x)

# 纯随机性检验
for(k in 1:2) print(Box.test(x,lag = 6*k))

# 序列自相关图和偏自相关图
# par(mfrow = c(1,2))
acf(x,lag=36)
pacf(x,lag=36)

# AR(1)

x.fit <- arima(x,order = c(1,0,0),seasonal = list(order = c(0,0,1),period=12),method = "ML")
x.fit

x.fit1 <- arima(x,order = c(1,0,0),seasonal = list(order = c(1,0,1),period=12),method = "ML")
x.fit1


library("lmtest")
coeftest(x.fit)


# 拟合模型显著性检验
dev.new(width=7, height=7)  # 设置新窗口的宽和高，单位是英寸
ts.diag(x.fit)

# 分析模型移除后的残差
residual <- x.fit$residuals
plot(residual ,type = "l", col = "blue",lwd = 2,main = "Residuals")


Box.test(residual, lag = 16, type = "Ljung-Box", fitdf = 2)
# 残差不存在自相关性

qqnorm(residual)
qqline(residual)

par(mfrow = c(1, 2), cex = 0.9)
acf(residual,lwd = 5,lag.max = 36, col = "blue")
pacf(residual,lwd = 5,lag.max = 36, col = "blue")

shapiro.test(residual)
# W = 0.97895：这个值非常接近1，表明你的数据与正态分布的拟合度相当高。
# p-value = 0.1734：这个p值大于常用的显著性水平0.05，这意味着没有足够的证据拒绝零假设。
# 因此，可以认为在统计上没有充分证据表明数据不遵循正态分布。

library(forecast)
x.fore <- forecast(x.fit,h=12)
plot(x.fore,lty = 2)
lines(fitted(x.fit),col=4)

# Holt-Winter 三参数指数平滑法
x.fit2 <- HoltWinters(x,seasonal = "mult")
x.fit2
x.fore_holtwinter <- forecast(x.fit2,h=12)
plot(x.fore_holtwinter,lty = 2)
lines(x.fore_holtwinter$fitted ,col=4)



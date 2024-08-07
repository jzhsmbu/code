setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa6")
dat <- read.csv("TrainingData.csv")
dat <- dat[complete.cases(dat), ]

x <- ts(dat$Значение,start = c(2017,1),frequency = 12)
plot(x)

# 计算训练集的长度：总长度减去12
train_length <- length(x) - 12

# 创建训练集：从开始到除去最后12个观测值的时间点
train <- window(x, end = c((train_length) %/% frequency(x) + start(x)[1], (train_length) %% frequency(x)))

# 创建测试集：包含最后12个观测值的时间点
test <- window(x, start = c(train_length %/% frequency(x) + start(x)[1], (train_length %% frequency(x)) + 1))

# 检查分割的结果
print(train)
print(test)

# SARMA(1,0,0)(0,0,1)

p <- 1
P <- 1
library(forecast)
nnet<- nnetar(train,p=p,P = P,size = 10 )

forecast_result <- forecast(nnet,h = 12)
# plot(forecast_result)

summary(nnet)

# 绘制预测结果
plot(forecast_result, main="Forecast vs Actual", xlab="Time", ylab="Value")

# 将测试集的实际值添加到图表中
lines(test, col = "red", lwd = 2)

# 添加图例
legend("topleft", legend=c("Forecast", "Actual"), col=c("blue", "red"), lwd=2)













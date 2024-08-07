# install.packages("COVID19")
library(COVID19)


x <- covid19("China",level =1,start='2022-09-01',end = '2022-12-31')
x <- x[,2:7]
head(x)


x$date <- as.Date(x$date,"%m/%d/%y")
confirmed <- diff(x$confirmed)
# plot(x$date[-1],confirmed,type='h',main = "China.Confirmed daily",col = 'blue',lwd = 5,panel.first=grid(nx=NULL,ny = 10,lty=1))


n <-length(confirmed)
date.conf <- x$date[2:n]
rate.conf <- confirmed[2:n]/confirmed[1:(n-1)]-1
# plot(date.conf,rate.conf,type='h',main = "China. Conformed rates",col = 'blue',lwd = 5,panel.first=grid(nx=NULL,ny = 10,lty=1))
rate.conf <- as.numeric(rate.conf)

# 创建时间序列对象
rate_sequencest <- ts(rate.conf,frequency = 7)

# 绘制时间序列图
plot(rate_sequencest, type = "l", col = "blue", lwd = 2, main = "Rate of China")

# 使用加法模型进行季节分解
addseason <- decompose(rate_sequencest, type = "additive")

# 绘制季节分解图
plot(addseason)

# 绘制季节分解后的时间序列的季节性成分图
plot(addseason$figure,type = "h",main = 'Rate of China. Additive Seasonal Component',col = 'green',lwd = 10 )

# 绘制季节分解后的时间序列的残差成分图
plot(addseason$random,type = 'b',pch = 20,main = 'Rate of China. Additive Seasonal Component deleted',col = 'green',lwd = 1 )

# 使用乘法模型进行季节分解
multseason <- decompose(rate_sequencest, type = "multiplicative")
plot(multseason)

# 绘制季节分解后的时间序列的季节性成分图
plot(multseason$figure,type = "h",main = 'Rate of China. Miltiplicative Seasonal Component',col = 'green',lwd = 10 )

# 绘制季节分解后的时间序列的残差成分图
plot(multseason$random,type = 'b',pch = 20,main = 'Rate of China. Miltiplicative Seasonal Component deleted',col = 'green',lwd = 1 )


getHurstExponent <- function(timeSeries, maxLag = 20) {
  # 生成滞后值范围
  lags <- 2:maxLag
  
  # 计算滞后差分的标准差
  tau <- sapply(lags, function(lag) {
    std.dev <- sd(timeSeries[(lag+1):length(timeSeries)] - timeSeries[1:(length(timeSeries)-lag)])
    return(std.dev)
  })
  
  # 对滞后时间的对数和对应的标准差的对数进行线性回归，计算斜率
  reg <- lm(log(tau) ~ log(lags))
  
  # 返回赫斯特指数，即线性模型斜率的估计值
  return(coef(reg)[2])
}

# 定义不同的滞后值
lags <- c(7, 30, 60, 90)

# 遍历滞后值，计算并打印赫斯特指数
for (lag in lags) {
  hurstExp <- getHurstExponent(rate_sequencest, lag)
  cat(sprintf("Hurst exponent with %d lags: %.4f\n", lag, hurstExp))
}

library(tseries)

# 使用decompose函数进行季节性分解
decomposed_x <- decompose(rate_sequencest)

# 获取残差
residuals <- decomposed_x$random

# 剔除NA值，因为残差序列的开始和结束可能包含NA
residuals <- na.omit(residuals)

# 使用ADF测试检查残差的平稳性
adf_test_result <- adf.test(residuals, alternative = "stationary")

# 打印ADF测试结果
print(adf_test_result)

# 根据p-value判断残差序列是否平稳
if (adf_test_result$p.value < 0.05) {
  cat("残差序列是平稳的，p-value:", adf_test_result$p.value, "\n")
} else {
  cat("残差序列不是平稳的，p-value:", adf_test_result$p.value, "\n")
}


library(stats)
# 构建残差的自相关函数（ACF）
acf(residuals, main="ACF for Residuals")

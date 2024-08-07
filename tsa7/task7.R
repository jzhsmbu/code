setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa7")
dat <- read.csv("TrainingData.csv", header = TRUE)
dat <- dat[complete.cases(dat), ]

Dates <- as.Date(dat$Дата)
# Dates

library(xts)
Inflation_rate <- xts(dat$Значение,order.by = Dates)
plot(Inflation_rate ,type = "l", col = "blue",lwd = 2,main = "Inflation_rate China")

library(prophet)
library(dplyr)

Inflation.data <- data.frame(ds = Dates,y = Inflation_rate)
Prophet.Inflation <- prophet(Inflation.data,daily.seasonality = F,weekly.seasonality=F,n.changepoints = 10,
                         growth = 'linear',interval.width = 0.6)

future_Inflation <- make_future_dataframe(Prophet.Inflation, periods = 12,freq = 'month')
tail(future_Inflation)

Inflation.predict <- predict(Prophet.Inflation,future_Inflation)
prophet_plot_components(Prophet.Inflation, Inflation.predict)

plot(Prophet.Inflation, Inflation.predict)+ add_changepoints_to_plot(Prophet.Inflation)

# 以天为单位设置交叉验证的参数
initial <- 12 * 30  # 使用前12个月的数据，假设每月30天
period <- 12 * 30   # 每12个月开始一个新周期，假设每月30天
horizon <- 12 * 30  # 预测未来12个月，假设每月30天

# 执行交叉验证
Prophet.Inflation_cv <- cross_validation(Prophet.Inflation,
                                         initial = initial,
                                         period = period,
                                         horizon = horizon,
                                         units = "days")
head(Prophet.Inflation_cv)

performance_metrics(Prophet.Inflation_cv, metrics = "mse",
                    rolling_window = 1) %>% head()

plot_cross_validation_metric(Prophet.Inflation_cv, metric = "mse",
                             rolling_window = 0.1)

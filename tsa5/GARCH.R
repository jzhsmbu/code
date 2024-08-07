setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa5")
dat <- read.csv("TrainingData.csv")
dat <- dat[complete.cases(dat), ]

x <- ts(dat$Значение,start = c(2017,1),frequency = 12)
x.fit <- arima(x,order = c(1,0,0),seasonal = list(order = c(0,0,1),period=12),method = "ML")
x.fit

# 拟合模型显著性检验
library(aTSA)


library("lmtest")
coeftest(x.fit)

dev.new(width=7, height=7)  # 设置新窗口的宽和高，单位是英寸
# Engle-test
arch.test(x.fit)

# 一个较大的p值（例如大于0.05）表明你不能拒绝残差方差恒定的假设。
# 这意味着，根据这个测试，没有足够的证据表明残差存在异方差性


library(rugarch)

residuals <- x.fit$residuals

best_aic <- Inf
best_model <- NULL
best_order <- c(0, 0)

# 遍历GARCH阶数
for (p in 0:2) {
  for (q in 1:2) {
    # 设置GARCH模型规范
    spec <- ugarchspec(mean.model = list(armaOrder = c(0, 0)),
                       variance.model = list(model = "sGARCH", garchOrder = c(p, q)),
                       distribution.model = "norm")
    # 拟合GARCH模型
    fit <- ugarchfit(residuals,spec = spec)
    # 获取模型的AIC
    current_aic <- infocriteria(fit)[1]
    # 输出当前模型和AIC值
    cat(sprintf("GARCH(%d,%d) model AIC: %f\n", p, q, current_aic))
    
    # 更新最佳模型
    if (current_aic < best_aic) {
      best_aic <- current_aic
      best_model <- fit
      best_order <- c(p, q)
    }
  }
}

# 打印最佳模型的阶数和AIC
cat("Best GARCH model order: (", best_order[1], ",", best_order[2], ")\n", sep = "")
cat("Best AIC: ", best_aic, "\n")

best_spec <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(0, 1)),
                       mean.model = list(armaOrder = c(0, 0)), distribution.model = "norm")
best_model <- ugarchfit(spec = best_spec, data = residuals)

n.ahead <- 12  # 预测的时间间隔数
confidence.level <- 0.95  # 置信水平

# 进行预测
forecast <- ugarchforecast(best_model, n.ahead = n.ahead)

# str(forecast)


# 预测值已经正确提取
forecasted_values <- forecast@forecast$seriesFor

# 对于95%置信区间，如果直接提取不可行，我们需要检查rugarch包的文档或使用默认方法
# 通常，ugarchforecast函数返回的对象允许通过方法获取这些信息
# 例如:
lower_bounds <- forecast@forecast$seriesFor - 1.96 * forecast@forecast$sigmaFor
upper_bounds <- forecast@forecast$seriesFor + 1.96 * forecast@forecast$sigmaFor

# 创建数据框
forecast_df <- data.frame(
  Time = 1:n.ahead,
  Forecast = as.vector(forecasted_values),
  Lower = as.vector(lower_bounds),
  Upper = as.vector(upper_bounds)
)

print(forecast_df)


library(ggplot2)

# 假设原始数据长度为 n
n <- length(x)

# 创建原始数据的日期序列
original_dates <- seq(as.Date("2017-01-01"), by = "month", length.out = n)

# 创建预测数据的日期序列，紧接在原始数据之后
forecast_dates <- seq(from = max(original_dates) + 30, by = "month", length.out = n.ahead)

# 创建一个包含原始时间序列的数据框
original_data_df <- data.frame(Date = original_dates, Value = as.vector(x))

# 调整forecast_df以包含日期而不是时间点索引
forecast_df$Date <- forecast_dates

# 绘制原始数据和预测，加上图例
ggplot() +
  geom_line(data = original_data_df, aes(x = Date, y = Value, colour = "Original Data"), size = 1) +
  geom_line(data = forecast_df, aes(x = Date, y = Forecast, colour = "Forecast"), size = 1) +
  geom_ribbon(data = forecast_df, aes(x = Date, ymin = Lower, ymax = Upper, fill = "95% Confidence Interval"), alpha = 0.2) +
  labs(title = "Original Data and GARCH Forecast", x = "Date", y = "Value") +
  theme_minimal() +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_colour_manual(values = c("Original Data" = "blue", "Forecast" = "red")) +
  scale_fill_manual(values = c("95% Confidence Interval" = "red"), guide = guide_legend(override.aes = list(alpha = 1))) +
  guides(colour = guide_legend(override.aes = list(size = 2)))


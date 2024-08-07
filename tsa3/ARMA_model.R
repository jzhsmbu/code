setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa3")
dat <- read.csv("Test_variant_13.csv")

par(mfrow = c(1,2))
acf(dat)
pacf(dat)

# MA(2)

ma2 <-  arima(dat,order = c(0,0,2),method="ML")
AIC(ma2)

ma2$coef

res <- ma2$residuals
Box.test(res, lag = 6, type = "Ljung-Box", fitdf = 2)
setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa8")
dat <- read.csv("TrainingData.csv",header = TRUE)
dat <- dat[complete.cases(dat), ]
head(dat)

Dates <- as.Date(dat$Дата)



library(xts)
library(bsts)

data.xts <- as.xts(dat$Значение,order.by = Dates)
data.xts <- as.data.frame(data.xts)
col.names <- colnames(data.xts)
col.names[1]<- "y"
colnames(data.xts) <-col.names 
head(data.xts)

data.xts <- as.xts(data.xts, order.by = Dates)

ss <- AddLocalLinearTrend(list(), data.xts$y)
ss <- AddSeasonal(ss, data.xts$y, nseasons = 12)
model.no.regressors <- bsts(data.xts$y,
                            state.specification = ss,
                            niter = 1000)

summary(model.no.regressors)


plot(model.no.regressors, "components")

PlotBstsResiduals(model.no.regressors, burn = SuggestBurn(.1, model.no.regressors), style = "dynamic")

pred1 <- predict(model.no.regressors, horizon = 12)
plot(pred1, plot.original = 200)


# 设置随机数种子以确保结果可复现
set.seed(1000)

# 模拟误差项 ε_t，标准正态分布的白噪声序列
sigma_squared <- 1  # 方差
epsilon_t <- rnorm(n = length(dat$Значение), mean = 0, sd = sqrt(sigma_squared))

# 使用原始时间序列 y_t 来生成时间序列数据 z_t
y_t <- dat$Значение
z_t <- 0.5 + 1 * y_t + epsilon_t

# 将 y_t, z_t 和 epsilon_t 转换为 xts 对象，以便用于 BSTS 模型
data.xts <- as.xts(cbind(y_t, z_t, epsilon_t), order.by = Dates)
colnames(data.xts) <- c("y", "z", "epsilon")

ss <- AddLocalLinearTrend(list(), data.xts$y)
ss <- AddSeasonal(ss, data.xts$y, nseasons = 12)

# 使用bsts函数来拟合模型
model.with.regressors <- bsts(y ~ ., 
                              state.specification = ss, 
                              niter = 1000, 
                              data = data.xts,seed = 1000)

summary(model.with.regressors)
plot(model.with.regressors, "comp")
dim(model.with.regressors$state.contributions)
matplot(model.with.regressors$state.contributions[1,1,],type='l',col = 'green',main ='Trend component. The first MCMC simulation',ylab = 'trend values',lwd = 3)
plot(model.with.regressors$state.contributions[1,2,],type='l',col = 'green',main ='Seasonal component.The first MCMC simulation',lwd = 3,ylab = 'seasonal component' )
plot(model.with.regressors, "coef")

# 估计模型，expected.model.size = 1
model.size1 <- bsts(y ~ .,
                    state.specification = ss,
                    niter = 1000,
                    data = data.xts,seed = 1000)

# 估计模型，expected.model.size = 2
model.size2 <- bsts(y ~ .,
                    state.specification = ss,
                    niter = 1000,
                    expected.model.size = 2,
                    data = data.xts,seed = 123)

summary(model.size1)
summary(model.size2)

plot(model.size2, "coef")


CompareBstsModels(list("Model 1" = model.no.regressors,
                       "Model default.expected.model.size" = model.size1,
                       "Model expected model size =2" = model.size2),
                  colors = c("black","green", "blue"))




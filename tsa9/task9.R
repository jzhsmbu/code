setwd("C:\\Users\\lenovo\\Desktop\\时间序列分析\\tsa9")
dat <- read.csv("var_13.csv")

library(tfarima)

head(dat)
matplot(dat,type ='b',col=c('red','blue'),pch = 21,main = 'Gas furnace data')
legend('topright',c('Input','Output'),col=c('red','blue'),lty=1)
grid()

Y <- dat$Input - mean(dat$Input)
X <- dat$Output - mean(dat$Output)

acf(X)
pacf(X)

# MA(1)

umx <- um(X, ma = 1)
summary(umx)

umy <- fit(umx, Y)
summary(umy)

pccf(X, Y, um.x = umx, um.y = NULL, lag.max = 16)

ccf(X,Y,lag.max =16 )

pccf(X, Y, um.x = NULL, um.y = NULL, lag.max = 16)


for (p in 1:3)
{
  for (q in 1:3)
  {
    tfx <- tfest(Y, X, delay = 5, p = p, q = q, um.x = umx, um.y = umy)
    tfmy <- tfm(Y, inputs = tfx, noise = um(ar = 3))
    smr <- summary(tfmy)
    cat("p = ", p , "q = " , q)
    cat(" aic = ",smr$aic)
    cat(" bic = ",smr$bic)
    cat(" rss = ",smr$rss)
    cat('\n')
  }    
}    

tfx <- tfest(Y, X, delay = 5, p = 1, q = 3, um.x = umx, um.y = umy)
tfmy <- tfm(Y, inputs = tfx, noise = um(ma = 1))
summary(tfmy)

nY <- length(Y)
forec <- predict(tfmy, n.ahead = 10, ori = nY-5,level = 0.95 )

plot(forec, n.back = 15, ylab = expression("Y"["t"]))

forec <- predict(tfmy, n.ahead = 10,level = 0.95 )
plot(forec, n.back = 15, ylab = expression("Y"["t"]))



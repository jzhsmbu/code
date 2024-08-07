# 设置工作目录
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task3")

# 读取CSV文件
data <- read.csv("CARS.csv")

# 加载所需的库
library(dplyr)
library(ggplot2)
library(car)
# 加载R6包
library(R6)

# 读取数据
data <- read.csv("CARS.csv")
data <- na.omit(data)

# 创建一个名为MyModel的R6类
MyModel <- R6Class(
  "MyModel",
  public = list(
    train_data = NULL,
    model = NULL,
    step = 1,
    
    # fit方法，用于构建模型
    fit = function(train_data, step) {
      self$train_data <- train_data
      self$step <- step
      
      # 执行数据预处理和模型构建
      self$preprocess_data()
      self$build_model()
      
      return(self$model)
    },
    
    # 数据预处理方法(Методы предварительной обработки данных)
    preprocess_data = function() {
      # 数据准备步骤
      self$train_data <- self$train_data %>%
        select(MPG_Highway, Length, Weight, Wheelbase, Horsepower, Invoice, EngineSize, Cylinders, Origin, Type)
      
      self$train_data$Invoice <- as.numeric(gsub("[^0-9.]", "", self$train_data$Invoice))
      # Преобразование в факторы
      self$train_data$Origin <- as.factor(self$train_data$Origin)
      self$train_data$Type <- as.factor(self$train_data$Type)
    },
    
    # 模型构建方法
    build_model = function() {
      # 多元线性回归模型构建步骤
      # self$model <- lm(MPG_Highway ~ Length+Weight+Wheelbase+Horsepower+Invoice+EngineSize+Cylinders+Origin+Type, data = self$train_data)
      self$model <- lm(MPG_Highway ~ ., data = self$train_data)
    },
    
    # summary方法，执行模型评估操作
    summary = function(model) {
      cat("summary result: ")
      print(summary(model))  # 评估回归模型
      # cat("step = ", self$step, ":\n")
      
      # 获取t值和p值
      t_values <- summary(model)$coefficients[, "t value"]
      p_values <- summary(model)$coefficients[, "Pr(>|t|)"]
      
      # 去掉截距项的t值和p值(Удалите член перехвата(Intercept))
      t_values <- t_values[-1]
      p_values <- p_values[-1]
      
      # 找出最显著的变量( наиболее значимую переменные)
      most_significant_variable <- names(coef(model))[-1][which.max(abs(t_values))]
      
      # 找出最不显著的变量(наиболее не значимую переменные)
      least_significant_variable <- names(coef(model))[-1][which.min(abs(t_values))]
      
      # 计算均方误差 (MSE)
      # 计算残差平方和(сумма квадратов остатков)
      SSE <- sum(resid(model)^2)
      
      # 计算残差的自由度(Степени свободы остатков)
      df_error <- nrow(self$train_data) - length(model$coefficients)
      
      # 计算均方误差 (MSE)
      MSE <- SSE / df_error
      
      # 计算AIC
      AIC_value <- AIC(model)
      
      # 计算R^2
      r_squared = summary(model)$r.squared
      
      # 计算调整后的R^2
      adjusted_r_squared <- summary(model)$adj.r.squared
      
      # 输出结果
      cat("R^2:", r_squared, "\n")
      cat("Adjusted R^2:", adjusted_r_squared, "\n")
      cat("AIC:", AIC_value, "\n")
      # cat("SSE:", SSE, "\n")
      cat("MSE:", MSE, "\n")
      cat("Most Significant Variable:", most_significant_variable, "\n")
      cat("Least Significant Variable:", least_significant_variable, "\n")
    },
    
    # plot方法，绘制模型的图形
    plot = function(model) {
      cat("Drawing model graphics \n")
      
      # 获取模型的残差
      residuals <- resid(model)
      
      # 绘制残差与拟合值的散点图(графики зависимости остатков от прогноза)
      plot(model, which = 1)
      plot(model, which = 2)
      title("Scatter plot of residual and fitted values")
      
      # 绘制残差的直方图(гистограмму распределения остатков)
      hist(residuals, main = "histogram of residuals", xlab = "residual", ylab = "frequency", col = "lightblue")
    }
  )
)


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------
# task3.1


# 创建一个MyModel类的实例
my_model <- MyModel$new()

# 使用fit方法构建模型
trained_model <- my_model$fit(train_data = data, step = 1)
cat("模型构建完成：\n")

# 调用summary方法，输出模型摘要
my_model$summary(trained_model)

# 调用plot方法，绘制模型的图形
my_model$plot(trained_model)

# cat("In summary, based on the data provided, the model has a relatively high R^2 and Adjusted R^2, 
# a relatively low AIC and a small MSE.These are positive signs that the model fits the data relatively well.")


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------
# task3.2


# 识别和排除异常值
# 计算Cook's距离
distance_cook <- cooks.distance(trained_model)

# 找出最大的3个值对应的观测
top_outliers <- order(distance_cook, decreasing = TRUE)[1:3]

# 输出这些观测的DFBETA值
cat("Top 3 Outliers - DFBETA Values:\n")
cat(distance_cook[top_outliers], "\n")

# 将这些异常值从数据中移除
data_cleaned <- data[-top_outliers, ]
nrow(data_cleaned)

# 绘制DFBETA的图
# 绘制DFBETA值
plot(distance_cook, pch = 19, xlab = "Observation", ylab = "DFBETA", main = "Cook's Distance")

# 在图上标记最大的3个DFBETA值对应的观测
text(top_outliers, distance_cook[top_outliers], labels = top_outliers, pos = 4)

# 使用fit方法构建模型
trained_model_cleaned <- my_model$fit(train_data = data_cleaned, step = 2)

# 调用summary方法，输出模型摘要
my_model$summary(trained_model_cleaned)

# 调用plot方法，绘制模型的图形
my_model$plot(trained_model_cleaned)

# cat("After removing outliers, a decrease in R^2 indicates that the model fits the data slightly 
#    less well, a decrease in AIC indicates a better fit, and a decrease in MSE indicates that the 
#    model's predictive power has improved. It indicates that it may be a better model.")


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------
# task3.3

# 使用第二问得到的data_cleaned数据 (Using the data obtained from the second question)
data_cleaned <- data_cleaned %>%
  select(MPG_Highway, Length, Weight, Wheelbase, Horsepower, Invoice, EngineSize, Cylinders, Origin, Type)


# ------------------------------------------ Origin
# 合并Origin      категориальных переменных
# 进行成对t检验         
pairwise_t_test_origin <- pairwise.t.test(data_cleaned$MPG_Highway, data_cleaned$Origin)

# 创建一个空的列表，用于存储要合并的组              
groups_to_merge_origin <- list()

p_num <- pairwise_t_test_origin$p.value
not_significant_groups_origin <- p_num > 0.01

# 遍历列
for (m in 1:ncol(not_significant_groups_origin)) {
  # 遍历行
  for (n in 1:nrow(not_significant_groups_origin)) {
    # 检查当前元素是否不是NA并且为TRUE
    if (!is.na(not_significant_groups_origin[m, n]) && not_significant_groups_origin[m, n] == TRUE) {
      # 如果条件成立，将组名添加到合并组列表
      groups_to_merge_origin[[length(groups_to_merge_origin) + 1]] <- c(colnames(not_significant_groups_origin)[m], rownames(not_significant_groups_origin)[n])
    }
  }
}

# data_consol 储存合并后的数据
data_consol_origin <- data_cleaned

# 遍历 groups_to_merge 列表中的组名
for (group in groups_to_merge_origin) {

  # 找到当前要合并的组名
  group_names <- unique(data_consol_origin$Origin[data_consol_origin$Origin %in% group])
  data_consol_origin$Origin[data_consol_origin$Origin %in% group_names] <- paste(group_names, collapse = "-")
}


# ------------------------------------------ Type
# 合并Type
# 进行成对t检验
pairwise_t_test_type <- pairwise.t.test(data_consol_origin$MPG_Highway, data_consol_origin$Type)

# 创建一个空的列表，用于存储要合并的组
groups_to_merge_type <- list()

p_num <- pairwise_t_test_type$p.value
not_significant_groups_type <- p_num > 0.01

# 遍历列
for (m in 1:ncol(not_significant_groups_type)) {
  # 遍历行
  for (n in 1:nrow(not_significant_groups_type)) {
    # 检查当前元素是否不是NA并且为TRUE
    if (!is.na(not_significant_groups_type[m, n]) && not_significant_groups_type[m, n] == TRUE) {
      # 如果条件成立，将组名添加到合并组列表
      groups_to_merge_type[[length(groups_to_merge_type) + 1]] <- c(colnames(not_significant_groups_type)[m], rownames(not_significant_groups_type)[n])
    }
  }
}

# data_consol_all 储存合并后的数据
data_consol_type <- data_consol_origin

# 遍历 groups_to_merge 列表中的组名
for (group in groups_to_merge_type) {

  # 找到当前要合并的组名
  group_names <- unique(data_consol_type$Type[data_consol_type$Type %in% group])
  data_consol_type$Type[data_consol_type$Type %in% group_names] <- paste(group_names, collapse = "-")
}

# 得到合并所有分类变量后的数据data_consol_all(Get the data after combining all categorical variables data_consol_all)
data_consol_all <- data_consol_type


# 使用fit方法构建模型
trained_model_consol <- my_model$fit(train_data = data_consol_all, step = 3)
cat("模型构建完成：\n")

# 调用summary方法，输出模型摘要
my_model$summary(trained_model_consol)

# 调用plot方法，绘制模型的图形
my_model$plot(trained_model_consol)

pairwise_t_test_new1 <- pairwise.t.test(data_consol_all$MPG_Highway, data_consol_all$Origin)
pairwise_t_test_new2<- pairwise.t.test(data_consol_all$MPG_Highway, data_consol_all$Type)

# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------
# task3.4

library(olsrr)

# 使用第3问得到的数据data_consol_all
# 去掉非数值字符并转换为数值类型
data_consol_all$Invoice <- as.numeric(gsub("[^0-9.]", "", data_consol_all$Invoice))
data_consol_all$Origin <- as.factor(data_consol_all$Origin)
data_consol_all$Type <- as.factor(data_consol_all$Type)

# 基于AIC准则进行逐步回归(Пошаговая регрессия на основе критерия AIC)
trained_model_step <- ols_step_best_subset(lm(MPG_Highway ~ ., data = data_consol_all), metric = "AIC")

# print(names(trained_model_step))

summary(trained_model_step)

# 绘制系数轨迹图和模型质量依赖图
plot(trained_model_step)

# 找到具有最小AIC值的模型的索引
best_model_index <- which.min(trained_model_step$aic)

# 获取最佳模型的预测变量
best_model_variables <- trained_model_step$predictors[[best_model_index]]

# 变量名是一个长字符串，先用空格拆分它们
best_model_variables_vector <- strsplit(best_model_variables, " ")[[1]]

# 为每个变量添加反引号并创建公式
best_model_formula <- as.formula(
  paste("MPG_Highway ~", paste(sapply(best_model_variables_vector, 
                                      function(x) paste0("`", x, "`")), collapse = " + "))
)

# 拟合最佳模型
best_model <- lm(best_model_formula, data = data_consol_all)

# 调用summary方法，输出模型摘要
my_model$summary(best_model)

# 调用plot方法，绘制模型的图形
my_model$plot(best_model)


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------
# task3.5

library(pls)

# 使用第3问得到的数据data_consol_all
# 去掉非数值字符并转换为数值类型
data_consol_all$Invoice <- as.numeric(gsub("[^0-9.]", "", data_consol_all$Invoice))
data_consol_all$Origin <- as.factor(data_consol_all$Origin)
data_consol_all$Type <- as.factor(data_consol_all$Type)


# 确定样本大小
n <- nrow(data_consol_all)

# 初始化 AIC 值的向量
aic_values <- numeric(10)

# 对于不同的 ncomp 值，计算 PCR 模型，然后用 lm 拟合最终模型来计算 AIC
for (i in 1:10) {
  # 拟合 PCR 模型
  pcr_model <- pcr(MPG_Highway ~ ., ncomp = i, scale = TRUE, data = data_consol_all)
  
  # 提取主成分得分(оценка главной компоненты)
  scores <- pcr_model$scores[,1:i]

  # 创建一个数据框，包含主成分得分和响应变量
  pcr_data <- data.frame(scores, MPG_Highway = data_consol_all$MPG_Highway)
  
  # 拟合线性模型
  lm_model <- lm(MPG_Highway ~ ., data = pcr_data)
  
  # 计算 AIC
  aic_values[i] <- AIC(lm_model)
}

# ncomp 的值
ncomp_values <- 1:10

# 绘制 ncomp 与 AIC 的关系
plot(ncomp_values, aic_values, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Components (ncomp)", ylab = "AIC",
     main = "AIC vs Number of Components")

# 在图中标出每个AIC值的具体数值
text(ncomp_values, aic_values, labels = round(aic_values, 2), pos = 3, cex = 0.8)

# 标记最小的 AIC 值
min_aic_ncomp <- ncomp_values[which.min(aic_values)]
min_aic_value <- min(aic_values)
points(min_aic_ncomp, min_aic_value, col = "red", cex = 2, pch = 4)


# 找出最小的AIC值对应的ncomp
best_ncomp <- which.min(aic_values)

# 使用最佳的ncomp值拟合PCR模型
best_pcr_model <- pcr(MPG_Highway ~ ., ncomp = best_ncomp, scale = TRUE, data = data_consol_all)
# print(names(best_pcr_model))

# 获取PCA的载荷(нагрузки для PCA, Нагрузки указывают на веса исходных переменных в каждой главной компоненте)       (Principal Component Analysis)
pc_loadings <- loadings(best_pcr_model)

# 计算每个变量在所有主成分中的绝对载荷和(“1” 表示函数应用于行(如果是 “2” 则应用于列))
var_contributions <- apply(abs(pc_loadings), 1, sum)

# 找到贡献最大和最小的变量
most_influential_var <- names(which.max(var_contributions))
least_influential_var <- names(which.min(var_contributions))

# 输出结果
cat("Most Significant Variable:", most_influential_var, "\n")
cat("Least Significant variable:", least_influential_var, "\n")

# 残差与预测值的关系图(графики зависимости остатков от прогноза)
plot(best_pcr_model$fitted.values, best_pcr_model$residuals, xlab = "Fitted Values", ylab = "Residuals", main = "Residuals vs Fitted")
abline(h = 0, col = "red")

# 残差的分布直方图(гистограмму распределения остатков)
hist(best_pcr_model$residuals, main = "Histogram of Residuals", xlab = "Residuals", breaks = "Scott",col = "lightblue")


# lm model
# 从最佳PCR模型中提取主成分得分
best_scores <- best_pcr_model$scores[,1:best_ncomp]

# 创建一个包含最佳主成分得分和响应变量的数据框
best_pcr_data <- data.frame(best_scores, MPG_Highway = data_consol_all$MPG_Highway)

# 使用最佳得分和响应变量建立lm模型
best_lm_model_pcr <- lm(MPG_Highway ~ ., data = best_pcr_data)

# 调用summary方法，输出模型摘要
my_model$summary(best_lm_model_pcr)

# 调用plot方法，绘制模型的图形
my_model$plot(best_lm_model_pcr)



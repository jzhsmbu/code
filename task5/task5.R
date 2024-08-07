# 设置工作目录
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task5")

# 读取CSV文件
data <- read.csv("CARS.csv")
data <- na.omit(data)

data$Invoice <- as.numeric(gsub("[^0-9.]", "", data$Invoice))

# 添加新列Expensive,Cheap
data$Expensive <- data$Invoice > 35000
data$Cheap <- data$Invoice < 20000

library(dplyr)
library(MASS)
library(caret)
library(ggplot2)
library(gridExtra)
library(ROSE)
library(pROC)
library(fbroc)

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task5.1
mean(data$Horsepower)
# 添加新列Cylinders_new,Horsepower_new
data$Cylinders_new <- data$Cylinders > 5.8
data$Horsepower_new <- data$Horsepower > 215.8

# Cylinders_new和Horsepower_new分别作为主要预测因子和分层预测因子,Expensive为响应变量
print("Cylinders_new and Horsepower_new are used as the main predictor and stratified predictor respectively,Expensive is the response variable")

# 进行卡方检验
chisq_test_result <- chisq.test(data$Cylinders_new, data$Expensive)

# 查看卡方检验结果
print(chisq_test_result)

# 判断卡方检验的显著性
if (chisq_test_result$p.value < 0.05) {
  print("Significant chi-square test result: Significant association between Cylinders_new and Expensive.")
} else {
  print("The chi-square test result is not significant: there is no significant association between Cylinders_new and Expensive.")
}



# 执行Cochran-Mantel-Haenszel检验
cmh_test_result <- mantelhaen.test(data$Cylinders_new, data$Expensive, data$Horsepower_new)

# 查看CMH检验结果
print(cmh_test_result)

# 判断CMH检验的显著性
if (cmh_test_result$p.value < 0.05) {
  print("CMH test is significant: association remains after considering Horsepower_new")
} else {
  print("CMH test is not significant: after considering Horsepower_new, Expensive's dependence on the original predictor Cylinders_new is no longer significant and the association disappears.")
}


# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task5.2

train_data <- data %>%
  dplyr::select(Cheap, Origin, MPG_City, MPG_Highway, Length, Weight, Wheelbase, Horsepower, EngineSize, Cylinders)


train_data$Origin <- as.factor(train_data$Origin)
# 把Cheap的名称修改为"Yes"和"No"是因为在使用交叉验证train函数时"TRUE"和"FALSE"被认定为不合法变量名
# Change the name of Cheap to "Yes" and "No" because "TRUE" and "FALSE" are recognized as 
# illegal variable names when using the cross-validation train function.
train_data$Cheap <- factor(train_data$Cheap, levels = c(FALSE, TRUE), labels = c("No", "Yes"))

str(train_data)

# 逻辑回归模型

# 设置随机数种子,确定交叉验证（CV）过程中的数据分割的方式
# Setting the random number seed to determine the way to partition the data in the cross validation (CV) process.
set.seed(1000) 

# 交叉验证控制( classProbs = TRUE：指示模型训练时需要计算类别的概率。这对于某些类型的模型评估（如 ROC 曲线分析）是必要的)
# Cross-validation control
ctrl <- trainControl(method = "cv", number = 5, classProbs = TRUE, summaryFunction = twoClassSummary)

# 初始化记录变量
best_auc <- 0
best_model <- NULL
best_formula <- NULL
auc_scores <- c()  # 用于存储AUC值
num_predictors <- c()  # 用于存储每个模型的预测因子数量

# 获取所有可能的预测变量
all_predictors <- names(train_data)[names(train_data) != "Cheap"]

# 创建只包含截距的初始模型
initial_model <- glm(Cheap ~ 1, data = train_data, family = binomial)

# 创建一个包含所有变量的全模型
full_model <- glm(Cheap ~ ., data = train_data, family = binomial)

current_model <- initial_model
# 遍历所有可能的变量数量
for (num_vars in 1:length(all_predictors)) {
  
  # 使用step函数建立模型, direction = forward，steps = 1，k = 0.00001用于模型比较的惩罚项，较小的 k 值意味着对模型复杂度的惩罚较轻。
  current_model <- step(current_model, direction = "forward", scope = list(lower = initial_model, upper = full_model), k=0.00001, steps=1, trace = 0)
  print("---------------------------------------------------")
  print(current_model$formula)
  
  # 使用roc函数计算模型的ROC曲线和AUC值
  # current_model$y：这是模型的响应变量（dependent variable），即实际观测到的分类标签。
  # 在逻辑回归模型中，这通常是一个二元变量，表示每个样本的实际类别（例如，1代表正类，0代表负类）
  # current_model$fitted.values：这是模型的拟合值（fitted values），即模型预测的概率值。
  # 对于逻辑回归模型，这些值表示模型预测每个观测值属于正类的概率。
  # 利用模型的预测概率和实际观测到的分类标签来计算ROC曲线
  current_roc <- roc(current_model$y ~ current_model$fitted.values)
  current_auc <- current_roc$auc
  auc_scores[num_vars]<-current_auc
  
  #  检查当前模型的AUC是否是目前为止最好的，如果是，则更新最佳模型信息
  if(current_auc > best_auc)
  {
      best_auc <- current_auc
      best_model <- current_model
      best_formula <- current_model$formula
  }
  
  # 绘制当前模型的ROC曲线
  if (num_vars == 1) {
    # 如果是第一个模型，创建新的ROC曲线图
    plot(current_roc, col=num_vars)
  } else {
    # 如果不是第一个模型，将ROC曲线添加到现有图形上
    plot(current_roc, add = TRUE, col=num_vars)
  }
  
  
  # 交叉验证当前模型
  # method = "glm"：指定训练方法为广义线性模型，family = "binomial"：指定 GLM 的家族为二项式。这通常用于处理二分类问题，如逻辑回归。
  cv_model <- train(current_model$formula, data = train_data, method = "glm", family = "binomial", trControl = ctrl, metric = "ROC")
  print(cv_model)
  
  # # 检查AUC并更新最佳模型
  # current_auc <- max(cv_model$results$ROC)
  # if(current_auc > best_auc) {
  #   best_auc <- current_auc
  #   best_model <- cv_model
  #   best_formula <- current_model$formula
  # }
  
  # 记录预测因子数量
  num_predictors <- c(num_predictors, num_vars)
}

# 最佳模型结果
print(best_formula)
cat("The best auc value is: ", best_auc ,"\n")

# 绘制AUC与模型复杂度的关系图
# 红色标出的点代表AUC的最大值
# The point marked in red represents the maximum value of AUC
plot_data <- data.frame(Number_of_Predictors = num_predictors, AUC = auc_scores)

ggplot(plot_data, aes(x = Number_of_Predictors, y = AUC)) +
  geom_line() +
  geom_point(aes(color = (AUC == max(AUC)))) +  # 突出显示最大AUC的点
  geom_text(aes(label = round(AUC, 4)), vjust = -1, hjust = 1, size = 3) +  # 增加精度，标出每个点的AUC值
  scale_color_manual(values = c("black", "red")) +  # 设置颜色
  xlab("Number of Predictors") +
  ylab("AUC") +
  ggtitle("Model Complexity vs. AUC") +
  theme_minimal()  # 使用简洁主题


# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task5.3

# table(train_data$Cheap)
# 对于整个样本训练数据
# best_formula is obtained in 5.2
all_data_model <- glm(best_formula, family = "binomial", data = train_data)

# 获得模型对训练数据集的预测概率
# 对于二元逻辑回归，这些值表示模型预测每个观测值属于正类（通常为因变量的第二水平）的概率，
# Obtain the model's prediction probability for the training dataset
# type = "response" 指定预测类型。对于某些模型（如逻辑回归），这意味着预测的是响应概率而不是类别标签。
all_data_predictions <- predict(all_data_model, newdata = train_data, type = "response")

# 使用函数boot.roc建立ROC曲线
all_data_ROC <- boot.roc(all_data_predictions, train_data$Cheap == "Yes")
plot(all_data_ROC)


# 建立过采样数据(Creating oversampling data)
# 过采样数据有助于处理类别不平衡(Oversampling data helps to address category imbalances)
# 计算每个类别的样本数量
num_yes <- sum(train_data$Cheap == "Yes")
num_no <- sum(train_data$Cheap == "No")

# 确保N是原始数据集大小的两倍或者更大
N <- max(num_yes, num_no) * 2

# 进行过采样
over_sampled_data <- ovun.sample(Cheap ~ ., data = train_data, method = "over", N = N)$data
table(over_sampled_data$Cheap)

# 对于过采样数据训练数据
over_data_model <- glm(best_formula, family = "binomial", data = over_sampled_data)

# 对原始数据集进行预测
over_data_predictions_on_original <- predict(over_data_model, newdata = train_data, type = "response")

# 使用函数boot.roc上建立 ROC 曲线
over_data_ROC_on_original <- boot.roc(over_data_predictions_on_original, train_data$Cheap == "Yes")
plot(over_data_ROC_on_original)

cat("Сравнивая изображения, полученные дважды, можно заметить значительное изменение 
качества модели передискретизации.")



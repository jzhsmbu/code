# 设置工作目录
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task4")

# 读取CSV文件
data <- read.csv("CARS.csv")
data <- na.omit(data)

library(bestglm)
library(dplyr)
library(car)
library(olsrr)
library(glmnet)
library(caret)
library(plotly)
library(scatterplot3d)

# 加载R6包
library(R6)


# !!!
# В комментариях к задании 3 вы сказали, что класс R6 не рассматривался, и что класс R6 я 
# изучил в Интернете. Поскольку использование классов R6 похоже на то, как пишутся классы в C++, 
# я решил использовать именно этот класс.

# 创建一个名为MyModel的R6类
MyModel <- R6Class(
  "MyModel",
  public = list(
    train_data = NULL,
    test_data = NULL,
    predict_data = NULL,
    model = NULL,
    
    # fit方法，用于构建模型
    fit = function(train_data) {
      self$train_data <- train_data
      
      # 执行数据预处理和模型构建
      self$preprocess_data()
      self$build_model()
      
      return(self$model)
    },
    
    # 数据预处理方法(Методы предварительной обработки данных)
    preprocess_data = function() {
      # 数据准备步骤
      self$train_data <- na.omit(self$train_data)
      self$train_data <- self$train_data %>%
        select(MPG_Highway, Length, Weight, Wheelbase, Horsepower, Invoice, EngineSize, Cylinders, Origin, Type)
      
      self$train_data$Invoice <- as.numeric(gsub("[^0-9.]", "", self$train_data$Invoice))
      # Преобразование в факторы
      self$train_data$Origin <- as.factor(self$train_data$Origin)
      self$train_data$Type <- as.factor(self$train_data$Type)
      
      # 数据转换(Преобразование входных переменных)

      # 对除了MPG_Highway之外的所有数值型变量进行对数变换
      # Logarithmic transformation of all numeric variables except MPG_Highway
      numeric_columns <- sapply(self$train_data, is.numeric)  # 检测数值型列
      columns_to_log_transform <- setdiff(names(self$train_data[numeric_columns]), "MPG_Highway")
      self$train_data[columns_to_log_transform] <- lapply(self$train_data[columns_to_log_transform], log)
      
      # 对除了MPG_Highway之外的所有数值型变量进行平方根变换
      # Square root transformation for all numeric variables except MPG_Highway
      # 对于右偏分布的正数数据，平方根变换可以降低数据的偏斜程度
      columns_to_transform <- setdiff(names(self$train_data[numeric_columns]), "MPG_Highway")
      self$train_data[columns_to_transform] <- lapply(self$train_data[columns_to_transform], function(x) sqrt(x))
      
    },
    
    # 模型构建方法
    build_model = function() {
      
      # Combination of linear and stepwise regression models
      # 多元线性回归模型构建步骤
      # 在回归方程中加入多项式项(добавление полиномиальных членов в уравнение регрессии)
      local_model <- lm(MPG_Highway ~ . + I(Length^2) + I(Weight^2) +I(Length * Weight) + I(Wheelbase^2) 
                        +  I(EngineSize^2) , data = self$train_data)
      summary(local_model)
      
      # 使用逐步回归建立模型(Modeling using stepwise regression)
      self$model <- step(local_model)
  
    },
    
    # predict方法，用于对测试集进行预测
    predict = function(model, test_data){
      
      self$test_data <- test_data
      self$model <- model
      
      # 执行数据预处理和模型构建
      self$preprocess_data_predict()
      self$build_model_predict()
      
      return(self$predict_data)
      
    },
    
    # 数据预处理方法
    preprocess_data_predict = function() {
      # 数据准备步骤
      self$test_data <- na.omit(self$test_data)
      self$test_data <- self$test_data %>%
        select(MPG_Highway, Length, Weight, Wheelbase, Horsepower, Invoice, EngineSize, Cylinders, Origin, Type)
      
      self$test_data$Invoice <- as.numeric(gsub("[^0-9.]", "", self$test_data$Invoice))
      self$test_data$Origin <- as.factor(self$test_data$Origin)
      self$test_data$Type <- as.factor(self$test_data$Type)
      
      # 数据转换(Преобразование входных переменных)
      
      numeric_columns <- sapply(self$test_data, is.numeric)  # 检测数值型列
      columns_to_log_transform <- setdiff(names(self$test_data[numeric_columns]), "MPG_Highway")
      self$test_data[columns_to_log_transform] <- lapply(self$test_data[columns_to_log_transform], log)
      
      columns_to_transform <- setdiff(names(self$test_data[numeric_columns]), "MPG_Highway")
      self$test_data[columns_to_transform] <- lapply(self$test_data[columns_to_transform], function(x) sqrt(x))
      
    },
    
    # 构建预测模型
    build_model_predict = function() {
      
      self$predict_data <- predict.lm(self$model, self$test_data)
      print(self$predict_data)
      
    },
    
    plot = function(model, train_data){
      
      self$model <- model
      self$train_data <- train_data
      
      # 数据准备步骤
      self$train_data <- na.omit(self$train_data)
      self$train_data <- self$train_data %>%
        select(MPG_Highway, Length, Weight, Wheelbase, Horsepower, Invoice, EngineSize, Cylinders, Origin, Type)
      
      self$train_data$Invoice <- as.numeric(gsub("[^0-9.]", "", self$train_data$Invoice))
      self$train_data$Origin <- as.factor(self$train_data$Origin)
      self$train_data$Type <- as.factor(self$train_data$Type)
      
      coefficients <- coef(self$model)
      
      # 移除截距项(Удалите член перехвата)
      coefficients <- coefficients[-1]
      
      # 选取最重要的两个变量
      important_vars <- names(sort(abs(coefficients), decreasing = TRUE))[1:2]
      print(important_vars)
      
      # Based on the results above, it has been obtained that Wheelbase and Weight 
      # are the two most important variables
      # 生成等间距序列的简化函数，分割Weight,Wheelbase(Разделите Weight,Wheelbase на 20 равных частей.)
      generate_seq <- function(column, n = 20) {
        seq(from = min(column), to = max(column), length.out = n)
      }
      
      # 使用简化函数生成 Weight 和 Wheelbase 序列
      Weight_value <- generate_seq(self$train_data$Weight)
      Wheelbase_value <- generate_seq(self$train_data$Wheelbase)
      
      
      # 创建20x20的网格(Создайте сетку размером 20х20)
      grid_values <- expand.grid(
        Wheelbase_new = seq(min(self$train_data$Wheelbase), max(self$train_data$Wheelbase), length.out = 20),
        Weight_new = seq(min(self$train_data$Weight), max(self$train_data$Weight), length.out = 20)
      )
      
      Wheelbase_vector <- grid_values$Wheelbase_new
      Weight_vector <- grid_values$Weight_new
      # print(Wheelbase_vector)
      # print(Weight_vector)
      
      
      # 选择除了'Type', 'Origin', 'Wheelbase', 'Weight'之外的所有列
      selected_cols <- setdiff(names(self$train_data), c("Type", "Origin", "Wheelbase", "Weight"))
      
      # 计算这些列的均值(среднее значение)
      mean_values <- colMeans(self$train_data[, selected_cols], na.rm = TRUE)
      
      # 创建包含400个相同均值的向量(Создайте вектор из 400 одинаковых средств)
      mean_vectors <- lapply(mean_values, function(x) rep(x, 400))
      
      # 结果是一个列表，每个元素是一个向量，包含特定列的均值
      MPG_Highway_vector <- mean_vectors$MPG_Highway
      Length_vector <- mean_vectors$Length
      Horsepower_vector <- mean_vectors$Horsepower
      Invoice_vector <- mean_vectors$Invoice
      EngineSize_vector <- mean_vectors$EngineSize
      Cylinders_vector <- mean_vectors$Cylinders
      
      
      # 定义一个函数，根据频率为向量赋值(Присвоение значений векторам на основе частоты)
      create_rep_vector_by_freq <- function(column) {
        # 计算每个类别的频率
        freq_table <- table(column)
        
        # 将频率转换为整数，用于确定每个类别应重复的次数，round 函数用于将结果四舍五入到最接近的整数
        freq_counts <- round(freq_table / sum(freq_table) * 400)
        
        # 确保总数为400(调整第一个元素)
        freq_counts[1] <- freq_counts[1] + (400 - sum(freq_counts))
        
        # 重复每个类别，根据其频率
        rep_vector <- rep(names(freq_counts), times = freq_counts)
        
        return(rep_vector)
      }
      
      # 对 Origin 列应用上述函数
      Origin_vector <- create_rep_vector_by_freq(self$train_data$Origin)
      
      # 对 Type 列应用上述函数
      Type_vector <- create_rep_vector_by_freq(self$train_data$Type)
      
      
      # 组合所有向量成为一个新的数据框
      data_new <- data.frame(
        MPG_Highway <- MPG_Highway_vector,
        Wheelbase = Wheelbase_vector,
        Weight = Weight_vector,
        Length = Length_vector,
        Horsepower = Horsepower_vector,
        Invoice = Invoice_vector,
        EngineSize = EngineSize_vector,
        Cylinders = Cylinders_vector,
        Origin = Origin_vector,
        Type = Type_vector
      )
      
      # 将这些向量转换为因子
      data_new$Origin <- as.factor(data_new$Origin)
      data_new$Type <- as.factor(data_new$Type)
      
      # 查看新的数据框的结构
      # str(self$train_data)
      # str(data_new)
      
      # 数据转换
      numeric_columns <- sapply(data_new, is.numeric)  # 检测数值型列
      columns_to_log_transform <- setdiff(names(data_new[numeric_columns]), "MPG_Highway")
      data_new[columns_to_log_transform] <- lapply(data_new[columns_to_log_transform], log)
      
      columns_to_transform <- setdiff(names(data_new[numeric_columns]), "MPG_Highway")
      data_new[columns_to_transform] <- lapply(data_new[columns_to_transform], function(x) sqrt(x))
      
      # 预测数据
      predict_data_new <- predict.lm(self$model, data_new)
      # print(predict_data_new)
      
      predict_data_new <- matrix(predict_data_new, nrow = 20, ncol = 20)
      
      plot_3D <- plot_ly(x = ~Wheelbase_value, y = ~Weight_value, z = ~predict_data_new) %>%
        add_surface(
          colorscale = 'Viridis',  # 使用色彩映射
          opacity = 0.8            # 设置透明度
        ) %>%
        layout(
          title = list(text = 'Wheelbase and Weight vs. Prediction', font = list(size = 18, color = 'blue')),
          scene = list(
            xaxis = list(title = list(text = 'Wheelbase', font = list(color = 'red'))),
            yaxis = list(title = list(text = 'Weight', font = list(color = 'green'))),
            zaxis = list(title = list(text = 'Prediction', font = list(color = 'purple'))),
            camera = list(eye = list(x = 1.5, y = 1.5, z = 1.5))  # 调整视角
          ),
          margin = list(l = 40, r = 40, b = 40, t = 40)  # 调整边距
        )
      
      plot_3D
      
    }
    
  )
)


# Часть, посвященная преобразованию категориальных переменных, уже была написана в других заданиях.

# 对分类变量进行变换(Преобразования категориальных переменных)
# ------------------------------------------ Origin
# 合并Origin
# 进行成对t检验
pairwise_t_test_origin <- pairwise.t.test(data$MPG_Highway, data$Origin)

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
      groups_to_merge_origin[[length(groups_to_merge_origin) + 1]] <- c(colnames(not_significant_groups_origin)[n], rownames(not_significant_groups_origin)[m])
    }
  }
}

# data_consol 储存合并后的数据
data_consol_origin <- data

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
      groups_to_merge_type[[length(groups_to_merge_type) + 1]] <- c(colnames(not_significant_groups_type)[n], rownames(not_significant_groups_type)[m])
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



# 使用数据data_consol_all    
# 分割数据,创建训练集(train_data)和测试集(test_data),分割是基于随机抽样进行的。

# Задавая различные случайные семена, можно получить произвольные обучающие и тестовые данные, 
# в данном случае в качестве примера для дальнейших расчетов я взял семя с номером 123. 
# Больше результатов, полученных с использованием случайных семян, приведено в pdf-файле.

myseed <- 123
set.seed(myseed) # 设置随机数种子，以便结果可重现
indices <- sample(seq_len(nrow(data_consol_all)), size = floor(0.75 * nrow(data_consol_all)))
my_train_data <- data_consol_all[indices, ]
my_test_data <- data_consol_all[-indices, ]

    
# 创建一个MyModel类的实例
my_model <- MyModel$new()

# 使用fit方法构建模型(Constructing models using the fit method)
trained_model <- my_model$fit(train_data = my_train_data)
cat("模型构建完成：\n")
summary(trained_model)

# 使用predict方法对测试集进行预测(Predicting the test set using the predict method)
predict_data <- my_model$predict(model = trained_model,test_data = my_test_data)


# 计算预测模型的平均绝对百分比误差(MAPE)
# MAPE是评估预测模型准确性的一种方法,较低的 MAPE 值通常表示模型预测的准确性较高。
# MAPE = (1/n) * Σ(|Original – Predicted| / |Original|)
n = length(my_test_data$MPG_Highway)
mape = (1/n) * sum(abs(my_test_data$MPG_Highway - predict_data) / abs(my_test_data$MPG_Highway))

# 输出结果
cat("The seed is: ", myseed , "and the value of mape is: " , mape , "\n")

# 使用plot方法画出3D图(Drawing 3D diagrams using the plot method)
my_model$plot(model = trained_model,train_data = data_consol_all)




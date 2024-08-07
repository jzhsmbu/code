# 设置工作目录
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task6")

library(caret)
library(cluster)  # K-medoids
library(mclust)   # GMM
library(factoextra)  # Visualization
library(ggplot2)
library(gridExtra)

data("iris")

# 选择特征
iris_features <- iris[, 1:4]

# 计算每列的平均值和标准差
summary_stats <- sapply(iris_features, function(x) c(mean = mean(x), sd = sd(x)))
summary_stats

# преобразование признаков
# 在这种情况下，我们将标准化数据，因为花瓣的宽度(Petal.Width)比其他所有的测量值小得多。
# В этом случае мы стандартизируем данные, потому что ширина лепестков(Petal.Width) намного меньше, чем все остальные измерения.


# 设置预处理方法为最小-最大标准化
preProcValues <- preProcess(iris_features, method = 'range')

# 应用最小-最大标准化进行归一化
# Applying min-max normalization for normalization
iris_normalized <- predict(preProcValues, iris_features)

# ---------------------------------------------------------------------------------
# 代码中使用了3种不同方式进行聚类，它们的错误分类数量都小于20，其中使用高斯混合模型聚类得到的错误分类数量最小，只有5个。
# В коде используется 3 различных способа кластеризации, и все они дают менее 20 ошибочных 
# классификаций, причем наименьшее количество ошибочных классификаций получено при использовании 
# кластеризации по модели гауссовой смеси - всего 5.

cat("В коде используется 3 различных способа кластеризации, и все они дают менее 20 ошибочных классификаций, 
    причем наименьшее количество ошибочных классификаций получено при использовании кластеризации по модели гауссовой смеси - всего 5.")


# 层次聚类(иерархические)
hc <- hclust(dist(iris_normalized), method = "complete")
hc_clusters <- cutree(hc, k = 3)

# K-medoids 聚类(на основе строгого разбиения)
km_medoids <- pam(iris_normalized, k = 3)

# 高斯混合模型聚类(параметрические вероятностные)
gmm <- Mclust(iris_normalized, G = 3)


# 计算错误分类数量的函数
# 使用table()函数创建了一个混淆矩阵 confusion_matrix。
# 这个矩阵的行代表真实类别，列代表预测类别。每个单元格的值表示属于真实类别但被预测为某一类别的观测数量。
calculate_misclassifications <- function(true_labels, predicted_labels) {
  confusion_matrix <- table(true_labels, predicted_labels)
  return(sum(confusion_matrix) - sum(diag(confusion_matrix)))
}

# 计算每种聚类方法的错误分类数量
# Calculate the number of misclassifications for each clustering method
hc_misclass <- calculate_misclassifications(iris$Species, hc_clusters)
km_medoids_misclass <- calculate_misclassifications(iris$Species, km_medoids$cluster)
gmm_misclass <- calculate_misclassifications(iris$Species, gmm$classification)

# 打印结果
print(paste("Hierarchical clustering misclassifications:", hc_misclass))
print(paste("K-medoids clustering misclassifications:", km_medoids_misclass))
print(paste("Gaussian Mixture Model clustering misclassifications:", gmm_misclass))


# ---------------------------------------------------------------------------------
# 以下代码分别在新窗口中画出了以上三种聚类方法的成对投影图，其中不同颜色代表不同的群，圆形的点代表正确分类，三角形代表错误点。
# Следующий код рисует парные проекции каждого из трех методов кластеризации в новом окне, 
# где разные цвета представляют разные кластеры, круглые точки - правильные классификации, 
# а треугольники - неправильные.

cat("Следующий код рисует парные проекции каждого из трех методов кластеризации в новом окне, 
    где разные цвета представляют разные кластеры, круглые точки - правильные классификации, а треугольники - неправильные.")


# 创建层次聚类和实际Species标签之间的映射
hc_mapping <- as.character(factor(hc_clusters, labels = c("setosa", "versicolor", "virginica")))
iris_with_clusters_hc <- iris
iris_with_clusters_hc$PredictedSpecies <- hc_mapping

# 确定错误分类的观测值
iris_with_clusters_hc$Misclassified <- iris_with_clusters_hc$Species != iris_with_clusters_hc$PredictedSpecies

# 因为图形太大而无法直接显示，因此我打开一个新的图形设备窗口，在这个新窗口中绘制图形。
# Поскольку график слишком велик для прямого отображения, 
# я открываю новое окно графического устройства и рисую график в этом новом окне.
windows(width = 10, height = 8)
# 绘制散点图矩阵
plots_hc <- list()
for(i in 1:3) {
  for(j in (i+1):4) {
    p <- ggplot(iris_with_clusters_hc, aes_string(x = names(iris)[i], y = names(iris)[j], color = 'PredictedSpecies')) +
      geom_point(aes(shape = factor(Misclassified))) +
      theme_minimal() +
      labs(title = paste(names(iris)[c(i, j)], collapse = " vs "))
    plots_hc[[length(plots_hc) + 1]] <- p
  }
}
do.call(gridExtra::grid.arrange, c(plots_hc, ncol = 2))


# 创建K-medoids聚类和实际Species标签之间的映射
km_medoids_mapping <- as.character(factor(km_medoids$cluster, labels = c("setosa", "versicolor", "virginica")))
iris_with_clusters_km <- iris
iris_with_clusters_km$PredictedSpecies <- km_medoids_mapping

# 确定错误分类的观测值
iris_with_clusters_km$Misclassified <- iris_with_clusters_km$Species != iris_with_clusters_km$PredictedSpecies

windows(width = 10, height = 8)
# 绘制散点图矩阵
plots_km <- list()
for(i in 1:3) {
  for(j in (i+1):4) {
    p <- ggplot(iris_with_clusters_km, aes_string(x = names(iris)[i], y = names(iris)[j], color = 'PredictedSpecies')) +
      geom_point(aes(shape = factor(Misclassified))) +
      theme_minimal() +
      labs(title = paste(names(iris)[c(i, j)], collapse = " vs "))
    plots_km[[length(plots_km) + 1]] <- p
  }
}
do.call(gridExtra::grid.arrange, c(plots_km, ncol = 2))


# 创建高斯混合模型聚类和实际Species标签之间的映射
gmm_mapping <- as.character(factor(gmm$classification, labels = c("setosa", "versicolor", "virginica")))
iris_with_clusters_gmm <- iris
iris_with_clusters_gmm$PredictedSpecies <- gmm_mapping

# 确定错误分类的观测值
iris_with_clusters_gmm$Misclassified <- iris_with_clusters_gmm$Species != iris_with_clusters_gmm$PredictedSpecies

windows(width = 10, height = 8)
# 绘制散点图矩阵
plots_gmm <- list()
for(i in 1:3) {
  for(j in (i+1):4) {
    p <- ggplot(iris_with_clusters_gmm, aes_string(x = names(iris)[i], y = names(iris)[j], color = 'PredictedSpecies')) +
      geom_point(aes(shape = factor(Misclassified))) +
      theme_minimal() +
      labs(title = paste(names(iris)[c(i, j)], collapse = " vs "))
    plots_gmm[[length(plots_gmm) + 1]] <- p
  }
}
do.call(gridExtra::grid.arrange, c(plots_gmm, ncol = 2))





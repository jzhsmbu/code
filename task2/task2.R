# 设置工作目录
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task2")

library(gridExtra)

# 读取CSV文件
data <- read.csv("CARS.csv")

alpha <- 0.01

# 移除包含缺失值的行
# data <- na.omit(data)

library(ggplot2)
library('sasLM')
library(multcomp)

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.1



# 执行ANOVA测试
anova_result <- aov(MPG_City ~ Origin, data = data)

# 查看ANOVA结果
summary(anova_result)

# 分析ANOVA结果
# 获取F-statistic和p-value
f_statistic <- summary(anova_result)[[1]][["F value"]]
p_value <- summary(anova_result)[[1]][["Pr(>F)"]]

# 显示F-statistic和p-value
cat("F-statistic:", f_statistic, "\n")
cat("P-value:", p_value, "\n")

# 检查最小的p-value是否小于设定的显著性水平,na.rm = TRUE 表明在求最小值时应忽略这些NA值
min_p_value <- min(p_value, na.rm = TRUE)
if (!is.na(min_p_value) && min_p_value < alpha) {
  cat(" Different origins (Origin) have a significant effect on mileage to city (MPG_city). \n")
} else {
  cat(" Different Origin (Origin) has no significant impact on city mileage (MPG_city). \n")
}

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.2

# 创建关于Origin和MPG_City的差异图 
# 创建一个颜色向量，为每个不同的Origin分配不同的颜色
colors <- c("red", "blue", "green")

# 创建一个新的图形窗口
par(mfrow = c(1, 2))  # 将绘图分成一行两列

# 绘制箱线图并使用颜色向量来指定颜色
boxplot(data$MPG_City ~ data$Origin, col = colors)

# 添加标题
title("Old Boxplot Origin --- MPG_City")

city <- data$MPG_City
origin <- data$Origin

# 进行成对t检验
pairwise_t_test <- pairwise.t.test(city, origin)

# print(pairwise_t_test$p.value)
p_num <- pairwise_t_test$p.value
print(p_num)

# 创建一个空的列表，用于存储要合并的组
groups_to_merge <- list()

# 查找无法区分的组
not_significant_groups <- p_num > alpha

# Итерация по столбцам и строкам
# 遍历列
for (m in 1:ncol(not_significant_groups)) {
  # 遍历行
  for (n in 1:nrow(not_significant_groups)) {
    # 检查当前元素是否不是NA并且为TRUE
    if (!is.na(not_significant_groups[m, n]) && not_significant_groups[m, n] == TRUE) {
      # 如果条件成立，将组名添加到合并组列表
      groups_to_merge[[length(groups_to_merge) + 1]] <- c(colnames(not_significant_groups)[m], rownames(not_significant_groups)[n])
    }
  }
}

# 输出要合并的组
groups_to_merge

# data_consol 储存合并后的数据
data_consol <- data

for (group in groups_to_merge) {

  # 找到当前要合并的组名
  group_names <- unique(data_consol$Origin[data_consol$Origin == group])
  data_consol$Origin[data_consol$Origin %in% group_names] <- paste(group_names, collapse = "-")
}


# 创建合并后关于Origin和MPG_City的差异图 
colors <- c("red", "blue", "green")

# 绘制箱线图并使用颜色向量来指定颜色
boxplot(data_consol$MPG_City ~ data_consol$Origin, col = colors)

# 添加标题
title("New Boxplot Origin --- MPG_City")

# 恢复默认的图形参数
par(mfrow = c(1, 1))  # 恢复默认的绘图布局


# 绘制小提琴图
ggplot(data, aes(x = Origin, y = MPG_City, fill = Origin)) + geom_violin()
title("Old Violin diagram Origin --- MPG_City")


# 绘制小提琴图
ggplot(data_consol, aes(x = Origin, y = MPG_City, fill = Origin)) + geom_violin()
ggtitle("New Violin diagram Origin --- MPG_City")


# 使用grid.arrange将两个图形放在一起展示
# grid.arrange(boxplot_plot_old, boxplot_plot_new, ncol = 2)


# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.3

Diffogram(MPG_City ~ Origin,data)

# 添加标题
title(main = "Diffogram of MPG_City by Origin")

# 添加图例
legend("bottom",  # 图例的位置，"bottom" 代表图底部
       legend = c("Not Significant", "Significant"),  # 图例文本
       col = c("red", "blue"),  # 图例中线条的颜色
       lty = 1,  # 线条的类型，1 代表实线
       cex = 0.6,  # 图例文字的缩放大小
       inset = 0.05)  # 图例距离图边框的距离

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.4

# 执行多元方差分析（ANOVA）来比较Type和Origin对MPG_City的影响
anova_result_with_Type <- aov(MPG_City ~ Origin + Type, data = data)

# 查看ANOVA结果
summary(anova_result_with_Type)

# 分析ANOVA结果
# 获取F-statistic和p-value
f_statistic_with_Type <- summary(anova_result_with_Type)[[1]][["F value"]]
p_value_with_Type <- summary(anova_result_with_Type)[[1]][["Pr(>F)"]]

# 显示F-statistic和p-value
cat("F-statistic_with_Type:", f_statistic_with_Type, "\n")
cat("P-value_with_Type:", p_value_with_Type, "\n")

# 检查最小的p-value是否小于设定的显著性水平
min_p_value_with_Type <- min(p_value_with_Type, na.rm = TRUE)

if (!is.na(min_p_value_with_Type) && min_p_value_with_Type < alpha) {
  cat("Origin + Type have a significant effect on MPG_city. Afterwards compare Origin + Type with the Origin model. \n")
} else {
  cat("Origin + Type have no significant effect on MPG_city. Origin + Type can be removed from the model. \n")
}

# Comparing the two models
# 比较两个模型
# 去掉包含NA的p-value
p_value <- p_value[!is.na(p_value)]
p_value_with_Type <- p_value_with_Type[!is.na(p_value_with_Type)]

print(p_value)
print(p_value_with_Type)

if (all(p_value_with_Type < p_value)) {
  cat("Models that include Type are better than models that don't include Type. \n")
} else {
  cat("Models that did not include Type were better than those that did, and adding the Type variable did not improve the model. \n")
}

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.5

# 拟合包括Origin和Type的交互效应的模型
model_with_interaction <- aov(MPG_City ~ Origin * Type, data = data)
summary(model_with_interaction)

# 检查交互效应的系数是否显著
p_value_with_Type_multiply_Origin <- summary(model_with_interaction)[[1]][["Pr(>F)"]]
p_value_with_Type_multiply_Origin <- p_value_with_Type_multiply_Origin[!is.na(p_value_with_Type_multiply_Origin)]

if (all(p_value_with_Type_multiply_Origin < alpha)) {
  cat("Origin * Type have a significant effect on MPG_city.Afterwards compare Origin * Type with the Origin + Type model. \n")
} else {
  cat("Origin * Type have no significant effect on MPG_city. Origin * Type can be removed from the model. \n")
}

cat("Поскольку эффект взаимодействия Origin * Type оказался не значимым и не оказал влияния на модель, 
    окончательная модель была построена после удаления эффекта взаимодействия Origin * Type.")

# 建立最终模型(Building the final model)

model_final = aov(MPG_City ~ Origin + Type, data = data)
summary(model_final)

# 绘制箱线图
# 创建一个箱线图，其中 x 轴表示 Origin，y 轴表示 MPG_City，箱线按 Type 分组，
# 能够看到不同 Origin 和 Type 组合的 MPG_City 分布情况

ggplot(data, aes(x = Type, y = MPG_City, fill = Type)) +
  geom_boxplot() +
  facet_grid(. ~ Origin) +  # 使用 facet_grid 来按 Origin 分类
  labs(title = "Interaction of Origin * Type on MPG_City", x = "Type", y = "MPG_City")

# 绘制小提琴图
ggplot(data, aes(x = Type, y = MPG_City, fill = Type)) +
  geom_violin() +
  facet_grid(. ~ Origin) +  # 使用 facet_grid 来按 Origin 分类
  labs(title = "Interaction of Origin * Type on MPG_City", x = "Type", y = "MPG_City")

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.6

library(emmeans)

# 创建逻辑条件，选择符合条件的行
condition <- (data$Origin == "Asia" & data$Type == "Sedan") |
  (data$Origin == "Europe" & data$Type == "Sedan") |
  (data$Origin == "USA" & data$Type == "Truck")

# 根据逻辑条件筛选数据
filtered_data <- data[condition, ]

# 创建分组条件
group_condition <- ifelse(filtered_data$Origin %in% c("Europe", "Asia") & filtered_data$Type == "Sedan", "European + Asian Sedans", "American Trucks")

# 将分组条件添加到筛选后的数据框
filtered_data$Group <- factor(group_condition)

model_group <- aov(MPG_City ~ Group, data = filtered_data)
summary(model_group)

# 使用 emmeans 进行均值比较
emmeans_model <- emmeans(model_group, "Group")

# 查看均值比较结果
summary(emmeans_model)

# 检验均值差异
# 使用 contrast 函数来比较 emmeans_model 中各组的均值差异。参数 method = "pairwise" 指定进行成对比较，即将每一组与其他每一组进行比较。
# 参数 alternative = "two.sided" 表明进行的是双侧检验，这意味着检验的假设是两组均值不相等
contrast(emmeans_model, method = "pairwise", alternative = "two.sided")


# t-test
# 创建两个子集，一个包含 "European + Asian Sedans"，另一个包含 "American Trucks"
subset1 <- subset(filtered_data, Group == "European + Asian Sedans")
subset2 <- subset(filtered_data, Group == "American Trucks")

# 执行独立样本的 t-test
t_test_result <- t.test(subset1$MPG_City, subset2$MPG_City)

# 查看 t-test 结果
t_test_result

# 分析P-value
if (t_test_result$p.value < alpha) {
  cat("P-value is less than the level of significance and there is a significant difference.Rejection of the original hypothesis. \n")
} else {
  cat("P-value is greater than the level of significance and there is no significant difference.Agree with original hypothesis. \n")
}

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.7

library(car)

# 正态性检验（Normality Test）
# 分析结果：观察绘制的Q-Q图。如果数据点基本位于45度直线上，
# 那么可以认为目标变量在不同组内是正态分布的。

# groups <- unique(filtered_data$Group)
# for(group in groups) {
#   print(paste("Shapiro test for group:", group))
#   print(shapiro.test(filtered_data$MPG_City[filtered_data$Group == group]))
# }

# 绘制Q-Q图
qqnorm(filtered_data$MPG_City, main = "Q-Q Plot for MPG_City", col = "blue", pch = 16)
qqline(filtered_data$MPG_City, col = "red")

# 进行Shapiro-Wilk正态性检验
shapiro_test_result <- shapiro.test(filtered_data$MPG_City)

# 输出Shapiro-Wilk检验结果
print("Shapiro-Wilk Normality Test")
print(shapiro_test_result)

# 判断正态性
if (shapiro_test_result$p.value < alpha) {
  cat("The data does not conform to a normal distribution. \n")
} else {
  cat("The data conforms to a normal distribution. \n")
}


# 方差齐性检验（Homogeneity of Variance Test）
# 分析结果：观察Levene's检验结果中的p值。如果p值大于显著性水平，可以认为不同组的方差相等。
# 执行Levene's检验
levene_test <- leveneTest(MPG_City ~ Group, data = filtered_data)

# 查看检验结果
levene_test
print(levene_test$`Pr(>F)`)

min_p_value_levene <- min(levene_test$`Pr(>F)`, na.rm = TRUE)
if (!is.na(min_p_value_levene) && min_p_value_levene > alpha) {
  cat(" The null hypothesis of variance chi-square cannot be rejected. Data satisfy requirements for variance chi-squared. \n")
} else {
  cat(" Data not satisfy requirements for variance chi-squared. \n")
}

# result
cat("Целевая переменная не удовлетворяла нормальному распределению, а дисперсия хи-квадрат между группами была удовлетворена.
Таким образом, применимость модели можно удовлетворить.")

# --------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------

# task2.8

# 执行 Kruskal-Wallis 检验
kruskal_result <- kruskal.test(MPG_City ~ Group, data = filtered_data)

# 查看 Kruskal-Wallis 检验结果
kruskal_result

# 提取 p 值
p_value_kruskal <- kruskal_result$p.value

# 判断是否存在显著差异
if (p_value_kruskal < alpha) {
  cat("P-value is less than the level of significance and there is a significant difference\n")
} else {
  cat("P-value is greater than the level of significance and there is no significant difference.\n")
}


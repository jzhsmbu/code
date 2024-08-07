# 设置工作目录
# Setting up the working directory
setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task1")

# 读取CSV文件
# Reading CSV files
cars_data <- read.csv("CARS.CSV")

# task 1.1
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------

makes <- cars_data$Make
origins <- cars_data$Origin
models <- cars_data$Model
types <- cars_data$Type
invoices <- as.numeric(gsub("[\\$,]", "", cars_data$Invoice)) # 去除$和逗号，并转换为数字

# 定义一个函数，将美元转换为卢布并始终保留两位小数
convert_to_rubles <- function(usd_price) {
  ruble_price <- usd_price * 60  # 将美元转换为卢布
  formatted_ruble_price <- sprintf("%.2f", ruble_price)  # 始终保留两位小数
  return(formatted_ruble_price)
}


# 使用paste函数将制造商和原产地组合成字符串
combinations <- paste(makes, "[", origins, "]", sep = "")

# 获取唯一的组合
unique_combinations <- unique(combinations)

# 初始化一个空的结果列表
results <- list()

# 获取所有唯一的Type
unique_types <- unique(types)

# 遍历每个唯一的组合
for (combo in unique_combinations) {
  # 从原始数据中筛选出当前组合对应的数据
  subset_data <- cars_data[combinations == combo, ]
  
  # 使用table函数统计每种Type的数量
  type_counts <- table(subset_data$Type)
  
  # 创建一个空的Type数量列表，包含所有唯一的Type
  type_counts_all <- rep(0, length(unique_types))
  
  # 更新Type数量列表，将存在的Type的数量填入
  for (i in 1:length(unique_types)) {
    type <- unique_types[i]
    if (type %in% names(type_counts)) {
      type_counts_all[i] <- type_counts[[type]]
    }
  }
  
  # 将Type名称和数量组合成字符串
  type_counts_str <- paste(unique_types, "=", type_counts_all, collapse = " ")
  
  
  # 计算每种Type的最大价格
  # 使用 tapply 函数，按照每种Type对 invoices 列的数据进行分组，并计算每个组内的最大值。
  max_prices <- tapply(invoices[combinations == combo], types[combinations == combo], max)
  
  # 计算每种Type的最大价格，并使用convert_to_rubles函数转换为卢布并保留两位小数
  # 使用 sapply 函数，遍历所有唯一的Type，并执行一个函数来处理每个Type的最大价格
  max_prices_in_rubles <- sapply(unique_types, function(type) {
    if (type %in% names(max_prices)) {
      usd_price <- max_prices[[type]]
      ruble_price <- convert_to_rubles(usd_price)
      return(paste(type, "=", ruble_price, " RUB", sep = ""))
    } 
    else {
      return(paste(type, "=0 RUB", sep = ""))
    }
  })
  
  # 合并相同制造商[原产地域]的不同Type的价格放在同一行
  merged_prices_str <- paste(max_prices_in_rubles, collapse = " ")
  
  
  # 创建最终的结果字符串，包括制造商[原产地域]和Type数量信息
  final_result <- paste(combo, '\n', type_counts_str, '\n', merged_prices_str, '\n')
  
  # 添加到结果列表
  results[[combo]] <- final_result
}

# 指定要保存的文本文件路径
output_file <- "car_data_output.txt"

# 使用cat函数将结果写入文本文件
cat(unlist(results), file = output_file, sep = "\n")

# 提示文本文件已创建或更新
cat("The text file has been created or updated: ", output_file, "\n")


# task 1.2
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------

library(tidyr)
library(dplyr)

# 修改convert_to_rubles函数，返回带有"RUB"单位的字符串
convert_to_rubles_new <- function(usd_price) {
  ruble_price <- usd_price * 60  # 将美元转换为卢布
  formatted_ruble_price <- sprintf("%.2f RUB", ruble_price)  # 带有"RU"单位
  return(formatted_ruble_price)
}


# 将Invoice列转换为数值类型
cars_data$Invoice <- as.numeric(gsub("[\\$,]", "", cars_data$Invoice))

# 使用dplyr进行数据处理
result <- cars_data %>%
  group_by(Type, Origin, Make) %>%
  summarise(Max_Price = max(Invoice, na.rm = TRUE)) %>%
  group_by(Type, Origin) %>%     # 对Type和Origin进行第二次分组，并计算Max_Price的总和
  summarise(Sum_Max_Price = sum(Max_Price, na.rm = TRUE)) %>%
  spread(Origin, Sum_Max_Price, fill = 0)   # 使用spread函数将Origin列中的唯一值转换为列名


# result <- cars_data %>%
#   group_by(Type, Origin, Make) %>%
#   summarise(Min_Price = min(Invoice, na.rm = TRUE)) %>%
#   group_by(Type, Origin) %>%
#   summarise(Min_Make_Price = min(Min_Price, na.rm = TRUE)) %>%
#   spread(Origin, Min_Make_Price, fill = 0)


# 将结果中的价格用convert_to_rubles函数转换为带有"RUB"单位的字符串
for (col in colnames(result)[-1]) {             # 使用一个for循环逐列处理数据集中除第一列之外的列（价格列）
  result[, col] <- sapply(result[, col], convert_to_rubles_new)   # 每列使用sapply函数调用convert_to_rubles_new函数
}

# 将结果保存为新的CSV表格
write.csv(result, "result_car.csv", row.names = FALSE)

# 提示csv文件已创建或更新
cat("The csv file has been created or updated: ", "result_car.csv", "\n")



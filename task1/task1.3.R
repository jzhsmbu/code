setwd("C:\\Users\\lenovo\\Desktop\\数据编程和统计分析\\task1")

# S3 类：
#灵活性： S3 是较为简单的面向对象系统，相对于 S4，它更为灵活。
#方法解析： 方法解析是基于函数名称的约定，而不是严格的类和方法匹配。
#不严格的类定义： S3 类的定义相对不严格，不需要显式地定义类。
#方法定义： 方法可以轻松地添加到已存在的类中。
#示例： 在S3中，常见的类似于 lm()（线性模型）的函数就是S3类的典型代表。

#S4 类：
#严格的类定义： S4 提供了更为严格和复杂的类定义，要求明确定义类的结构。
#面向对象的方法： S4 类型的方法需要明确指定要使用的类，方法匹配更为严格。
#继承和多态性： S4 类支持继承和多态性，允许更严格地定义对象的属性和行为。
#复杂性： S4 类相对更为复杂，但也更加强大和严格。


# 定义一个函数，将美元转换为卢布并始终保留两位小数
convert_to_rubles <- function(usd_price) {
  ruble_price <- usd_price * 60  # 将美元转换为卢布
  formatted_ruble_price <- sprintf("%.2f", ruble_price)  # 始终保留两位小数
  return(formatted_ruble_price)
}

# 修改convert_to_rubles函数，返回带有"RUB"单位的字符串
convert_to_rubles_new <- function(usd_price) {
  ruble_price <- usd_price * 60  # 将美元转换为卢布
  formatted_ruble_price <- sprintf("%.2f RUB", ruble_price)  # 带有"RU"单位
  return(formatted_ruble_price)
}


# S3
#定义新的 S3 类 MyDataFrame，继承自 data.frame
setClass("MyDataFrame", contains = "data.frame")


# --------------------------------------------------------------   print
#为 MyDataFrame 类定义 print 方法
# function(x, ...) { ... }：这是定义方法的函数体。
# 其中，x表示方法的第一个参数，通常是指向对象本身的引用，...表示可能存在的其他参数。
setMethod("print", "MyDataFrame", function(x, ...) {
  makes <- x$Make
  origins <- x$Origin
  types <- x$Type
  invoices <- as.numeric(gsub("[\\$,]", "", x$Invoice))
  
  combinations <- paste(makes, "[", origins, "]", sep = "")
  unique_combinations <- unique(combinations)
  
  results <- list()
  
  unique_types <- unique(types)
  
  for (combo in unique_combinations) {
    subset_data <- x[combinations == combo, ]
    
    type_counts <- table(subset_data$Type)
    
    type_counts_all <- rep(0, length(unique_types))
    
    for (i in 1:length(unique_types)) {
      type <- unique_types[i]
      if (type %in% names(type_counts)) {
        type_counts_all[i] <- type_counts[[type]]
      }
    }
    
    type_counts_str <- paste(unique_types, "=", type_counts_all, collapse = " ")
    
    max_prices <- tapply(invoices[combinations == combo], types[combinations == combo], max)
    
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
    
    merged_prices_str <- paste(max_prices_in_rubles, collapse = " ")
    
    final_result <- paste(combo, '\n', type_counts_str, '\n', merged_prices_str, '\n')
    
    results[[combo]] <- final_result
  }
  
  output_file <- "car_data_output_newprint.txt"
  
  cat(unlist(results), file = output_file, sep = "\n")
  
  cat("The text file has been created or updated: ", output_file, "\n")
})

# -------------------------------------------------------------------  write.csv_new
# 为 MyDataFrame 类定义一个自定义的 write.csv_new 方法
# row.names = FALSE：这是函数的一个可选参数，默认情况下为 FALSE，用来确定是否在输出中包含行名称
write.csv_new <- function(x, file, ..., row.names = FALSE) {
  # 在这里执行数据处理和转换逻辑
  makes <- x$Make
  origins <- x$Origin
  models <- x$Model
  types <- x$Type
  invoices <- as.numeric(gsub("[\\$,]", "", x$Invoice))
  
  # 进行其他数据处理和转换，类似之前的代码
  library(tidyr)
  library(dplyr)
  
  # 将Invoice列转换为数值类型
  x$Invoice <- as.numeric(gsub("[\\$,]", "", x$Invoice))
  
  # 使用dplyr进行数据处理
  result <- x %>%
    group_by(Type, Origin, Make) %>%
    summarise(Max_Price = max(Invoice, na.rm = TRUE)) %>%
    group_by(Type, Origin) %>%
    summarise(Sum_Max_Price = sum(Max_Price, na.rm = TRUE)) %>%
    spread(Origin, Sum_Max_Price, fill = 0)
  
  # 将结果中的价格用convert_to_rubles函数转换为带有"RUB"单位的字符串
  for (col in colnames(result)[-1]) {
    result[, col] <- sapply(result[, col], convert_to_rubles_new)
  }
  
  # 调用默认的write.csv方法来保存结果
  utils::write.csv(result, file, row.names = row.names, ...)
  
  # 提示CSV文件已创建或更新
  cat("The CSV file has been created or updated: ", file, "\n")
}



# 创建 MyDataFrame 对象
# 读取数据
cars_data <- read.csv("CARS.CSV")
# 将 data.frame 转换为 MyDataFrame
class(cars_data) <- c("MyDataFrame", class(cars_data))

# 调用 print 方法
print(cars_data)

# 调用自定义的 write.csv_new 方法果
write.csv_new(cars_data, "result_car_newwrite.csv", row.names = FALSE)



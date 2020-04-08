# 读取数据并查看相关信息
bk <- read.xls(
  "../data/dds_datasets/dds_ch2_rollingsales/rollingsales_brooklyn.xls",
  perl = "D:/Strawberry/perl/bin/perl.exe", 
  pattern = "BOROUGH"
  )
head(bk)
summary(bk)
# 将价格SALE.PRICE一列从character转化为numeric
bk$SALE.PRICE.N <- as.numeric(
  gsub("[^[:digit:]]", "", bk$SALE.PRICE)
)
# 查看新增列中是否有na项
table(is.na(bk$SALE.PRICE.N))
# 将每一列的名称转换为小写
names(bk) <- tolower(names(bk))

# 使用正则表达式清理和格式化数据
bk$gross.sqft <- as.numeric(
  gsub("[^[:digit:]]", "", bk$gross.square.feet)
)
bk$land.sqft <- as.numeric(
  gsub("[^[:digit:]]", "", bk$land.square.feet)
)
bk$sale.date <- as.Date(bk$sale.date)
bk$year.built <- as.numeric(as.character(bk$year.built))

# 做一些探索性数据分析， 确保销售价格无异常出现

# 建立路径索引
attach(bk)
# 使用hist绘制直方图
hist(bk$sale.price.n)
hist(bk$sale.price.n[sale.price.n>0])
hist(bk$gross.sqft[sale.price.n==0])
detach()

# 只保留有价值的订单
bk.sale <- bk[bk$sale.price.n!=0,]
plot(bk.sale$gross.sqft, bk.sale$sale.price.n)
plot(log(bk.sale$gross.sqft), log(bk.sale$sale.price.n))

## 在有价值的订单中查看家庭住宅的信息
bk.homes <- bk.sale[
  which(grepl("FAMILY", bk.sale$building.class.category)),
]
summary(bk.homes)
plot(log(bk.homes$gross.sqft), log(bk.homes$sale.price.n))
## 去除bk.homes中那些看起来不像真实订单的奇异值
bk.homes$outliers <- (log(bk.homes$sale.price.n) <= 10) + 0
bk.homes <- bk.homes[which(bk.homes$outliers==0),]
plot(log(bk.homes$gross.sqft), log(bk.homes$sale.price.n))

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
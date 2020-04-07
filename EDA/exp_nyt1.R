# 读取数据并查看相关信息
data1 <- read.csv("../data/dds_datasets/dds_ch2_nyt/nyt1.csv")
# 显示前五行数据
head(data1)
# 将年龄分段，前开后闭区间
data1$agecat <- cut(data1$Age, c(-Inf, 0, 18, 24, 34, 44, 54, 64, Inf))
# 总览
summary(data1)
# 分组
install.packages("doBy")
library(doBy)
siterange <- function(x){
  c(length(x), min(x), mean(x), max(x))
}
summaryBy(Age~agecat, data = data1, FUN=siterange)
# 登录的用户才有性别和年龄
summaryBy(Gender+Signed_In+Impressions+Clicks~agecat, data = data1)
# 绘图
install.packages("ggplot2")
library(ggplot2)
ggplot(
  data1, aes(x=Impressions, fill=agecat)
)+geom_histogram(binwidth = 1)
ggplot(
  data1, aes(x=agecat, y=Impressions, fill=agecat)
)+geom_boxplot()
# 根据转化率创建点击
data1$hasimps <- cut(data1$Impressions, c(-Inf, 0, Inf))
summaryBy(Clicks~hasimps, data = data1, FUN=siterange)
ggplot(
  subset(data1, Impressions>0), aes(x=Clicks/Impressions, colour=agecat)
)+geom_density()
ggplot(
  subset(data1, Clicks>0), aes(x=Clicks/Impressions, colour=agecat)
)+geom_density()
ggplot(
  subset(data1, Clicks>0), aes(x=agecat, y=Clicks, fill=agecat)
)+geom_boxplot()
ggplot(
  subset(data1, Clicks>0), aes(x=Clicks, colour=agecat)
)+geom_density()
# 分组
data1$scode[data1$Impressions==0] <- "NoImps"
data1$scode[data1$Impressions >0] <- "Imps"
data1$scode[data1$Clicks >0] <- "Clicks"
# 将列转换成一个因素
data1$scode <- factor(data1$scode)
head(data1)
# 查看水平
clen <- function(x){c(length(x), mean(x))}
etable <- summaryBy(
  Impressions~scode+Gender+agecat, data = data1, FUN = clen
  )
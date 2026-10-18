# headreg:internal/drop_index —— 删掉「名字 -> 数字 id」索引项
# 入口：storage headreg:data root.cname 已就绪（由 del_data 在删除分桶前快照下来）
# 说明：索引与分桶必须同生同死，否则按名字会查到空桶
$data remove storage headreg:index $(cname)
data remove storage headreg:data root.cname

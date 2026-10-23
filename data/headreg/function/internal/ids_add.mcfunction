# headreg:internal/ids_add —— 把一个数字 id 追加进活跃列表（宏 $(id)）
# 入口：宏 $(id) = 要登记的 id；出口：headreg:ids list 尾部 +{id:<id>}
# 说明：先查重再追加 —— 列表允许重复元素，同 id 出现两次会让 api/list 渲染两行。
$execute unless data storage headreg:ids list[{id:$(id)}] run data modify storage headreg:ids list append value {id:$(id)}

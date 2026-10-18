# headreg:internal/snapshot_prev —— 把本人分桶备份到 root.prev（供 register 继承只写一次的字段）
# 前置：root.target_id 已就绪
# 说明：分桶不存在时 data modify 失败且不落空对象，故「prev 不存在」= 首次登记。
$data modify storage headreg:data root.prev set from storage headreg:data root.$(target_id).data

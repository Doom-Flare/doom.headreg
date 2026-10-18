# headreg:internal/del_data —— 删除 root.<target_id>.data
# 前置：storage headreg:data root.target_id 已就绪。
$data modify storage headreg:data root.cname set from storage headreg:data root.$(target_id).data.name
$data remove storage headreg:data root.$(target_id).data
execute if data storage headreg:data root.cname run function headreg:internal/drop_index with storage headreg:data root

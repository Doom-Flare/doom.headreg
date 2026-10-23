# headreg:internal/ids_rebuild_add —— 单个 id 探桶并登记（宏 $(id)，由 ids_rebuild_scan 逐条调用）
# 入口：storage headreg:scan rbk.id；出口：桶存在则 headreg:ids list +{id:<id>}
$execute if data storage headreg:data root.$(id).data run function headreg:internal/ids_add with storage headreg:scan rbk

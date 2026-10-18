# headreg:internal/query_dispatch —— 处理玩家自助的 /trigger
# 由 tick 每 tick 调用；没有分数的玩家不会被选中，常态零成本
# 选择器一律用 1.. ：处理完把分数置 0，既不会重放，也不必 reset
execute as @a[scores={headreg.query=1..}] run function headreg:internal/query_by_trigger
execute as @a[scores={headreg.qlist=1..}] run function headreg:internal/list_by_trigger

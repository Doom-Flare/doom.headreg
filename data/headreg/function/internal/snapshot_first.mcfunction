# headreg:internal/snapshot_first —— 落「初次档案」快照（只在从未记录过时调用）
# 语义：这是本包第一次登记该玩家时，Mojang 给出的那份档案时间。
#       它不是「第一次进服时间」——只有挂了登录钩子，两者才近似。
# 前置：root.working_data.ts_ms / .ts_sec / .date_str 已算好
data modify storage headreg:data root.working_data.first_ts_ms set from storage headreg:data root.working_data.ts_ms
data modify storage headreg:data root.working_data.first_ts_sec set from storage headreg:data root.working_data.ts_sec
data modify storage headreg:data root.working_data.first_date_str set from storage headreg:data root.working_data.date_str
execute store result storage headreg:data root.working_data.first_tick long 1 run time query gametime

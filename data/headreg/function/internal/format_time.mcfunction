# headreg:internal/format_time —— ts_sec -> 可读日期（UTC）
# 入口：root.working_data.ts_sec（10 位秒字符串）、root.working_data.premium
# 出口：root.working_data.date_str = "YYYY-MM-DD HH:MM:SS"（非正版或缺失时为 "-"）
#       副产物：#ts = 同一 epoch 秒（供 clock_anchor 使用）
data remove storage headreg:data root.working_data.date_str
data modify storage headreg:data root.working_data.date_str set value "-"
execute unless data storage headreg:data root.working_data.ts_sec run return 0
execute unless data storage headreg:data root.working_data{premium:1b} run return 0

function headreg:internal/to_score with storage headreg:data root.working_data
function headreg:internal/render_date
data modify storage headreg:data root.working_data.date_str set from storage headreg:tmp date

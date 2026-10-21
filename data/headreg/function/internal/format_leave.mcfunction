# headreg:internal/format_leave —— 渲染「上次离开（估算）」的本地时间（按 config.tz）
# 入口：root.working_data.last_leave_sec
# 出口：root.working_data.last_leave_str（缺失或未锚定时为 "-"）
data remove storage headreg:data root.working_data.last_leave_str
data modify storage headreg:data root.working_data.last_leave_str set value "-"
execute store result score #sec headreg.calc run data get storage headreg:data root.working_data.last_leave_sec
execute unless score #sec headreg.calc matches 1.. run return 0
scoreboard players operation #ts headreg.calc = #sec headreg.calc
function headreg:internal/render_date
data modify storage headreg:data root.working_data.last_leave_str set from storage headreg:tmp date

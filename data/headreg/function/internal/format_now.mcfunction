# headreg:internal/format_now —— 渲染「现在」的 UTC 时间
# 入口：storage headreg:clock 已锚定
# 出口：root.working_data.now_date_str（未锚定时为 "-"）
data remove storage headreg:data root.working_data.now_date_str
data modify storage headreg:data root.working_data.now_date_str set value "-"
function headreg:internal/now_sec
execute unless score #sec headreg.calc matches 1.. run return 0
scoreboard players operation #ts headreg.calc = #sec headreg.calc
function headreg:internal/render_date
data modify storage headreg:data root.working_data.now_date_str set from storage headreg:tmp date

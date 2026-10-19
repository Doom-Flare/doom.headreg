# headreg:internal/format_leave —— 渲染「上次结算时刻」
# 前置：headreg:tmp cur.last_leave_sec
# 后置：headreg:tmp fmt = 该时刻的 14 个一位分量；字段缺失时落成 1970-01-01 00:00:00
scoreboard players set #t headreg.calc 0
execute store result score #t headreg.calc run data get storage headreg:tmp cur.last_leave_sec
function headreg:internal/format_time

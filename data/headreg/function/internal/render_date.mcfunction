# headreg:internal/render_date —— epoch 秒 -> 可读日期字符串（UTC）
# 入口：#ts = epoch 秒（int32 安全）
# 出口：storage headreg:tmp date = "YYYY-MM-DD HH:MM:SS"
# 说明：只做渲染，不读也不写任何归档字段，供 format_time / format_now / format_leave 共用。
scoreboard players operation #t headreg.calc = #ts headreg.calc
scoreboard players operation #t headreg.calc %= #k86400 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k3600 headreg.calc
scoreboard players operation #t headreg.calc %= #k3600 headreg.calc
scoreboard players operation #mi headreg.calc = #t headreg.calc
scoreboard players operation #mi headreg.calc /= #k60 headreg.calc
scoreboard players operation #s headreg.calc = #t headreg.calc
scoreboard players operation #s headreg.calc %= #k60 headreg.calc

scoreboard players operation #days headreg.calc = #ts headreg.calc
scoreboard players operation #days headreg.calc /= #k86400 headreg.calc
scoreboard players set #year headreg.calc 1970
function headreg:internal/sub_year

scoreboard players operation #doy headreg.calc = #days headreg.calc
scoreboard players set #mon headreg.calc 0
function headreg:internal/month_scan

execute store result storage headreg:tmp num.y int 1 run scoreboard players get #year headreg.calc
execute store result storage headreg:tmp num.mo int 1 run scoreboard players get #mon headreg.calc
execute store result storage headreg:tmp num.d int 1 run scoreboard players get #doy headreg.calc
execute store result storage headreg:tmp num.h int 1 run scoreboard players get #h headreg.calc
execute store result storage headreg:tmp num.mi int 1 run scoreboard players get #mi headreg.calc
execute store result storage headreg:tmp num.s int 1 run scoreboard players get #s headreg.calc
function headreg:internal/pad_all with storage headreg:tmp num
data modify storage headreg:tmp pad.y set from storage headreg:tmp num.y
function headreg:internal/concat_date with storage headreg:tmp pad

data remove storage headreg:tmp num
data remove storage headreg:tmp pad

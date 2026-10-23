# headreg:internal/tz_refresh_scan —— 逐条推进：每 tick 重渲染一条记录，到下一条时续排
# 入口：#tzid（0 起 = 活跃列表下标），上限 #ln（ids_len 读到的列表长度）
# 出口：当前 id 的显示串按当前时区重算；列表里的 id 一定存在，故不再需要空号 gate
# 说明：#tzid 是循环游标，翻成真实 id 后写进 scan adisp.id，由 tz_rec_all 的宏 $(id) 拼进路径。
#       尾部用 schedule 而不是直接递归：一条记录就吃掉上万条命令，同步递归会被链长上限截断。
execute if score #tzid headreg.calc >= #ln headreg.calc run data remove storage headreg:scan adisp
execute if score #tzid headreg.calc >= #ln headreg.calc run return 0
execute store result storage headreg:scan adisp.k int 1 run scoreboard players get #tzid headreg.calc
function headreg:internal/ids_at with storage headreg:scan adisp
data modify storage headreg:scan adisp.id set from storage headreg:scan idat.id
function headreg:internal/tz_rec_all with storage headreg:scan adisp
scoreboard players add #tzid headreg.calc 1
schedule function headreg:internal/tz_refresh_scan 1t replace

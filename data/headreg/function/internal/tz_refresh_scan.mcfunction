# headreg:internal/tz_refresh_scan —— 逐条推进：每 tick 重渲染一条记录，到下一条时续排
# 入口：#tzid（1 起），上限 #init（headreg.next 计分板）
# 出口：当前 id 的显示串按当前时区重算；没有记录的 id 是无副作用的空操作
# 说明：#tzid 是循环游标，写进 scan adisp.id 后由 tz_rec_all 的宏 $(id) 拼进路径。
#       尾部用 schedule 而不是直接递归：一条记录就吃掉 2.5 万条命令，同步递归会被链长上限截断。
execute if score #tzid headreg.calc > #init headreg.next run data remove storage headreg:scan adisp
execute if score #tzid headreg.calc > #init headreg.next run return 0
execute store result storage headreg:scan adisp.id int 1 run scoreboard players get #tzid headreg.calc
function headreg:internal/tz_rec_all with storage headreg:scan adisp
scoreboard players add #tzid headreg.calc 1
schedule function headreg:internal/tz_refresh_scan 1t replace

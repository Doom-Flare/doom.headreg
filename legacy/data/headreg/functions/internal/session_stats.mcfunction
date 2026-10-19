# headreg:internal/session_stats —— 在线时长换算
# 前置：headreg:tmp cur 已就绪（history / last_leave_sec）；#now 已算好
# 出口：#sm/#ss = 本次在线 分/秒；#tm/#ts2 = 累计在线 分/秒
# 口径（legacy 无 play_time 统计，§6 的 objective 表里没有 headreg.play）：
#   累计 = history 各段 dur_sec 之和；本次 = #now - last_leave_sec（本段已经走过的秒数）。
scoreboard players set #dt60 headreg.calc 60
scoreboard players set #tot headreg.calc 0
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[0].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[1].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[2].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[3].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[4].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[5].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[6].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[7].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[8].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #x headreg.calc 0
execute store result score #x headreg.calc run data get storage headreg:tmp cur.history[9].dur_sec
scoreboard players operation #tot headreg.calc += #x headreg.calc
scoreboard players set #sess headreg.calc 0
scoreboard players operation #sess headreg.calc = #now headreg.calc
scoreboard players set #lv headreg.calc 0
execute store result score #lv headreg.calc run data get storage headreg:tmp cur.last_leave_sec
execute if score #lv headreg.calc matches 1.. run scoreboard players operation #sess headreg.calc -= #lv headreg.calc
execute if score #sess headreg.calc matches ..-1 run scoreboard players set #sess headreg.calc 0
scoreboard players operation #sm headreg.calc = #sess headreg.calc
scoreboard players operation #sm headreg.calc /= #dt60 headreg.calc
scoreboard players operation #ss headreg.calc = #sess headreg.calc
scoreboard players operation #ss headreg.calc %= #dt60 headreg.calc
scoreboard players operation #tm headreg.calc = #tot headreg.calc
scoreboard players operation #tm headreg.calc /= #dt60 headreg.calc
scoreboard players operation #ts2 headreg.calc = #tot headreg.calc
scoreboard players operation #ts2 headreg.calc %= #dt60 headreg.calc

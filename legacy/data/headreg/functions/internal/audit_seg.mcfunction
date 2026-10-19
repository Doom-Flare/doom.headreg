# headreg:internal/audit_seg —— 检查第 #seg 段的时长与两端时间是否自洽（容差 ±1 秒）
# 前置：#seg = 0..9 槽位、该槽位确实存在；headreg:tmp cur 已读入；#bad = 当前失败数
# 后置：#bad 可能 +1，只影响 headreg.calc 的计数，不修改记录
scoreboard players set #au_a headreg.calc 0
scoreboard players set #au_b headreg.calc 0
scoreboard players set #au_c headreg.calc 0
execute if score #au_seg headreg.calc matches 0 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[0].in_sec
execute if score #au_seg headreg.calc matches 1 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[1].in_sec
execute if score #au_seg headreg.calc matches 2 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[2].in_sec
execute if score #au_seg headreg.calc matches 3 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[3].in_sec
execute if score #au_seg headreg.calc matches 4 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[4].in_sec
execute if score #au_seg headreg.calc matches 5 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[5].in_sec
execute if score #au_seg headreg.calc matches 6 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[6].in_sec
execute if score #au_seg headreg.calc matches 7 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[7].in_sec
execute if score #au_seg headreg.calc matches 8 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[8].in_sec
execute if score #au_seg headreg.calc matches 9 store result score #au_a headreg.calc run data get storage headreg:tmp cur.history[9].in_sec
execute if score #au_seg headreg.calc matches 0 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[0].out_sec
execute if score #au_seg headreg.calc matches 1 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[1].out_sec
execute if score #au_seg headreg.calc matches 2 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[2].out_sec
execute if score #au_seg headreg.calc matches 3 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[3].out_sec
execute if score #au_seg headreg.calc matches 4 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[4].out_sec
execute if score #au_seg headreg.calc matches 5 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[5].out_sec
execute if score #au_seg headreg.calc matches 6 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[6].out_sec
execute if score #au_seg headreg.calc matches 7 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[7].out_sec
execute if score #au_seg headreg.calc matches 8 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[8].out_sec
execute if score #au_seg headreg.calc matches 9 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[9].out_sec
execute if score #au_seg headreg.calc matches 0 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[0].dur_sec
execute if score #au_seg headreg.calc matches 1 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[1].dur_sec
execute if score #au_seg headreg.calc matches 2 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[2].dur_sec
execute if score #au_seg headreg.calc matches 3 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[3].dur_sec
execute if score #au_seg headreg.calc matches 4 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[4].dur_sec
execute if score #au_seg headreg.calc matches 5 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[5].dur_sec
execute if score #au_seg headreg.calc matches 6 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[6].dur_sec
execute if score #au_seg headreg.calc matches 7 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[7].dur_sec
execute if score #au_seg headreg.calc matches 8 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[8].dur_sec
execute if score #au_seg headreg.calc matches 9 store result score #au_c headreg.calc run data get storage headreg:tmp cur.history[9].dur_sec
scoreboard players operation #au_d headreg.calc = #au_b headreg.calc
scoreboard players operation #au_d headreg.calc -= #au_a headreg.calc
scoreboard players operation #au_e headreg.calc = #au_c headreg.calc
scoreboard players operation #au_e headreg.calc -= #au_d headreg.calc
execute unless score #au_e headreg.calc matches -1..1 run scoreboard players add #au_bad headreg.calc 1
execute unless score #au_e headreg.calc matches -1..1 run tellraw @s [{"text":"[audit] ✗ 某段 dur_sec 与 (out_sec-in_sec) 不符","color":"red"}]
execute unless score #au_d headreg.calc matches 1.. run scoreboard players add #au_bad headreg.calc 1
execute unless score #au_d headreg.calc matches 1.. run tellraw @s [{"text":"[audit] ✗ 某段时长不是正数","color":"red"}]

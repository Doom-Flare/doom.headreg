# headreg:internal/render_history_one —— 渲染第 #qi 段历史（1 基序号，0 基下标在 #qi0）
# 前置：#qi0 = #qi-1（0..9）；headreg:tmp cur = 该编号的记录
# 后置：一行 tellraw；headreg:tmp seg / fmt 被占用
# 说明：§4 要求 in/out 时刻现算（不存 in_str/out_str）。先把本段拷到 headreg:tmp seg（无宏，
#       只能按 10 个槽位逐条判 #qi0），再渲染进时刻→备份 14 个分量到 #2*→渲染出时刻→拼一行。
data remove storage headreg:tmp seg
execute if score #qi0 headreg.calc matches 0 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[0].in_sec
execute if score #qi0 headreg.calc matches 1 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[1].in_sec
execute if score #qi0 headreg.calc matches 2 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[2].in_sec
execute if score #qi0 headreg.calc matches 3 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[3].in_sec
execute if score #qi0 headreg.calc matches 4 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[4].in_sec
execute if score #qi0 headreg.calc matches 5 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[5].in_sec
execute if score #qi0 headreg.calc matches 6 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[6].in_sec
execute if score #qi0 headreg.calc matches 7 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[7].in_sec
execute if score #qi0 headreg.calc matches 8 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[8].in_sec
execute if score #qi0 headreg.calc matches 9 run data modify storage headreg:tmp seg.in_sec set from storage headreg:tmp cur.history[9].in_sec
execute if score #qi0 headreg.calc matches 0 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[0].out_sec
execute if score #qi0 headreg.calc matches 1 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[1].out_sec
execute if score #qi0 headreg.calc matches 2 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[2].out_sec
execute if score #qi0 headreg.calc matches 3 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[3].out_sec
execute if score #qi0 headreg.calc matches 4 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[4].out_sec
execute if score #qi0 headreg.calc matches 5 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[5].out_sec
execute if score #qi0 headreg.calc matches 6 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[6].out_sec
execute if score #qi0 headreg.calc matches 7 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[7].out_sec
execute if score #qi0 headreg.calc matches 8 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[8].out_sec
execute if score #qi0 headreg.calc matches 9 run data modify storage headreg:tmp seg.out_sec set from storage headreg:tmp cur.history[9].out_sec
execute if score #qi0 headreg.calc matches 0 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[0].dur_sec
execute if score #qi0 headreg.calc matches 1 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[1].dur_sec
execute if score #qi0 headreg.calc matches 2 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[2].dur_sec
execute if score #qi0 headreg.calc matches 3 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[3].dur_sec
execute if score #qi0 headreg.calc matches 4 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[4].dur_sec
execute if score #qi0 headreg.calc matches 5 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[5].dur_sec
execute if score #qi0 headreg.calc matches 6 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[6].dur_sec
execute if score #qi0 headreg.calc matches 7 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[7].dur_sec
execute if score #qi0 headreg.calc matches 8 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[8].dur_sec
execute if score #qi0 headreg.calc matches 9 run data modify storage headreg:tmp seg.dur_sec set from storage headreg:tmp cur.history[9].dur_sec
execute if score #qi0 headreg.calc matches 0 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[0].exit_kind
execute if score #qi0 headreg.calc matches 1 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[1].exit_kind
execute if score #qi0 headreg.calc matches 2 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[2].exit_kind
execute if score #qi0 headreg.calc matches 3 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[3].exit_kind
execute if score #qi0 headreg.calc matches 4 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[4].exit_kind
execute if score #qi0 headreg.calc matches 5 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[5].exit_kind
execute if score #qi0 headreg.calc matches 6 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[6].exit_kind
execute if score #qi0 headreg.calc matches 7 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[7].exit_kind
execute if score #qi0 headreg.calc matches 8 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[8].exit_kind
execute if score #qi0 headreg.calc matches 9 run data modify storage headreg:tmp seg.exit_kind set from storage headreg:tmp cur.history[9].exit_kind
scoreboard players set #t headreg.calc 0
execute store result score #t headreg.calc run data get storage headreg:tmp seg.in_sec
function headreg:internal/format_time
scoreboard players operation #2ya headreg.calc = #ya headreg.calc
scoreboard players operation #2yb headreg.calc = #yb headreg.calc
scoreboard players operation #2yc headreg.calc = #yc headreg.calc
scoreboard players operation #2yd headreg.calc = #yd headreg.calc
scoreboard players operation #2moh headreg.calc = #moh headreg.calc
scoreboard players operation #2mol headreg.calc = #mol headreg.calc
scoreboard players operation #2dh headreg.calc = #dh headreg.calc
scoreboard players operation #2dl headreg.calc = #dl headreg.calc
scoreboard players operation #2hh headreg.calc = #hh headreg.calc
scoreboard players operation #2hl headreg.calc = #hl headreg.calc
scoreboard players operation #2mih headreg.calc = #mih headreg.calc
scoreboard players operation #2mil headreg.calc = #mil headreg.calc
scoreboard players operation #2sh headreg.calc = #sh headreg.calc
scoreboard players operation #2sl headreg.calc = #sl headreg.calc
scoreboard players set #t headreg.calc 0
execute store result score #t headreg.calc run data get storage headreg:tmp seg.out_sec
function headreg:internal/format_time
scoreboard players set #t headreg.calc 0
scoreboard players set #a_dur headreg.calc 0
execute if score #qi0 headreg.calc matches 0 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[0].dur_sec
execute if score #qi0 headreg.calc matches 1 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[1].dur_sec
execute if score #qi0 headreg.calc matches 2 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[2].dur_sec
execute if score #qi0 headreg.calc matches 3 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[3].dur_sec
execute if score #qi0 headreg.calc matches 4 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[4].dur_sec
execute if score #qi0 headreg.calc matches 5 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[5].dur_sec
execute if score #qi0 headreg.calc matches 6 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[6].dur_sec
execute if score #qi0 headreg.calc matches 7 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[7].dur_sec
execute if score #qi0 headreg.calc matches 8 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[8].dur_sec
execute if score #qi0 headreg.calc matches 9 store result score #a_dur headreg.calc run data get storage headreg:tmp cur.history[9].dur_sec
tellraw @s [{"text":"   #","color":"dark_gray"},{"score":{"name":"#qi","objective":"headreg.calc"},"color":"gray"},{"text":" ","color":"dark_gray"},{"score":{"name":"#2ya","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2yb","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2yc","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2yd","objective":"headreg.calc"},"color":"aqua"},{"text":"-","color":"aqua"},{"score":{"name":"#2moh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2mol","objective":"headreg.calc"},"color":"aqua"},{"text":"-","color":"aqua"},{"score":{"name":"#2dh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2dl","objective":"headreg.calc"},"color":"aqua"},{"text":" ","color":"aqua"},{"score":{"name":"#2hh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2hl","objective":"headreg.calc"},"color":"aqua"},{"text":":","color":"aqua"},{"score":{"name":"#2mih","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2mil","objective":"headreg.calc"},"color":"aqua"},{"text":":","color":"aqua"},{"score":{"name":"#2sh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#2sl","objective":"headreg.calc"},"color":"aqua"},{"text":" → ","color":"dark_gray"},{"score":{"name":"#ya","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#yb","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#yc","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#yd","objective":"headreg.calc"},"color":"aqua"},{"text":"-","color":"aqua"},{"score":{"name":"#moh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#mol","objective":"headreg.calc"},"color":"aqua"},{"text":"-","color":"aqua"},{"score":{"name":"#dh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#dl","objective":"headreg.calc"},"color":"aqua"},{"text":" ","color":"aqua"},{"score":{"name":"#hh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#hl","objective":"headreg.calc"},"color":"aqua"},{"text":":","color":"aqua"},{"score":{"name":"#mih","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#mil","objective":"headreg.calc"},"color":"aqua"},{"text":":","color":"aqua"},{"score":{"name":"#sh","objective":"headreg.calc"},"color":"aqua"},{"score":{"name":"#sl","objective":"headreg.calc"},"color":"aqua"},{"text":"   ","color":"dark_gray"},{"score":{"name":"#a_dur","objective":"headreg.calc"},"color":"white"},{"text":" 秒  ","color":"dark_gray"},{"nbt":"seg.exit_kind","storage":"headreg:tmp","color":"gold"}]

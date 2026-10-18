# headreg:internal/clock_from_tick —— 指定 gametime 时刻 -> epoch 秒
# 入口：#tt = 某个 gametime 时刻（如玩家的 last_seen）；storage headreg:clock 已锚定
# 出口：#sec = 该时刻对应的 epoch 秒；未锚定时为 0
# 跨重启：#tt 早于本次开机（clock.boot）说明该时刻来自上一轮运行，此时用留档锚点 clock.prev。
scoreboard players set #sec headreg.calc 0
execute unless data storage headreg:clock tick run return 0
scoreboard players set #boot headreg.calc 0
scoreboard players set #ps headreg.calc 0
scoreboard players set #pt headreg.calc 0
scoreboard players set #up headreg.calc 0
execute store result score #boot headreg.calc run data get storage headreg:clock boot
execute store result score #ps headreg.calc run data get storage headreg:clock prev.sec
execute store result score #pt headreg.calc run data get storage headreg:clock prev.tick
# 留档锚点必须可信才用：sec 至少是 2001 年（1e9）、tick 为正，且该时刻确实早于本次开机
execute if score #tt headreg.calc < #boot headreg.calc if score #ps headreg.calc matches 1000000001.. if score #pt headreg.calc matches 1.. run scoreboard players set #up headreg.calc 1
execute if score #up headreg.calc matches 0 store result score #bs headreg.calc run data get storage headreg:clock sec
execute if score #up headreg.calc matches 0 store result score #bt headreg.calc run data get storage headreg:clock tick
execute if score #up headreg.calc matches 1 store result score #bs headreg.calc run data get storage headreg:clock prev.sec
execute if score #up headreg.calc matches 1 store result score #bt headreg.calc run data get storage headreg:clock prev.tick
scoreboard players operation #d headreg.calc = #tt headreg.calc
scoreboard players operation #d headreg.calc -= #bt headreg.calc
scoreboard players operation #d headreg.calc /= #k20 headreg.calc
scoreboard players operation #sec headreg.calc = #bs headreg.calc
scoreboard players operation #sec headreg.calc += #d headreg.calc

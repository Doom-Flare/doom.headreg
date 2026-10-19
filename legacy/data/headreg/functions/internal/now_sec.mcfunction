# headreg:internal/now_sec —— 用服务器时钟推算「现在」的 epoch 秒
# 前置：storage headreg:clock = {sec,tick,anchor_sec,anchor_tick}（由 load 或 clock_anchor 锚定）
# 后置：#now headreg.calc = 当前 epoch 秒；未锚定时为 0（调用方据此跳过，不要用 #now 以外的残留值）
# 误差来源：gametime 在停机期间不走（重启后靠首条记录/正版档案前移），以及掉刻。
scoreboard players set #now headreg.calc 0
scoreboard players set #nabort headreg.calc 0
execute unless data storage headreg:clock tick run scoreboard players set #nabort headreg.calc 1
execute if score #nabort headreg.calc matches 0 store result score #bs headreg.calc run data get storage headreg:clock sec
execute if score #nabort headreg.calc matches 0 store result score #bt headreg.calc run data get storage headreg:clock tick
execute if score #nabort headreg.calc matches 0 store result score #gn headreg.calc run time query gametime
execute if score #nabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc = #gn headreg.calc
execute if score #nabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc -= #bt headreg.calc
execute if score #nabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc /= #k20 headreg.calc
execute if score #nabort headreg.calc matches 0 run scoreboard players operation #now headreg.calc = #bs headreg.calc
execute if score #nabort headreg.calc matches 0 run scoreboard players operation #now headreg.calc += #d headreg.calc
scoreboard players set #nabort headreg.calc 0

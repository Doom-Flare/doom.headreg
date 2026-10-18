# headreg:internal/now_sec —— 用服务器时钟推算「现在」的 epoch 秒
# 入口：storage headreg:clock = {sec:int, tick:int}（由 clock_anchor 锚定）
# 出口：#sec = epoch 秒；时钟未锚定时为 0
# 说明：数据包读不到系统时钟，只能拿 gametime 差分。误差来源只有两处：
#       ① 服务器停机期间 gametime 不走，时钟会落后（每次有正版玩家登录会向前校正）
#       ② 掉刻时 gametime 慢于真实时间
scoreboard players set #sec headreg.calc 0
execute unless data storage headreg:clock tick run return 0
execute store result score #bs headreg.calc run data get storage headreg:clock sec
execute store result score #bt headreg.calc run data get storage headreg:clock tick
execute store result score #gn headreg.calc run time query gametime
scoreboard players operation #d headreg.calc = #gn headreg.calc
scoreboard players operation #d headreg.calc -= #bt headreg.calc
scoreboard players operation #d headreg.calc /= #k20 headreg.calc
scoreboard players operation #sec headreg.calc = #bs headreg.calc
scoreboard players operation #sec headreg.calc += #d headreg.calc

# headreg:internal/session_stats —— 由 vanilla 统计项算出本次 / 累计在线时长
# 入口：@s 为玩家（在线或离线均可，分数离线仍在）
#   headreg.play = minecraft.custom:minecraft.play_time（tick，服务端自己递增、离线冻结）
#   headreg.join_play = 本次进服时的 play 快照（on_join 写入）
# 出口：#sm/#ss = 本次在线 分/秒；#tm/#ts2 = 累计在线 分/秒
scoreboard players operation #sess headreg.calc = @s headreg.play
scoreboard players operation #sess headreg.calc -= @s headreg.join_play
scoreboard players operation #sess headreg.calc /= #k20 headreg.calc
scoreboard players operation #sm headreg.calc = #sess headreg.calc
scoreboard players operation #sm headreg.calc /= #k60 headreg.calc
scoreboard players operation #ss headreg.calc = #sess headreg.calc
scoreboard players operation #ss headreg.calc %= #k60 headreg.calc

scoreboard players operation #ttl headreg.calc = @s headreg.play
scoreboard players operation #ttl headreg.calc /= #k20 headreg.calc
scoreboard players operation #tm headreg.calc = #ttl headreg.calc
scoreboard players operation #tm headreg.calc /= #k60 headreg.calc
scoreboard players operation #ts2 headreg.calc = #ttl headreg.calc
scoreboard players operation #ts2 headreg.calc %= #k60 headreg.calc

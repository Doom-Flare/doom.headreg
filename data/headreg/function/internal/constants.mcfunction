# headreg:internal/constants —— 算术常量（每次 load 重设，防被外部改动）
# 注意：int32 上限 2147483647，故最大常量只到 1e9（截秒靠字符串切片，不靠除法）。
scoreboard players set #k2 headreg.calc 2
scoreboard players set #k4 headreg.calc 4
scoreboard players set #k16 headreg.calc 16
# gametime(tick) / play_time(tick) -> 秒
scoreboard players set #k20 headreg.calc 20
scoreboard players set #k256 headreg.calc 256
scoreboard players set #k48 headreg.calc 48
scoreboard players set #k60 headreg.calc 60
scoreboard players set #k64 headreg.calc 64
# 日历换算用
scoreboard players set #k7 headreg.calc 7
scoreboard players set #k365 headreg.calc 365
scoreboard players set #k366 headreg.calc 366
scoreboard players set #k400 headreg.calc 400
# 400 年整周期 = 146097 天（含 97 个闰日），sub_year_seed 用它做一次整除估年起
scoreboard players set #k146097 headreg.calc 146097
scoreboard players set #k3600 headreg.calc 3600
scoreboard players set #k86400 headreg.calc 86400
scoreboard players set #k1e1 headreg.calc 10
scoreboard players set #k1e2 headreg.calc 100
scoreboard players set #k1e3 headreg.calc 1000
scoreboard players set #k1e4 headreg.calc 10000
scoreboard players set #k1e5 headreg.calc 100000
scoreboard players set #k1e6 headreg.calc 1000000
scoreboard players set #k1e7 headreg.calc 10000000
scoreboard players set #k1e8 headreg.calc 100000000
scoreboard players set #k1e9 headreg.calc 1000000000
scoreboard players set #k65536 headreg.calc 65536
scoreboard players set #k_retry headreg.calc 200

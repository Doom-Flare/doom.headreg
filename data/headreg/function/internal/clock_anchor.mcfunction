# headreg:internal/clock_anchor —— 用 Mojang 档案时间校正服务器时钟
# 入口：#ts = 本次档案 epoch 秒（format_time 的副产物）
# 说明：两件事必须同时成立，时钟才准：
#   1) 只向前校正 —— 档案时间可能命中 ProfileResolver 缓存而偏旧，此时 gap<0 直接跳过，绝不让时钟倒退。
#   2) 门限必须小 —— gametime 不等于墙钟：实测 20 分钟内 TPS 漂移累积 52 秒。
#      门限若设为 61 秒，这 52 秒的漂移永远落在门外，时钟就永久慢 52 秒。故取 1 秒。
#      取 1 而非 2：漂移 1 秒时若不校正，界面会出现「现在」比「本次档案」早 1 秒的怪象。
execute unless score #ts headreg.calc matches 1.. run return 0
function headreg:internal/now_sec
scoreboard players operation #gap headreg.calc = #ts headreg.calc
scoreboard players operation #gap headreg.calc -= #sec headreg.calc
execute unless score #gap headreg.calc matches 1.. run return 0
execute store result storage headreg:clock sec int 1 run scoreboard players get #ts headreg.calc
execute store result storage headreg:clock tick int 1 run time query gametime

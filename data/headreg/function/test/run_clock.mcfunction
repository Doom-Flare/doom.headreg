# headreg:test/run_clock —— 包内自断言（第 3/6 段）：时钟换算 10 例（3 常规 + 7 偏移与跨重启）
# 由第 2 段 schedule 续跑；不要单独调用。headreg:ckbak 的备份与写回必须留在同一段内。
execute unless score #stg headreg.test matches 3 run return 0

# ---------- 时钟换算（clock_from_tick） ----------
# 整块备份真锚点（含 boot / prev），本组跑完整块写回：测试绝不允许污染生产时钟
data remove storage headreg:ckbak root
data modify storage headreg:ckbak root set from storage headreg:clock
data remove storage headreg:clock boot
data remove storage headreg:clock prev
# 基本换算：锚点 1000s/200tick，gametime 600 → 差 400 tick = 20 秒
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:200}
scoreboard players set #tt headreg.calc 600
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1020 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1020 run scoreboard players add #fail headreg.test 1
# 未锚定：必须回 0，绝不能编出一个 1970 的时间
scoreboard players add #calls headreg.test 1
data remove storage headreg:clock sec
data remove storage headreg:clock tick
scoreboard players set #tt headreg.calc 600
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 0 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 0 run scoreboard players add #fail headreg.test 1
# gametime 早于锚点（换存档 / 回档）：向下取整，1000 + (-200)/20 = 990
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:200}
scoreboard players set #tt headreg.calc 0
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 990 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 990 run scoreboard players add #fail headreg.test 1

# ---------- 时钟换算（clock_from_tick）：偏移与跨重启 ----------
# 正向：5200 tick 比锚点晚 200 tick = 10 秒
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:5000}
scoreboard players set #tt headreg.calc 5200
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1010 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1010 run scoreboard players add #fail headreg.test 1
# 反向：4900 tick 比锚点早 100 tick = -5 秒
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 4900
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 995 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 995 run scoreboard players add #fail headreg.test 1
# 同一时刻：差值 0
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 5000
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1000 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1000 run scoreboard players add #fail headreg.test 1
# 未锚定（只删 tick）：必须回落 0
scoreboard players add #calls headreg.test 1
data remove storage headreg:clock tick
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 0 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 0 run scoreboard players add #fail headreg.test 1
# 跨重启 · 本次开机内：800 ≥ boot 500 → 当前锚点 1600000000 + (800-1000)/20 = 1599999990
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1600000000,tick:1000,boot:500,prev:{sec:1599999900,tick:900}}
scoreboard players set #tt headreg.calc 800
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999990 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999990 run scoreboard players add #fail headreg.test 1
# 跨重启 · 上一轮遗留：400 < boot 500 → 留档锚点 1599999900 + (400-900)/20 = 1599999875
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 400
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999875 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999875 run scoreboard players add #fail headreg.test 1
# 留档锚点不可信（1970 级 sec）：必须回落当前锚点 1600000000 + (400-1000)/20 = 1599999970
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1600000000,tick:1000,boot:500,prev:{sec:2000,tick:900}}
scoreboard players set #tt headreg.calc 400
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999970 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999970 run scoreboard players add #fail headreg.test 1
# 恢复真锚点：整块写回，绝不残留测试值
data remove storage headreg:clock sec
data remove storage headreg:clock tick
data remove storage headreg:clock boot
data remove storage headreg:clock prev
execute if data storage headreg:ckbak root.sec run data modify storage headreg:clock sec set from storage headreg:ckbak root.sec
execute if data storage headreg:ckbak root.tick run data modify storage headreg:clock tick set from storage headreg:ckbak root.tick
execute if data storage headreg:ckbak root.boot run data modify storage headreg:clock boot set from storage headreg:ckbak root.boot
execute if data storage headreg:ckbak root.prev run data modify storage headreg:clock prev set from storage headreg:ckbak root.prev
data remove storage headreg:ckbak root

# ---------- 交给第 4 段（时区 preset） ----------
scoreboard players set #stg headreg.test 4
schedule function headreg:test/run_tz 1t replace

# headreg:internal/tz_rule_eu —— 欧洲夏令时规则判定
# 规则：3 月最后一个周日 01:00 UTC 起，10 月最后一个周日 01:00 UTC 止
# 入口：#tsd / #tzb / #leap / #y0（tz_prep 已备好）
# 出口：#tzdst = 1/0；#tz1 / #tz2 留下两次切换的本地基准时刻（排查用）
# 换算：切点 = 当日 00:00(基准) + 01:00 UTC 的本地基准表示 = 日号*86400 + 3600 + #tzb
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 89
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_last
scoreboard players operation #tz1 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz1 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz1 headreg.calc 3600
scoreboard players operation #tz1 headreg.calc += #tzb headreg.calc
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 303
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_last
scoreboard players operation #tz2 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz2 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz2 headreg.calc 3600
scoreboard players operation #tz2 headreg.calc += #tzb headreg.calc
scoreboard players set #tzdst headreg.calc 0
execute if score #tsd headreg.calc >= #tz1 headreg.calc if score #tsd headreg.calc < #tz2 headreg.calc run scoreboard players set #tzdst headreg.calc 1
# int32 护栏：秒级日号乘 86400 在 2038 边界会溢出成负数，此时一律判为「非夏令时」
execute if score #tz1 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0
execute if score #tz2 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0

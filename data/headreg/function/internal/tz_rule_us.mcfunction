# headreg:internal/tz_rule_us —— 美国夏令时规则判定
# 规则：3 月第 2 个周日 02:00 本地标准时起，11 月第 1 个周日 02:00 本地夏令时止
# 入口：#tsd / #tzb / #leap / #y0（tz_prep 已备好）
# 出口：#tzdst = 1/0；#tz1 / #tz2 留下两次切换的本地基准时刻（排查用）
# 换算：02:00 标准时 = 基准本地 7200；02:00 夏令时 = 基准本地 3600（夏令时比基准快 1 小时）
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 59
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_first
scoreboard players add #sdy headreg.calc 7
scoreboard players operation #tz1 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz1 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz1 headreg.calc 7200
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 304
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_first
scoreboard players operation #tz2 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz2 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz2 headreg.calc 3600
scoreboard players set #tzdst headreg.calc 0
execute if score #tsd headreg.calc >= #tz1 headreg.calc if score #tsd headreg.calc < #tz2 headreg.calc run scoreboard players set #tzdst headreg.calc 1
# int32 护栏：2038 边界溢出时一律判为非夏令时
execute if score #tz1 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0
execute if score #tz2 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0

# headreg:internal/tz_rule_au —— 澳洲夏令时规则判定（南半球，跨年生效）
# 规则：10 月第 1 个周日 02:00 本地标准时起，次年 4 月第 1 个周日 03:00 本地夏令时止
# 入口：#tsd / #tzb / #leap / #y0（tz_prep 已备好）
# 出口：#tzdst = 1/0；#tz1 / #tz2 留下两次切换的本地基准时刻（排查用）
# 换算：02:00 标准时与 03:00 夏令时在「基准本地」上同为 7200，故两个切点都用 +7200。
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 273
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_first
scoreboard players operation #tz1 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz1 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz1 headreg.calc 7200
scoreboard players operation #m1 headreg.calc = #leap headreg.calc
scoreboard players add #m1 headreg.calc 90
scoreboard players operation #m1 headreg.calc += #y0 headreg.calc
function headreg:internal/tz_sun_first
scoreboard players operation #tz2 headreg.calc = #sdy headreg.calc
scoreboard players operation #tz2 headreg.calc *= #k86400 headreg.calc
scoreboard players add #tz2 headreg.calc 7200
# 南半球：要么已过 10 月切点，要么还没到次年 4 月切点
scoreboard players set #tzdst headreg.calc 0
execute if score #tsd headreg.calc >= #tz1 headreg.calc run scoreboard players set #tzdst headreg.calc 1
execute if score #tsd headreg.calc < #tz2 headreg.calc run scoreboard players set #tzdst headreg.calc 1
execute if score #tz1 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0
execute if score #tz2 headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0

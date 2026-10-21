# headreg:internal/tz_sun_last —— 求「某月最后一个周日」的绝对日号
# 入口：#m1 = 该月最后一天的绝对日号（= #y0 + 年内日序）
# 出口：#sdy = 该月最后一个周日的绝对日号；#dowo 被当作草稿覆盖
# 依据：1970-01-01 是周四，故「日号 + 4 mod 7」= 星期几（0=周日，…，4=周四）。
scoreboard players operation #dowo headreg.calc = #m1 headreg.calc
scoreboard players add #dowo headreg.calc 4
scoreboard players operation #dowo headreg.calc %= #k7 headreg.calc
scoreboard players operation #sdy headreg.calc = #m1 headreg.calc
scoreboard players operation #sdy headreg.calc -= #dowo headreg.calc

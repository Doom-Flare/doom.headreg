# headreg:internal/sub_year_seed —— sub_year 的估算段：把 #days 一次性砍到不足 2 年
# 入口：#days >= 366，#year = 1970（与 sub_year 同一套约定）
# 出口：#days / #year 已被推进，剩余不足 2 年，交给 sub_year 末尾的循环补正
#
# 累计天数(yr) = 365*yr + floor((1969+yr)/4) - floor((1969+yr)/100) + floor((1969+yr)/400) - 477
# 477 是 1970-01-01 之前累计的闰日数；把 +1969 折进分子就是 yq+1 / yq+69 / yq+369。
# 粗估 yq = floor(#days*400/146097) - 1：400 年恰 146097 天，整除必为高估，退 1 年即保守，
# 保证 #days 不会被减成负数（下面的 ..-1 护栏只是最后一道保险）。
scoreboard players operation #yq headreg.calc = #days headreg.calc
scoreboard players operation #yq headreg.calc *= #k400 headreg.calc
scoreboard players operation #yq headreg.calc /= #k146097 headreg.calc
execute if score #yq headreg.calc matches 1.. run scoreboard players remove #yq headreg.calc 1
scoreboard players operation #ycs headreg.calc = #yq headreg.calc
scoreboard players operation #ycs headreg.calc *= #k365 headreg.calc
scoreboard players operation #yh headreg.calc = #yq headreg.calc
scoreboard players add #yh headreg.calc 1
scoreboard players operation #yh headreg.calc /= #k4 headreg.calc
scoreboard players operation #ycs headreg.calc += #yh headreg.calc
scoreboard players operation #yh headreg.calc = #yq headreg.calc
scoreboard players add #yh headreg.calc 69
scoreboard players operation #yh headreg.calc /= #k1e2 headreg.calc
scoreboard players operation #ycs headreg.calc -= #yh headreg.calc
scoreboard players operation #yh headreg.calc = #yq headreg.calc
scoreboard players add #yh headreg.calc 369
scoreboard players operation #yh headreg.calc /= #k400 headreg.calc
scoreboard players operation #ycs headreg.calc += #yh headreg.calc
scoreboard players operation #days headreg.calc -= #ycs headreg.calc
scoreboard players operation #year headreg.calc += #yq headreg.calc
execute if score #days headreg.calc matches ..-1 run scoreboard players set #days headreg.calc 0

# headreg:internal/sub_year —— 把「距 1970-01-01 的天数」折算成「年 + 年内第几天」
# 入口：#days = 天数（>=0），#year = 起始年（1970）
# 出口：#days = 年内第几天（0 基），#year = 真实年份
# 递归：每次减掉一整年，减不动就收敛。13 位 ms 最大对应 2286 年。
#
# 年数不靠逐年试减：先从 400 年周期整除粗估起算年（sub_year_seed），
# 剩余不足 2 年再由下面的循环补正，递归深度从 56 层降到 <= 2 层。
# 守卫用 366 而不是 365：剩余 365 天时估算段必然算出 0 年，白跑 20 条。
execute if score #days headreg.calc matches 366.. run function headreg:internal/sub_year_seed
#
# 闰年判定：y%4==0 且 (y%100!=0 或 y%400==0)
scoreboard players set #leap headreg.calc 0
scoreboard players operation #t2 headreg.calc = #year headreg.calc
scoreboard players operation #t2 headreg.calc %= #k4 headreg.calc
execute if score #t2 headreg.calc matches 0 run scoreboard players set #leap headreg.calc 1
scoreboard players operation #t2 headreg.calc = #year headreg.calc
scoreboard players operation #t2 headreg.calc %= #k1e2 headreg.calc
execute if score #t2 headreg.calc matches 0 run scoreboard players set #leap headreg.calc 0
scoreboard players operation #t2 headreg.calc = #year headreg.calc
scoreboard players operation #t2 headreg.calc %= #k400 headreg.calc
execute if score #t2 headreg.calc matches 0 run scoreboard players set #leap headreg.calc 1
scoreboard players set #yd headreg.calc 365
execute if score #leap headreg.calc matches 1 run scoreboard players set #yd headreg.calc 366
#
# 减一年：先把「够不够减」算成一个标志再动 #days ——
# 三条若共用同一个 `if score >= #yd`，第二条会在 #days 已被改小后重新求值而跳过，年份就会少加 1。
scoreboard players set #go headreg.calc 0
execute if score #days headreg.calc >= #yd headreg.calc run scoreboard players set #go headreg.calc 1
execute if score #go headreg.calc matches 1 run scoreboard players operation #days headreg.calc -= #yd headreg.calc
execute if score #go headreg.calc matches 1 run scoreboard players add #year headreg.calc 1
execute if score #go headreg.calc matches 1 run function headreg:internal/sub_year

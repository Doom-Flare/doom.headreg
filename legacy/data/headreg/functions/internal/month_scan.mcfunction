# headreg:internal/month_scan —— 年内第几天 -> 月 / 日（由 build/gen.mjs 生成，勿手改）
# 入口：#doy = 年内第几天（0 基），#leap = 1/0，#mon 必须已置 0
# 出口：#mon = 1..12，#doy 被改写成当月第几天（1 基）

# --- 倒扫命中月份（12 -> 1，第一个满足的就是答案） ---
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 334.. run scoreboard players set #mon headreg.calc 12
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 335.. run scoreboard players set #mon headreg.calc 12
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 304.. run scoreboard players set #mon headreg.calc 11
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 305.. run scoreboard players set #mon headreg.calc 11
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 273.. run scoreboard players set #mon headreg.calc 10
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 274.. run scoreboard players set #mon headreg.calc 10
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 243.. run scoreboard players set #mon headreg.calc 9
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 244.. run scoreboard players set #mon headreg.calc 9
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 212.. run scoreboard players set #mon headreg.calc 8
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 213.. run scoreboard players set #mon headreg.calc 8
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 181.. run scoreboard players set #mon headreg.calc 7
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 182.. run scoreboard players set #mon headreg.calc 7
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 151.. run scoreboard players set #mon headreg.calc 6
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 152.. run scoreboard players set #mon headreg.calc 6
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 120.. run scoreboard players set #mon headreg.calc 5
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 121.. run scoreboard players set #mon headreg.calc 5
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 90.. run scoreboard players set #mon headreg.calc 4
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 91.. run scoreboard players set #mon headreg.calc 4
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 59.. run scoreboard players set #mon headreg.calc 3
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 60.. run scoreboard players set #mon headreg.calc 3
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 31.. run scoreboard players set #mon headreg.calc 2
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 31.. run scoreboard players set #mon headreg.calc 2
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches 0.. run scoreboard players set #mon headreg.calc 1
execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches 0.. run scoreboard players set #mon headreg.calc 1

# --- 折算成「日」：day = doy - (月首 - 1) ---
execute if score #mon headreg.calc matches 12 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 333
execute if score #mon headreg.calc matches 12 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 334
execute if score #mon headreg.calc matches 11 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 303
execute if score #mon headreg.calc matches 11 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 304
execute if score #mon headreg.calc matches 10 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 272
execute if score #mon headreg.calc matches 10 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 273
execute if score #mon headreg.calc matches 9 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 242
execute if score #mon headreg.calc matches 9 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 243
execute if score #mon headreg.calc matches 8 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 211
execute if score #mon headreg.calc matches 8 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 212
execute if score #mon headreg.calc matches 7 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 180
execute if score #mon headreg.calc matches 7 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 181
execute if score #mon headreg.calc matches 6 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 150
execute if score #mon headreg.calc matches 6 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 151
execute if score #mon headreg.calc matches 5 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 119
execute if score #mon headreg.calc matches 5 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 120
execute if score #mon headreg.calc matches 4 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 89
execute if score #mon headreg.calc matches 4 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 90
execute if score #mon headreg.calc matches 3 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 58
execute if score #mon headreg.calc matches 3 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 59
execute if score #mon headreg.calc matches 2 if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc 30
execute if score #mon headreg.calc matches 2 if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc 30
execute if score #mon headreg.calc matches 1 if score #leap headreg.calc matches 0 run scoreboard players add #doy headreg.calc 1
execute if score #mon headreg.calc matches 1 if score #leap headreg.calc matches 1 run scoreboard players add #doy headreg.calc 1

# headreg:internal/clock_anchor —— 用可信的档案时间校正服务器时钟
# 前置：#ts_sec headreg.calc = 本次抓到的档案 epoch 秒（classify / extract_ts 的产物）
# 后置：storage headreg:clock 的 sec/tick 被设定，此后 now_sec 才不再是 0
# 两件事必须同时成立，时钟才准：
#   1) 只向前校正 —— 档案时间可能命中 ProfileResolver 缓存而偏旧，此时 gap < 0 直接跳过，绝不让时钟倒退。
#   2) 门限必须小 —— gametime 不等于墙钟：实测 20 分钟内 TPS 漂移累积 52 秒；门限取 1 秒才不会永久慢。
# 首次锚定：clock.tick 还不存在时直接用档案时间建锚（#gap 预置为 1），否则全新世界永远等不到锚点。
scoreboard players set #cabort headreg.calc 0
execute unless score #ts_sec headreg.calc matches 1000000000.. run scoreboard players set #cabort headreg.calc 1
scoreboard players set #gap headreg.calc 1
execute if score #cabort headreg.calc matches 0 if data storage headreg:clock tick run function headreg:internal/now_sec
execute if score #cabort headreg.calc matches 0 if data storage headreg:clock tick run scoreboard players operation #gap headreg.calc = #ts_sec headreg.calc
execute if score #cabort headreg.calc matches 0 if data storage headreg:clock tick run scoreboard players operation #gap headreg.calc -= #now headreg.calc
execute unless score #gap headreg.calc matches 1.. run scoreboard players set #cabort headreg.calc 1
execute if score #cabort headreg.calc matches 0 store result score #bn headreg.calc run time query gametime
execute if score #cabort headreg.calc matches 0 run execute store result storage headreg:clock sec int 1 run scoreboard players get #ts_sec headreg.calc
execute if score #cabort headreg.calc matches 0 run execute store result storage headreg:clock tick int 1 run scoreboard players get #bn headreg.calc
scoreboard players set #cabort headreg.calc 0

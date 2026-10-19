# headreg:internal/append_history —— 把 headreg:tmp session 追加进记录的历史，超 10 段裁最旧
# 前置：#cur headreg.rec 已设；headreg:tmp cur = 刚写回分桶的记录；headreg:tmp session = 本段
# 后置：cur.history 追加并裁到 ≤10；已重新 push_data；headreg:tmp session 已清
# 必须在 register 的 push_data 之后调用 —— push 是整体覆盖，先追加会被抹掉。
scoreboard players set #habort headreg.calc 0
execute unless score #cur headreg.rec matches 1.. run scoreboard players set #habort headreg.calc 1
execute unless data storage headreg:tmp session run scoreboard players set #habort headreg.calc 1
execute unless data storage headreg:tmp cur run scoreboard players set #habort headreg.calc 1
# 首段：history 还不存在，必须先建空列表，append 才有落点
execute if score #habort headreg.calc matches 0 unless data storage headreg:tmp cur.history run data modify storage headreg:tmp cur.history set value []
execute if score #habort headreg.calc matches 0 run data modify storage headreg:tmp cur.history append from storage headreg:tmp session
execute if score #habort headreg.calc matches 0 run scoreboard players set #hlen headreg.calc 0
execute if score #habort headreg.calc matches 0 store result score #hlen headreg.calc run data get storage headreg:tmp cur.history
execute if score #habort headreg.calc matches 0 if score #hlen headreg.calc matches 11.. run data remove storage headreg:tmp cur.history[0]
execute if score #habort headreg.calc matches 0 run function headreg:internal/push_data
data remove storage headreg:tmp session

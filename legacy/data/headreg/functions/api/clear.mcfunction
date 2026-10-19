# headreg:api/clear —— 清掉执行者自己的记录（便于同一玩家重复测试）
# 用法：execute as <player> run function headreg:api/clear
# 前置：@s 为玩家；load 已建表
# 后置：root.<id>.data 被移除；headreg.id 保留 —— 重复注册仍落回同一编号，
#       这样反复测试不会让分桶无限膨胀。
scoreboard players set #xabort headreg.calc 0
execute unless score @s headreg.id matches 1.. run scoreboard players set #xabort headreg.calc 1
execute if score #xabort headreg.calc matches 1 run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"你还没有任何登记记录。","color":"yellow"}]
execute if score #xabort headreg.calc matches 0 run scoreboard players operation #cur headreg.rec = @s headreg.id
execute if score #xabort headreg.calc matches 0 run function headreg:internal/del_data
execute if score #xabort headreg.calc matches 0 run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"已清除你的登记记录（数字 id 保留，重新注册仍落回同一编号）。","color":"green"}]
data remove storage headreg:tmp cur

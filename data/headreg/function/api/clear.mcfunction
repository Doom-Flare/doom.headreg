# headreg:api/clear —— 清掉执行者自己的记录（便于同一玩家重复测试）
# 只删除 root.<id>.data，保留 headreg.id 记分板值，使重复注册落回同一分桶。
# 也不动 storage headreg:ids（活跃 id 列表）：id 仍在，重注册不会再走 assign_id，
# 一旦把号从列表里删掉就永久漏扫。空桶由 list_one 的 if data 兜住，api/list 不会多打一行。
# 用法：execute as <player> run function headreg:api/clear
execute unless score @s headreg.id matches 1.. run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.api.clear.none","fallback":"你还没有任何登记记录。","color":"yellow"}]
execute unless score @s headreg.id matches 1.. run return 0
execute store result storage headreg:data root.target_id int 1 run scoreboard players get @s headreg.id
function headreg:internal/del_data with storage headreg:data root
data remove storage headreg:data root.target_id
data remove storage headreg:data root.working_data
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.api.clear.done","fallback":"已清除你的登记记录（数字 id 保留）。","color":"green"}]

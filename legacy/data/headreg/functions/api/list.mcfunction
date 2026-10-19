# headreg:api/list —— 列出全部已登记玩家（编号 + 名字 + 首次登记时刻）
# 入口一：/function headreg:api/list（函数级命令，需 OP）
# 入口二：/trigger headreg.qlist（人人可用，经 internal/list_by_trigger 到这里）
# 前置：headreg.next 的 #init = 已分配的最大编号（0 表示还没有人登记）
# 代价：O(#init × 一次 pull_data)，只在管理员手动调用时执行（§12）
# 注意：list_scan 是递归实现，每份记录约 70 条命令；默认 gamerule maxCommandChainLength=65536，
#       因此满表（1023 份）会超出命令链上限而中途截断。要一次列全请先
#       /gamerule maxCommandChainLength 200000，或直接按编号查 api/query_id。
tellraw @s [{"text":"[headreg] ","color":"gray"},{"text":"已登记玩家：","color":"white"}]
scoreboard players set #li headreg.calc 1
scoreboard players set #cnt headreg.calc 0
scoreboard players operation #init headreg.calc = #init headreg.next
function headreg:internal/list_scan
tellraw @s [{"text":"[headreg] ","color":"gray"},{"text":"共 ","color":"gray"},{"score":{"name":"#cnt","objective":"headreg.calc"},"color":"white"},{"text":" 份记录","color":"gray"}]
data remove storage headreg:tmp cur

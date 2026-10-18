# headreg:api/query_id —— 按数字 id 查询任意已登记玩家（含历史会话）
# 用法（OP / 控制台）：/execute as <查看者> run function headreg:api/query_id {id:10}
# 用法（普通玩家）：先 /function headreg:api/list 找自己的编号，再 /trigger headreg.query set 10
# 注意：结果是用 tellraw 打给 @s，所以必须在「以某个玩家身份执行」时才有输出
$execute unless data storage headreg:data root.$(id) run tellraw @s [{"text":"[headreg] ","color":"gray"},{"text":"没有 id 为 $(id) 的登记记录","color":"red"}]
$execute if data storage headreg:data root.$(id) run tellraw @s [{"text":"[headreg] ","color":"gray"},{"text":"#$(id) ","color":"dark_gray"},{"nbt":"root.$(id).data.name","storage":"headreg:data","color":"white"},{"text":"   正版 ","color":"gray"},{"nbt":"root.$(id).data.premium","storage":"headreg:data","color":"green"}]
$execute if data storage headreg:data root.$(id) run tellraw @s [{"text":"  初次 ","color":"gray"},{"nbt":"root.$(id).data.first_date_str","storage":"headreg:data","color":"yellow"},{"text":"   本次 ","color":"gray"},{"nbt":"root.$(id).data.date_str","storage":"headreg:data","color":"gold"}]
$execute if data storage headreg:data root.$(id) run tellraw @s [{"text":"  登记 ","color":"gray"},{"nbt":"root.$(id).data.reg_count","storage":"headreg:data","color":"white"},{"text":" 次   离开 ","color":"gray"},{"nbt":"root.$(id).data.prev_leave","storage":"headreg:data","color":"white"},{"text":" 次   上段在线 ","color":"gray"},{"nbt":"root.$(id).data.prev_play","storage":"headreg:data","color":"white"},{"text":" tick","color":"dark_gray"}]
$execute if data storage headreg:data root.$(id) run tellraw @s [{"text":"  uuid ","color":"gray"},{"nbt":"root.$(id).data.uuid_str","storage":"headreg:data","color":"dark_aqua"}]

# 历史会话（最多 10 段，旧 → 新）
$scoreboard players set #qid headreg.calc $(id)
scoreboard players set #qlen headreg.calc 0
$execute store result score #qlen headreg.calc run data get storage headreg:data root.$(id).data.history
scoreboard players set #qi headreg.calc 1
execute if score #qlen headreg.calc matches 1.. run tellraw @s [{"text":"  历史会话 ","color":"gray"},{"score":{"name":"#qlen","objective":"headreg.calc"},"color":"white"},{"text":" 段（旧 → 新）","color":"dark_gray"}]
execute if score #qlen headreg.calc matches 1.. run function headreg:internal/render_history
$execute if data storage headreg:data root.$(id) if score #qlen headreg.calc matches ..0 run tellraw @s [{"text":"  历史会话 暂无（要等下一次进服结算出上一段）","color":"dark_gray"}]

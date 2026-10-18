# headreg:api/query —— 读回执行者自己已登记的记录并用 tellraw 显示
# 用法：execute as <player> run function headreg:api/query
execute unless score @s headreg.id matches 1.. run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"你还没有登记记录，先执行 /function headreg:api/register","color":"yellow"}]
execute unless score @s headreg.id matches 1.. run return 0
execute store result storage headreg:data root.target_id int 1 run scoreboard players get @s headreg.id
data remove storage headreg:data root.working_data
function headreg:internal/pull_data with storage headreg:data root
execute unless data storage headreg:data root.working_data run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"分桶里没有你的记录，先执行 /function headreg:api/register","color":"yellow"}]
execute unless data storage headreg:data root.working_data run return 0
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"已登记档案","color":"gold"}]
tellraw @s [{"text":"  名称: ","color":"gray"},{"nbt":"root.working_data.name","storage":"headreg:data","color":"white"},{"text":"  数字id: ","color":"gray"},{"score":{"name":"@s","objective":"headreg.id"},"color":"white"}]
execute if data storage headreg:data root.working_data{premium:1b} run tellraw @s [{"text":"  正版: ","color":"gray"},{"text":"是（档案含 textures 签名）","color":"green"}]
execute unless data storage headreg:data root.working_data{premium:1b} run tellraw @s [{"text":"  正版: ","color":"gray"},{"text":"否（离线档案，profile 内没有 properties）","color":"red"}]
tellraw @s [{"text":"  uuid: ","color":"gray"},{"nbt":"root.working_data.uuid_str","storage":"headreg:data","color":"white"}]
tellraw @s [{"text":"  ts_ms: ","color":"gray"},{"nbt":"root.working_data.ts_ms","storage":"headreg:data","color":"aqua"},{"text":"  ts_sec: ","color":"gray"},{"nbt":"root.working_data.ts_sec","storage":"headreg:data","color":"aqua"}]
tellraw @s [{"text":"  初次档案(UTC): ","color":"gray"},{"nbt":"root.working_data.first_date_str","storage":"headreg:data","color":"yellow"},{"text":"  本次档案(UTC): ","color":"gray"},{"nbt":"root.working_data.date_str","storage":"headreg:data","color":"gold"}]
function headreg:internal/format_now
function headreg:internal/format_leave
function headreg:internal/session_stats
tellraw @s [{"text":"  现在(UTC): ","color":"gray"},{"nbt":"root.working_data.now_date_str","storage":"headreg:data","color":"aqua"},{"text":"  ← 服务器时钟推算，随 tick 走动","color":"dark_gray"}]
tellraw @s [{"text":"  本次在线: ","color":"gray"},{"score":{"name":"#sm","objective":"headreg.calc"},"color":"green"},{"text":" 分 ","color":"gray"},{"score":{"name":"#ss","objective":"headreg.calc"},"color":"green"},{"text":" 秒   累计在线: ","color":"gray"},{"score":{"name":"#tm","objective":"headreg.calc"},"color":"green"},{"text":" 分 ","color":"gray"},{"score":{"name":"#ts2","objective":"headreg.calc"},"color":"green"},{"text":" 秒","color":"gray"}]
execute unless data storage headreg:data root.working_data{settled:1b} run tellraw @s [{"text":"  上段: ","color":"gray"},{"text":"首次登记（没有可结算的上一段）","color":"dark_gray"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b} run tellraw @s [{"text":"  离开次数: ","color":"gray"},{"score":{"name":"@s","objective":"headreg.leave"},"color":"white"},{"text":"   上次离开(约): ","color":"gray"},{"nbt":"root.working_data.last_leave_str","storage":"headreg:data","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:0b} run tellraw @s [{"text":"  上段: ","color":"gray"},{"text":"无结束登记（服务端关服下线或统计未落盘）；离开时刻不可信，已隐藏","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"global"} run tellraw @s [{"text":"  上次结束: ","color":"gray"},{"text":"与 ","color":"yellow"},{"nbt":"root.working_data.exit_peers","storage":"headreg:data","color":"yellow"},{"text":" 人同一时刻消失（同一事件：关服 / 全服掉线）","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"personal"} run tellraw @s [{"text":"  上次结束: ","color":"gray"},{"text":"单独离开（同服另有 ","color":"aqua"},{"nbt":"root.working_data.exit_seen","storage":"headreg:data","color":"aqua"},{"text":" 份记录，均不在该时刻）","color":"aqua"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"solo"} run tellraw @s [{"text":"  上次结束: ","color":"gray"},{"text":"单独离开（无可比较的同伴，无法判全局/个人）","color":"dark_aqua"}]
execute if data storage headreg:data root.working_data{prev_clean:0b} run tellraw @s [{"text":"  上段结束: ","color":"gray"},{"text":"无结束登记（上次是服务端关服下线，或统计未落盘）","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b} if data storage headreg:data root.working_data.prev_play run tellraw @s [{"text":"  上段在线(tick): ","color":"gray"},{"nbt":"root.working_data.prev_play","storage":"headreg:data","color":"white"}]
tellraw @s [{"text":"  登记次数: ","color":"gray"},{"nbt":"root.working_data.reg_count","storage":"headreg:data","color":"white"}]
tellraw @s [{"text":"  fetched_at（tick）: ","color":"gray"},{"nbt":"root.working_data.fetched_at","storage":"headreg:data","color":"white"}]
data remove storage headreg:data root.target_id

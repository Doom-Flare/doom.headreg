# headreg:api/query —— 读回执行者自己已登记的记录并用 tellraw 显示
# 用法：execute as <player> run function headreg:api/query
execute unless score @s headreg.id matches 1.. run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.cmd.need_register","fallback":"你还没有登记记录，先执行 /function headreg:api/register","color":"yellow"}]
execute unless score @s headreg.id matches 1.. run return 0
execute store result storage headreg:data root.target_id int 1 run scoreboard players get @s headreg.id
data remove storage headreg:data root.working_data
function headreg:internal/pull_data with storage headreg:data root
execute unless data storage headreg:data root.working_data run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.cmd.need_register_bucket","fallback":"分桶里没有你的记录，先执行 /function headreg:api/register","color":"yellow"}]
execute unless data storage headreg:data root.working_data run return 0
# 显示前先按当前时区把档案级时间串从 *_sec 重渲染一遍（now/last_leave 由 format_now / format_leave 现算）
function headreg:internal/tz_refresh_one
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.api.query.header","fallback":"已登记档案","color":"gold"}]
tellraw @s [{"translate":"headreg.field.name","fallback":"  名称: ","color":"gray"},{"nbt":"root.working_data.name","storage":"headreg:data","color":"white"},{"translate":"headreg.field.id","fallback":"  数字id: ","color":"gray"},{"score":{"name":"@s","objective":"headreg.id"},"color":"white"}]
execute if data storage headreg:data root.working_data{premium:1b} run tellraw @s [{"translate":"headreg.field.premium","fallback":"  正版: ","color":"gray"},{"translate":"headreg.value.premium_yes","fallback":"是（档案含 textures 签名）","color":"green"}]
execute unless data storage headreg:data root.working_data{premium:1b} run tellraw @s [{"translate":"headreg.field.premium","fallback":"  正版: ","color":"gray"},{"translate":"headreg.value.premium_no","fallback":"否（离线档案，profile 内没有 properties）","color":"red"}]
tellraw @s [{"text":"  uuid: ","color":"gray"},{"nbt":"root.working_data.uuid_str","storage":"headreg:data","color":"white"}]
tellraw @s [{"text":"  ts_ms: ","color":"gray"},{"nbt":"root.working_data.ts_ms","storage":"headreg:data","color":"aqua"},{"text":"  ts_sec: ","color":"gray"},{"nbt":"root.working_data.ts_sec","storage":"headreg:data","color":"aqua"}]
tellraw @s [{"translate":"headreg.field.first_seen","fallback":"  初次档案: ","color":"gray"},{"nbt":"root.working_data.first_date_str","storage":"headreg:data","color":"yellow"},{"translate":"headreg.field.this_seen","fallback":"  本次档案: ","color":"gray"},{"nbt":"root.working_data.date_str","storage":"headreg:data","color":"gold"}]
function headreg:internal/format_now
function headreg:internal/format_leave
function headreg:internal/session_stats
tellraw @s [{"translate":"headreg.field.now","fallback":"  现在: ","color":"gray"},{"nbt":"root.working_data.now_date_str","storage":"headreg:data","color":"aqua"},{"translate":"headreg.field.zone","fallback":"  时区: ","color":"dark_gray"},{"nbt":"tz","storage":"headreg:config","color":"dark_gray"},{"translate":"headreg.hint.clock_derived","fallback":"  ← 服务器时钟推算，随 tick 走动","color":"dark_gray"}]
tellraw @s [{"translate":"headreg.field.session_play","fallback":"  本次在线: ","color":"gray"},{"score":{"name":"#sm","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.unit.minute","fallback":" 分 ","color":"gray"},{"score":{"name":"#ss","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.field.total_play_mid","fallback":" 秒   累计在线: ","color":"gray"},{"score":{"name":"#tm","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.unit.minute","fallback":" 分 ","color":"gray"},{"score":{"name":"#ts2","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.unit.second","fallback":" 秒","color":"gray"}]
execute unless data storage headreg:data root.working_data{settled:1b} run tellraw @s [{"translate":"headreg.field.prev","fallback":"  上段: ","color":"gray"},{"translate":"headreg.value.first_register","fallback":"首次登记（没有可结算的上一段）","color":"dark_gray"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b} run tellraw @s [{"translate":"headreg.field.leave_count","fallback":"  离开次数: ","color":"gray"},{"score":{"name":"@s","objective":"headreg.leave"},"color":"white"},{"translate":"headreg.field.last_leave","fallback":"   上次离开(约): ","color":"gray"},{"nbt":"root.working_data.last_leave_str","storage":"headreg:data","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:0b} run tellraw @s [{"translate":"headreg.field.prev","fallback":"  上段: ","color":"gray"},{"translate":"headreg.value.no_leave_ts","fallback":"无结束登记（服务端关服下线或统计未落盘）；离开时刻不可信，已隐藏","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"global"} run tellraw @s [{"translate":"headreg.field.prev_exit","fallback":"  上次结束: ","color":"gray"},{"translate":"headreg.exit.peers","fallback":"与 %s 人同一时刻消失（同一事件：关服 / 全服掉线）","with":[{"nbt":"root.working_data.exit_peers","storage":"headreg:data"}],"color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"personal"} run tellraw @s [{"translate":"headreg.field.prev_exit","fallback":"  上次结束: ","color":"gray"},{"translate":"headreg.exit.seen","fallback":"单独离开（同服另有 %s 份记录，均不在该时刻）","with":[{"nbt":"root.working_data.exit_seen","storage":"headreg:data"}],"color":"aqua"}]
execute if data storage headreg:data root.working_data{settled:1b,prev_clean:1b,exit_kind:"solo"} run tellraw @s [{"translate":"headreg.field.prev_exit","fallback":"  上次结束: ","color":"gray"},{"translate":"headreg.value.exit_solo","fallback":"单独离开（无可比较的同伴，无法判全局/个人）","color":"dark_aqua"}]
execute if data storage headreg:data root.working_data{prev_clean:0b} run tellraw @s [{"translate":"headreg.field.prev_exit_raw","fallback":"  上段结束: ","color":"gray"},{"translate":"headreg.value.no_prev_exit","fallback":"无结束登记（上次是服务端关服下线，或统计未落盘）","color":"yellow"}]
execute if data storage headreg:data root.working_data{settled:1b} if data storage headreg:data root.working_data.prev_play run tellraw @s [{"translate":"headreg.field.prev_play","fallback":"  上段在线(tick): ","color":"gray"},{"nbt":"root.working_data.prev_play","storage":"headreg:data","color":"white"}]
tellraw @s [{"translate":"headreg.field.reg_count","fallback":"  登记次数: ","color":"gray"},{"nbt":"root.working_data.reg_count","storage":"headreg:data","color":"white"}]
tellraw @s [{"translate":"headreg.field.fetched_at","fallback":"  fetched_at（tick）: ","color":"gray"},{"nbt":"root.working_data.fetched_at","storage":"headreg:data","color":"white"}]
data remove storage headreg:data root.target_id

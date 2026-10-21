# headreg:api/query_id —— 按数字 id 查询任意已登记玩家（含最近 10 段历史）
# 前置：#qid headreg.calc ≥ 1；@s = 接收 tellraw 的玩家
# 后置：headreg:tmp cur 已清（渲染完就收，避免残留到下一个人）
# 说明：legacy 无宏，记录一次读到 headreg:tmp cur 后整段渲染；日期用 14 个一位分数现拼（§4，不存 date_str）。
scoreboard players set #qabort headreg.calc 0
execute unless score #qid headreg.calc matches 1.. run scoreboard players set #qabort headreg.calc 1

# 1) 读记录
execute if score #qabort headreg.calc matches 0 run scoreboard players operation #cur headreg.rec = #qid headreg.calc
execute if score #qabort headreg.calc matches 0 run function headreg:internal/pull_data
execute if score #qabort headreg.calc matches 0 unless score #hit headreg.rec matches 1 run scoreboard players set #qabort headreg.calc 1
execute if score #qabort headreg.calc matches 0 unless score #hit headreg.rec matches 1 run tellraw @s [{"text":"[headreg] ","color":"gray"},{"translate":"headreg.cmd.no_such_id_prefix","fallback":"没有 id 为 ","color":"red"},{"score":{"name":"#qid","objective":"headreg.calc"},"color":"red"},{"translate":"headreg.cmd.no_such_id_suffix","fallback":" 的登记记录","color":"red"}]

# 2) 头两行：编号 + 名字 + 正版 + 首次登记时刻
execute if score #qabort headreg.calc matches 0 run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"#","color":"dark_gray"},{"score":{"name":"#qid","objective":"headreg.calc"},"color":"dark_gray"},{"text":" ","color":"dark_gray"},{"nbt":"cur.name","storage":"headreg:tmp","color":"white"},{"translate":"headreg.qid.premium","fallback":"   正版 ","color":"gray"},{"nbt":"cur.premium","storage":"headreg:tmp","color":"green"}]
execute if score #qabort headreg.calc matches 0 run scoreboard players set #t headreg.calc 0
execute if score #qabort headreg.calc matches 0 store result score #t headreg.calc run data get storage headreg:tmp cur.first_sec
execute if score #qabort headreg.calc matches 0 run function headreg:internal/format_time
execute if score #qabort headreg.calc matches 0 run tellraw @s [{"translate":"headreg.qid.first_sec","fallback":"  首次登记(UTC) ","color":"gray"},{"score":{"name":"#ya","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yb","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yc","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yd","objective":"headreg.calc"},"color":"yellow"},{"text":"-","color":"yellow"},{"score":{"name":"#moh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#mol","objective":"headreg.calc"},"color":"yellow"},{"text":"-","color":"yellow"},{"score":{"name":"#dh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#dl","objective":"headreg.calc"},"color":"yellow"},{"text":" ","color":"yellow"},{"score":{"name":"#hh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#hl","objective":"headreg.calc"},"color":"yellow"},{"text":":","color":"yellow"},{"score":{"name":"#mih","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#mil","objective":"headreg.calc"},"color":"yellow"},{"text":":","color":"yellow"},{"score":{"name":"#sh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#sl","objective":"headreg.calc"},"color":"yellow"},{"translate":"headreg.qid.reg_v2","fallback":"   登记 ","color":"gray"},{"nbt":"cur.reg_count","storage":"headreg:tmp","color":"white"},{"translate":"headreg.qid.times","fallback":" 次","color":"gray"}]

# 3) 上次结算时刻 + 上段时长
execute if score #qabort headreg.calc matches 0 run function headreg:internal/format_leave
execute if score #qabort headreg.calc matches 0 run tellraw @s [{"translate":"headreg.qid.last_sec","fallback":"  上次结算(UTC) ","color":"gray"},{"score":{"name":"#ya","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yb","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yc","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#yd","objective":"headreg.calc"},"color":"yellow"},{"text":"-","color":"yellow"},{"score":{"name":"#moh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#mol","objective":"headreg.calc"},"color":"yellow"},{"text":"-","color":"yellow"},{"score":{"name":"#dh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#dl","objective":"headreg.calc"},"color":"yellow"},{"text":" ","color":"yellow"},{"score":{"name":"#hh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#hl","objective":"headreg.calc"},"color":"yellow"},{"text":":","color":"yellow"},{"score":{"name":"#mih","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#mil","objective":"headreg.calc"},"color":"yellow"},{"text":":","color":"yellow"},{"score":{"name":"#sh","objective":"headreg.calc"},"color":"yellow"},{"score":{"name":"#sl","objective":"headreg.calc"},"color":"yellow"},{"translate":"headreg.qid.prevplay_plain","fallback":"   上段在线 ","color":"gray"},{"nbt":"cur.prev_play","storage":"headreg:tmp","color":"white"},{"translate":"headreg.qid.exit_kind","fallback":" tick   离开方式 ","color":"gray"},{"nbt":"cur.exit_kind","storage":"headreg:tmp","color":"gold"}]

# 4) 历史会话（旧 → 新）
scoreboard players set #qlen headreg.calc 0
execute if score #qabort headreg.calc matches 0 store result score #qlen headreg.calc run data get storage headreg:tmp cur.history
execute if score #qabort headreg.calc matches 0 if score #qlen headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.qid.history","fallback":"  历史会话 ","color":"gray"},{"score":{"name":"#qlen","objective":"headreg.calc"},"color":"white"},{"translate":"headreg.qid.history_order","fallback":" 段（旧 → 新）","color":"dark_gray"}]
execute if score #qabort headreg.calc matches 0 run scoreboard players set #qi headreg.calc 1
execute if score #qabort headreg.calc matches 0 if score #qlen headreg.calc matches 1.. run function headreg:internal/render_history
execute if score #qabort headreg.calc matches 0 if score #qlen headreg.calc matches ..0 run tellraw @s [{"translate":"headreg.qid.history_empty","fallback":"  历史会话 暂无（要等下一次进服结算出上一段）","color":"dark_gray"}]
data remove storage headreg:tmp cur

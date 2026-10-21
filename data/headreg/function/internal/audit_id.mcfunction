# headreg:internal/audit_id —— 对 $(id) 这份档案做 7 项一致性检查
# 入口：storage headreg:audit {id:<数字>}
# 说明：只读；失败项累加到 #bad（objective headreg.audit），不修改被审计的数据
# 注意：1.21.11 里含 $(变量) 的行必须以 $ 开头才会做宏替换，否则原样当字面量执行而静默失败
scoreboard players set #bad headreg.audit 0
scoreboard players set #n headreg.audit 0
scoreboard players set #a headreg.audit -1
scoreboard players set #b headreg.audit -1
scoreboard players set #c headreg.audit -1
scoreboard players set #l headreg.audit -1
$scoreboard players set #id headreg.audit $(id)

# 1) history 最多 10 段
scoreboard players add #n headreg.audit 1
$execute if data storage headreg:data root.$(id).data.history[10] run scoreboard players add #bad headreg.audit 1
$execute if data storage headreg:data root.$(id).data.history[10] run tellraw @s [{"translate":"headreg.audit.err.history_overflow","fallback":"[audit] ✗ history 超过 10 段","color":"red"}]

# 2) 末段自洽：in_sec < out_sec，且 dur_sec == out_sec - in_sec（容差 ±1 秒）
scoreboard players add #n headreg.audit 1
$execute store result score #a headreg.audit run data get storage headreg:data root.$(id).data.history[-1].in_sec
$execute store result score #b headreg.audit run data get storage headreg:data root.$(id).data.history[-1].out_sec
$execute store result score #c headreg.audit run data get storage headreg:data root.$(id).data.history[-1].dur_sec
$execute if data storage headreg:data root.$(id).data.history[0] run function headreg:internal/audit_seg with storage headreg:audit

# 3) 末段 out_sec 不得晚于 last_leave_sec（仅在档案确实有 last_leave_sec 时判定）
scoreboard players add #n headreg.audit 1
$execute store result score #l headreg.audit run data get storage headreg:data root.$(id).data.last_leave_sec
$execute if data storage headreg:data root.$(id).data.last_leave_sec if data storage headreg:data root.$(id).data.history[0] if score #b headreg.audit > #l headreg.audit run scoreboard players add #bad headreg.audit 1
$execute if data storage headreg:data root.$(id).data.last_leave_sec if data storage headreg:data root.$(id).data.history[0] if score #b headreg.audit > #l headreg.audit run tellraw @s [{"translate":"headreg.audit.err.out_after_leave","fallback":"[audit] ✗ 末段 out_sec 晚于 last_leave_sec","color":"red"}]

# 4) 已结算的档案：exit_kind 必须是 personal / global / solo 之一
scoreboard players add #n headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b} unless data storage headreg:data root.$(id).data{exit_kind:"personal"} unless data storage headreg:data root.$(id).data{exit_kind:"global"} unless data storage headreg:data root.$(id).data{exit_kind:"solo"} run scoreboard players add #bad headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b} unless data storage headreg:data root.$(id).data{exit_kind:"personal"} unless data storage headreg:data root.$(id).data{exit_kind:"global"} unless data storage headreg:data root.$(id).data{exit_kind:"solo"} run tellraw @s [{"translate":"headreg.audit.err.exit_kind","fallback":"[audit] ✗ exit_kind 取值非法（已结算却给了非法值）","color":"red"}]

# 5) 已结算的档案必须有上段时长，或明确标了「关服回档」
scoreboard players add #n headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b} unless data storage headreg:data root.$(id).data.prev_play unless data storage headreg:data root.$(id).data{prev_clean:0b} run scoreboard players add #bad headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b} unless data storage headreg:data root.$(id).data.prev_play unless data storage headreg:data root.$(id).data{prev_clean:0b} run tellraw @s [{"translate":"headreg.audit.err.missing_prev_play","fallback":"[audit] ✗ 已结算但没有 prev_play（且未标关服回档）","color":"red"}]

# 6) 索引一致：index[名字] 必须回指同一个 id
scoreboard players add #n headreg.audit 1
$data modify storage headreg:audit look.name set from storage headreg:data root.$(id).data.name
execute if data storage headreg:audit look.name run function headreg:internal/audit_index with storage headreg:audit look
execute unless data storage headreg:audit look.name run scoreboard players add #bad headreg.audit 1
execute unless data storage headreg:audit look.name run tellraw @s [{"translate":"headreg.audit.err.no_name","fallback":"[audit] ✗ 档案里没有 name 字段","color":"red"}]

# 7) last_leave_sec 必须是正整数（已结算且正版：正版才有服务器时钟，离线服缺字段是正常现象）
scoreboard players add #n headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b,premium:1b} unless score #l headreg.audit matches 1.. run scoreboard players add #bad headreg.audit 1
$execute if data storage headreg:data root.$(id).data{settled:1b,premium:1b} unless score #l headreg.audit matches 1.. run tellraw @s [{"translate":"headreg.audit.err.premium_no_leave","fallback":"[audit] ✗ 正版档案已结算却没有 last_leave_sec","color":"red"}]

# 汇总
execute if score #bad headreg.audit matches 0 run tellraw @s [{"translate":"headreg.audit.ok.all","fallback":"[audit] ✓ 7 项全过（无历史段时跳过段内检查）","color":"green"}]
execute unless score #bad headreg.audit matches 0 run tellraw @s [{"translate":"headreg.audit.summary.fail_prefix","fallback":"[audit] ✗ 失败 ","color":"red"},{"score":{"name":"#bad","objective":"headreg.audit"},"color":"red"},{"translate":"headreg.audit.summary.mid","fallback":" 项 / 共 ","color":"gray"},{"score":{"name":"#n","objective":"headreg.audit"}},{"translate":"headreg.audit.summary.suffix","fallback":" 项","color":"gray"}]
data remove storage headreg:audit look

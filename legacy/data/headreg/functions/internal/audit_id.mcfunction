# headreg:internal/audit_id —— 对 #qid 这份档案做 6 项一致性检查
# 前置：#qid ≥ 1；@s = 接收输出的玩家
# 后置：#bad = 失败项数、#n = 检查项数；headreg:tmp cur 已读入；不修改被审计的记录
scoreboard players set #aabort headreg.calc 0
execute if score #aabort headreg.calc matches 0 run scoreboard players operation #cur headreg.rec = #qid headreg.calc
execute if score #aabort headreg.calc matches 0 run function headreg:internal/pull_data
execute if score #aabort headreg.calc matches 0 unless score #hit headreg.rec matches 1 run scoreboard players set #aabort headreg.calc 1
execute if score #aabort headreg.calc matches 1 run tellraw @s [{"translate":"headreg.audit.no_bucket_prefix","fallback":"[headreg] 分桶里没有 #","color":"red"},{"score":{"name":"#qid","objective":"headreg.calc"},"color":"red"},{"translate":"headreg.audit.no_bucket_suffix","fallback":" 的档案。","color":"red"}]

# 1) history 最多 10 段
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[10] run scoreboard players add #au_bad headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[10] run tellraw @s [{"translate":"headreg.audit.err.history_overflow","fallback":"[audit] ✗ history 超过 10 段","color":"red"}]

# 2) 段内自洽：dur_sec == out_sec - in_sec（容差 ±1 秒），逐个槽位查
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 0
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[0] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[1] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 2
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[2] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 3
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[3] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 4
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[4] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 5
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[5] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 6
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[6] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 7
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[7] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 8
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[8] run function headreg:internal/audit_seg
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_seg headreg.calc 9
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[9] run function headreg:internal/audit_seg

# 3) 末段 out_sec 不得晚于 last_leave_sec
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_l headreg.calc 0
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_b headreg.calc 0
execute if score #aabort headreg.calc matches 0 store result score #au_l headreg.calc run data get storage headreg:tmp cur.last_leave_sec
execute if score #aabort headreg.calc matches 0 store result score #au_b headreg.calc run data get storage headreg:tmp cur.history[-1].out_sec
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[0] if data storage headreg:tmp cur.last_leave_sec if score #au_b headreg.calc > #au_l headreg.calc run scoreboard players add #au_bad headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur.history[0] if data storage headreg:tmp cur.last_leave_sec if score #au_b headreg.calc > #au_l headreg.calc run tellraw @s [{"translate":"headreg.audit.err.out_after_leave","fallback":"[audit] ✗ 末段 out_sec 晚于 last_leave_sec","color":"red"}]

# 4) 已结算的档案：exit_kind 必须是 personal / global / solo 之一
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur{settled:1b} unless data storage headreg:tmp cur{exit_kind:"personal"} unless data storage headreg:tmp cur{exit_kind:"global"} unless data storage headreg:tmp cur{exit_kind:"solo"} run scoreboard players add #au_bad headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur{settled:1b} unless data storage headreg:tmp cur{exit_kind:"personal"} unless data storage headreg:tmp cur{exit_kind:"global"} unless data storage headreg:tmp cur{exit_kind:"solo"} run tellraw @s [{"translate":"headreg.audit.err.exit_kind","fallback":"[audit] ✗ exit_kind 取值非法（已结算却给了非法值）","color":"red"}]

# 5) 已结算的档案必须有 prev_play
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur{settled:1b} unless data storage headreg:tmp cur.prev_play run scoreboard players add #au_bad headreg.calc 1
execute if score #aabort headreg.calc matches 0 if data storage headreg:tmp cur{settled:1b} unless data storage headreg:tmp cur.prev_play run tellraw @s [{"translate":"headreg.audit.err.missing_prev_play_v2","fallback":"[audit] ✗ 已结算但没有 prev_play","color":"red"}]

# 6) ts_sec 必须存在且非负
execute if score #aabort headreg.calc matches 0 run scoreboard players add #au_n headreg.calc 1
execute if score #aabort headreg.calc matches 0 run scoreboard players set #au_tsa headreg.calc -1
execute if score #aabort headreg.calc matches 0 store result score #au_tsa headreg.calc run data get storage headreg:tmp cur.ts_sec
execute if score #aabort headreg.calc matches 0 unless score #au_tsa headreg.calc matches 0.. run scoreboard players add #au_bad headreg.calc 1
execute if score #aabort headreg.calc matches 0 unless score #au_tsa headreg.calc matches 0.. run tellraw @s [{"translate":"headreg.audit.err.ts_sec_invalid","fallback":"[audit] ✗ ts_sec 缺失或为负","color":"red"}]

# 汇总
execute if score #aabort headreg.calc matches 0 if score #au_bad headreg.calc matches 0 run tellraw @s [{"text":"[audit] ✓ ","color":"green"},{"score":{"name":"#au_n","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.audit.summary.all_ok_suffix","fallback":" 项全过","color":"green"}]
execute if score #aabort headreg.calc matches 0 unless score #au_bad headreg.calc matches 0 run tellraw @s [{"translate":"headreg.audit.summary.fail_prefix","fallback":"[audit] ✗ 失败 ","color":"red"},{"score":{"name":"#au_bad","objective":"headreg.calc"},"color":"red"},{"translate":"headreg.audit.summary.mid","fallback":" 项 / 共 ","color":"gray"},{"score":{"name":"#au_n","objective":"headreg.calc"}},{"translate":"headreg.audit.summary.suffix","fallback":" 项","color":"gray"}]

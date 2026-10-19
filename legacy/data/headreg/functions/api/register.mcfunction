# headreg:api/register —— 对执行者玩家做一次注册
# 用法：execute as <player> run function headreg:api/register
# 前置：@s 为玩家；load 已建表（headreg.calc / headreg.id / headreg.next / headreg.rec / headreg.last_seen）
# 后置：root.<编号>.data 已写（含本次 history 段）；headreg:tmp cur/prev/prof/session/seg 已清
# 流程：只服务玩家 → 分配编号 → 自愈中转实体 → 读旧记录并快照到 prev → 抓头颅 → 默认值 → 正版判定
#      → 时钟校正 → 继承只写一次/累计字段 → 结算上一段 → 会话基线 → 登记数 +1 → 写回 → 追加历史 → 回报
# 与主线的差异（§4）：没有 uuid_str / date_str / ts_ms / fetched_at，字符串一律改整数秒；
#   legacy 没有索引，故 push_data 之后不调 put_index。

scoreboard players set #abort headreg.calc 0
execute unless entity @s[type=minecraft:player] run scoreboard players set #abort headreg.calc 1

# 1) 编号：没有就分配（assign_id 超限时把 id 置 0 并置 #idfull=1）
#    上界写 1023 而不是 assign_id 注释里的 1024：分桶是 0..15 × 0..63，只覆盖 1..1023，
#    id=1024 会算成 16 号桶（不存在）而静默写不进去，宁可在门口拒绝。
execute if score #abort headreg.calc matches 0 unless score @s headreg.id matches 1.. run function headreg:internal/assign_id
execute if score #abort headreg.calc matches 0 unless score @s headreg.id matches 1..1023 run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"编号已用尽（上限 1023），本次不登记。","color":"red"}]
execute if score #abort headreg.calc matches 0 unless score @s headreg.id matches 1..1023 run scoreboard players set @s headreg.id 0
execute if score #abort headreg.calc matches 0 unless score @s headreg.id matches 1..1023 run scoreboard players set #abort headreg.calc 1

# 2) 自愈：共享中转头颅实体若被外部清掉，就地重建（否则 grab_head 会静默读不到档案）
execute if score #abort headreg.calc matches 0 in minecraft:overworld unless entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run function headreg:internal/ensure_display

# 3) 读旧记录到中转槽，并整块快照到 headreg:tmp prev
#    快照必须排在 grab_head 之前：grab_head 会动 cur，而后面所有继承都以旧记录为准。
execute if score #abort headreg.calc matches 0 run scoreboard players operation #cur headreg.rec = @s headreg.id
execute if score #abort headreg.calc matches 0 run data remove storage headreg:tmp prev
execute if score #abort headreg.calc matches 0 run function headreg:internal/pull_data
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp cur run data modify storage headreg:tmp prev set from storage headreg:tmp cur

# 4) 抓头颅 → headreg:tmp prof + #found
execute if score #abort headreg.calc matches 0 run function headreg:internal/grab_head
execute if score #abort headreg.calc matches 0 if score #found headreg.calc matches 0 run function headreg:internal/report_fail
execute if score #abort headreg.calc matches 0 if score #found headreg.calc matches 0 run scoreboard players set #abort headreg.calc 1

# 5) 首次登记时 cur 是空的：先建骨架，否则后面的 set value / store result int 找不到父路径会静默失败
execute if score #abort headreg.calc matches 0 if score #hit headreg.rec matches 0 run data merge storage headreg:tmp {cur:{}}

# 6) 字段默认值（§9 schema）
execute if score #abort headreg.calc matches 0 run data modify storage headreg:tmp cur.premium set value 0b
execute if score #abort headreg.calc matches 0 run data modify storage headreg:tmp cur.ts_sec set value 0
# 名字来自 SkullOwner.Name；取不到就不写该键（§9）
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prof.name run data modify storage headreg:tmp cur.name set from storage headreg:tmp prof.name
# 档案里的中间键不是记录字段，落盘前清掉
execute if score #abort headreg.calc matches 0 run data remove storage headreg:tmp cur.id
execute if score #abort headreg.calc matches 0 run data remove storage headreg:tmp cur.properties

# 7) 正版判定 + 档案时刻
#    #prem / #ts_sec 先归零：classify 若提前中止，不能读到上一轮的残留（否则会把旧档案时刻当成本次的）。
execute if score #abort headreg.calc matches 0 run scoreboard players set #prem headreg.calc 0
execute if score #abort headreg.calc matches 0 run scoreboard players set #ts_sec headreg.calc 0
execute if score #abort headreg.calc matches 0 run function headreg:internal/classify
execute if score #abort headreg.calc matches 0 if score #prem headreg.calc matches 1 run data modify storage headreg:tmp cur.premium set value 1b
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp cur{premium:1b} run scoreboard players set #prem headreg.calc 1
# 档案时刻的落点是并行开发期的契约缝隙：契约写 cur，mainline 写 working_data；两边都认。
execute if score #abort headreg.calc matches 0 if score #prem headreg.calc matches 1 store result storage headreg:tmp cur.ts_sec int 1 run scoreboard players get #ts_sec headreg.calc

# 8) 时钟：拿本次档案时刻做锚点（只向前校正），再取「现在」
execute if score #abort headreg.calc matches 0 run scoreboard players set #ts headreg.calc 0
execute if score #abort headreg.calc matches 0 store result score #ts headreg.calc run data get storage headreg:tmp cur.ts_sec
execute if score #abort headreg.calc matches 0 if score #ts headreg.calc matches 1.. run function headreg:internal/clock_anchor
execute if score #abort headreg.calc matches 0 run function headreg:internal/now_sec

# 9) 继承 prev 里「只写一次 / 累计」的字段
#    判存在用 if data，不能用数值真假 —— settled:0b / prev_clean:0b 也存在。
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev.first_sec run data modify storage headreg:tmp cur.first_sec set from storage headreg:tmp prev.first_sec
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev.reg_count run data modify storage headreg:tmp cur.reg_count set from storage headreg:tmp prev.reg_count
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev.last_leave_sec run data modify storage headreg:tmp cur.last_leave_sec set from storage headreg:tmp prev.last_leave_sec
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev.prev_play run data modify storage headreg:tmp cur.prev_play set from storage headreg:tmp prev.prev_play
# 历史整段继承：push_data 是整体覆盖，不继承的话每次只剩本次这一条
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev.history run data modify storage headreg:tmp cur.history set from storage headreg:tmp prev.history
# settled / prev_clean / exit_kind / exit_peers 故意不继承：它们只能由 settle_session 产出，
# 继承会把「上次结算失败」伪装成「已结算」。
execute if score #abort headreg.calc matches 0 unless data storage headreg:tmp cur.first_sec run function headreg:internal/snapshot_first

# 10) 结算上一段（有旧记录才结算）
execute if score #abort headreg.calc matches 0 run scoreboard players set #settle_pending headreg.calc 0
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp prev run scoreboard players set #settle_pending headreg.calc 1
execute if score #abort headreg.calc matches 0 run function headreg:internal/settle_session

# 11) 会话基线：本段从「现在」起算。
#     必须排在 settle 之后 —— settle 要把 last_seen 读成「上一次观测到在线的时刻」。
execute if score #abort headreg.calc matches 0 run scoreboard players operation @s headreg.last_seen = #now headreg.calc

# 12) 登记次数 +1（data get 未命中时 store result 不落值，故先清零）
execute if score #abort headreg.calc matches 0 run scoreboard players set #rc headreg.calc 0
execute if score #abort headreg.calc matches 0 store result score #rc headreg.calc run data get storage headreg:tmp cur.reg_count
execute if score #abort headreg.calc matches 0 run scoreboard players add #rc headreg.calc 1
execute if score #abort headreg.calc matches 0 run execute store result storage headreg:tmp cur.reg_count int 1 run scoreboard players get #rc headreg.calc

# 13) 写回分桶
execute if score #abort headreg.calc matches 0 run function headreg:internal/push_data

# 14) 历史段追加 —— 必须在 push 之后：push 整体覆盖 data，先追加会被抹掉
execute if score #abort headreg.calc matches 0 if data storage headreg:tmp session run function headreg:internal/append_history

# 15) 回报
execute if score #abort headreg.calc matches 0 run function headreg:internal/report_ok

# 16) 收尾：清掉本轮草稿（只留分桶里的归档数据）
data remove storage headreg:tmp cur
data remove storage headreg:tmp prev
data remove storage headreg:tmp session
data remove storage headreg:tmp prof
data remove storage headreg:tmp seg

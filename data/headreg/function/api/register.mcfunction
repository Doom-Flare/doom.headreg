# headreg:api/register —— 对执行者玩家做一次注册
# 用法：execute as <player> run function headreg:api/register
# 流程：抓头颅 -> 判正版(properties.textures) -> base64 解码取时间戳 -> 入分桶 -> tellraw

# 0) 只服务玩家：非玩家实体不分配 id（避免白吃号）
execute unless entity @s[type=minecraft:player] run return 0

# 1) 保证有稳定数字 id（记分板 headreg.id 的 @s）
execute unless score @s headreg.id matches 1.. run function headreg:internal/assign_id

# 1b) 自愈：共享中转实体若被外部 kill（人工清理、/kill @e 等）就地重建。
#     不做这一步的话 grab_head 会静默读不到 profile，register 直接 return 0。
execute in minecraft:overworld unless entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run function headreg:internal/ensure_display

# 1c) 把本人已有记录备份到 root.prev。
#     必须另存：grab_head 第 8 行会 data remove working_data，直接 pull 到这里等于白读。
execute store result storage headreg:data root.target_id int 1 run scoreboard players get @s headreg.id
data remove storage headreg:data root.prev
function headreg:internal/snapshot_prev with storage headreg:data root
data remove storage headreg:data root.target_id

# 2) 抓头颅并读回 profile（全部在 overworld 执行，避免执行者在其它维度时选不到中转实体）
function headreg:internal/grab_head

# 3) 读失败早退（拆两行：不依赖 `return run` 的返回值语义）
execute if score #found headreg.calc matches 0 run function headreg:internal/report_fail
execute if score #found headreg.calc matches 0 run data remove storage headreg:data root.prev
execute if score #found headreg.calc matches 0 run return 0

# 4) 归档字段默认值（uuid 不再落盘：全包无人读取，显示用的是 build_uuid 生成的 uuid_str）
data modify storage headreg:data root.working_data.premium set value 0b
data modify storage headreg:data root.working_data.ts_ms set value "0"
data modify storage headreg:data root.working_data.ts_sec set value "0"
execute store result storage headreg:data root.working_data.fetched_at long 1 run time query gametime

# 5) 正版判定 + 时间戳提取
function headreg:internal/classify

# 5b) 派生字段：可读日期 + UUID 字符串（非正版会落成 "-"）
function headreg:internal/format_time
function headreg:internal/build_uuid

# 5b2) 服务器时钟：拿本次档案时间做锚点（只向前校正），再渲染「现在」
function headreg:internal/clock_anchor
function headreg:internal/format_now

# 5c) 继承 root.prev 里「只写一次」的字段（首次登记时 prev 不存在，就地快照）
execute if data storage headreg:data root.prev.first_ts_ms run data modify storage headreg:data root.working_data.first_ts_ms set from storage headreg:data root.prev.first_ts_ms
execute if data storage headreg:data root.prev.first_ts_sec run data modify storage headreg:data root.working_data.first_ts_sec set from storage headreg:data root.prev.first_ts_sec
execute if data storage headreg:data root.prev.first_date_str run data modify storage headreg:data root.working_data.first_date_str set from storage headreg:data root.prev.first_date_str
execute if data storage headreg:data root.prev.first_tick run data modify storage headreg:data root.working_data.first_tick set from storage headreg:data root.prev.first_tick
execute if data storage headreg:data root.prev.reg_count run data modify storage headreg:data root.working_data.reg_count set from storage headreg:data root.prev.reg_count
# 会话结算结果：上次离开（估算 epoch 秒）与上一段在线 tick 数
execute if data storage headreg:data root.prev.last_leave_sec run data modify storage headreg:data root.working_data.last_leave_sec set from storage headreg:data root.prev.last_leave_sec
execute if data storage headreg:data root.prev.prev_play run data modify storage headreg:data root.working_data.prev_play set from storage headreg:data root.prev.prev_play
# 历史会话：整段继承。push_data 是整体覆盖 data，不继承的话每次只剩本次这一条。
execute if data storage headreg:data root.prev.history run data modify storage headreg:data root.working_data.history set from storage headreg:data root.prev.history
execute unless data storage headreg:data root.working_data.first_ts_ms run function headreg:internal/snapshot_first

# 5c2) 结算上一段会话（放在时钟校正之后，否则「上次离开」会用旧锚点算错）
execute if data storage headreg:data root.prev run function headreg:internal/settle_session
scoreboard players set #settle_pending headreg.calc 0

# 5c2b) 会话基线：必须在 settle 之后（要用旧基线算上段时长）、report_ok 之前（否则「本次在线」显示的是上段时长）
scoreboard players operation @s headreg.join_play = @s headreg.play
scoreboard players operation @s headreg.join_leave = @s headreg.leave
scoreboard players operation @s headreg.last_seen = #gt headreg.calc

# 5d) 登记次数累加
scoreboard players set #rc headreg.calc 0
execute store result score #rc headreg.calc run data get storage headreg:data root.working_data.reg_count
scoreboard players add #rc headreg.calc 1
execute store result storage headreg:data root.working_data.reg_count int 1 run scoreboard players get #rc headreg.calc

# 6) 入分桶：root.<id>.data
execute store result storage headreg:data root.target_id int 1 run scoreboard players get @s headreg.id
function headreg:internal/push_data with storage headreg:data root

# 6b) 历史会话：push_data 会整体覆盖 data，所以追加必须排在它之后
#     必须在清掉 root.target_id 之前，否则宏 $(target_id) 取不到值、整条静默不执行
execute if data storage headreg:data root.session run function headreg:internal/append_history with storage headreg:data root
# 6c) 名字索引：按名字查询 O(1) 命中，不必遍历所有分桶
function headreg:internal/put_index with storage headreg:data root.working_data

data remove storage headreg:data root.session
data remove storage headreg:data root.target_id

data modify storage headreg:diag root.step set value 6
data modify storage headreg:diag root.pushed set value 1b

# 7) 回报
function headreg:internal/report_ok

# 8) 收尾：清掉本轮的临时草稿（只留分桶里的归档数据）
#    working_data 也要清：否则下一个人登录前，storage 里还留着上一个人的档案
data remove storage headreg:data root.working_data
data remove storage headreg:tmp args
data remove storage headreg:data root.prev
data remove storage headreg:data root.session

# headreg:internal/settle_session —— 结算「上一段会话」
# 前置：@s 为玩家；#settle_pending == 1；working_data 已就绪，且时钟已被本次档案校正过
# 语义：离开事件没有执行上下文，所以结算挪到下次进服做。两件事都是精确的：
#   ① 上一段在线时长 = play - join_play（play 在离开那一刻就冻结了）
#   ② 离开时刻用 last_seen 折算（误差 = 时钟漂移，不是扫描间隔）
# 写回：直接写进 working_data，随后由 register 的 push_data 一并入桶
execute unless score @s headreg.id matches 1.. run return 0
execute unless score #settle_pending headreg.calc matches 1 run return 0
data modify storage headreg:data root.working_data.settled set value 1b

scoreboard players operation #sp headreg.calc = @s headreg.play
scoreboard players operation #sp headreg.calc -= @s headreg.join_play

scoreboard players operation #tt headreg.calc = @s headreg.last_seen
function headreg:internal/clock_from_tick

# 人数旁证：本人 last_seen 与其它已登记玩家是否落在同一时刻（±2 tick）
#   命中 -> global（同一事件，如关服、全服掉线）；未命中 -> personal/solo
scoreboard players operation #sid headreg.calc = @s headreg.id
scoreboard players operation #ttl headreg.calc = #tt headreg.calc
scoreboard players operation #ttl headreg.calc -= #k2 headreg.calc
scoreboard players operation #tt2 headreg.calc = #tt headreg.calc
scoreboard players operation #tt2 headreg.calc += #k2 headreg.calc
scoreboard players set #glob headreg.calc 0
scoreboard players set #seen headreg.calc 0
# 同伴扫描按活跃 id 列表走（storage headreg:ids list），#i 是列表下标，从 0 起
function headreg:internal/ids_len
scoreboard players set #i headreg.calc 0
function headreg:internal/scan_peer
data remove storage headreg:scan src
data remove storage headreg:scan cur
execute store result storage headreg:data root.working_data.exit_peers int 1 run scoreboard players get #glob headreg.calc
execute store result storage headreg:data root.working_data.exit_seen int 1 run scoreboard players get #seen headreg.calc
execute if score #glob headreg.calc matches 1.. run data modify storage headreg:data root.working_data.exit_kind set value "global"
execute if score #glob headreg.calc matches 0 run data modify storage headreg:data root.working_data.exit_kind set value "personal"
execute if score #seen headreg.calc matches 0 run data modify storage headreg:data root.working_data.exit_kind set value "solo"

execute store result storage headreg:diag root.d_tt int 1 run scoreboard players get #tt headreg.calc
execute store result storage headreg:diag root.d_bt int 1 run scoreboard players get #bt headreg.calc
execute store result storage headreg:diag root.d_bs int 1 run scoreboard players get #bs headreg.calc
execute store result storage headreg:diag root.d_d int 1 run scoreboard players get #d headreg.calc
execute store result storage headreg:diag root.d_sec int 1 run scoreboard players get #sec headreg.calc
execute store result storage headreg:diag root.d_gt int 1 run scoreboard players get #gt headreg.calc
execute store result storage headreg:diag root.d_play int 1 run scoreboard players get #sp headreg.calc
data modify storage headreg:diag root.phase set value "settle-after"

# 时钟未锚定（离线模式，或首个登录者是离线玩家）时 #sec=0，此时宁可不写，也不要写出 1970 年
execute if score #sec headreg.calc matches 1.. store result storage headreg:data root.working_data.last_leave_sec int 1 run scoreboard players get #sec headreg.calc
execute unless score #sec headreg.calc matches 1.. run data remove storage headreg:data root.working_data.last_leave_sec
execute store result storage headreg:data root.working_data.prev_play int 1 run scoreboard players get #sp headreg.calc

# 退出方式判决（实测结论，勿凭直觉改）：
#   正常退出 / 硬断（拔线、崩溃）/ 被踢 —— 三者 leave_game 都 +1，包内无法区分。
#   只有「服务端关服、统计未落盘」这一种情况差值为 0。
# 故 prev_leave>=1 只能读作「上一次有会话结束记录」，不等于干净退出；
# prev_clean 是名不副实的旧字段名，语义应理解为「上次结束已落盘」。
scoreboard players operation #lv headreg.calc = @s headreg.leave
scoreboard players operation #lv headreg.calc -= @s headreg.join_leave
execute store result storage headreg:data root.working_data.prev_leave int 1 run scoreboard players get #lv headreg.calc
execute if score #lv headreg.calc matches 1.. run data modify storage headreg:data root.working_data.prev_clean set value 1b
execute unless score #lv headreg.calc matches 1.. run data modify storage headreg:data root.working_data.prev_clean set value 0b

# 历史会话：把本段写进 root.session，由 register 第 6b 步在 push_data 之后追加进分桶
# （不能在 push 之前放，push_data 会整体覆盖 data，历史会被抹掉）
data remove storage headreg:data root.session
execute if score #sec headreg.calc matches 1.. run function headreg:internal/build_session

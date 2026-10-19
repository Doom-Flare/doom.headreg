# headreg:internal/settle_session —— 结算「上一段会话」
# 前置：@s 玩家且 headreg.id 有效；#cur 已设；headreg:tmp cur = 待写记录（旧字段已继承）；
#       headreg:tmp prev = 上一段快照；#settle_pending == 1；#now 已由本次档案校正
# 后置：cur 的 settled / prev_clean / exit_kind / exit_peers / prev_play / last_leave_sec 已写；
#       headreg:tmp session = 本段历史条目（dur<=0 时不生成）；root.g_last / g_last2 / g_n 已推进；
#       #settle_pending 置 0（重复调用不再重入）
#
# 时长口径（legacy 无 leave 钩子、无 play_time 统计，§6 的 objective 表里没有 headreg.play）：
#   out_sec = @s headreg.last_seen（最后一次被观测到在线的 epoch 秒；没人刷过就退回 #now）
#   in_sec  = prev.last_leave_sec（上次结算时刻；缺失退回 prev.first_sec）
#   dur_sec = out_sec - in_sec，负值钳 0。
#   包里没有 tick 时 last_seen 只在进服时写一次，dur 因此是「两次登记之间的间隔」；
#   日后若挂上 tick 刷新 last_seen，dur 自动变成真实在线时长，本函数一行都不用改。

scoreboard players set #sabort headreg.calc 0
execute unless score #cur headreg.rec matches 1.. run scoreboard players set #sabort headreg.calc 1
execute unless data storage headreg:tmp prev run scoreboard players set #sabort headreg.calc 1
execute unless score #settle_pending headreg.calc matches 1 run scoreboard players set #sabort headreg.calc 1
execute unless score #now headreg.calc matches 1.. run scoreboard players set #sabort headreg.calc 1

# 1) 退出时刻
scoreboard players set #out headreg.calc 0
execute if score #sabort headreg.calc matches 0 store result score #out headreg.calc run scoreboard players get @s headreg.last_seen
execute if score #sabort headreg.calc matches 0 unless score #out headreg.calc matches 1.. run scoreboard players operation #out headreg.calc = #now headreg.calc
execute if score #sabort headreg.calc matches 0 unless score #out headreg.calc matches 1.. run scoreboard players set #sabort headreg.calc 1

# 2) 本段起点
scoreboard players set #in headreg.calc 0
execute if score #sabort headreg.calc matches 0 store result score #in headreg.calc run data get storage headreg:tmp prev.last_leave_sec
execute if score #sabort headreg.calc matches 0 if score #in headreg.calc matches ..0 store result score #in headreg.calc run data get storage headreg:tmp prev.first_sec
execute if score #sabort headreg.calc matches 0 if score #in headreg.calc matches ..0 run scoreboard players operation #in headreg.calc = #out headreg.calc

# 3) dur_sec = out_sec - in_sec
scoreboard players operation #dur headreg.calc = #out headreg.calc
scoreboard players operation #dur headreg.calc -= #in headreg.calc
execute if score #sabort headreg.calc matches 0 if score #dur headreg.calc matches ..-1 run scoreboard players set #dur headreg.calc 0

# 4) exit_kind：O(1) 全局哨兵（DESIGN §11），不扫描记录、不按名字寻址计分板
#    #my = 我自己上一段的离开时刻（prev.last_leave_sec）
#    #p1 = root.g_last（最近一次离开）、#p2 = root.g_last2（次近）、#gn = root.g_n（已结算会话总数）
#    哨兵在比较之后才推进，所以此刻它们仍代表「别人（或我更早的段）的离开」。
scoreboard players set #my headreg.calc 0
scoreboard players set #p1 headreg.calc 0
scoreboard players set #p2 headreg.calc 0
scoreboard players set #gn headreg.calc 0
scoreboard players set #p1id headreg.calc 0
scoreboard players set #p2id headreg.calc 0
scoreboard players operation #myid headreg.calc = #cur headreg.rec
execute if score #sabort headreg.calc matches 0 store result score #my headreg.calc run data get storage headreg:tmp prev.last_leave_sec
execute if score #sabort headreg.calc matches 0 unless score #my headreg.calc matches 1.. run scoreboard players operation #my headreg.calc = #out headreg.calc
execute if score #sabort headreg.calc matches 0 store result score #p1 headreg.calc run data get storage headreg:data root.g_last
execute if score #sabort headreg.calc matches 0 store result score #p2 headreg.calc run data get storage headreg:data root.g_last2
execute if score #sabort headreg.calc matches 0 store result score #p1id headreg.calc run data get storage headreg:data root.g_last_id
execute if score #sabort headreg.calc matches 0 store result score #p2id headreg.calc run data get storage headreg:data root.g_last2_id
execute if score #sabort headreg.calc matches 0 store result score #gn headreg.calc run data get storage headreg:data root.g_n
scoreboard players operation #d1 headreg.calc = #p1 headreg.calc
scoreboard players operation #d1 headreg.calc -= #my headreg.calc
scoreboard players operation #d2 headreg.calc = #p2 headreg.calc
scoreboard players operation #d2 headreg.calc -= #my headreg.calc
# kind: 1=global 2=solo 3=personal
# 哨兵槽里存了「是谁离开留下的」（g_last_id / g_last2_id），比 id 为 #cur 的那条是我自己的旧段，
# 必须跳过 —— 否则「只有我一个人玩」会被自己的历史判成 global。
scoreboard players set #kind headreg.calc 3
execute if score #sabort headreg.calc matches 0 if score #p1 headreg.calc matches 1.. unless score #p1id headreg.calc = #myid headreg.calc if score #d1 headreg.calc matches -2..2 run scoreboard players set #kind headreg.calc 1
execute if score #sabort headreg.calc matches 0 unless score #kind headreg.calc matches 1 if score #p2 headreg.calc matches 1.. unless score #p2id headreg.calc = #myid headreg.calc if score #d2 headreg.calc matches -2..2 run scoreboard players set #kind headreg.calc 1
# solo 判据：全服只分配过 1 个编号（= 除我之外没有任何登记玩家）。用 #init 而不是 g_n，
# 因为 g_n 只数结算次数，单人玩家第二次结算就会被误判成 personal。
execute if score #sabort headreg.calc matches 0 unless score #kind headreg.calc matches 1 unless score #init headreg.next matches 2.. run scoreboard players set #kind headreg.calc 2

# 5) 写回记录字段
execute if score #sabort headreg.calc matches 0 run data modify storage headreg:tmp cur.settled set value 1b
execute if score #sabort headreg.calc matches 0 run data modify storage headreg:tmp cur.prev_clean set value 1b
# §11：legacy 只能给出布尔式的 global，数不出同批人数，exit_peers 恒 0
execute if score #sabort headreg.calc matches 0 run data modify storage headreg:tmp cur.exit_peers set value 0
# prev_play 字段名沿用主线，口径是 tick（§9），由秒折算
execute if score #sabort headreg.calc matches 0 run scoreboard players set #dt20 headreg.calc 20
execute if score #sabort headreg.calc matches 0 run scoreboard players operation #pp headreg.calc = #dur headreg.calc
execute if score #sabort headreg.calc matches 0 run scoreboard players operation #pp headreg.calc *= #dt20 headreg.calc
execute if score #sabort headreg.calc matches 0 run execute store result storage headreg:tmp cur.prev_play int 1 run scoreboard players get #pp headreg.calc
execute if score #sabort headreg.calc matches 0 run execute store result storage headreg:tmp cur.last_leave_sec int 1 run scoreboard players get #out headreg.calc
execute if score #sabort headreg.calc matches 0 if score #kind headreg.calc matches 1 run data modify storage headreg:tmp cur.exit_kind set value "global"
execute if score #sabort headreg.calc matches 0 if score #kind headreg.calc matches 2 run data modify storage headreg:tmp cur.exit_kind set value "solo"
execute if score #sabort headreg.calc matches 0 if score #kind headreg.calc matches 3 run data modify storage headreg:tmp cur.exit_kind set value "personal"

# 6) 历史段：dur==0 表示没有任何观测跨过，不写零长段污染 history
data remove storage headreg:tmp session
execute if score #sabort headreg.calc matches 0 if score #dur headreg.calc matches 1.. run function headreg:internal/build_session

# 7) 哨兵推进：g_last2 ← g_last ← #my；g_n + 1（只动 §11 的三个固定路径）
execute if score #sabort headreg.calc matches 0 if data storage headreg:data root.g_last run data modify storage headreg:data root.g_last2 set from storage headreg:data root.g_last
execute if score #sabort headreg.calc matches 0 if data storage headreg:data root.g_last_id run data modify storage headreg:data root.g_last2_id set from storage headreg:data root.g_last_id
execute if score #sabort headreg.calc matches 0 run execute store result storage headreg:data root.g_last int 1 run scoreboard players get #my headreg.calc
execute if score #sabort headreg.calc matches 0 run execute store result storage headreg:data root.g_last_id int 1 run scoreboard players get #myid headreg.calc
execute if score #sabort headreg.calc matches 0 run scoreboard players add #gn headreg.calc 1
execute if score #sabort headreg.calc matches 0 run execute store result storage headreg:data root.g_n int 1 run scoreboard players get #gn headreg.calc
scoreboard players set #settle_pending headreg.calc 0

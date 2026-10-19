# headreg:tick —— 每 tick 维护「在线观测时刻」与自助查询（由 #minecraft:tick 驱动）
# 职责：
#   1) 取 gametime 到 #gt，并记 #gtm1 = #gt - 1
#   2) 识别「新进服 / 重新进服」的玩家 -> 走 on_join（自动注册 + 结算上一段 + 会话基线）
#   3) 刷新 last_seen（epoch 秒，结算时作 out_sec）与 seen_tick（本 tick 存活着的水印）
#   4) 处理 /trigger headreg.query 与 headreg.qlist
#
# 为什么判「新进服」用 seen_tick 而不是 last_seen：
#   last_seen 是 epoch 秒，20 tick 才动一格，看不出「上一 tick 在不在」。
#   seen_tick 每 tick 都刷成 #gt，所以「不等于 #gt-1」只可能是这段期间人不在。
#   全新玩家根本没有 seen_tick 分数 —— 分数缺席时 "unless score @s X = #gtm1 Y" 成立，同样进 on_join。
#   这里不用 return 早退（1.19.4 没有 /return），全部用 #abort 标志替代。
# 顺序纪律：刷新 last_seen 必须排在 on_join 之后 —— settle_session 正是拿
#   「上一 tick 之前最后一次观测到的 last_seen」当作上一段的 out_sec，先刷就成了 dur=0。

execute store result score #gt headreg.calc run time query gametime
scoreboard players operation #gtm1 headreg.calc = #gt headreg.calc
scoreboard players remove #gtm1 headreg.calc 1

execute as @a unless score @s headreg.seen_tick = #gtm1 headreg.calc run function headreg:internal/on_join

execute as @a run scoreboard players operation @s headreg.seen_tick = #gt headreg.calc
function headreg:internal/now_sec
execute as @a if score #now headreg.calc matches 1.. run scoreboard players operation @s headreg.last_seen = #now headreg.calc

function headreg:internal/query_dispatch

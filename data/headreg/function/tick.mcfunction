# headreg:tick —— 每 tick 维护在线状态与服务器时钟（由 #minecraft:tick 驱动）
# 职责：
#   1) 取当前 gametime 到 #gt
#   2) 识别「新进服 / 重新进服」的玩家 -> 走 on_join（自动注册 + 会话结算 + 基线快照）
#   3) 存活玩家刷新 last_seen（离开时刻结算时用它折算墙上时间）
# 在线时长本身不在这里累加：#headreg.play 挂在 vanilla 统计 minecraft.custom:minecraft.play_time 上，
# 由服务端自己按 tick 递增，离线冻结、重登续涨，无需我们逐 tick 记账。
#
# 为什么「重新进服」要靠 last_seen 落后判定：headreg.online 是存档记分板，玩家退出时不会自动归零，
# 下次登录若只看「online 未置位」会永远判不出这是一段新会话。tick 每 tick 都会把存活玩家的
# last_seen 刷成 #gt，所以「last_seen 比上一 tick 还旧」只可能意味着这个人这期间根本不在线。
execute store result score #gt headreg.calc run time query gametime
scoreboard players operation #gtm1 headreg.calc = #gt headreg.calc
scoreboard players remove #gtm1 headreg.calc 1

execute as @a unless score @s headreg.online matches 1 run function headreg:internal/on_join
execute as @a[scores={headreg.online=1}] if score @s headreg.last_seen < #gtm1 headreg.calc run function headreg:internal/on_join

execute as @a[scores={headreg.online=1}] run scoreboard players operation @s headreg.last_seen = #gt headreg.calc

# 4) 玩家自助查询：抓 /trigger headreg.query 的请求
function headreg:internal/query_dispatch

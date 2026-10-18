# headreg:internal/on_join —— 玩家刚进服（被 tick 检测到在线但未标记）时的统一入口
# 前置：@s 为玩家；#gt 已就绪
# 语义：这里就是「进来就抓一次」的地方 —— 自动注册 + 会话基线，无需玩家手打命令。
# 结算不在这一步做：上一段的离开时刻要用校正过的时钟折算，必须等 register 抓到新鲜档案之后。

# 1) 记下「上一段会话还没结算」这件事（本人 online 仍为 1 即说明如此）
scoreboard players set #settle_pending headreg.calc 0
execute if score @s headreg.online matches 1 run scoreboard players set #settle_pending headreg.calc 1

# 2) 先标记在线，避免 register 执行期间被 tick 重复触发
scoreboard players set @s headreg.online 1

# 2b) 开放自助查询：trigger 类计分板必须逐个玩家 enable，否则 /trigger 会回
#     「You cannot trigger this objective yet」。每次进服都重新 enable 一次，代价可忽略。
scoreboard players enable @s headreg.query
scoreboard players enable @s headreg.qlist

# 3) 自动注册（抓档案 -> 时钟校正 -> 结算上一段 -> 入桶 -> 回报）
function headreg:api/register


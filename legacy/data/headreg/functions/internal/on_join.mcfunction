# headreg:internal/on_join —— 玩家进服的统一入口
# 前置：@s 为玩家
# 语义：开放自助查询（trigger 类计分板必须逐个玩家 enable，否则 /trigger 会回
#       「You cannot trigger this objective yet」），然后自动注册一次。
# 说明：本函数不自己记「在线」，会话基线由 api/register 内部维持（headreg.last_seen）。
scoreboard players enable @s headreg.query
scoreboard players enable @s headreg.qlist
function headreg:api/register

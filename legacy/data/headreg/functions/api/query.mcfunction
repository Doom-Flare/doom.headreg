# headreg:api/query —— 读回执行者自己已登记的记录（主线语义：本人自助查询）
# 用法：execute as <player> run function headreg:api/query
# 前置：@s 为玩家
# 后置：headreg:tmp cur 已清；#qid/#cur 被占用
# 说明：真正的渲染在 api/query_id —— 这里只负责「取到自己的编号」并交棒，
#       与玩家侧 /trigger headreg.query 走同一条渲染路径。
scoreboard players set #pabort headreg.calc 0
execute unless score @s headreg.id matches 1.. run scoreboard players set #pabort headreg.calc 1
execute unless score @s headreg.id matches 1.. run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.cmd.need_register","fallback":"你还没有登记记录，先执行 /function headreg:api/register","color":"yellow"}]
execute if score #pabort headreg.calc matches 0 run scoreboard players operation #qid headreg.calc = @s headreg.id
execute if score #pabort headreg.calc matches 0 run function headreg:api/query_id
data remove storage headreg:tmp cur

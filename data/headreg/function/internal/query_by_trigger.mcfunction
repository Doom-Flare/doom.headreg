# headreg:internal/query_by_trigger —— /trigger headreg.query set <编号> 的处理
# 入口：#qid = @s headreg.query 的值（>=1）
# 重要：/trigger 用一次就会被自动 disable，用完必须重新 enable，否则玩家第二次查询会得到
# 「You cannot trigger this objective yet」。
# 处理完把分数置 0 而不是 reset：dispatch 选择器是 1..，0 不会被选中，无需 reset 也不会重放。
scoreboard players operation #qid headreg.calc = @s headreg.query
scoreboard players set @s headreg.query 0
scoreboard players enable @s headreg.query
execute store result storage headreg:scan qarg.id int 1 run scoreboard players get #qid headreg.calc
function headreg:api/query_id with storage headreg:scan qarg
data remove storage headreg:scan qarg

# headreg:internal/query_by_trigger —— /trigger headreg.query set <编号> 的处理
# 入口：#qid = @s headreg.query 的值（≥1）
# 说明：/trigger 用一次就会被自动 disable，用完必须重新 enable，否则第二次查询会得到
#       「You cannot trigger this objective yet」。分数置 0 而不是 reset：dispatch 是 1..，0 不会被选中。
scoreboard players operation #qid headreg.calc = @s headreg.query
scoreboard players set @s headreg.query 0
scoreboard players enable @s headreg.query
function headreg:api/query_id

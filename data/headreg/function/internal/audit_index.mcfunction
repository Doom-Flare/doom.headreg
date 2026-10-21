# headreg:internal/audit_index —— 索引回指校验：index[$(name)] 必须等于 #id
# 入口：storage headreg:audit look {name:"玩家名"}；#id = 期望的 id
scoreboard players set #g headreg.audit 0
$execute store result score #g headreg.audit run data get storage headreg:index $(name)
execute unless score #g headreg.audit = #id headreg.audit run scoreboard players add #bad headreg.audit 1
execute unless score #g headreg.audit = #id headreg.audit run tellraw @s [{"translate":"headreg.audit.err.index_mismatch","fallback":"[audit] ✗ 索引与档案不一致（index 查不到该名字或回指别的 id）","color":"red"}]

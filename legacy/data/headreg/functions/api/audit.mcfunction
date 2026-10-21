# headreg:api/audit —— 对「执行者自己的档案」做自检，只读、不修数据
# 用法：execute as <player> run function headreg:api/audit
# 覆盖 6 项（§9 schema）：history ≤10 / dur_sec == out_sec-in_sec / 末段 out_sec ≤ last_leave_sec /
#        exit_kind 枚举 / settled 必须有 prev_play / ts_sec 非负
# 不做：uuid_str、名字索引（legacy 都没有，§4/§12）
scoreboard players set #vabort headreg.calc 0
execute unless entity @s[type=minecraft:player] run scoreboard players set #vabort headreg.calc 1
execute if score #vabort headreg.calc matches 0 unless score @s headreg.id matches 1.. run scoreboard players set #vabort headreg.calc 1
execute if score #vabort headreg.calc matches 0 run scoreboard players set #au_bad headreg.calc 0
execute if score #vabort headreg.calc matches 0 run scoreboard players set #au_n headreg.calc 0
execute if score #vabort headreg.calc matches 1 run tellraw @s [{"translate":"headreg.api.audit.no_profile","fallback":"[headreg] 你还没有档案，无从审计。","color":"red"}]
execute if score #vabort headreg.calc matches 0 run scoreboard players operation #qid headreg.calc = @s headreg.id
execute if score #vabort headreg.calc matches 0 run function headreg:internal/audit_id
data remove storage headreg:tmp cur

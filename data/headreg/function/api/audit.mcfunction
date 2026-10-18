# headreg:api/audit —— 自检「我自己这一份档案」的内部一致性，只读、不修数据
# 用法：/function headreg:api/audit（函数级命令，需 OP）
# 覆盖 7 项：history 段数上限 / 末段时间自洽 / 末段不越过上次离开 / exit_kind 枚举 / 结算后 prev_play 存在 / 索引一致 / last_leave_sec 有效
# 输出：通过时一行绿字；失败逐条红字 + 汇总
data remove storage headreg:audit id
execute store result storage headreg:audit id int 1 run scoreboard players get @s headreg.id
execute if data storage headreg:audit id run function headreg:internal/audit_id with storage headreg:audit
execute unless data storage headreg:audit id run tellraw @s [{"text":"[headreg] 你还没有档案，无从审计。","color":"red"}]

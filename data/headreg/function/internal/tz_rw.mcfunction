# headreg:internal/tz_rw —— 按当前时区重渲染 working_data 里的一个显示串
# 入口：storage headreg:scan adisp = {p:"<源 _sec 字段>", d:"<目标 _str 字段>"}（两个都是宏）
# 出口：root.working_data.<d> = 重渲染结果；源字段缺失或 <=0 时原值原样保留（不写脏、不崩）
# 说明：只动 working_data（草稿副本），绝不回写归档桶。p/d 同为宏，调用方只需改组合同一处。
data remove storage headreg:tmp ts_sec
$data modify storage headreg:tmp ts_sec set string storage headreg:data root.working_data.$(p)
scoreboard players set #ts headreg.calc 0
execute if data storage headreg:tmp ts_sec run function headreg:internal/to_score with storage headreg:tmp
$execute unless data storage headreg:tmp ts_sec run execute store result score #ts headreg.calc run data get storage headreg:data root.working_data.$(p)
data remove storage headreg:tmp ts_sec
execute if score #ts headreg.calc matches 1.. run function headreg:internal/render_date
$execute if score #ts headreg.calc matches 1.. run data modify storage headreg:data root.working_data.$(d) set from storage headreg:tmp date

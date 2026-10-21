# headreg:internal/tz_rh —— 按当前时区重渲染一条历史会话里的一个时间串
# 入口：storage headreg:scan adisp = {id:"<数字 id>", i:"<数组下标 0 基>", s:"<源 _sec 字段>", d:"<目标 _str 字段>"}
# 出口：headreg:data root.<id>.data.history[<i>].<d> = 重渲染结果；源字段缺失或 <=0 时原值原样保留
# 说明：历史项是数组元素，宏要拼进 [$(i)] 下标里，故单独成函数、不与 tz_rq 合并。
#       本函数不 return —— 缺 *_sec 时把 #ts 留成 0 由两道 gate 隐式跳过，不会打断调用方的后续命令。
data remove storage headreg:tmp ts_sec
$data modify storage headreg:tmp ts_sec set string storage headreg:data root.$(id).data.history[$(i)].$(s)
scoreboard players set #ts headreg.calc 0
execute if data storage headreg:tmp ts_sec run function headreg:internal/to_score with storage headreg:tmp
$execute unless data storage headreg:tmp ts_sec run execute store result score #ts headreg.calc run data get storage headreg:data root.$(id).data.history[$(i)].$(s)
data remove storage headreg:tmp ts_sec
execute if score #ts headreg.calc matches 1.. run function headreg:internal/render_date
$execute if score #ts headreg.calc matches 1.. run data modify storage headreg:data root.$(id).data.history[$(i)].$(d) set from storage headreg:tmp date

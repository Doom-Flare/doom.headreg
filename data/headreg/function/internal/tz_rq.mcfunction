# headreg:internal/tz_rq —— 按当前时区重渲染某个归档玩家记录里的一个显示串
# 入口：storage headreg:scan adisp = {id:"<数字 id>", s:"<源 _sec 字段>", d:"<目标 _str 字段>"}
# 出口：headreg:data root.<id>.data.<d> = 重渲染结果；源字段缺失或 <=0 时原值原样保留
# 说明：就地改写归档里的显示串 —— 这正是「切了时区，旧记录也跟着走」的落点。
data remove storage headreg:tmp ts_sec
$data modify storage headreg:tmp ts_sec set string storage headreg:data root.$(id).data.$(s)
scoreboard players set #ts headreg.calc 0
execute if data storage headreg:tmp ts_sec run function headreg:internal/to_score with storage headreg:tmp
$execute unless data storage headreg:tmp ts_sec run execute store result score #ts headreg.calc run data get storage headreg:data root.$(id).data.$(s)
data remove storage headreg:tmp ts_sec
execute if score #ts headreg.calc matches 1.. run function headreg:internal/render_date
$execute if score #ts headreg.calc matches 1.. run data modify storage headreg:data root.$(id).data.$(d) set from storage headreg:tmp date

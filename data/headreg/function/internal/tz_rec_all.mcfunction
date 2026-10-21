# headreg:internal/tz_rec_all —— 全量重渲染一条归档记录（档案级 3 个串 + 全部历史会话的 in_str/out_str）
# 入口：storage headreg:scan adisp = {id:"<数字 id>"}（宏 $(id)）
# 出口：root.<id>.data 下所有时间显示串与当前时区一致；缺 *_sec 的字段保持原样，老数据不会变成 "-"
# 说明：切时区后「旧记录也跟着走」的落点。逐字段走 tz_rq / tz_rh（各带 #ts gate），最后递归历史。
data modify storage headreg:scan adisp.s set value "first_ts_sec"
data modify storage headreg:scan adisp.d set value "first_date_str"
function headreg:internal/tz_rq with storage headreg:scan adisp
data modify storage headreg:scan adisp.s set value "ts_sec"
data modify storage headreg:scan adisp.d set value "date_str"
function headreg:internal/tz_rq with storage headreg:scan adisp
data modify storage headreg:scan adisp.s set value "last_leave_sec"
data modify storage headreg:scan adisp.d set value "last_leave_str"
function headreg:internal/tz_rq with storage headreg:scan adisp
scoreboard players set #tzlen headreg.calc 0
$execute if data storage headreg:data root.$(id).data.history run execute store result score #tzlen headreg.calc run data get storage headreg:data root.$(id).data.history
scoreboard players set #qi headreg.calc 1
execute if score #tzlen headreg.calc matches 1.. run function headreg:internal/tz_render_hist with storage headreg:scan adisp
execute unless score #tzlen headreg.calc matches 1.. run data remove storage headreg:scan adisp

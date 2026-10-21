# headreg:internal/tz_render_hist —— 递归重渲染一条归档记录里历史会话的时间串
# 入口：storage headreg:scan adisp = {id:"<数字 id>"}；#qi（1 起）到 #tzlen
# 出口：root.<id>.data.history[#qi-1] 的 in_str / out_str 按当前时区重算
# 说明：递归体与 render_history 同构，只是把「显示」换成「重写显示串」。
execute if score #qi headreg.calc > #tzlen headreg.calc run data remove storage headreg:scan adisp
execute if score #qi headreg.calc > #tzlen headreg.calc run return 0
scoreboard players operation #tzidx headreg.calc = #qi headreg.calc
scoreboard players remove #tzidx headreg.calc 1
execute store result storage headreg:scan adisp.i int 1 run scoreboard players get #tzidx headreg.calc
data modify storage headreg:scan adisp.s set value "in_sec"
data modify storage headreg:scan adisp.d set value "in_str"
function headreg:internal/tz_rh with storage headreg:scan adisp
data modify storage headreg:scan adisp.s set value "out_sec"
data modify storage headreg:scan adisp.d set value "out_str"
function headreg:internal/tz_rh with storage headreg:scan adisp
scoreboard players add #qi headreg.calc 1
function headreg:internal/tz_render_hist with storage headreg:scan adisp

# headreg:internal/list_scan —— 按活跃 id 列表逐个渲染已存在的分桶
# 入口：#li（0 起 = 列表下标），上限 #ln（ids_len 读到的列表长度）
# 说明：老写法扫 1..#init（= 已分配的最大 id），空号越多白跑越多；改走活跃列表后成本只与真实玩家数相关。
#       列表元素是复合 {id:N}，先把下标翻成真实 id（#cid / scan idat.id），故 tellraw 显示的仍是 #1001 这类编号。
execute if score #li headreg.calc >= #ln headreg.calc run return run data remove storage headreg:scan larg
execute store result storage headreg:scan larg.k int 1 run scoreboard players get #li headreg.calc
function headreg:internal/ids_at with storage headreg:scan larg
data modify storage headreg:scan larg.i set from storage headreg:scan idat.id
function headreg:internal/list_one with storage headreg:scan larg
scoreboard players add #li headreg.calc 1
function headreg:internal/list_scan

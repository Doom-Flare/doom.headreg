# headreg:internal/ids_rebuild_scan —— 逐个 id 探分桶，存在则追加进活跃列表
# 入口：#rb（1 起，当前 id）、#rbc（0 起，本帧已处理个数）、#rbd（0=未完成）
# 说明：这是全包唯一还按 1..max_id 走的地方，且只在升级老存档时跑一次；空号由 if data 自然跳过。
#       本函数自身不带宏行 —— 带 $(x) 的函数必须由 function ... with 调用，否则宏行不展开、整条失效，
#       故逐条探桶交给 ids_rebuild_add（宏 $(id)），这里只负责推进游标与分帧。
#       老存档空号可能上万，同步扫会撞 maxCommandChainLength，故每 200 个让出一 tick。
#       完成标志单独用 #rbd：不能用 #rb 归零兼作哨兵，那样 #init=1 时会把 id 1 直接跳过。
execute if score #rb headreg.calc > #init headreg.next run scoreboard players set #rbd headreg.calc 1
execute if score #rbd headreg.calc matches 1.. run data modify storage headreg:meta ids1 set value 1b
execute if score #rbd headreg.calc matches 1.. run data remove storage headreg:scan rbk
execute if score #rbd headreg.calc matches 1.. run return 0
execute store result storage headreg:scan rbk.id int 1 run scoreboard players get #rb headreg.calc
function headreg:internal/ids_rebuild_add with storage headreg:scan rbk
scoreboard players add #rb headreg.calc 1
scoreboard players add #rbc headreg.calc 1
execute if score #rbc headreg.calc matches 200.. run scoreboard players set #rbc headreg.calc 0
execute if score #rbc headreg.calc matches 0 run schedule function headreg:internal/ids_rebuild_scan 1t replace
execute if score #rbc headreg.calc matches 1.. run function headreg:internal/ids_rebuild_scan

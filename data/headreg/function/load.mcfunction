# headreg:load —— 数据包加载 / 服务器启动时执行一次
# 每次加载都自愈：常量、LUT、共享中转实体；首次加载建表。
execute unless data storage headreg:meta init run function headreg:internal/first_init
data modify storage headreg:meta init set value 1b
function headreg:internal/constants
execute unless data storage headreg:meta obj1 run function headreg:internal/ensure_objectives
execute unless data storage headreg:meta obj2 run function headreg:internal/ensure_obj_dummy
execute unless data storage headreg:meta obj3 run function headreg:internal/ensure_obj_leave
execute unless data storage headreg:meta obj4 run function headreg:internal/ensure_obj_test
execute unless data storage headreg:meta obj5 run function headreg:internal/ensure_obj_query
execute unless data storage headreg:meta obj6 run function headreg:internal/ensure_obj_qlist
execute unless data storage headreg:meta obj7 run function headreg:internal/ensure_obj_audit
# 活跃 id 列表（storage headreg:ids list）：api/list、同伴扫描、时区整表重渲都按它遍历。
# 老存档升级时重建一次（分帧推进，完成时由 ids_rebuild_scan 自己置 ids1）；此后由 assign_id 追加入表。
execute unless data storage headreg:meta ids1 run function headreg:internal/ids_rebuild
# reload 不会重新走 on_join，这里补一次：为已在线的玩家开放 /trigger 自助查询
scoreboard players enable @a headreg.query
scoreboard players enable @a headreg.qlist
function headreg:internal/lut_init
function headreg:internal/lut_time
function headreg:internal/tz_defaults
execute in minecraft:overworld unless entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run function headreg:internal/ensure_display
# forceload 提交后区块要到下一 tick 才真正加载，故补一次延迟重试。
# 重试带预算（#k_retry = 200，约 10 秒）：超时就大声报错并停手，绝不无限空转。
scoreboard players operation #retry headreg.calc = #k_retry headreg.calc
schedule function headreg:internal/ensure_display_retry 1t replace

# 清掉 scan 草稿（宏参数残留，data remove 必须给到叶子路径）
data remove storage headreg:scan larg
data remove storage headreg:scan harg

# 跨重启时钟：把上一轮运行的锚点留档，并记住本次开机时的 gametime。
# 判据：last_seen < boot 说明离开发生在本次运行之前 —— gametime 在停机期间不走，
#       拿本次新锚点折算会把重启前的时刻整体后移「停机时长」，故改用上一轮锚点。
# 注意：/reload 也会走到这里，会把 prev 覆盖成本轮锚点，届时退化为旧行为（偏一个停机时长）。
execute if data storage headreg:clock tick run data modify storage headreg:clock prev.sec set from storage headreg:clock sec
execute if data storage headreg:clock tick run data modify storage headreg:clock prev.tick set from storage headreg:clock tick
# load 时世界还没开始走 tick，time query gametime 读到 0，故延后 1 tick 再打卡
schedule function headreg:internal/mark_boot 1t replace

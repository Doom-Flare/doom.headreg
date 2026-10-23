# headreg:internal/ids_rebuild —— 老存档一次性重建活跃 id 列表（按分桶存在性）
# 入口：无；出口：headreg:ids list 与现有 root.<id>.data 一一对应，并置 meta ids1 门
# 说明：只由 load.mcfunction 的 meta ids1 门调用一次；此后列表靠 assign_id 增长。
#       重建要扫 1..max_id，老存档的空号可能上万 —— 一次性同步扫会撞 maxCommandChainLength，
#       故 ids_rebuild_scan 每 200 个让出一 tick，跑完才置 ids1（中途停服下次 load 会从头重来，幂等）。
data modify storage headreg:ids list set value []
data remove storage headreg:meta ids1
scoreboard players set #rb headreg.calc 1
scoreboard players set #rbc headreg.calc 0
scoreboard players set #rbd headreg.calc 0
function headreg:internal/ids_rebuild_scan

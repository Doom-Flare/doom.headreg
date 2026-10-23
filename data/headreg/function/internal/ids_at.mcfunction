# headreg:internal/ids_at —— 把活跃列表下标 $(k) 对应的数字 id 取进 headreg:scan idat.id
# 入口：宏 $(k) = 列表下标（0 起）；调用方保证 0 <= k < #ln
# 出口：#cid = 取到的 id（越界为 -1）；headreg:scan idat.id = 同一个值（int，供 data modify ... set from 复制）
# 说明：越界用 if data 兜住，避免 NBT 路径落空时往日志里刷 "Found no elements"。
scoreboard players set #cid headreg.calc -1
$execute if data storage headreg:ids list[$(k)] store result score #cid headreg.calc run data get storage headreg:ids list[$(k)].id
execute store result storage headreg:scan idat.id int 1 run scoreboard players get #cid headreg.calc

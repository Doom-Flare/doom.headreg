# headreg:internal/scan_peer_one —— 处理单个 id（宏：$(i) = 真实 id，由 scan_peer 用 ids_at 翻出来）
execute if score #cid headreg.calc = #sid headreg.calc run return 0
data remove storage headreg:scan cur
$data modify storage headreg:scan cur.name set from storage headreg:data root.$(i).data.name
execute unless data storage headreg:scan cur.name run return 0
scoreboard players add #seen headreg.calc 1
scoreboard players set #other headreg.calc -1
function headreg:internal/scan_peer_get with storage headreg:scan cur
# 读不到（-1）说明此人从未有过 last_seen，跳过
execute if score #other headreg.calc matches -1 run return 0
execute if score #other headreg.calc < #ttl headreg.calc run return 0
execute if score #other headreg.calc > #tt2 headreg.calc run return 0
scoreboard players add #glob headreg.calc 1

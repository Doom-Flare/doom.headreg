# headreg:internal/scan_peer —— 按活跃 id 列表统计「与本人上次离开同时刻消失」的同伴
# 入口：#i=0（列表下标起点）、#sid=本人 id、#ttl/#tt2=时间窗下/上界、#glob=命中数、#seen=已读到名字的桶数
# 说明：老写法遍历 id=1..max，空号全靠下游 gate 兜；改走活跃列表后只走真实存在的桶。
#       列表元素是复合 {id:N}，故先把下标翻成真实 id（#cid）再交给 scan_peer_one。
# 为什么不用 @a：选择器只能选到在线玩家，离线玩家的分数字仍存在，但只能按名字读。
execute if score #i headreg.calc >= #ln headreg.calc run return 0
execute store result storage headreg:scan src.k int 1 run scoreboard players get #i headreg.calc
function headreg:internal/ids_at with storage headreg:scan src
data modify storage headreg:scan src.i set from storage headreg:scan idat.id
function headreg:internal/scan_peer_one with storage headreg:scan src
scoreboard players add #i headreg.calc 1
function headreg:internal/scan_peer

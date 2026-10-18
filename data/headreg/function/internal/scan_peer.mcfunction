# headreg:internal/scan_peer —— 遍历 id=1..max，统计「与本人上次离开同时刻消失」的同伴
# 入口：#i=1（起始）、#sid=本人 id、#ttl/#tt2=时间窗下/上界、#glob=命中数、#seen=已读到名字的桶数
# 为什么不用 @a：选择器只能选到在线玩家，离线玩家的分数字仍存在，但只能按名字读。
execute if score #i headreg.calc > #init headreg.next run return 0
execute store result storage headreg:scan src.i int 1 run scoreboard players get #i headreg.calc
function headreg:internal/scan_peer_one with storage headreg:scan src
scoreboard players add #i headreg.calc 1
function headreg:internal/scan_peer

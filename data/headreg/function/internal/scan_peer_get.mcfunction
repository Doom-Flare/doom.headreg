# headreg:internal/scan_peer_get —— 按名字读 last_seen（宏：$(name)），离线玩家同样可读
$execute store result score #other headreg.calc run scoreboard players get $(name) headreg.last_seen

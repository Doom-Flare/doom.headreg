# headreg:internal/ensure_display
# 固定域 forceload：区块 (1184704, 1184704)，远离出生点，仅本包使用。
# 共享 item_display 常驻于此，作为「抓头颅 -> 读 profile」的中转槽。
# 注意：item_display 的槽位名是 container.0。
# 注意：不要写 Persistent（那是 Mob 的字段，见 Mob.java 的 persistenceRequired）；
#       Display/Entity 的 checkDespawn 是空实现，item_display 天然不消失。
forceload add 1184704 1184704
# 区块未就绪就绝不 summon：否则 kill 杀不到、summon 却会在区块加载后落地，
# 与重试各落一个 => 每次重启累积 +2。
execute unless loaded 1184704 0 1184704 run return 0
execute in minecraft:overworld run kill @e[type=minecraft:item_display,tag=headreg.display]
execute in minecraft:overworld run summon minecraft:item_display 1184704.5 0.0 1184704.5 {Tags:["headreg.display"],Invulnerable:1b,NoGravity:1b}

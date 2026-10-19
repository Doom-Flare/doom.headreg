# headreg:internal/ensure_display —— 在固定区块维护唯一的 item_display 中转槽
# 前置：无（load 与 ensure_display_retry 调用）
# 后置：区块就绪时中转实体存在且唯一；区块未就绪时什么都不做，改为排一次重试（绝不无守卫地 summon）
# 固定域 forceload：主世界区块 (1184704, 1184704)，远离出生点，仅本包使用。
# 为什么每条命令都套 in minecraft:overworld：forceload / loaded / summon 的坐标都属于「执行者当前维度」。
# 玩家在下界或末地触发时，若不套这一层，forceload 会去圈下界的区块、summon 会把实体生成在下界同坐标，
# 而 grab_head 始终按主世界那一个去找 —— 两边永远对不上，还留下一堆野外实体。主线同样全程套这一层。
# 注意：item_display 的槽位名是 container.0；不要写 Persistent（那是 Mob 字段，item_display 天然不消失）。
execute in minecraft:overworld run forceload add 1184704 1184704
scoreboard players set #ld headreg.calc 0
execute in minecraft:overworld if loaded 1184704 0 1184704 run scoreboard players set #ld headreg.calc 1
# 区块未就绪就绝不 summon：否则 kill 杀不到、summon 却会在区块加载后落地，与重试各落一个 => 每次重启累积 +2。
execute if score #ld headreg.calc matches 0 run scoreboard players operation #dsp headreg.calc = #k_retry headreg.calc
execute if score #ld headreg.calc matches 0 run schedule function headreg:internal/ensure_display_retry 1t replace
execute if score #ld headreg.calc matches 1 run scoreboard players set #eabort headreg.calc 0
execute if score #ld headreg.calc matches 1 if score #eabort headreg.calc matches 0 run execute in minecraft:overworld run kill @e[type=minecraft:item_display,tag=headreg.display]
execute if score #ld headreg.calc matches 1 if score #eabort headreg.calc matches 0 run execute in minecraft:overworld run summon minecraft:item_display 1184704.5 0.0 1184704.5 {Tags:["headreg.display"],Invulnerable:1b,NoGravity:1b}

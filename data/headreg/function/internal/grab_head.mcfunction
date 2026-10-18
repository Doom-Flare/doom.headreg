# headreg:internal/grab_head —— 抓执行者头颅到共享中转槽，并读回 profile
# 入口：@s = 目标玩家
# 出口：storage headreg:data root.working_data = minecraft:profile 组件内容；
#       #found = 1 成功 / 0 失败
# 全部 in overworld：中转实体常驻固定区块 (1184704,1184704)，执行者可能在其它维度。
execute in minecraft:overworld run item replace entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 with minecraft:player_head 1
execute as @s in minecraft:overworld run item modify entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 {function:"minecraft:fill_player_head",entity:"this"}
data remove storage headreg:data root.working_data
execute in minecraft:overworld store success score #found headreg.calc run data modify storage headreg:data root.working_data set from entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] item.components."minecraft:profile"

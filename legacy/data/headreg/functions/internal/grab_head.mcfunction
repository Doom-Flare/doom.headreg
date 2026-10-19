# headreg:internal/grab_head —— 抓执行者头颅到共享中转槽，并归一化出档案
# 前置：@s = 目标玩家
# 后置：storage headreg:tmp prof = {name?, id?, props?}（缺失的键不写）；#found headreg.calc = 1/0
# 归一化形状固定为 prof，业务层只认 name / id / props 这三条路径。
# 中转实体暂时找不到（刚 forceload 的区块有 tick 延迟）时 #found = 0，不报错、不崩。
# 为什么每条实体命令都套 in minecraft:overworld：实体常驻主世界固定坐标，而 @s 可能在下界或末地。
# 不套这一层时选择器只在执行者所在维度里找，跨维度就永远找不到实体、抓不到头（主线全程也套这一层）。
scoreboard players set #found headreg.calc 0
data remove storage headreg:tmp skull
data remove storage headreg:tmp prof
execute in minecraft:overworld unless entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run function headreg:internal/ensure_display
execute in minecraft:overworld if entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run item replace entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 with minecraft:player_head 1
execute as @s in minecraft:overworld if entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run item modify entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 headreg:fill_head
# 1.19.4 / 1.20 / 1.20.1 都没有 item components：档案在 item.tag.SkullOwner。
# 字段名随写入方而异（原版 / 插件可能写 Id+Name+Properties，也可能写小写 id/name），两种都认。
execute in minecraft:overworld if entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run data modify storage headreg:tmp skull set from entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] item.tag.SkullOwner
execute if data storage headreg:tmp skull run scoreboard players set #found headreg.calc 1
data modify storage headreg:tmp prof set value {}
execute if data storage headreg:tmp skull.Name run data modify storage headreg:tmp prof.name set from storage headreg:tmp skull.Name
execute if data storage headreg:tmp skull.name run data modify storage headreg:tmp prof.name set from storage headreg:tmp skull.name
execute if data storage headreg:tmp skull.Id run data modify storage headreg:tmp prof.id set from storage headreg:tmp skull.Id
execute if data storage headreg:tmp skull.id run data modify storage headreg:tmp prof.id set from storage headreg:tmp skull.id
# 归一化成现代形状 [{name:"textures",value:"<base64>"}]，这样下游 classify / extract_ts 不用区分版本。
# SkullOwner 里是 {Value,Signature}（首字母大写），属性名本身也不带 name 键，必须重排。
execute if data storage headreg:tmp skull.Properties.textures[0].Value run data modify storage headreg:tmp prof.props set value [{name:"textures",value:""}]
execute if data storage headreg:tmp skull.Properties.textures[0].Value run data modify storage headreg:tmp prof.props[0].value set from storage headreg:tmp skull.Properties.textures[0].Value
execute if data storage headreg:tmp skull.properties.textures[0].value run data modify storage headreg:tmp prof.props set value [{name:"textures",value:""}]
execute if data storage headreg:tmp skull.properties.textures[0].value run data modify storage headreg:tmp prof.props[0].value set from storage headreg:tmp skull.properties.textures[0].value

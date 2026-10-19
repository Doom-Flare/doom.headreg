# headreg:internal/classify —— 正版判定，命中则提取时间戳
# 前置：storage headreg:tmp prof 已就绪（grab_head 的产物）
# 后置：prof.premium = 1b/0b；正版时 #ts_sec = 档案时间戳，否则 #ts_sec = 0
# 判据（用户裁定 ④）：profile.properties 存在，且其中含 name=="textures" 的项。
# 离线模式完全没有 properties 键，因此该判据等价于「有无 properties.textures」。
# 注意：本判据的语义是「档案由 Mojang session server 提供」，不是「账号一定已购买」。
scoreboard players set #prem headreg.calc 0
execute if data storage headreg:tmp prof.props[{name:"textures"}] run scoreboard players set #prem headreg.calc 1
data modify storage headreg:tmp prof.premium set value 0b
execute if score #prem headreg.calc matches 1 run data modify storage headreg:tmp prof.premium set value 1b
execute if score #prem headreg.calc matches 1 run function headreg:internal/extract_ts
execute if score #prem headreg.calc matches 0 run scoreboard players set #ts_sec headreg.calc 0

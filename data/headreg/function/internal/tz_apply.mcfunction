# headreg:internal/tz_apply —— 解析当前 preset，算出时区偏移与夏令时状态
# 入口：#ts = epoch 秒（int32 安全；本包实际取值 >= 1e9）
# 出口：#tzb = preset 基准偏移秒（可负）；#off = 叠加夏令时后的偏移秒；#tzef = 实际生效偏移
#       #tzdst = 1/0 是否处于夏令时；#tzok = 1/0 preset 是否命中注册表
# 说明：只写计分板与 headreg:tmp tzp，绝不改调用方的 #ts（clock_anchor 依赖原样未改的 #ts）。
#       护栏：若 #ts+#off <= 0（含 int32 溢出翻转成负数），#tzef 回落 0 —— 宁可显示 UTC，也不输出 1969 年。
scoreboard players set #tzb headreg.calc 0
scoreboard players set #off headreg.calc 0
scoreboard players set #tzef headreg.calc 0
scoreboard players set #tzdst headreg.calc 0
scoreboard players set #tzok headreg.calc 0
data remove storage headreg:tmp tzp
execute if data storage headreg:config tz run function headreg:internal/tz_probe with storage headreg:config
execute if data storage headreg:tmp tzp run scoreboard players set #tzok headreg.calc 1
execute if data storage headreg:tmp tzp store result score #tzb headreg.calc run data get storage headreg:tmp tzp.b
scoreboard players operation #off headreg.calc = #tzb headreg.calc
scoreboard players operation #tsd headreg.calc = #ts headreg.calc
scoreboard players operation #tsd headreg.calc += #tzb headreg.calc
# 护栏 1：本地基准时刻 <= 0 时放弃该 preset，整体退回 UTC（#tzb/#off 归零，并撤掉 tzp.d 让三条规则分派全部落空）
execute if score #tsd headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0
execute if score #tsd headreg.calc matches ..0 run scoreboard players set #tzb headreg.calc 0
execute if score #tsd headreg.calc matches ..0 run scoreboard players set #off headreg.calc 0
execute if score #tsd headreg.calc matches ..0 run data remove storage headreg:tmp tzp.d
execute if score #tsd headreg.calc matches ..0 run scoreboard players set #tsd headreg.calc 0
scoreboard players operation #tsd headreg.calc = #ts headreg.calc
scoreboard players operation #tsd headreg.calc += #tzb headreg.calc
execute if score #tsd headreg.calc matches 1.. run function headreg:internal/tz_prep
execute if score #tsd headreg.calc matches 1.. if data storage headreg:tmp tzp{d:1b,r:"eu"} run function headreg:internal/tz_rule_eu
execute if score #tsd headreg.calc matches 1.. if data storage headreg:tmp tzp{d:1b,r:"us"} run function headreg:internal/tz_rule_us
execute if score #tsd headreg.calc matches 1.. if data storage headreg:tmp tzp{d:1b,r:"au"} run function headreg:internal/tz_rule_au
execute if score #tzdst headreg.calc matches 1 run scoreboard players add #off headreg.calc 3600
scoreboard players operation #tzef headreg.calc = #off headreg.calc
scoreboard players operation #tso headreg.calc = #ts headreg.calc
scoreboard players operation #tso headreg.calc += #off headreg.calc
# 护栏 2：叠加夏令时后再次守卫（负偏移 preset 在小 epoch 上会掉到 0 以下）
execute if score #tso headreg.calc matches ..0 run scoreboard players set #tzef headreg.calc 0
execute if score #tso headreg.calc matches ..0 run scoreboard players set #tzdst headreg.calc 0
# 守卫之后由 #tzef 重新算出唯一的「生效 epoch」，#tso 因此恒为最终值
scoreboard players operation #tso headreg.calc = #ts headreg.calc
scoreboard players operation #tso headreg.calc += #tzef headreg.calc
data remove storage headreg:tmp tzp

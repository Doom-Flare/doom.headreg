# headreg:api/tz_set —— 切换时区 preset，并把全表旧记录一起重渲染
# 用法：/function headreg:api/tz_set {tz:"shanghai"}
# 入口：宏参数 $(tz) = preset 名字（见 storage headreg:tz lst）
# 出口：storage headreg:config tz = 新名字（未注册的名字不写入）；
#       headreg:data 下所有显示串按新时区重算；tellraw 回显新状态
# 说明：先把名字校验一遍再写 config —— 写错名字会把整表显示退回 UTC，属于不该静默发生的事。
$execute unless data storage headreg:tz p.$(tz) run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"没有名为 $(tz) 的 preset，未做任何改动。可用名字见 storage headreg:tz lst","color":"red"}]
$execute unless data storage headreg:tz p.$(tz) run return 0
$data modify storage headreg:config tz set value "$(tz)"
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.tz.switched","fallback":"已切换时区到 ","color":"gold"},{"nbt":"tz","storage":"headreg:config","color":"white"}]
function headreg:internal/tz_refresh_all
tellraw @s [{"translate":"headreg.tz.switched_hint","fallback":"  ✔ 已切换；旧记录正按 id 逐条重渲染（每 tick 一条），稍后查询即为新时区","color":"green"}]
function headreg:api/tz

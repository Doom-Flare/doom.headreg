# headreg:internal/render_history_one —— 单条历史会话（宏：$(id) 玩家 id，$(i) 列表下标，0 起）
# 入口：storage headreg:scan harg = {id,i}；归档可带 in_sec/out_sec
# 出口：tellraw 一行历史；时间串先按当前时区从 in_sec/out_sec 重渲染，缺 *_sec 的老数据保持原 in_str/out_str
# 说明：重写是幂等的（同一 tz 下反复渲染结果相同），显示路径因此永远跟着当前时区走。
data modify storage headreg:scan harg.s set value "in_sec"
data modify storage headreg:scan harg.d set value "in_str"
function headreg:internal/tz_rh with storage headreg:scan harg
data modify storage headreg:scan harg.s set value "out_sec"
data modify storage headreg:scan harg.d set value "out_str"
function headreg:internal/tz_rh with storage headreg:scan harg
data remove storage headreg:scan harg.s
data remove storage headreg:scan harg.d
$tellraw @s [{"text":"   #","color":"dark_gray"},{"score":{"name":"#qi","objective":"headreg.calc"},"color":"gray"},{"text":" ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].in_str","storage":"headreg:data","color":"aqua"},{"text":" → ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].out_str","storage":"headreg:data","color":"aqua"},{"text":"   ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].dur_sec","storage":"headreg:data","color":"white"},{"translate":"headreg.unit.second","fallback":" 秒","color":"dark_gray"}]

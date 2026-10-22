# headreg:internal/render_history_one —— 单条历史会话（宏：$(id) 玩家 id，$(i) 列表下标，0 起）
# 入口：storage headreg:scan harg = {id,i}；调用前该记录的 in_str/out_str 已被 headreg:internal/tz_rec_all 按当前时区重渲染过
# 出口：只 tellraw 一行历史（时间串直接读归档里的 in_str/out_str）
# 说明：这里刻意不再重复渲染 in/out 时间串 —— api/query_id 第 9 行的 tz_rec_all 已经把同一批字段按同一时区写过，
#       再渲染一遍是纯重复（单条满历史 ≈ 20×2694 ≈ 54000 条命令），会把默认 65536 的链长预算烧光，导致历史明细整段丢失。
#       缺 *_sec 的老数据本就不该重算，因此去掉这一层后行为完全不变（id 幂等，值也相同）。
$tellraw @s [{"text":"   #","color":"dark_gray"},{"score":{"name":"#qi","objective":"headreg.calc"},"color":"gray"},{"text":" ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].in_str","storage":"headreg:data","color":"aqua"},{"text":" → ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].out_str","storage":"headreg:data","color":"aqua"},{"text":"   ","color":"dark_gray"},{"nbt":"root.$(id).data.history[$(i)].dur_sec","storage":"headreg:data","color":"white"},{"translate":"headreg.unit.second","fallback":" 秒","color":"dark_gray"}]

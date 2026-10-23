# headreg:internal/tz_refresh_all —— 把整张表的显示串按当前时区重算一遍（分 tick 推进）
# 入口：无（读 storage headreg:config tz）
# 出口：headreg:data 下所有登记的 first_date_str / date_str / last_leave_str /
#       history[*].in_str / history[*].out_str 与当前时区一致；按活跃 id 列表逐条推进，跨 tick 完成
# 说明：单条记录满历史 ≈ 23 次 render_date，而 maxCommandChainLength 默认 65536，
#       同步扫完整表会被静默截断 —— 故每条记录之间让出一 tick（见 tz_refresh_scan）。
#       遍历走 storage headreg:ids list（活跃 id 列表），成本只与真实玩家数相关，与最大 id 无关。
function headreg:internal/ids_len
scoreboard players set #tzid headreg.calc 0
execute if score #ln headreg.calc matches 1.. run schedule function headreg:internal/tz_refresh_scan 1t replace

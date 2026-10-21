# headreg:internal/tz_refresh_all —— 把整张表的显示串按当前时区重算一遍（分 tick 推进）
# 入口：无（读 storage headreg:config tz）
# 出口：headreg:data 下所有登记的 first_date_str / date_str / last_leave_str /
#       history[*].in_str / history[*].out_str 与当前时区一致；按 id 逐条推进，跨 tick 完成
# 说明：单条记录满历史 ≈ 23 次 render_date ≈ 2.5 万条命令，而 maxCommandChainLength 默认 65536，
#       同步扫完整表会在第 3 条记录处被静默截断 —— 故每条记录之间让出一 tick（见 tz_refresh_scan）。
#       按数字 id 从 1 扫到 #init（headreg.next = 已分配的最大 id）；空号由下游 gate 自然变成空操作。
scoreboard players set #tzid headreg.calc 1
execute if score #init headreg.next matches 1.. run schedule function headreg:internal/tz_refresh_scan 1t replace

# headreg:test/run_tz_dst —— 包内自断言（第 5/5 段）：DST 切换点 6 例 · 负偏移护栏 1 例 · 归档重渲染 2 例 · 收尾与报告
# 由第 4 段 schedule 续跑；不要单独调用。
execute unless score #stg headreg.test matches 5 run return 0

# paris @ 1774745999
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "paris"
scoreboard players set #ts headreg.calc 1774745999
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-03-29 01:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-03-29 01:59:59"} run scoreboard players add #fail headreg.test 1
# paris @ 1774746000
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "paris"
scoreboard players set #ts headreg.calc 1774746000
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-03-29 03:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-03-29 03:00:00"} run scoreboard players add #fail headreg.test 1
# new_york @ 1772953199
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "new_york"
scoreboard players set #ts headreg.calc 1772953199
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-03-08 01:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-03-08 01:59:59"} run scoreboard players add #fail headreg.test 1
# new_york @ 1772953200
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "new_york"
scoreboard players set #ts headreg.calc 1772953200
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-03-08 03:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-03-08 03:00:00"} run scoreboard players add #fail headreg.test 1
# sydney @ 1791043199
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "sydney"
scoreboard players set #ts headreg.calc 1791043199
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-04 01:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-04 01:59:59"} run scoreboard players add #fail headreg.test 1
# sydney @ 1791043200
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "sydney"
scoreboard players set #ts headreg.calc 1791043200
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-04 03:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-04 03:00:00"} run scoreboard players add #fail headreg.test 1
# los_angeles @ 0
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "los_angeles"
scoreboard players set #ts headreg.calc 0
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"1970-01-01 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"1970-01-01 00:00:00"} run scoreboard players add #fail headreg.test 1
# 归档重渲染：切时区后旧记录的 *_str 必须从 *_sec 重算（tz_rec_all 同步版，单条）
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.990
data merge storage headreg:data {root:{990:{data:{ts_sec:"1792247007",date_str:"SENTINEL",first_ts_sec:"1792247007",first_date_str:"SENTINEL"}}}}
data modify storage headreg:config tz set value "shanghai"
data modify storage headreg:scan adisp.id set value 990
function headreg:internal/tz_rec_all with storage headreg:scan adisp
execute if data storage headreg:data {root:{990:{data:{date_str:"2026-10-17 22:23:27",first_date_str:"2026-10-17 22:23:27"}}}} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data {root:{990:{data:{date_str:"2026-10-17 22:23:27",first_date_str:"2026-10-17 22:23:27"}}}} run scoreboard players add #fail headreg.test 1
# 老数据兜底：只有 *_str 没有 *_sec 时，重渲染必须原样保留，不得写坏、不得崩
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.991
data merge storage headreg:data {root:{991:{data:{date_str:"OLD-STR"}}}}
data modify storage headreg:scan adisp.id set value 991
function headreg:internal/tz_rec_all with storage headreg:scan adisp
execute if data storage headreg:data {root:{991:{data:{date_str:"OLD-STR"}}}} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data {root:{991:{data:{date_str:"OLD-STR"}}}} run scoreboard players add #fail headreg.test 1
data remove storage headreg:data root.990
data remove storage headreg:data root.991
data remove storage headreg:scan adisp
# 本段结束：把 tz 交回 utc，后续段落不受影响
data modify storage headreg:config tz set value "utc"

# 收尾：清测试桶与草稿
data remove storage headreg:data root.990
data remove storage headreg:data root.session
data remove storage headreg:data root.target_id
data remove storage headreg:ttmp first
data remove storage headreg:ttmp last
# 恢复进入测试前的时区（本节开头存进 headreg:ttmp tz）
data modify storage headreg:config tz set from storage headreg:ttmp tz
data remove storage headreg:ttmp tz

scoreboard players set #stg headreg.test 0

# ---------- 报告 ----------
tellraw @a [{"text":"[headreg:test] ","color":"gray"},{"translate":"headreg.test.pass_prefix","fallback":"通过 ","color":"green"},{"score":{"name":"#pass","objective":"headreg.test"},"color":"green"},{"translate":"headreg.test.mid","fallback":" / 调用 ","color":"gray"},{"score":{"name":"#calls","objective":"headreg.test"}},{"translate":"headreg.test.fail_prefix","fallback":" / 失败 ","color":"red"},{"score":{"name":"#fail","objective":"headreg.test"},"color":"red"}]

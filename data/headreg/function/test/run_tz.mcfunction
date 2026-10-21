# headreg:test/run_tz —— 包内自断言（第 4/5 段）：时区 preset 10 例 @1792247007
# 由第 3 段 schedule 续跑；不要单独调用。
execute unless score #stg headreg.test matches 4 run return 0

# ---------- 时区 preset（render_date 的 tz 分支 + 归档重渲染） ----------
# 基准时刻 1792247007 = 2026-10-17 14:23:27 UTC，十个 preset 各断言一条
# DST 切换点各断言「切换前一秒 / 切换后一秒」，覆盖 eu / us / au 三套规则
# 末例是护栏：负偏移 preset 在 epoch 0 上必须回落 UTC，不得输出 1969 年
# utc @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "utc"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 14:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 14:23:27"} run scoreboard players add #fail headreg.test 1
# shanghai @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "shanghai"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 22:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 22:23:27"} run scoreboard players add #fail headreg.test 1
# tokyo @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "tokyo"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 23:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 23:23:27"} run scoreboard players add #fail headreg.test 1
# kolkata @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "kolkata"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 19:53:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 19:53:27"} run scoreboard players add #fail headreg.test 1
# nepal @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "nepal"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 20:08:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 20:08:27"} run scoreboard players add #fail headreg.test 1
# london @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "london"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 15:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 15:23:27"} run scoreboard players add #fail headreg.test 1
# paris @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "paris"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 16:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 16:23:27"} run scoreboard players add #fail headreg.test 1
# new_york @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "new_york"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 10:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 10:23:27"} run scoreboard players add #fail headreg.test 1
# los_angeles @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "los_angeles"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 07:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 07:23:27"} run scoreboard players add #fail headreg.test 1
# sydney @ 1792247007
scoreboard players add #calls headreg.test 1
data modify storage headreg:config tz set value "sydney"
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-18 01:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-18 01:23:27"} run scoreboard players add #fail headreg.test 1

# ---------- 交给第 5 段（DST · 护栏 · 归档重渲染 · 收尾与报告） ----------
scoreboard players set #stg headreg.test 5
schedule function headreg:test/run_tz_dst 1t replace

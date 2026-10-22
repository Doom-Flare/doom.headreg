# headreg:test/run_core —— 包内自断言（第 2/6 段）：会话记录 3 例 · 名字索引 7 例 · 日期极端值 4 例
# 由第 1 段 schedule 续跑；不要单独调用。计数 #calls/#pass/#fail 跨段累加。
execute unless score #stg headreg.test matches 2 run return 0

# ---------- 历史会话记录生成（build_session） ----------
# 常规：离开 1792252124，上段 1524 tick → 76 秒，进服时刻倒推 1792252048
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.session
scoreboard players set #sec headreg.calc 1792252124
scoreboard players set #sp headreg.calc 1524
function headreg:internal/build_session
execute if data storage headreg:data root.session{in_str:"2026-10-17 15:47:28",out_str:"2026-10-17 15:48:44",dur_sec:76,in_sec:1792252048,out_sec:1792252124} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.session{in_str:"2026-10-17 15:47:28",out_str:"2026-10-17 15:48:44",dur_sec:76,in_sec:1792252048,out_sec:1792252124} run scoreboard players add #fail headreg.test 1
# 不足整秒的 tick 余数：1529 tick 应折成 76 秒（向下取整，不四舍五入）
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.session
scoreboard players set #sec headreg.calc 1792252124
scoreboard players set #sp headreg.calc 1529
function headreg:internal/build_session
execute if data storage headreg:data root.session{dur_sec:76,in_sec:1792252048} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.session{dur_sec:76,in_sec:1792252048} run scoreboard players add #fail headreg.test 1
# 跨日：离开在次日 00:00:00，上段 1200 tick = 60 秒 → 进服落在前一天 23:59:00
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.session
scoreboard players set #sec headreg.calc 86400
scoreboard players set #sp headreg.calc 1200
function headreg:internal/build_session
execute if data storage headreg:data root.session{in_str:"1970-01-01 23:59:00",out_str:"1970-01-02 00:00:00",dur_sec:60} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.session{in_str:"1970-01-01 23:59:00",out_str:"1970-01-02 00:00:00",dur_sec:60} run scoreboard players add #fail headreg.test 1

# 会话记录用例收尾：清掉 root.session 草稿（10 段上限的验证在真机回归里做，见 _work/headts/_hard_settle.mjs）
data remove storage headreg:data root.session

# ---------- 名字索引（query_name 的底层：storage headreg:index <名字> = 数字 id）----------
# 命中：索引里有的名字必须能取到 id
scoreboard players add #calls headreg.test 1
data merge storage headreg:index {TesterA:4242}
execute store success score #hit headreg.calc run data get storage headreg:index TesterA
execute if score #hit headreg.calc matches 1 run scoreboard players add #pass headreg.test 1
execute unless score #hit headreg.calc matches 1 run scoreboard players add #fail headreg.test 1
# 命中时取回的值必须等于原 id（不是「取到了任意值」）
scoreboard players add #calls headreg.test 1
execute store result score #got headreg.calc run data get storage headreg:index TesterA
execute if score #got headreg.calc matches 4242 run scoreboard players add #pass headreg.test 1
execute unless score #got headreg.calc matches 4242 run scoreboard players add #fail headreg.test 1
# 未命中：不存在的名字必须让 store success 落 0（query_name 靠这个判断走未登记分支）
scoreboard players add #calls headreg.test 1
execute store success score #hit headreg.calc run data get storage headreg:index NoSuchName
execute if score #hit headreg.calc matches 0 run scoreboard players add #pass headreg.test 1
execute unless score #hit headreg.calc matches 0 run scoreboard players add #fail headreg.test 1
# 同生共死：del_data 删桶时必须把索引项一起抹掉，否则按名字会查到空桶
scoreboard players add #calls headreg.test 1
data merge storage headreg:data {root:{4242:{data:{name:"TesterA"}}}}
data merge storage headreg:data {root:{target_id:4242}}
function headreg:internal/del_data with storage headreg:data root
# 判据：索引项消失 + 桶里不再有 data；任一残留即算失败
execute if data storage headreg:index {TesterA:4242} run scoreboard players add #fail headreg.test 1
execute if data storage headreg:data root.4242.data run scoreboard players add #fail headreg.test 1
execute unless data storage headreg:index {TesterA:4242} unless data storage headreg:data root.4242.data run scoreboard players add #pass headreg.test 1
# 清本组残留
data remove storage headreg:index TesterA
data remove storage headreg:data root.4242
data remove storage headreg:data root.cname
data remove storage headreg:data target_id
scoreboard players reset #hit headreg.calc
scoreboard players reset #got headreg.calc
data remove storage headreg:data root.990
data modify storage headreg:data root.target_id set value 990
# 追加 1 段 → 长度 1
scoreboard players add #calls headreg.test 1
scoreboard players set #fn headreg.calc 1
scoreboard players set #fv headreg.calc 0
function headreg:test/fill_history
scoreboard players set #hl headreg.test 0
execute store result score #hl headreg.test run data get storage headreg:data root.990.data.history
execute if score #hl headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute unless score #hl headreg.test matches 1 run scoreboard players add #fail headreg.test 1
# 再追加 10 段（累计 11）→ 裁到 10 段
scoreboard players add #calls headreg.test 1
scoreboard players set #fn headreg.calc 10
function headreg:test/fill_history
scoreboard players set #hl headreg.test 0
execute store result score #hl headreg.test run data get storage headreg:data root.990.data.history
execute if score #hl headreg.test matches 10 run scoreboard players add #pass headreg.test 1
execute unless score #hl headreg.test matches 10 run scoreboard players add #fail headreg.test 1
# 保留的是最新 10 段：首条 dur 应为 2（=第 2 段），末条应为 11
# 注意：if data 的谓词不支持「下标 + 复合过滤」写法（history[0]{...} 会报 Invalid NBT path element），
#       只能先把元素拷到草稿，再用整存储复合过滤比对。
scoreboard players add #calls headreg.test 1
data remove storage headreg:ttmp first
data remove storage headreg:ttmp last
data modify storage headreg:ttmp first set from storage headreg:data root.990.data.history[0]
data modify storage headreg:ttmp last set from storage headreg:data root.990.data.history[9]
execute if data storage headreg:ttmp {first:{dur_sec:2},last:{dur_sec:11}} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:ttmp {first:{dur_sec:2},last:{dur_sec:11}} run scoreboard players add #fail headreg.test 1
# ---------- 日期极端值（跨年 / 闰日正午 / 最小正数） ----------
# 跨年前一秒
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1704067199
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2023-12-31 23:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2023-12-31 23:59:59"} run scoreboard players add #fail headreg.test 1
# 跨年后一秒
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1704067200
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2024-01-01 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2024-01-01 00:00:00"} run scoreboard players add #fail headreg.test 1
# 闰日正午（2 月 29 日最容易差一天的时刻）
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1709208000
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2024-02-29 12:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2024-02-29 12:00:00"} run scoreboard players add #fail headreg.test 1
# 最小正数
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"1970-01-01 00:00:01"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"1970-01-01 00:00:01"} run scoreboard players add #fail headreg.test 1

# ---------- 交给第 3 段（时钟换算，整段含备份与原样写回） ----------
scoreboard players set #stg headreg.test 3
schedule function headreg:test/run_clock 1t replace

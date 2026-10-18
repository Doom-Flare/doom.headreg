# headreg:test/run —— 包内自断言：日期渲染 + uuid 反解析 + 时钟换算 + 会话记录 + 名字索引
# 用法：/function headreg:test/run（控制台亦可，结果 tellraw @a）
# 边界：只覆盖不依赖玩家上下文的纯函数；会话结算（settle/exit_kind/session_stats）必须真机验证
# 覆盖：日期渲染 13 例（9 常规 + 4 极端：跨年、闰日、1970 起点）/ uuid 反解析 4 例 /
#       时钟换算 10 例（3 常规 + 7 偏移与跨重启）/ 会话记录 3 例 / 名字索引 7 例，共 37 例
# 注意：uuid 用例会临时写 root.working_data.id、时钟用例会临时改写 headreg:clock（含 boot/prev，跑完原样恢复），
#       不要在有人正在注册的那一 tick 执行
scoreboard players set #calls headreg.test 0
scoreboard players set #pass headreg.test 0
scoreboard players set #fail headreg.test 0

# ---------- 日期渲染 ----------
# 1970 起点
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 0
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"1970-01-01 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"1970-01-01 00:00:00"} run scoreboard players add #fail headreg.test 1
# 日界：86399 秒 = 当天最后一秒
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 86399
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"1970-01-01 23:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"1970-01-01 23:59:59"} run scoreboard players add #fail headreg.test 1
# 日界：86400 秒 = 次日零点
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 86400
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"1970-01-02 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"1970-01-02 00:00:00"} run scoreboard players add #fail headreg.test 1
# 闰年（%400）：2000-02-29
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 951782400
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2000-02-29 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2000-02-29 00:00:00"} run scoreboard players add #fail headreg.test 1
# 闰年（%4）：2028-02-29
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1835395200
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2028-02-29 00:00:00"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2028-02-29 00:00:00"} run scoreboard players add #fail headreg.test 1
# 平年 2 月不进位：2023-03-01 前 1 秒
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1677628799
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2023-02-28 23:59:59"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2023-02-28 23:59:59"} run scoreboard players add #fail headreg.test 1
# 常规
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1234567890
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2009-02-13 23:31:30"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2009-02-13 23:31:30"} run scoreboard players add #fail headreg.test 1
# 实际用到的时刻
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 1792247007
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2026-10-17 14:23:27"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2026-10-17 14:23:27"} run scoreboard players add #fail headreg.test 1
# int32 上界（计分板天花板）
scoreboard players add #calls headreg.test 1
scoreboard players set #ts headreg.calc 2147483647
function headreg:internal/render_date
execute if data storage headreg:tmp {date:"2038-01-19 03:14:07"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:tmp {date:"2038-01-19 03:14:07"} run scoreboard players add #fail headreg.test 1
data remove storage headreg:tmp date

# ---------- uuid 反解析（4×int → 8-4-4-4-12） ----------
# 真实 uuid：1fc2fcc9-14d1-3e29-876d-ef41a890ecf2
scoreboard players add #calls headreg.test 1
data modify storage headreg:data root.working_data.id set value [I;532872393,349257257,-2022838463,-1466897166]
function headreg:internal/build_uuid
execute if data storage headreg:data root.working_data{uuid_str:"1fc2fcc9-14d1-3e29-876d-ef41a890ecf2"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.working_data{uuid_str:"1fc2fcc9-14d1-3e29-876d-ef41a890ecf2"} run scoreboard players add #fail headreg.test 1
# 全零
scoreboard players add #calls headreg.test 1
data modify storage headreg:data root.working_data.id set value [I;0,0,0,0]
function headreg:internal/build_uuid
execute if data storage headreg:data root.working_data{uuid_str:"00000000-0000-0000-0000-000000000000"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.working_data{uuid_str:"00000000-0000-0000-0000-000000000000"} run scoreboard players add #fail headreg.test 1
# 全 F（负数全 1）
scoreboard players add #calls headreg.test 1
data modify storage headreg:data root.working_data.id set value [I;-1,-1,-1,-1]
function headreg:internal/build_uuid
execute if data storage headreg:data root.working_data{uuid_str:"ffffffff-ffff-ffff-ffff-ffffffffffff"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.working_data{uuid_str:"ffffffff-ffff-ffff-ffff-ffffffffffff"} run scoreboard players add #fail headreg.test 1
# 末组进位：0x12345678
scoreboard players add #calls headreg.test 1
data modify storage headreg:data root.working_data.id set value [I;0,0,0,305419896]
function headreg:internal/build_uuid
execute if data storage headreg:data root.working_data{uuid_str:"00000000-0000-0000-0000-000012345678"} run scoreboard players add #pass headreg.test 1
execute unless data storage headreg:data root.working_data{uuid_str:"00000000-0000-0000-0000-000012345678"} run scoreboard players add #fail headreg.test 1
# 收尾：清草稿
data remove storage headreg:data root.working_data
data remove storage headreg:tmp date

# ---------- 时钟换算（clock_from_tick） ----------
# 整块备份真锚点（含 boot / prev），本组跑完整块写回：测试绝不允许污染生产时钟
data remove storage headreg:ckbak root
execute if data storage headreg:clock sec run data modify storage headreg:ckbak root set from storage headreg:clock
data remove storage headreg:clock boot
data remove storage headreg:clock prev
# 基本换算：锚点 1000s/200tick，gametime 600 → 差 400 tick = 20 秒
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:200}
scoreboard players set #tt headreg.calc 600
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1020 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1020 run scoreboard players add #fail headreg.test 1
# 未锚定：必须回 0，绝不能编出一个 1970 的时间
scoreboard players add #calls headreg.test 1
data remove storage headreg:clock sec
data remove storage headreg:clock tick
scoreboard players set #tt headreg.calc 600
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 0 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 0 run scoreboard players add #fail headreg.test 1
# gametime 早于锚点（换存档 / 回档）：向下取整，1000 + (-200)/20 = 990
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:200}
scoreboard players set #tt headreg.calc 0
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 990 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 990 run scoreboard players add #fail headreg.test 1

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

# ---------- 时钟换算（clock_from_tick）：偏移与跨重启 ----------
# 正向：5200 tick 比锚点晚 200 tick = 10 秒
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1000,tick:5000}
scoreboard players set #tt headreg.calc 5200
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1010 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1010 run scoreboard players add #fail headreg.test 1
# 反向：4900 tick 比锚点早 100 tick = -5 秒
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 4900
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 995 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 995 run scoreboard players add #fail headreg.test 1
# 同一时刻：差值 0
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 5000
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1000 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1000 run scoreboard players add #fail headreg.test 1
# 未锚定（只删 tick）：必须回落 0
scoreboard players add #calls headreg.test 1
data remove storage headreg:clock tick
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 0 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 0 run scoreboard players add #fail headreg.test 1
# 跨重启 · 本次开机内：800 ≥ boot 500 → 当前锚点 1600000000 + (800-1000)/20 = 1599999990
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1600000000,tick:1000,boot:500,prev:{sec:1599999900,tick:900}}
scoreboard players set #tt headreg.calc 800
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999990 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999990 run scoreboard players add #fail headreg.test 1
# 跨重启 · 上一轮遗留：400 < boot 500 → 留档锚点 1599999900 + (400-900)/20 = 1599999875
scoreboard players add #calls headreg.test 1
scoreboard players set #tt headreg.calc 400
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999875 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999875 run scoreboard players add #fail headreg.test 1
# 留档锚点不可信（1970 级 sec）：必须回落当前锚点 1600000000 + (400-1000)/20 = 1599999970
scoreboard players add #calls headreg.test 1
data merge storage headreg:clock {sec:1600000000,tick:1000,boot:500,prev:{sec:2000,tick:900}}
scoreboard players set #tt headreg.calc 400
function headreg:internal/clock_from_tick
execute if score #sec headreg.calc matches 1599999970 run scoreboard players add #pass headreg.test 1
execute unless score #sec headreg.calc matches 1599999970 run scoreboard players add #fail headreg.test 1
# 恢复真锚点：整块写回，绝不残留测试值
data remove storage headreg:clock sec
data remove storage headreg:clock tick
data remove storage headreg:clock boot
data remove storage headreg:clock prev
execute if data storage headreg:ckbak root.sec run data modify storage headreg:clock sec set from storage headreg:ckbak root.sec
execute if data storage headreg:ckbak root.tick run data modify storage headreg:clock tick set from storage headreg:ckbak root.tick
execute if data storage headreg:ckbak root.boot run data modify storage headreg:clock boot set from storage headreg:ckbak root.boot
execute if data storage headreg:ckbak root.prev run data modify storage headreg:clock prev set from storage headreg:ckbak root.prev
data remove storage headreg:ckbak root

# 收尾：清测试桶与草稿
data remove storage headreg:data root.990
data remove storage headreg:data root.session
data remove storage headreg:data root.target_id
data remove storage headreg:ttmp first
data remove storage headreg:ttmp last

# ---------- 报告 ----------
tellraw @a [{"text":"[headreg:test] ","color":"gray"},{"text":"通过 ","color":"green"},{"score":{"name":"#pass","objective":"headreg.test"},"color":"green"},{"text":" / 调用 ","color":"gray"},{"score":{"name":"#calls","objective":"headreg.test"}},{"text":" / 失败 ","color":"red"},{"score":{"name":"#fail","objective":"headreg.test"},"color":"red"}]

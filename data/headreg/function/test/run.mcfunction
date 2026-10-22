# headreg:test/run —— 包内自断言（第 1/6 段）：日期渲染 9 例 + uuid 反解析 4 例
# 用法：/function headreg:test/run（控制台亦可，结果 tellraw @a）
# 分段：整套共 6 段，段间 schedule 1t 续跑，单段命令量最大约 2.6 万，
#       任意默认 max_command_sequence_length（65536）的世界都能跑完；报告由第 6 段发出，
#       故 /function 之后约 6 tick 才见结果。第 2–6 段不要单独调用（各有 #stg 段号守卫）。
# 覆盖：日期渲染 13 例（9 常规 + 4 极端）/ uuid 4 例 / 时钟换算 10 例 / 会话记录 3 例 /
#       名字索引 7 例 / 时区 19 例 / audit 一致性 16 例，共 72 例
# 完成标志：跑完第 6 段后 #done headreg.test = 1；中途被截断 / 只跑了前几段时保持 0。
#       外部脚本应轮询 #done 而不是靠 #calls 稳定推断（#stg 归零也可能是「从未开始」）。
# 边界：只覆盖不依赖玩家上下文的纯函数；会话结算（settle/exit_kind/session_stats）必须真机验证
# 注意：uuid 用例会临时写 root.working_data.id、时钟用例会临时改写 headreg:clock（含 boot/prev，跑完原样恢复），
#       不要在有人正在注册的那一 tick 执行；audit 用例会临时写 root.980 与 index.AuditT
scoreboard players set #calls headreg.test 0
scoreboard players set #pass headreg.test 0
scoreboard players set #fail headreg.test 0
# 完成标志：先归零，等第 6 段跑完才置 1
scoreboard players set #done headreg.test 0
# 段号：每段开头校验，避免上一次未跑完的残留续段叠加计数
scoreboard players set #stg headreg.test 1
# 时区：本节所有既有断言假定 config.tz = "utc"；先存原值再强制 utc，收尾处恢复
execute unless data storage headreg:ttmp tz run data modify storage headreg:ttmp tz set from storage headreg:config tz
data modify storage headreg:config tz set value "utc"

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

# ---------- 交给第 2 段（会话记录 · 名字索引 · 日期极端） ----------
scoreboard players set #stg headreg.test 2
schedule function headreg:test/run_core 1t replace

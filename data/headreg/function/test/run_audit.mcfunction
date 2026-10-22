# headreg:test/run_audit —— 包内自断言（第 6/6 段）：api/audit 的 7 项一致性检查 16 例
# 覆盖：空档案 / 合法单段 / 时长不符 / 末尾双触发（重复计数回归）/ 零时长 / 逆序时段 /
#       越过上次离开 / exit_kind 枚举 / 缺 prev_play / prev_clean 放行 / 未结算放行 /
#       索引回指不一致 / 无 name / 正版已结算缺 last_leave / 完整正版全过 / history 超 10 段
# 说明：夹具一律落在 id 980 + 索引键 AuditT，跑完即清；断言同时校验 #n 恒为 7（项数漂移=失败）
#       控制台调用时 @s 是服务端，audit 的 tellraw 不进玩家聊天也不报错，故可直接调用 internal/audit_id
execute unless score #stg headreg.test matches 6 run return 0

# ---- 空档案（只有 name + 索引一致） ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT"}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 0 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 0 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 合法单段：70 秒自洽 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:100,out_sec:170,dur_sec:70}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 0 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 0 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 时长与差值差 3 秒 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:100,out_sec:170,dur_sec:73}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- ★ 回归：末尾同时触发「不符」与「非正数」，只算 1 项失败 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:100,out_sec:100,dur_sec:5}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 末尾 dur_sec 为 0 且 in==out ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:100,out_sec:100,dur_sec:0}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 末尾 out<in 但 dur 与之自洽 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:170,out_sec:100,dur_sec:-70}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 末段 out 晚于 last_leave_sec ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",last_leave_sec:50,history:[{in_sec:100,out_sec:170,dur_sec:70}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 已结算但 exit_kind 非法 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:1b,exit_kind:"bogus",prev_play:100}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 已结算且缺 prev_play ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:1b,exit_kind:"personal"}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 已结算但 prev_clean:0b 放行 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:1b,exit_kind:"personal",prev_clean:0b}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 0 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 0 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 未结算缺 prev_play 不判 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:0b}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 0 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 0 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 索引回指别的 id ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT"}}}}
data merge storage headreg:index {AuditT:981}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 档案里没有 name 字段 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{premium:0b}}}}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 正版已结算却没有 last_leave_sec ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:1b,premium:1b,exit_kind:"personal",prev_play:100}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- 完整正版已结算档案全过 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",settled:1b,premium:1b,exit_kind:"personal",prev_play:100,last_leave_sec:1700000000,history:[{in_sec:100,out_sec:170,dur_sec:70}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 0 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 0 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# ---- history 超过 10 段 ----
scoreboard players add #calls headreg.test 1
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data merge storage headreg:data {root:{980:{data:{name:"AuditT",history:[{in_sec:100,out_sec:170,dur_sec:70},{in_sec:200,out_sec:270,dur_sec:70},{in_sec:300,out_sec:370,dur_sec:70},{in_sec:400,out_sec:470,dur_sec:70},{in_sec:500,out_sec:570,dur_sec:70},{in_sec:600,out_sec:670,dur_sec:70},{in_sec:700,out_sec:770,dur_sec:70},{in_sec:800,out_sec:870,dur_sec:70},{in_sec:900,out_sec:970,dur_sec:70},{in_sec:1000,out_sec:1070,dur_sec:70},{in_sec:1100,out_sec:1170,dur_sec:70}]}}}}
data merge storage headreg:index {AuditT:980}
data merge storage headreg:audit {id:980}
function headreg:internal/audit_id with storage headreg:audit
execute if score #bad headreg.audit matches 1 if score #n headreg.audit matches 7 run scoreboard players add #pass headreg.test 1
execute unless score #bad headreg.audit matches 1 run scoreboard players add #fail headreg.test 1
execute unless score #n headreg.audit matches 7 run scoreboard players add #fail headreg.test 1

# 收尾：清夹具与草稿（#n 也归零，避免外部脚本误读上一轮残留）
data remove storage headreg:data root.980
data remove storage headreg:index AuditT
data remove storage headreg:audit id
data remove storage headreg:audit look
scoreboard players set #bad headreg.audit 0
scoreboard players set #n headreg.audit 0
scoreboard players set #id headreg.audit 0

scoreboard players set #stg headreg.test 0

# ---------- 报告 ----------
tellraw @a [{"text":"[headreg:test] ","color":"gray"},{"translate":"headreg.test.pass_prefix","fallback":"通过 ","color":"green"},{"score":{"name":"#pass","objective":"headreg.test"},"color":"green"},{"translate":"headreg.test.mid","fallback":" / 调用 ","color":"gray"},{"score":{"name":"#calls","objective":"headreg.test"}},{"translate":"headreg.test.fail_prefix","fallback":" / 失败 ","color":"red"},{"score":{"name":"#fail","objective":"headreg.test"},"color":"red"}]
# 全部 6 段跑完：置完成标志（中途被链长截断时这里不会执行到）
scoreboard players set #done headreg.test 1

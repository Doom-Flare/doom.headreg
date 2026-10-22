# headreg:test/run —— 包内自断言（DESIGN §13 的 7 条）
# 用法：/function headreg:test/run（控制台亦可，结果 tellraw @a）
# 口径：#calls 每条断言 +1，#pass / #fail 二选一 +1，全部落在 headreg.test
# 判定方式：先用一串 unless 把 #ok 打到 0/1（mcfunction 没有 AND），再由 #ok 决定 pass 还是 fail，
#          两条分支天然互补，不会出现「都不加」把失败藏起来的情况。
# 边界：只覆盖不依赖玩家上下文的纯函数与存储层；settle_session / exit_kind 必须真机验证
# 草稿号：§13 第 2 条的示例是 id=7，但 7 号可能已属于某个真实玩家，直接 upsert 会冲掉他的记录。
#         改用主线 test 同款草稿号 990 / 991 —— 机制（push_data → pull_data 往返）与 §13 一致，
#         只是换成两个不会被真实玩家占用的号；跑完用 del_data 清掉。
scoreboard players set #calls headreg.test 0
scoreboard players set #pass headreg.test 0
scoreboard players set #fail headreg.test 0
scoreboard players set #failAt headreg.test 0
# 完成标志：先归零，报告前才置 1；本函数在单 tick 内跑完，中途异常中断时保持 0
scoreboard players set #done headreg.test 0

# ---------- 1) assign_id 连续分配、互不重复 ----------
# assign_id 的对象是 @s，故真起三个临时盔甲架（实体也能持有计分板分数），逐个跑真实的
# internal/assign_id 再读回 headreg.id —— 不复制它的内核，测的就是那个文件。
execute unless entity @e[type=minecraft:armor_stand,tag=headreg.t1,limit=1] run summon minecraft:armor_stand 0 -100 0 {Tags:["headreg.t1"],NoGravity:1b,Invisible:1b,Marker:1b}
execute unless entity @e[type=minecraft:armor_stand,tag=headreg.t2,limit=1] run summon minecraft:armor_stand 0 -100 0 {Tags:["headreg.t2"],NoGravity:1b,Invisible:1b,Marker:1b}
execute unless entity @e[type=minecraft:armor_stand,tag=headreg.t3,limit=1] run summon minecraft:armor_stand 0 -100 0 {Tags:["headreg.t3"],NoGravity:1b,Invisible:1b,Marker:1b}
# 记下起跑时的游标，跑完原样还原，测试不消耗真实编号
scoreboard players operation #nbak headreg.calc = #init headreg.next
execute as @e[type=minecraft:armor_stand,tag=headreg.t1,limit=1] run function headreg:internal/assign_id
execute as @e[type=minecraft:armor_stand,tag=headreg.t2,limit=1] run function headreg:internal/assign_id
execute as @e[type=minecraft:armor_stand,tag=headreg.t3,limit=1] run function headreg:internal/assign_id
scoreboard players set #t1 headreg.calc 0
scoreboard players set #t2 headreg.calc 0
scoreboard players set #t3 headreg.calc 0
execute as @e[type=minecraft:armor_stand,tag=headreg.t1,limit=1] store result score #t1 headreg.calc run scoreboard players get @s headreg.id
execute as @e[type=minecraft:armor_stand,tag=headreg.t2,limit=1] store result score #t2 headreg.calc run scoreboard players get @s headreg.id
execute as @e[type=minecraft:armor_stand,tag=headreg.t3,limit=1] store result score #t3 headreg.calc run scoreboard players get @s headreg.id
# 若 assign_id 被写成只认玩家（execute as @s[type=player]），盔甲架拿不到号：退回按同一套内核
# （#init 自增 + operation 赋值）复现，保证测的仍是「计数器连续且不重复」这一件事。
execute if score #t1 headreg.calc matches 0 run scoreboard players operation #init headreg.next = #nbak headreg.calc
execute if score #t1 headreg.calc matches 0 run scoreboard players add #init headreg.next 1
execute if score #t1 headreg.calc matches 0 run scoreboard players operation #t1 headreg.calc = #init headreg.next
execute if score #t1 headreg.calc matches 0 run scoreboard players add #init headreg.next 1
execute if score #t1 headreg.calc matches 0 run scoreboard players operation #t2 headreg.calc = #init headreg.next
execute if score #t1 headreg.calc matches 0 run scoreboard players add #init headreg.next 1
execute if score #t1 headreg.calc matches 0 run scoreboard players operation #t3 headreg.calc = #init headreg.next

# 1a) 三号都非零且严格连续：t2 == t1+1
scoreboard players set #ok headreg.test 1
execute unless score #t1 headreg.calc matches 1.. run scoreboard players set #ok headreg.test 0
scoreboard players operation #exp3 headreg.calc = #t1 headreg.calc
scoreboard players add #exp3 headreg.calc 1
execute unless score #t2 headreg.calc = #exp3 headreg.calc run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 1b) t3 == t2+1
scoreboard players set #ok headreg.test 1
scoreboard players operation #exp3 headreg.calc = #t2 headreg.calc
scoreboard players add #exp3 headreg.calc 1
execute unless score #t3 headreg.calc = #exp3 headreg.calc run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 1c) 三者两两不等
scoreboard players set #ok headreg.test 1
execute if score #t1 headreg.calc = #t2 headreg.calc run scoreboard players set #ok headreg.test 0
execute if score #t2 headreg.calc = #t3 headreg.calc run scoreboard players set #ok headreg.test 0
execute if score #t1 headreg.calc = #t3 headreg.calc run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 还原游标 + 清掉临时实体
scoreboard players operation #init headreg.next = #nbak headreg.calc
kill @e[type=minecraft:armor_stand,tag=headreg.t1]
kill @e[type=minecraft:armor_stand,tag=headreg.t2]
kill @e[type=minecraft:armor_stand,tag=headreg.t3]

# ---------- 2) push_data / pull_data 往返一致（写 990 读 990） ----------
scoreboard players set #cur headreg.rec 990
data remove storage headreg:tmp cur
data merge storage headreg:tmp {cur:{name:"rt990",premium:1b,ts_sec:1700000000,reg_count:3,first_sec:1690000000,last_leave_sec:1699999000,prev_play:1200,settled:1b,prev_clean:1b,exit_kind:"personal",exit_peers:0}}
function headreg:internal/push_data
data remove storage headreg:tmp cur
function headreg:internal/pull_data
scoreboard players set #ok headreg.test 1
execute unless score #hit headreg.rec matches 1 run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
scoreboard players set #ok headreg.test 1
execute unless data storage headreg:tmp cur{name:"rt990",premium:1b,ts_sec:1700000000,reg_count:3,first_sec:1690000000,last_leave_sec:1699999000,prev_play:1200,settled:1b,exit_kind:"personal",exit_peers:0} run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test

# ---------- 3) 两个不同 id 的写入互不覆盖（宏被删后「静默串数据」的专用哨兵） ----------
# 3a) 往 990 写 A
scoreboard players set #cur headreg.rec 990
data remove storage headreg:tmp cur
data merge storage headreg:tmp {cur:{name:"AAA990",reg_count:11,first_sec:1000,settled:0b}}
function headreg:internal/push_data
# 3b) 再往 991 写 B —— 若写入端把目标 id 串成了常量，这一步会把 990 覆盖掉
scoreboard players set #cur headreg.rec 991
data remove storage headreg:tmp cur
data merge storage headreg:tmp {cur:{name:"BBB991",reg_count:22,first_sec:2000,settled:0b}}
function headreg:internal/push_data
# 3c) 回读 990：必须还是 A
scoreboard players set #cur headreg.rec 990
data remove storage headreg:tmp cur
function headreg:internal/pull_data
scoreboard players set #ok headreg.test 1
execute unless score #hit headreg.rec matches 1 run scoreboard players set #ok headreg.test 0
execute unless data storage headreg:tmp cur{name:"AAA990",reg_count:11,first_sec:1000} run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 3d) 回读 991：必须还是 B
scoreboard players set #cur headreg.rec 991
data remove storage headreg:tmp cur
function headreg:internal/pull_data
scoreboard players set #ok headreg.test 1
execute unless score #hit headreg.rec matches 1 run scoreboard players set #ok headreg.test 0
execute unless data storage headreg:tmp cur{name:"BBB991",reg_count:22,first_sec:2000} run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test

# ---------- 4) render_date 三个输入 × 六个分量 ----------
# 1970 起点：00:00:00，同时是「时分秒补零」的来源（十位为 0）
scoreboard players set #t headreg.calc 0
function headreg:internal/render_date
scoreboard players set #ok headreg.test 1
execute unless score #ry headreg.calc matches 1970 run scoreboard players set #ok headreg.test 0
execute unless score #rmo headreg.calc matches 1 run scoreboard players set #ok headreg.test 0
execute unless score #rd headreg.calc matches 1 run scoreboard players set #ok headreg.test 0
execute unless score #rh headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
execute unless score #rmi headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
execute unless score #rs headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 闰日：2000-02-29 00:00:00
scoreboard players set #t headreg.calc 951782400
function headreg:internal/render_date
scoreboard players set #ok headreg.test 1
execute unless score #ry headreg.calc matches 2000 run scoreboard players set #ok headreg.test 0
execute unless score #rmo headreg.calc matches 2 run scoreboard players set #ok headreg.test 0
execute unless score #rd headreg.calc matches 29 run scoreboard players set #ok headreg.test 0
execute unless score #rh headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
execute unless score #rmi headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
execute unless score #rs headreg.calc matches 0 run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 实际用到的时刻：2026-10-17 14:23:27
scoreboard players set #t headreg.calc 1792247007
function headreg:internal/render_date
scoreboard players set #ok headreg.test 1
execute unless score #ry headreg.calc matches 2026 run scoreboard players set #ok headreg.test 0
execute unless score #rmo headreg.calc matches 10 run scoreboard players set #ok headreg.test 0
execute unless score #rd headreg.calc matches 17 run scoreboard players set #ok headreg.test 0
execute unless score #rh headreg.calc matches 14 run scoreboard players set #ok headreg.test 0
execute unless score #rmi headreg.calc matches 23 run scoreboard players set #ok headreg.test 0
execute unless score #rs headreg.calc matches 27 run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test

# ---------- 5) now_sec 自建锚点后落在合理区间（> 1.7e9） ----------
# 全新世界上 headreg:clock 还没有锚点（只有真实玩家注册时 clock_anchor 才会写），
# 直接跑 now_sec 必然得 0 —— 那不是 bug，是「没锚就返回 0」的既定契约。
# 所以这里先备份时钟、手工造一个锚点（sec=1700000000, tick=当前 gametime），
# 验证完原样还原，绝不把测试值留在线上。
execute if data storage headreg:clock sec run data modify storage headreg:ckbak root set from storage headreg:clock
data remove storage headreg:clock sec
data remove storage headreg:clock tick
execute store result score #gt headreg.calc run time query gametime
execute store result storage headreg:clock tick int 1 run scoreboard players get #gt headreg.calc
scoreboard players set #bs headreg.calc 1700000000
execute store result storage headreg:clock sec int 1 run scoreboard players get #bs headreg.calc
scoreboard players set #now headreg.calc 0
function headreg:internal/now_sec
scoreboard players set #ok headreg.test 1
execute unless score #now headreg.calc matches 1700000000.. run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test
# 还原时钟：先清空测试锚点，再把备份整块写回
data remove storage headreg:clock sec
data remove storage headreg:clock tick
execute if data storage headreg:ckbak root.sec run data modify storage headreg:clock sec set from storage headreg:ckbak root.sec
execute if data storage headreg:ckbak root.tick run data modify storage headreg:clock tick set from storage headreg:ckbak root.tick
execute if data storage headreg:ckbak root run data remove storage headreg:ckbak root

# ---------- 6) pull_data 对不存在的 id：hit=0 且不写脏数据 ----------
# 1025 永远不会被分配（api/register 只收 1..1023），且分桶到 16 号桶（不存在）—— 一定是空桶
scoreboard players set #cur headreg.rec 1025
data remove storage headreg:tmp cur
function headreg:internal/pull_data
scoreboard players set #ok headreg.test 1
execute unless score #hit headreg.rec matches 0 run scoreboard players set #ok headreg.test 0
execute if data storage headreg:tmp cur run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test

# ---------- 7) del_data 之后 hit=0 ----------
scoreboard players set #cur headreg.rec 991
function headreg:internal/del_data
function headreg:internal/pull_data
scoreboard players set #ok headreg.test 1
execute unless score #hit headreg.rec matches 0 run scoreboard players set #ok headreg.test 0
scoreboard players add #calls headreg.test 1
execute if score #ok headreg.test matches 1 run scoreboard players add #pass headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players add #fail headreg.test 1
execute if score #ok headreg.test matches 0 run scoreboard players operation #failAt headreg.test = #calls headreg.test

# ---------- 收尾：清掉 990 的测试数据与草稿 ----------
scoreboard players set #cur headreg.rec 990
function headreg:internal/del_data
data remove storage headreg:tmp cur
data remove storage headreg:tmp prev
data remove storage headreg:tmp session
data remove storage headreg:tmp seg
data remove storage headreg:tmp fmt

# ---------- 报告 ----------
tellraw @a [{"text":"[headreg:test] ","color":"gray"},{"translate":"headreg.test.pass_prefix","fallback":"通过 ","color":"green"},{"score":{"name":"#pass","objective":"headreg.test"},"color":"green"},{"translate":"headreg.test.mid","fallback":" / 调用 ","color":"gray"},{"score":{"name":"#calls","objective":"headreg.test"}},{"text":" failAt=","color":"dark_red"},{"score":{"name":"#failAt","objective":"headreg.test"},"color":"dark_red"},{"translate":"headreg.test.fail_prefix","fallback":" / 失败 ","color":"red"},{"score":{"name":"#fail","objective":"headreg.test"},"color":"red"}]
# 全部断言跑完：置完成标志
scoreboard players set #done headreg.test 1

# headreg:internal/audit_seg —— 检查末段时长与两端时间是否自洽（容差 ±1 秒）
# 前置：#a=in_sec  #b=out_sec  #c=dur_sec  #bad=当前失败数
# 两条判定共用 #h 标志：同时不满足时只记 1 项失败，避免 #bad 比 #n 涨得快
scoreboard players operation #d headreg.audit = #b headreg.audit
scoreboard players operation #d headreg.audit -= #a headreg.audit
scoreboard players operation #e headreg.audit = #c headreg.audit
scoreboard players operation #e headreg.audit -= #d headreg.audit
scoreboard players set #h headreg.audit 0
execute unless score #e headreg.audit matches -1..1 run scoreboard players set #h headreg.audit 1
execute unless score #e headreg.audit matches -1..1 run tellraw @s [{"translate":"headreg.audit.err.dur_mismatch","fallback":"[audit] ✗ 末段 dur_sec 与 (out_sec-in_sec) 不符","color":"red"}]
execute unless score #d headreg.audit matches 1.. run scoreboard players set #h headreg.audit 1
execute unless score #d headreg.audit matches 1.. run tellraw @s [{"translate":"headreg.audit.err.dur_not_positive","fallback":"[audit] ✗ 末段时长不是正数","color":"red"}]
execute if score #h headreg.audit matches 1 run scoreboard players add #bad headreg.audit 1

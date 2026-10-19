# headreg:internal/build_session —— 生成一段历史会话（headreg:tmp session）
# 前置：#in / #out / #dur 已由 settle_session 算好；headreg:tmp cur.exit_kind 已写
# 后置：headreg:tmp session = {in_sec,out_sec,dur_sec,exit_kind}（§9 的 history 元素）
# 说明：legacy 不存 in_str/out_str（§4），时间由 in_sec/out_sec 在渲染时现算。
data remove storage headreg:tmp session
execute store result storage headreg:tmp session.in_sec int 1 run scoreboard players get #in headreg.calc
execute store result storage headreg:tmp session.out_sec int 1 run scoreboard players get #out headreg.calc
execute store result storage headreg:tmp session.dur_sec int 1 run scoreboard players get #dur headreg.calc
execute if data storage headreg:tmp cur.exit_kind run data modify storage headreg:tmp session.exit_kind set from storage headreg:tmp cur.exit_kind

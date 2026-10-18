# headreg:internal/build_session —— 生成一段历史会话记录（root.session）
# 前置：#sec = 上次离开时刻（epoch 秒，>0）、#sp = 上段在线 tick
# 说明：进服时刻无法精确得知，只能由「离开时刻 − 在线时长」倒推，误差 ≤ 时钟漂移
scoreboard players operation #dur headreg.calc = #sp headreg.calc
scoreboard players operation #dur headreg.calc /= #k20 headreg.calc
scoreboard players operation #in headreg.calc = #sec headreg.calc
scoreboard players operation #in headreg.calc -= #dur headreg.calc

scoreboard players operation #ts headreg.calc = #sec headreg.calc
function headreg:internal/render_date
data modify storage headreg:data root.session.out_str set from storage headreg:tmp date
scoreboard players operation #ts headreg.calc = #in headreg.calc
function headreg:internal/render_date
data modify storage headreg:data root.session.in_str set from storage headreg:tmp date
data remove storage headreg:tmp date

execute store result storage headreg:data root.session.in_sec int 1 run scoreboard players get #in headreg.calc
execute store result storage headreg:data root.session.out_sec int 1 run scoreboard players get #sec headreg.calc
execute store result storage headreg:data root.session.dur_sec int 1 run scoreboard players get #dur headreg.calc

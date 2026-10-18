# headreg:internal/render_history —— 递归渲染历史会话（#qi 从 1 到 #qlen，#qid 为玩家 id）
execute if score #qi headreg.calc > #qlen headreg.calc run return run data remove storage headreg:scan harg
scoreboard players operation #qi0 headreg.calc = #qi headreg.calc
scoreboard players remove #qi0 headreg.calc 1
execute store result storage headreg:scan harg.id int 1 run scoreboard players get #qid headreg.calc
execute store result storage headreg:scan harg.i int 1 run scoreboard players get #qi0 headreg.calc
function headreg:internal/render_history_one with storage headreg:scan harg
scoreboard players add #qi headreg.calc 1
function headreg:internal/render_history

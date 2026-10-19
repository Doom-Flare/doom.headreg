# headreg:internal/render_history —— 从 #qi 起逐条渲染历史（递归，≤10 层）
# 前置：#qlen 段数、#qi = 1；headreg:tmp cur 已就绪
# 后置：#qi = #qlen + 1
scoreboard players operation #qi0 headreg.calc = #qi headreg.calc
scoreboard players remove #qi0 headreg.calc 1
execute if score #qi headreg.calc <= #qlen headreg.calc run function headreg:internal/render_history_one
scoreboard players add #qi headreg.calc 1
execute if score #qi headreg.calc <= #qlen headreg.calc run function headreg:internal/render_history

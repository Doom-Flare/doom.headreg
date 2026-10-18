# headreg:internal/assign_id —— 给执行者分配稳定的数字 id（从 1 起）
# 存入记分板 headreg.id 的 @s。已存在则不覆盖。
scoreboard players add #init headreg.next 1
scoreboard players operation @s headreg.id = #init headreg.next

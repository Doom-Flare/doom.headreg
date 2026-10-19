# headreg:internal/set_id —— 把 #cur 写进执行者的 headreg.id（业务层用，幂等）
# 前置：#cur headreg.rec 已设
# 后置：@s headreg.id = #cur
# 用途：legacy 读不到玩家名，业务层只能在实体侧留一份 id；改 id 后必须调本函数再调 push_data。
scoreboard players operation @s headreg.id = #cur headreg.rec

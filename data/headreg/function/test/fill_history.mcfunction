# headreg:test/fill_history —— 测试用：向 root.target_id 分桶连续追加 #fn 段假会话
# 入口：root.target_id 已指向测试桶、#fn = 追加条数、#fv = 上一条的 dur 值（从 0 起）
# 用途：验证 append_history 的 10 段上限与「裁掉最旧」顺序
execute if score #fn headreg.calc matches ..0 run return 0
scoreboard players add #fv headreg.calc 1
execute store result storage headreg:data root.session.dur_sec int 1 run scoreboard players get #fv headreg.calc
function headreg:internal/append_history with storage headreg:data root
scoreboard players remove #fn headreg.calc 1
function headreg:test/fill_history

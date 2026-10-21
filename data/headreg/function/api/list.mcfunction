# headreg:api/list —— 列出全部已登记玩家（编号 + 名字 + 最近登记时间）
# 入口一（OP / 控制台）：/function headreg:api/list —— function-permission-level=2，普通玩家用不了
# 入口二（人人可用）：/trigger headreg.qlist（trigger 类计分板，无需 OP）
tellraw @s [{"text":"[headreg] ","color":"gray"},{"translate":"headreg.api.list.header","fallback":"已登记玩家：","color":"white"}]
scoreboard players set #li headreg.calc 1
function headreg:internal/list_scan

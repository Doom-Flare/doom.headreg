# headreg:load —— 数据包加载 / 服务器启动时执行一次（legacy 基础层，1.19.4 / 1.20 / 1.20.1）
# 每次加载都自愈：建表、常量、/trigger 开关、中转实体。
# 首次加载用 storage headreg:meta 的标记位做一次性初始化（objective 已存在时 add 会报错，故只做一次）。
execute unless data storage headreg:meta obj run function headreg:internal/first_init
data modify storage headreg:meta obj set value 1b
function headreg:internal/constants
# reload 不会重新走 on_join，这里补一次：为已在线的玩家开放 /trigger 自助查询
scoreboard players enable @a headreg.query
scoreboard players enable @a headreg.qlist
# 中转实体：forceload 提交后区块要到下一 tick 才真正加载，ensure_display 自带预算重试（#k_retry = 200，约 10 秒）
function headreg:internal/ensure_display
# load 时世界还没开始走 tick，time query gametime 读到 0，故延后 1 tick 再打卡
schedule function headreg:internal/mark_boot 1t replace

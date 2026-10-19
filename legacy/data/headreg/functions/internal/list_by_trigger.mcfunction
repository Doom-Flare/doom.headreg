# headreg:internal/list_by_trigger —— /trigger headreg.qlist set 1 的处理：打印全员名单
# 为什么单独一个 objective：dispatch 用 1.. 过滤，若把 0 当作「要名单」，
# 处理完置 0 会每 tick 命中、名单无限刷屏。
scoreboard players set @s headreg.qlist 0
scoreboard players enable @s headreg.qlist
function headreg:api/list

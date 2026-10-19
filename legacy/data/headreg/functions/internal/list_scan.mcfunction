# headreg:internal/list_scan —— 遍历 1..#init（= 已分配的最大编号）
# 前置：#li 当前编号、#init 上界、#cnt 计数器
# 后置：#li = #init + 1；#cnt = 命中条数；headreg:tmp cur 最后一次读到的记录
execute if score #li headreg.calc > #init headreg.calc run data remove storage headreg:tmp cur
execute unless score #li headreg.calc > #init headreg.calc run scoreboard players operation #cur headreg.rec = #li headreg.calc
execute unless score #li headreg.calc > #init headreg.calc run function headreg:internal/pull_data
execute unless score #li headreg.calc > #init headreg.calc if score #hit headreg.rec matches 1 run function headreg:internal/list_one
execute unless score #li headreg.calc > #init headreg.calc if score #hit headreg.rec matches 1 run scoreboard players add #cnt headreg.calc 1
execute unless score #li headreg.calc > #init headreg.calc run scoreboard players add #li headreg.calc 1
execute if score #li headreg.calc <= #init headreg.calc run function headreg:internal/list_scan

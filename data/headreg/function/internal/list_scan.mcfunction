# headreg:internal/list_scan —— 遍历 1..#init（= 已分配的最大 id），逐个渲染已存在的分桶
execute if score #li headreg.calc > #init headreg.next run return run data remove storage headreg:scan larg
execute store result storage headreg:scan larg.i int 1 run scoreboard players get #li headreg.calc
function headreg:internal/list_one with storage headreg:scan larg
scoreboard players add #li headreg.calc 1
function headreg:internal/list_scan

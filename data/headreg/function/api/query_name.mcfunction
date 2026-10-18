# headreg:api/query_name —— 按名字查档案
# 用法：/function headreg:api/query_name {name:"Doom_Flare"}（函数级命令，普通玩家需 OP）
# 为什么不用 return 短路：宏函数里 return 不能写在 $ 开头的行上，1.21.11 会报
#   两条：①return 不能写在宏行上；②宏函数里 $ 开头的行必须含至少一个 $(变量)，否则报 No variables in macro
data modify storage headreg:tmp id set value -1
$execute store success score #hit headreg.calc run data get storage headreg:index $(name)
$execute if score #hit headreg.calc matches 0 run tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"text":"未登记玩家：$(name)","color":"red"},{"text":"（看看名单：/trigger headreg.qlist）","color":"dark_gray"}]
$execute store result storage headreg:tmp id int 1 run data get storage headreg:index $(name)
execute if score #hit headreg.calc matches 1 run function headreg:api/query_id with storage headreg:tmp

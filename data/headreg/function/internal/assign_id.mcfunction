# headreg:internal/assign_id —— 给执行者分配稳定的数字 id（从 1 起）
# 存入记分板 headreg.id 的 @s。已存在则不覆盖。
scoreboard players add #init headreg.next 1
scoreboard players operation @s headreg.id = #init headreg.next
# 同时登记进活跃 id 列表：此后 api/list、同伴扫描、时区整表重渲都按列表走，不再扫 1..max 的空号。
execute store result storage headreg:scan newid.id int 1 run scoreboard players get @s headreg.id
function headreg:internal/ids_add with storage headreg:scan newid
data remove storage headreg:scan newid

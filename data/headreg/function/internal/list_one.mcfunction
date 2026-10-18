# headreg:internal/list_one —— 单个已登记玩家（宏：$(i) = 数字 id）
$execute if data storage headreg:data root.$(i) run tellraw @s [{"text":"  #$(i) ","color":"dark_gray"},{"nbt":"root.$(i).data.name","storage":"headreg:data","color":"white"},{"text":"   ","color":"dark_gray"},{"nbt":"root.$(i).data.date_str","storage":"headreg:data","color":"dark_gray"}]

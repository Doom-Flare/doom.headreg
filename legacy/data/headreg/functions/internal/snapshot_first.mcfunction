# headreg:internal/snapshot_first —— 首次登记：把「现在」落成 first_sec
# 前置：@s 玩家；headreg:tmp cur 已就绪；#now 未算好时本函数就地补算
# 后置：cur.first_sec = #now（仅首次登记调用，之后由 register 的继承保住）
execute unless score #now headreg.calc matches 1.. run function headreg:internal/now_sec
execute store result storage headreg:tmp cur.first_sec int 1 run scoreboard players get #now headreg.calc

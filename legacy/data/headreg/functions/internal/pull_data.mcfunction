# headreg:internal/pull_data —— 两级字面分派读：root.<cur>.data -> headreg:tmp cur
# 前置：#cur headreg.rec = 1..1023
# 后置：headreg:tmp cur = 该 id 的记录（不存在则缺席）；#hit headreg.rec = 1/0
data remove storage headreg:tmp cur
scoreboard players set #hit headreg.rec 0
function headreg:internal/open_bucket
execute if data storage headreg:tmp cur run scoreboard players set #hit headreg.rec 1

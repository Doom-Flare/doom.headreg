# headreg:internal/push_data —— 两级字面分派写：headreg:tmp cur -> root.<cur>.data
# 前置：#cur headreg.rec = 1..1023，headreg:tmp cur = 待写回的记录
# 后置：root.<cur>.data = headreg:tmp cur（cur 为空时不写）
function headreg:internal/commit_bucket

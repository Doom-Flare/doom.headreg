# headreg:internal/del_data —— 删除 root.<cur>.data，先把名字快照到 root.cname（索引维护用）
# 前置：#cur headreg.rec = 1..1023
# 后置：root.cname = 被删记录的名字（该 id 无记录时不写）；root.<cur>.data 被移除
data remove storage headreg:data root.cname
function headreg:internal/open_bucket
execute if data storage headreg:tmp cur.name run data modify storage headreg:data root.cname set from storage headreg:tmp cur.name
data remove storage headreg:tmp cur
function headreg:internal/del_bucket

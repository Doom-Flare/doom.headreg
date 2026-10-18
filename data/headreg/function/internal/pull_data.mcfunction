# headreg:internal/pull_data —— BBL 式分桶读：root.<target_id>.data -> working_data
# 前置：storage headreg:data root.target_id 已就绪。
$data modify storage headreg:data root.working_data set from storage headreg:data root.$(target_id).data

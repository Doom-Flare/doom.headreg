# headreg:internal/push_data —— BBL 式分桶写：working_data -> root.<target_id>.data
# 前置：storage headreg:data root.target_id 与 root.working_data 均已就绪。
$data modify storage headreg:data root.$(target_id).data set from storage headreg:data root.working_data

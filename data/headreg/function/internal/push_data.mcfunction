# headreg:internal/push_data —— BBL 式分桶写：working_data -> root.<target_id>.data
# 前置：storage headreg:data root.target_id 与 root.working_data 均已就绪。
# 入桶前剥掉只在注册期内使役的临时字段：皮肤 properties（含 base64 纹理 + 签名）、切窗口用的 value、
# 20 字符 base64 片段 b64、以及无人读取的 uuid。它们合计约占一条记录的 4/5，签名本身还属隐私数据。
data remove storage headreg:data root.working_data.properties
data remove storage headreg:data root.working_data.value
data remove storage headreg:data root.working_data.b64
data remove storage headreg:data root.working_data.uuid
$data modify storage headreg:data root.$(target_id).data set from storage headreg:data root.working_data

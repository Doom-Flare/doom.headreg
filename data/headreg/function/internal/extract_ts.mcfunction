# headreg:internal/extract_ts —— 取 textures 的 base64 载荷并解出时间戳
# 入口：root.working_data.properties 含 textures 项
# 出口：root.working_data.ts_ms / .ts_sec
data remove storage headreg:data root.working_data.value
execute store success score #found headreg.calc run data modify storage headreg:data root.working_data.value set from storage headreg:data root.working_data.properties[{name:"textures"}].value
execute if score #found headreg.calc matches 0 run return 0
function headreg:internal/decode_window
function headreg:internal/decode_b64
function headreg:internal/build_record

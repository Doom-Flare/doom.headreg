# headreg:internal/extract_ts —— 取 textures 的 base64 载荷并解出时间戳
# 前置：storage headreg:tmp prof.props = [{name:"textures",value:"<base64>"}]
# 后置：#ts_sec headreg.calc = 秒级 epoch 时间戳（取不到或载荷形状不对为 0）
# 无宏：base64 的解码由 internal/decode_b64（gen.mjs 生成）用 64 路字面分派完成，全程不产生字符串。
scoreboard players set #tv headreg.calc 0
data remove storage headreg:tmp b64
execute store success score #tv headreg.calc run data modify storage headreg:tmp b64 set from storage headreg:tmp prof.props[{name:"textures"}].value
execute if score #tv headreg.calc matches 1 run function headreg:internal/decode_b64
execute if score #tv headreg.calc matches 0 run scoreboard players set #ts_sec headreg.calc 0
data remove storage headreg:tmp b64

# headreg:internal/decode_window —— 从完整 profile 里取出 base64 的 [24,44) 窗口
# 入口：storage headreg:data root.working_data.value = 完整 base64 载荷
# 出口：storage headreg:data root.working_data.b64 = 20 个字符
# 依据：真实 Mojang payload 前缀恰 18 字节 '{\n  "timestamp" : '，
#       故 timestamp 数字从 base64 的第 24 个字符起；20 个 base64 字符 = 15 字节，
#       覆盖 13 位 ms 数字 + 收尾（13 位后紧跟 '}' 前的换行/引号，落在第 14/15 字节）。
data remove storage headreg:data root.working_data.b64
data modify storage headreg:data root.working_data.b64 set string storage headreg:data root.working_data.value 24 44

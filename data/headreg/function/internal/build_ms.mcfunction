# headreg:internal/build_ms —— 用宏把 13 个数字拼成 ts_ms 字符串
# 宏替换是文本级的：args.d0..d12 的 int 值被直接代入引号内，得到 "1792159106268"。
$data modify storage headreg:data root.working_data.ts_ms set value "$(d0)$(d1)$(d2)$(d3)$(d4)$(d5)$(d6)$(d7)$(d8)$(d9)$(d10)$(d11)$(d12)"

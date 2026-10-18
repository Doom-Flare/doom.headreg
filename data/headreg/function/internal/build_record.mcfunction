# headreg:internal/build_record —— 组装时间戳字段（由 _work/headreg/_gen.mjs 生成）
# 入口：#d0..#d12 = 13 个十进制数字
# 出口：storage headreg:data root.working_data.ts_ms / .ts_sec（均为字符串）
# 说明：ts_ms 保留为字符串而非 int，因为 13 位 ms 远超 int32 上限 2147483647。

# 把 13 个数字（int）搬进宏参数 args.d0..args.d12
execute store result storage headreg:tmp args.d0 int 1 run scoreboard players get #d0 headreg.calc
execute store result storage headreg:tmp args.d1 int 1 run scoreboard players get #d1 headreg.calc
execute store result storage headreg:tmp args.d2 int 1 run scoreboard players get #d2 headreg.calc
execute store result storage headreg:tmp args.d3 int 1 run scoreboard players get #d3 headreg.calc
execute store result storage headreg:tmp args.d4 int 1 run scoreboard players get #d4 headreg.calc
execute store result storage headreg:tmp args.d5 int 1 run scoreboard players get #d5 headreg.calc
execute store result storage headreg:tmp args.d6 int 1 run scoreboard players get #d6 headreg.calc
execute store result storage headreg:tmp args.d7 int 1 run scoreboard players get #d7 headreg.calc
execute store result storage headreg:tmp args.d8 int 1 run scoreboard players get #d8 headreg.calc
execute store result storage headreg:tmp args.d9 int 1 run scoreboard players get #d9 headreg.calc
execute store result storage headreg:tmp args.d10 int 1 run scoreboard players get #d10 headreg.calc
execute store result storage headreg:tmp args.d11 int 1 run scoreboard players get #d11 headreg.calc
execute store result storage headreg:tmp args.d12 int 1 run scoreboard players get #d12 headreg.calc

# 宏替换是文本级的：13 个 int 直接代入引号内 -> "1792159106268"
function headreg:internal/build_ms with storage headreg:tmp args

# 截前 10 位得秒（字符串切片，避免 10 位数溢出 int32）
data modify storage headreg:data root.working_data.ts_sec set string storage headreg:data root.working_data.ts_ms 0 10

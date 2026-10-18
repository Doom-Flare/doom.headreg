# headreg:internal/decode_b64 —— base64 解码链（由 _work/headreg/_gen.mjs 生成，勿手改）
# 入口：storage headreg:data root.working_data.b64 已就绪（20 字符窗口 [24,44)）
# 出口：#d0..#d12 = 13 个十进制数字（记分板 headreg.calc）

# --- 第 1 步：逐字符查表，得到 20 个 6bit 值 #c0..#c19 ---
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 0 1
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c0 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 1 2
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c1 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 2 3
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c2 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 3 4
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c3 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 4 5
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c4 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 5 6
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c5 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 6 7
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c6 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 7 8
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c7 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 8 9
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c8 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 9 10
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c9 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 10 11
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c10 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 11 12
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c11 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 12 13
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c12 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 13 14
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c13 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 14 15
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c14 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 15 16
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c15 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 16 17
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c16 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 17 18
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c17 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 18 19
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c18 headreg.calc = #v headreg.calc
data modify storage headreg:tmp args.k set string storage headreg:data root.working_data.b64 19 20
function headreg:internal/lut_b64 with storage headreg:tmp args
scoreboard players operation #c19 headreg.calc = #v headreg.calc

# --- 第 2 步：每 4 个 6bit 拼成 1 个 24bit，切成 3 个字节并转十进制数字 ---
# 三元组 0：字符 0..3 -> 字节 0..2
scoreboard players operation #t headreg.calc = #c0 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c1 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c2 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c3 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k65536 headreg.calc
scoreboard players operation #m headreg.calc = #t headreg.calc
scoreboard players operation #m headreg.calc %= #k65536 headreg.calc
scoreboard players operation #g headreg.calc = #m headreg.calc
scoreboard players operation #g headreg.calc /= #k256 headreg.calc
scoreboard players operation #l headreg.calc = #m headreg.calc
scoreboard players operation #l headreg.calc %= #k256 headreg.calc
scoreboard players operation #d0 headreg.calc = #h headreg.calc
scoreboard players operation #d0 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d1 headreg.calc = #g headreg.calc
scoreboard players operation #d1 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d2 headreg.calc = #l headreg.calc
scoreboard players operation #d2 headreg.calc -= #k48 headreg.calc
# 三元组 1：字符 4..7 -> 字节 3..5
scoreboard players operation #t headreg.calc = #c4 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c5 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c6 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c7 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k65536 headreg.calc
scoreboard players operation #m headreg.calc = #t headreg.calc
scoreboard players operation #m headreg.calc %= #k65536 headreg.calc
scoreboard players operation #g headreg.calc = #m headreg.calc
scoreboard players operation #g headreg.calc /= #k256 headreg.calc
scoreboard players operation #l headreg.calc = #m headreg.calc
scoreboard players operation #l headreg.calc %= #k256 headreg.calc
scoreboard players operation #d3 headreg.calc = #h headreg.calc
scoreboard players operation #d3 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d4 headreg.calc = #g headreg.calc
scoreboard players operation #d4 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d5 headreg.calc = #l headreg.calc
scoreboard players operation #d5 headreg.calc -= #k48 headreg.calc
# 三元组 2：字符 8..11 -> 字节 6..8
scoreboard players operation #t headreg.calc = #c8 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c9 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c10 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c11 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k65536 headreg.calc
scoreboard players operation #m headreg.calc = #t headreg.calc
scoreboard players operation #m headreg.calc %= #k65536 headreg.calc
scoreboard players operation #g headreg.calc = #m headreg.calc
scoreboard players operation #g headreg.calc /= #k256 headreg.calc
scoreboard players operation #l headreg.calc = #m headreg.calc
scoreboard players operation #l headreg.calc %= #k256 headreg.calc
scoreboard players operation #d6 headreg.calc = #h headreg.calc
scoreboard players operation #d6 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d7 headreg.calc = #g headreg.calc
scoreboard players operation #d7 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d8 headreg.calc = #l headreg.calc
scoreboard players operation #d8 headreg.calc -= #k48 headreg.calc
# 三元组 3：字符 12..15 -> 字节 9..11
scoreboard players operation #t headreg.calc = #c12 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c13 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c14 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c15 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k65536 headreg.calc
scoreboard players operation #m headreg.calc = #t headreg.calc
scoreboard players operation #m headreg.calc %= #k65536 headreg.calc
scoreboard players operation #g headreg.calc = #m headreg.calc
scoreboard players operation #g headreg.calc /= #k256 headreg.calc
scoreboard players operation #l headreg.calc = #m headreg.calc
scoreboard players operation #l headreg.calc %= #k256 headreg.calc
scoreboard players operation #d9 headreg.calc = #h headreg.calc
scoreboard players operation #d9 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d10 headreg.calc = #g headreg.calc
scoreboard players operation #d10 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d11 headreg.calc = #l headreg.calc
scoreboard players operation #d11 headreg.calc -= #k48 headreg.calc
# 三元组 4：字符 16..19 -> 字节 12..14
scoreboard players operation #t headreg.calc = #c16 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c17 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c18 headreg.calc
scoreboard players operation #t headreg.calc *= #k64 headreg.calc
scoreboard players operation #t headreg.calc += #c19 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k65536 headreg.calc
scoreboard players operation #m headreg.calc = #t headreg.calc
scoreboard players operation #m headreg.calc %= #k65536 headreg.calc
scoreboard players operation #g headreg.calc = #m headreg.calc
scoreboard players operation #g headreg.calc /= #k256 headreg.calc
scoreboard players operation #l headreg.calc = #m headreg.calc
scoreboard players operation #l headreg.calc %= #k256 headreg.calc
scoreboard players operation #d12 headreg.calc = #h headreg.calc
scoreboard players operation #d12 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d13 headreg.calc = #g headreg.calc
scoreboard players operation #d13 headreg.calc -= #k48 headreg.calc
scoreboard players operation #d14 headreg.calc = #l headreg.calc
scoreboard players operation #d14 headreg.calc -= #k48 headreg.calc

# --- 第 3 步：钳位，非数字字符一律归 0（防脏载荷拼出负号） ---
execute unless score #d0 headreg.calc matches 0..9 run scoreboard players set #d0 headreg.calc 0
execute unless score #d1 headreg.calc matches 0..9 run scoreboard players set #d1 headreg.calc 0
execute unless score #d2 headreg.calc matches 0..9 run scoreboard players set #d2 headreg.calc 0
execute unless score #d3 headreg.calc matches 0..9 run scoreboard players set #d3 headreg.calc 0
execute unless score #d4 headreg.calc matches 0..9 run scoreboard players set #d4 headreg.calc 0
execute unless score #d5 headreg.calc matches 0..9 run scoreboard players set #d5 headreg.calc 0
execute unless score #d6 headreg.calc matches 0..9 run scoreboard players set #d6 headreg.calc 0
execute unless score #d7 headreg.calc matches 0..9 run scoreboard players set #d7 headreg.calc 0
execute unless score #d8 headreg.calc matches 0..9 run scoreboard players set #d8 headreg.calc 0
execute unless score #d9 headreg.calc matches 0..9 run scoreboard players set #d9 headreg.calc 0
execute unless score #d10 headreg.calc matches 0..9 run scoreboard players set #d10 headreg.calc 0
execute unless score #d11 headreg.calc matches 0..9 run scoreboard players set #d11 headreg.calc 0
execute unless score #d12 headreg.calc matches 0..9 run scoreboard players set #d12 headreg.calc 0

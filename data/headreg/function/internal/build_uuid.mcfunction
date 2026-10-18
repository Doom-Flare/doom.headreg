# headreg:internal/build_uuid —— profile.id -> UUID 字符串（由 _work/headreg/_gen.mjs 生成，勿手改）
# 入口：root.working_data.id = [I;a,b,c,d]（每个是 32 位补码 int）
# 出口：root.working_data.uuid_str = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
data remove storage headreg:data root.working_data.uuid_str
data modify storage headreg:data root.working_data.uuid_str set value "-"
execute unless data storage headreg:data root.working_data.id run return 0

# --- 第 1 个 int（对应 UUID 的第 1 组 8 字符）---
execute store result score #u headreg.calc run data get storage headreg:data root.working_data.id[0]
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c7 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c6 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c5 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c4 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c3 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c2 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c1 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c0 headreg.calc = #r headreg.calc

# --- 第 2 个 int（对应 UUID 的第 2 组 8 字符）---
execute store result score #u headreg.calc run data get storage headreg:data root.working_data.id[1]
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c15 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c14 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c13 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c12 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c11 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c10 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c9 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c8 headreg.calc = #r headreg.calc

# --- 第 3 个 int（对应 UUID 的第 3 组 8 字符）---
execute store result score #u headreg.calc run data get storage headreg:data root.working_data.id[2]
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c23 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c22 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c21 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c20 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c19 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c18 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c17 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c16 headreg.calc = #r headreg.calc

# --- 第 4 个 int（对应 UUID 的第 4 组 8 字符）---
execute store result score #u headreg.calc run data get storage headreg:data root.working_data.id[3]
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c31 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c30 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c29 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c28 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c27 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c26 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c25 headreg.calc = #r headreg.calc
scoreboard players operation #r headreg.calc = #u headreg.calc
scoreboard players operation #r headreg.calc %= #k16 headreg.calc
scoreboard players operation #u headreg.calc /= #k16 headreg.calc
execute if score #r headreg.calc matches ..-1 run scoreboard players remove #u headreg.calc 1
execute if score #r headreg.calc matches ..-1 run scoreboard players add #r headreg.calc 16
scoreboard players operation #c24 headreg.calc = #r headreg.calc

# --- 32 个 nibble 送进宏参数 ---
execute store result storage headreg:tmp ux.c0 int 1 run scoreboard players get #c0 headreg.calc
execute store result storage headreg:tmp ux.c1 int 1 run scoreboard players get #c1 headreg.calc
execute store result storage headreg:tmp ux.c2 int 1 run scoreboard players get #c2 headreg.calc
execute store result storage headreg:tmp ux.c3 int 1 run scoreboard players get #c3 headreg.calc
execute store result storage headreg:tmp ux.c4 int 1 run scoreboard players get #c4 headreg.calc
execute store result storage headreg:tmp ux.c5 int 1 run scoreboard players get #c5 headreg.calc
execute store result storage headreg:tmp ux.c6 int 1 run scoreboard players get #c6 headreg.calc
execute store result storage headreg:tmp ux.c7 int 1 run scoreboard players get #c7 headreg.calc
execute store result storage headreg:tmp ux.c8 int 1 run scoreboard players get #c8 headreg.calc
execute store result storage headreg:tmp ux.c9 int 1 run scoreboard players get #c9 headreg.calc
execute store result storage headreg:tmp ux.c10 int 1 run scoreboard players get #c10 headreg.calc
execute store result storage headreg:tmp ux.c11 int 1 run scoreboard players get #c11 headreg.calc
execute store result storage headreg:tmp ux.c12 int 1 run scoreboard players get #c12 headreg.calc
execute store result storage headreg:tmp ux.c13 int 1 run scoreboard players get #c13 headreg.calc
execute store result storage headreg:tmp ux.c14 int 1 run scoreboard players get #c14 headreg.calc
execute store result storage headreg:tmp ux.c15 int 1 run scoreboard players get #c15 headreg.calc
execute store result storage headreg:tmp ux.c16 int 1 run scoreboard players get #c16 headreg.calc
execute store result storage headreg:tmp ux.c17 int 1 run scoreboard players get #c17 headreg.calc
execute store result storage headreg:tmp ux.c18 int 1 run scoreboard players get #c18 headreg.calc
execute store result storage headreg:tmp ux.c19 int 1 run scoreboard players get #c19 headreg.calc
execute store result storage headreg:tmp ux.c20 int 1 run scoreboard players get #c20 headreg.calc
execute store result storage headreg:tmp ux.c21 int 1 run scoreboard players get #c21 headreg.calc
execute store result storage headreg:tmp ux.c22 int 1 run scoreboard players get #c22 headreg.calc
execute store result storage headreg:tmp ux.c23 int 1 run scoreboard players get #c23 headreg.calc
execute store result storage headreg:tmp ux.c24 int 1 run scoreboard players get #c24 headreg.calc
execute store result storage headreg:tmp ux.c25 int 1 run scoreboard players get #c25 headreg.calc
execute store result storage headreg:tmp ux.c26 int 1 run scoreboard players get #c26 headreg.calc
execute store result storage headreg:tmp ux.c27 int 1 run scoreboard players get #c27 headreg.calc
execute store result storage headreg:tmp ux.c28 int 1 run scoreboard players get #c28 headreg.calc
execute store result storage headreg:tmp ux.c29 int 1 run scoreboard players get #c29 headreg.calc
execute store result storage headreg:tmp ux.c30 int 1 run scoreboard players get #c30 headreg.calc
execute store result storage headreg:tmp ux.c31 int 1 run scoreboard players get #c31 headreg.calc
function headreg:internal/hex_map with storage headreg:tmp ux
function headreg:internal/concat_uuid with storage headreg:tmp uu
data remove storage headreg:tmp ux
data remove storage headreg:tmp uu

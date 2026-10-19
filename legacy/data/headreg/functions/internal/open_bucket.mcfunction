# headreg:internal/open_bucket —— 两级字面分派：读（由 build/gen.mjs 生成，勿手改）
# 入口：#cur headreg.rec = 1..1023（槽位号 = id；1024 会落到不存在的 16 号桶）
# 出口：headreg:tmp cur = root.<cur>.data 的副本；该 id 无记录时 headreg:tmp cur 保持缺席
# 分桶：#b = #cur / 64（0..15），#o = #cur % 64（0..63）；open_b.<b> 第 M 行对应 id = b*64+M
scoreboard players operation #b headreg.calc = #cur headreg.rec
scoreboard players operation #b headreg.calc /= #k64 headreg.calc
scoreboard players operation #o headreg.calc = #cur headreg.rec
scoreboard players operation #o headreg.calc %= #k64 headreg.calc
execute if score #b headreg.calc matches 0 run function headreg:internal/open_b.0
execute if score #b headreg.calc matches 1 run function headreg:internal/open_b.1
execute if score #b headreg.calc matches 2 run function headreg:internal/open_b.2
execute if score #b headreg.calc matches 3 run function headreg:internal/open_b.3
execute if score #b headreg.calc matches 4 run function headreg:internal/open_b.4
execute if score #b headreg.calc matches 5 run function headreg:internal/open_b.5
execute if score #b headreg.calc matches 6 run function headreg:internal/open_b.6
execute if score #b headreg.calc matches 7 run function headreg:internal/open_b.7
execute if score #b headreg.calc matches 8 run function headreg:internal/open_b.8
execute if score #b headreg.calc matches 9 run function headreg:internal/open_b.9
execute if score #b headreg.calc matches 10 run function headreg:internal/open_b.10
execute if score #b headreg.calc matches 11 run function headreg:internal/open_b.11
execute if score #b headreg.calc matches 12 run function headreg:internal/open_b.12
execute if score #b headreg.calc matches 13 run function headreg:internal/open_b.13
execute if score #b headreg.calc matches 14 run function headreg:internal/open_b.14
execute if score #b headreg.calc matches 15 run function headreg:internal/open_b.15

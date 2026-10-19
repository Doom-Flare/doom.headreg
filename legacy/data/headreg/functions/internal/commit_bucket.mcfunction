# headreg:internal/commit_bucket —— 两级字面分派：写（由 build/gen.mjs 生成，勿手改）
# 入口：#cur headreg.rec = 1..1023，headreg:tmp cur = 待写回的记录
# 出口：root.<cur>.data = headreg:tmp cur；tmp cur 为空时不写（避免把桶写成空对象）
# 分桶：#b = #cur / 64（0..15），#o = #cur % 64（0..63）；commit_b.<b> 第 M 行对应 id = b*64+M
scoreboard players operation #b headreg.calc = #cur headreg.rec
scoreboard players operation #b headreg.calc /= #k64 headreg.calc
scoreboard players operation #o headreg.calc = #cur headreg.rec
scoreboard players operation #o headreg.calc %= #k64 headreg.calc
execute if score #b headreg.calc matches 0 run function headreg:internal/commit_b.0
execute if score #b headreg.calc matches 1 run function headreg:internal/commit_b.1
execute if score #b headreg.calc matches 2 run function headreg:internal/commit_b.2
execute if score #b headreg.calc matches 3 run function headreg:internal/commit_b.3
execute if score #b headreg.calc matches 4 run function headreg:internal/commit_b.4
execute if score #b headreg.calc matches 5 run function headreg:internal/commit_b.5
execute if score #b headreg.calc matches 6 run function headreg:internal/commit_b.6
execute if score #b headreg.calc matches 7 run function headreg:internal/commit_b.7
execute if score #b headreg.calc matches 8 run function headreg:internal/commit_b.8
execute if score #b headreg.calc matches 9 run function headreg:internal/commit_b.9
execute if score #b headreg.calc matches 10 run function headreg:internal/commit_b.10
execute if score #b headreg.calc matches 11 run function headreg:internal/commit_b.11
execute if score #b headreg.calc matches 12 run function headreg:internal/commit_b.12
execute if score #b headreg.calc matches 13 run function headreg:internal/commit_b.13
execute if score #b headreg.calc matches 14 run function headreg:internal/commit_b.14
execute if score #b headreg.calc matches 15 run function headreg:internal/commit_b.15

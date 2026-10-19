# headreg:internal/assign_id —— 给执行者分配稳定的数字 id（从 1 起，上限 1023）
# 前置：@s = 玩家；headreg.id 未设
# 后置：@s headreg.id = 1..1023；超限置 0 并置 #idfull = 1（超限的记录无处落，必须由调用方拒绝）
# 上限为什么是 1023 而不是 1024：分桶把 id 直接当槽位号 —— #b = id/64 ∈ 0..15、#o = id%64，
# 路径是 root.<b*64+M>.data，于是 16 桶 × 64 行只能覆盖槽位 0..1023。id=1024 会算成 #b=16、#o=0，
# 落进一个不存在的桶，open/commit/del 全部静默不生效（数据写不进去也读不回来）。
# 槽位 0 不用（0 是「分配失败」的哨兵），故可用 id 恰好是 1..1023。
scoreboard players set #idfull headreg.calc 0
scoreboard players add #init headreg.next 1
execute if score #init headreg.next matches 1024.. run scoreboard players set #idfull headreg.calc 1
execute if score #idfull headreg.calc matches 1 run scoreboard players set @s headreg.id 0
execute if score #idfull headreg.calc matches 0 run scoreboard players operation @s headreg.id = #init headreg.next

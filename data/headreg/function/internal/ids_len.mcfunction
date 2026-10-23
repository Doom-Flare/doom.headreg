# headreg:internal/ids_len —— 把活跃 id 列表的长度读进 #ln（headreg.calc）
# 出口：#ln = 列表元素个数；列表不存在或为空时为 0。
# 说明：先显式清零再读 —— store result 在路径缺失时会写 0，但写 0 与「读成功但值就是 0」不可区分，
#       垫一条 set 让「没读到」和「读到 0 个」在语义上都落到 0，不必再分辨。
scoreboard players set #ln headreg.calc 0
execute if data storage headreg:ids list store result score #ln headreg.calc run data get storage headreg:ids list

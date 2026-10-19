# headreg:internal/clock_from_tick —— 指定 gametime 时刻 -> epoch 秒
# 前置：#tt headreg.calc = 某个 gametime 时刻（如 first_sec 对应的 tick）；storage headreg:clock 已锚定
# 后置：#sec headreg.calc = 该时刻对应的 epoch 秒；未锚定时为 0
# 简化（用户裁定）：legacy 不做跨重启的 prev 修正。早于本次开机的 tick 仍按当前锚点折算，
# 只影响「停机前的那段时长」的绝对时刻，不影响时长差本身；时长请用 tick 差直接算。
scoreboard players set #sec headreg.calc 0
scoreboard players set #tabort headreg.calc 0
execute unless data storage headreg:clock tick run scoreboard players set #tabort headreg.calc 1
execute if score #tabort headreg.calc matches 0 store result score #bs headreg.calc run data get storage headreg:clock sec
execute if score #tabort headreg.calc matches 0 store result score #bt headreg.calc run data get storage headreg:clock tick
execute if score #tabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc = #tt headreg.calc
execute if score #tabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc -= #bt headreg.calc
execute if score #tabort headreg.calc matches 0 run scoreboard players operation #d headreg.calc /= #k20 headreg.calc
execute if score #tabort headreg.calc matches 0 run scoreboard players operation #sec headreg.calc = #bs headreg.calc
execute if score #tabort headreg.calc matches 0 run scoreboard players operation #sec headreg.calc += #d headreg.calc
scoreboard players set #tabort headreg.calc 0

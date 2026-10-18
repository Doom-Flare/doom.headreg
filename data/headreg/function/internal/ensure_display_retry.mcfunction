# headreg:internal/ensure_display_retry
# 区块未就绪则继续每 tick 重试，直到就绪才真正补建（只建一次）。
# 重试预算 #retry（由 load.mcfunction 置为 #k_retry）逐次递减；
# 耗尽则 tellraw 报错并停手 —— 借鉴 doom.schedule:internal/retry 的「预算递减 + 耗尽终止」写法，
# 避免区块永不就绪时每 tick 自我重排、静默空转到服务器重启。
execute if score #retry headreg.calc matches ..0 run tellraw @a [{"text":"[headreg] ","color":"dark_gray"},{"text":"共享中转槽初始化超时：区块 (1184704,1184704) 在 200 tick 内始终未就绪，已停止重试。请检查该区块是否被 /forceload remove 或维度数据异常。","color":"red"}]
execute if score #retry headreg.calc matches ..0 run scoreboard players set #retry headreg.calc 0
execute if score #retry headreg.calc matches 1.. run scoreboard players remove #retry headreg.calc 1
execute if score #retry headreg.calc matches 1.. unless loaded 1184704 0 1184704 run schedule function headreg:internal/ensure_display_retry 1t replace
execute in minecraft:overworld unless entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] run function headreg:internal/ensure_display

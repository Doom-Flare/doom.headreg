# headreg:internal/report_fail —— 注册链路失败的统一提示
# 前置：@s 为玩家
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.register.fail_v2","fallback":"注册失败：未能从共享中转槽读到 minecraft:profile（请确认中转区块已 forceload 且 headreg.display 实体存在）。","color":"red"}]

# headreg:internal/ensure_display_retry —— 区块就绪后补建中转实体（forceload 是异步生效的）
# 前置：#dsp headreg.calc = 剩余重试预算（constants 置 #k_retry = 200）
# 后置：区块就绪时实体已建；预算耗尽则停手（#dsp 归 0），不做无限空转
scoreboard players set #ld headreg.calc 0
execute if loaded 1184704 0 1184704 run scoreboard players set #ld headreg.calc 1
execute if score #ld headreg.calc matches 1 run function headreg:internal/ensure_display
execute if score #ld headreg.calc matches 0 run scoreboard players remove #dsp headreg.calc 1
execute if score #ld headreg.calc matches 0 if score #dsp headreg.calc matches 1.. run schedule function headreg:internal/ensure_display_retry 1t replace

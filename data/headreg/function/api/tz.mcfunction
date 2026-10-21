# headreg:api/tz —— 显示当前时区 preset 的状态与本地的「现在」
# 用法：execute as <player> run function headreg:api/tz
# 入口：无（读 storage headreg:config tz）
# 出口：仅 tellraw；#tzb/#off/#tzdst/#tzok 留在 headreg.calc 上供排查
# 说明：时钟未锚定时不能拿 #ts=0 去跑 tz_apply（护栏会把偏移压成 0，显示成假的 0 秒），
#       故先直接读注册表拿基准偏移，只有锚定后才叠夏令时算实际偏移。
function headreg:internal/now_sec
scoreboard players set #tzb headreg.calc 0
scoreboard players set #off headreg.calc 0
scoreboard players set #tzef headreg.calc 0
scoreboard players set #tzdst headreg.calc 0
scoreboard players set #tzok headreg.calc 0
data remove storage headreg:tmp tzp
execute if data storage headreg:config tz run function headreg:internal/tz_probe with storage headreg:config
execute if data storage headreg:tmp tzp run scoreboard players set #tzok headreg.calc 1
execute if data storage headreg:tmp tzp store result score #tzb headreg.calc run data get storage headreg:tmp tzp.b
data remove storage headreg:tmp tzp
execute if score #sec headreg.calc matches 1.. run scoreboard players operation #ts headreg.calc = #sec headreg.calc
execute if score #sec headreg.calc matches 1.. run function headreg:internal/tz_apply
tellraw @s [{"text":"[headreg] ","color":"dark_gray"},{"translate":"headreg.tz.header","fallback":"时区 preset","color":"gold"}]
tellraw @s [{"translate":"headreg.tz.current","fallback":"  当前: ","color":"gray"},{"nbt":"tz","storage":"headreg:config","color":"white"}]
tellraw @s [{"translate":"headreg.tz.base","fallback":"  基准偏移: ","color":"gray"},{"score":{"name":"#tzb","objective":"headreg.calc"},"color":"aqua"},{"translate":"headreg.tz.reg_hit","fallback":" 秒   命中注册表: ","color":"gray"},{"score":{"name":"#tzok","objective":"headreg.calc"},"color":"green"},{"translate":"headreg.tz.reg_hint","fallback":"   （注册表见 storage headreg:tz）","color":"dark_gray"}]
execute if score #tzok headreg.calc matches 0 run tellraw @s [{"translate":"headreg.tz.unknown","fallback":"  ⚠ preset 名字不在注册表里，已按 UTC 渲染；改回可用名字见 /function headreg:api/tz_set","color":"red"}]
execute if score #sec headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.tz.offset","fallback":"  实际偏移: ","color":"gray"},{"score":{"name":"#off","objective":"headreg.calc"},"color":"aqua"},{"translate":"headreg.tz.dst","fallback":" 秒   夏令时: ","color":"gray"},{"score":{"name":"#tzdst","objective":"headreg.calc"},"color":"yellow"},{"translate":"headreg.tz.dst_hint","fallback":"  （1 = 正在夏令时，0 = 标准时 / 该 preset 不适用）","color":"dark_gray"}]
execute if score #sec headreg.calc matches 1.. if score #tzdst headreg.calc matches 1 run tellraw @s [{"translate":"headreg.tz.dst_on","fallback":"  → 处于夏令时，实际偏移 = 基准偏移 + 3600 秒","color":"green"}]
execute unless score #sec headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.tz.offset_pending","fallback":"  实际偏移: 待服务器时钟锚定后才能判定（夏令时同理）","color":"yellow"}]
execute unless score #sec headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.tz.now_pending","fallback":"  现在: 服务器时钟还没锚定，无法推算；等下一次登记后自动可用","color":"yellow"}]
execute if score #sec headreg.calc matches 1.. run function headreg:internal/render_date
execute if score #sec headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.tz.now_local","fallback":"  现在(本地): ","color":"gray"},{"nbt":"date","storage":"headreg:tmp","color":"aqua"}]
execute if score #sec headreg.calc matches 1.. run tellraw @s [{"translate":"headreg.tz.epoch","fallback":"  epoch 秒: ","color":"gray"},{"score":{"name":"#sec","objective":"headreg.calc"},"color":"white"},{"translate":"headreg.tz.shifted","fallback":"   叠加偏移后: ","color":"gray"},{"score":{"name":"#tso","objective":"headreg.calc"},"color":"white"}]
data remove storage headreg:tmp date
data remove storage headreg:tmp tzp

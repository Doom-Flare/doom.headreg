# headreg:internal/render_date —— epoch 秒 -> 六个日期分量（UTC），不产生任何字符串
# 前置：#t headreg.calc = epoch 秒
# 后置：#ry #rmo #rd #rh #rmi #rs headreg.calc = 年 / 月 / 日 / 时 / 分 / 秒
# 消费方用 tellraw 的 score 组件拼 "YYYY-MM-DD HH:MM:SS"，补零在 tellraw 一侧用「<10 先输出 "0"」分支。
scoreboard players operation #days headreg.calc = #t headreg.calc
scoreboard players operation #days headreg.calc /= #k86400 headreg.calc
scoreboard players operation #t headreg.calc %= #k86400 headreg.calc
scoreboard players operation #h headreg.calc = #t headreg.calc
scoreboard players operation #h headreg.calc /= #k3600 headreg.calc
scoreboard players operation #t headreg.calc %= #k3600 headreg.calc
scoreboard players operation #mi headreg.calc = #t headreg.calc
scoreboard players operation #mi headreg.calc /= #k60 headreg.calc
scoreboard players operation #s headreg.calc = #t headreg.calc
scoreboard players operation #s headreg.calc %= #k60 headreg.calc
scoreboard players set #year headreg.calc 1970
function headreg:internal/sub_year
scoreboard players operation #doy headreg.calc = #days headreg.calc
scoreboard players set #mon headreg.calc 0
function headreg:internal/month_scan
scoreboard players operation #ry headreg.calc = #year headreg.calc
scoreboard players operation #rmo headreg.calc = #mon headreg.calc
scoreboard players operation #rd headreg.calc = #doy headreg.calc
scoreboard players operation #rh headreg.calc = #h headreg.calc
scoreboard players operation #rmi headreg.calc = #mi headreg.calc
scoreboard players operation #rs headreg.calc = #s headreg.calc

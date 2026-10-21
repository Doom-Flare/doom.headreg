# headreg:internal/tz_prep —— 为夏令时判定准备「本地基准日期」上下文
# 入口：#tsd = #ts + 基准偏移（调用方保证 >= 1）、#tzb = 基准偏移
# 出口：#dim = 本地基准日号、#y0 = 当年 1 月 1 日的日号、#leap = 当年是否闰年
# 说明：sub_year 会吃掉 #days，故 #y0 由「减前 - 减后」反推；#year/#doy/#mon 等草稿由 render_date 之后自行重算。
scoreboard players operation #dim headreg.calc = #tsd headreg.calc
scoreboard players operation #dim headreg.calc /= #k86400 headreg.calc
scoreboard players operation #days headreg.calc = #dim headreg.calc
scoreboard players set #year headreg.calc 1970
function headreg:internal/sub_year
scoreboard players operation #y0 headreg.calc = #dim headreg.calc
scoreboard players operation #y0 headreg.calc -= #days headreg.calc

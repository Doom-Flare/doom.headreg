# headreg:internal/format_now —— 渲染「现在」
# 前置：无（时钟由 base 层 internal/now_sec 提供 #now）
# 后置：headreg:tmp fmt = 当前时刻的 14 个一位分量
function headreg:internal/now_sec
scoreboard players operation #t headreg.calc = #now headreg.calc
function headreg:internal/format_time

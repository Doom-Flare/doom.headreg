# headreg:internal/pad_all —— 把月/日/时/分/秒补成两位字符串
# 入口：storage headreg:tmp num = {y,mo,d,h,mi,s}（int，mo/d/h/mi/s 均 < 60）
# 出口：storage headreg:tmp pad = {mo,d,h,mi,s}（字符串）
# 用查表代替格式化：mcfunction 没有 sprintf，pad[N] 直接取 "NN"。
$data modify storage headreg:tmp pad.mo set string storage headreg:lut pad[$(mo)]
$data modify storage headreg:tmp pad.d set string storage headreg:lut pad[$(d)]
$data modify storage headreg:tmp pad.h set string storage headreg:lut pad[$(h)]
$data modify storage headreg:tmp pad.mi set string storage headreg:lut pad[$(mi)]
$data modify storage headreg:tmp pad.s set string storage headreg:lut pad[$(s)]

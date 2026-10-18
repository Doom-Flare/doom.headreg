# headreg:internal/ensure_obj_query —— 玩家自助查询用的触发器计分板
# 两个 objective 分工，避免「0 到底代表没设值还是要名单」的歧义：
#   headreg.query  set <编号>  查某个编号的档案
#   headreg.qlist  set 1        要名单
scoreboard objectives add headreg.query trigger
scoreboard objectives add headreg.qlist trigger
data modify storage headreg:meta obj5 set value 1b

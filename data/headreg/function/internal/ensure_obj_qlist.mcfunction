# headreg:internal/ensure_obj_qlist —— 名单触发器（老存档里 obj5 已存在时补建这一只）
scoreboard objectives add headreg.qlist trigger
data modify storage headreg:meta obj6 set value 1b

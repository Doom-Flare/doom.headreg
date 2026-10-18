# headreg:internal/ensure_obj_test —— 自断言计分板（#pass / #calls / #fail）
scoreboard objectives add headreg.test dummy
data modify storage headreg:meta obj4 set value 1b

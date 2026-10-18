# headreg:internal/ensure_obj_audit —— 审计函数用的计分板（纯内存，不参与任何玩家数据）
# 单独一个 objective，避免和 headreg.calc 的通用寄存器混用；老存档靠 obj7 标记补建
scoreboard objectives add headreg.audit dummy
data modify storage headreg:meta obj7 set value 1b

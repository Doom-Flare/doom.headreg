# headreg:internal/ensure_obj_dummy —— 建会话用的普通计分板（只在首次 load 执行一次）
# headreg.online    : 1 = 本段会话已开（离开后仍为 1，直到下次进服结算）
# headreg.join_play : 本次进服时的 headreg.play 快照
# headreg.last_seen : 最后一次被 tick 看到的 gametime（离开时刻折算用）
scoreboard objectives add headreg.online dummy
scoreboard objectives add headreg.join_play dummy
scoreboard objectives add headreg.last_seen dummy
data modify storage headreg:meta obj2 set value 1b

# headreg:internal/ensure_objectives —— 建「统计项」计分板（只在首次 load 执行一次）
# 为什么要这么建：minecraft.custom:minecraft.play_time / leave_game 是 vanilla 统计项，
# 挂成 objective 后由服务端自己累加 —— 在线 tick 数免费、离线冻结、重登续涨。
# 已知行为（1.21.11 实测）：不回填历史，从 objective 创建那一刻起算；玩家离线时无分数。
scoreboard objectives add headreg.play minecraft.custom:minecraft.play_time
scoreboard objectives add headreg.leave minecraft.custom:minecraft.leave_game
data modify storage headreg:meta obj1 set value 1b

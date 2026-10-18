# headreg:internal/ensure_obj_leave —— 建「上次退出是否干净」用的计分板（只在首次 load 执行一次）
# headreg.join_leave : 本次进服时的 headreg.leave 快照
# 用途：下次进服时 headreg.leave - join_leave 就是这个会话期间「干净退出」发生了几次。
#   实测（1.21.11）：服务端 stop 把人踢下线 不计；客户端点「保存并退出」才 +1。
scoreboard objectives add headreg.join_leave dummy
data modify storage headreg:meta obj3 set value 1b

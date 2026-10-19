# headreg:internal/mark_boot —— 记录本次开机的 gametime（load 时世界还没开始走 tick，直接读会得到 0）
# 由 load 用 schedule … 1t 触发；届时 gametime 才是真实值
# 后置：storage headreg:clock.boot = 本次开机的 gametime
execute store result storage headreg:clock boot int 1 run time query gametime

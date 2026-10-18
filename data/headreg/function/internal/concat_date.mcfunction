# headreg:internal/concat_date —— 拼出可读日期字符串
# 入口：storage headreg:tmp pad = {y,mo,d,h,mi,s}（字符串，月日时分秒已补两位）
# 出口：storage headreg:tmp date = "YYYY-MM-DD HH:MM:SS"
# 说明：这是 UTC。Mojang session server 的 timestamp 本就是 UTC 毫秒。
#       结果放 tmp，由调用方决定落到哪个字段（date_str / now_date_str / last_leave_str）。
$data modify storage headreg:tmp date set value "$(y)-$(mo)-$(d) $(h):$(mi):$(s)"

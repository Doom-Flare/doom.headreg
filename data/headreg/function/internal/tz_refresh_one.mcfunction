# headreg:internal/tz_refresh_one —— 把「当前 working_data」的两个档案级时间串按当前时区重算
# 入口：storage headreg:data root.working_data 已就位（pull_data 之后）
# 出口：root.working_data.first_date_str / date_str 按当前时区重算；源 *_sec 缺失时原值保留
# 说明：now_date_str / last_leave_str 不在这里做 —— format_now / format_leave 本身就是现算，
#       它们调 render_date 时已带上当前时区。working_data 只是草稿副本，不回写归档。
data modify storage headreg:scan adisp.d set value "first_date_str"
data modify storage headreg:scan adisp.p set value "first_ts_sec"
function headreg:internal/tz_rw with storage headreg:scan adisp
data modify storage headreg:scan adisp.d set value "date_str"
data modify storage headreg:scan adisp.p set value "ts_sec"
function headreg:internal/tz_rw with storage headreg:scan adisp
data remove storage headreg:scan adisp

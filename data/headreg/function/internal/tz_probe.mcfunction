# headreg:internal/tz_probe —— 按 config.tz 抓取 preset 记录
# 入口：storage headreg:config tz = preset 名字符串（宏参数名 $(tz)）
# 出口：storage headreg:tmp tzp = 该 preset 的 {b,d,r}；名字未注册时 tzp 保持不存在
# 说明：整行带条件，未注册的名字不会触发「路径不存在」的命令报错，日志保持干净。
$execute if data storage headreg:tz p.$(tz) run data modify storage headreg:tmp tzp set from storage headreg:tz p.$(tz)

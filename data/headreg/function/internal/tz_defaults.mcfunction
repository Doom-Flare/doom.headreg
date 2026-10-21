# headreg:internal/tz_defaults —— 幂等安装时区 preset 注册表与默认配置
# 入口：无
# 出口：storage headreg:tz = {v:1, p:{<名字>:{b:基准偏移秒, d:是否夏令时, r:规则}}, lst:[可用名字]}
#       storage headreg:config tz = 当前 preset 名（缺失时补 "utc"，已有值绝不覆盖）
# 说明：注册表是「代码」，每次 load 整体覆盖；config.tz 是「用户状态」，只在缺失时补默认值。
#       规则 r 取值：none / eu（3 月最后周日 01:00 UTC 起 - 10 月最后周日 01:00 UTC 止）
#                          / us（3 月第 2 周日 02:00 本地起 - 11 月第 1 周日 02:00 本地止）
#                          / au（10 月第 1 周日 02:00 本地起 - 4 月第 1 周日 03:00 本地止，南半球跨年）
data merge storage headreg:tz {v:1,p:{"utc":{b:0,d:0b,r:"none"},"shanghai":{b:28800,d:0b,r:"none"},"tokyo":{b:32400,d:0b,r:"none"},"kolkata":{b:19800,d:0b,r:"none"},"nepal":{b:20700,d:0b,r:"none"},"london":{b:0,d:1b,r:"eu"},"paris":{b:3600,d:1b,r:"eu"},"new_york":{b:-18000,d:1b,r:"us"},"los_angeles":{b:-28800,d:1b,r:"us"},"sydney":{b:36000,d:1b,r:"au"}}}
data modify storage headreg:tz lst set value ["utc","shanghai","tokyo","kolkata","nepal","london","paris","new_york","los_angeles","sydney"]
execute unless data storage headreg:config tz run data modify storage headreg:config tz set value "utc"

# headreg:internal/to_score —— 把纯数字字符串转成记分板数值
# 入口：root.working_data.ts_sec（10 位十进制字符串）
# 出口：#ts headreg.calc
# 原理：宏替换是文本级的，字符串内容会被原样插入命令，故 10 位纯数字可当字面量用。
$scoreboard players set #ts headreg.calc $(ts_sec)

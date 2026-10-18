# headreg:internal/lut_b64 —— 单字符 base64 查表（宏）
# 入口：headreg:tmp args.k = 一个 base64 字符
# 出口：记分板 headreg.calc 的 #v = 该字符的 6bit 值（0..63）
# 路径写成 b64."$(k)"：宏展开后再解析，因此 '+','/','=' 这类字符无需转义。
scoreboard players set #v headreg.calc -1
$execute store result score #v headreg.calc run data get storage headreg:lut b64."$(k)"
# 越界/非法字符一律钳到 0，避免后续算术带出负值
execute unless score #v headreg.calc matches 0..63 run scoreboard players set #v headreg.calc 0

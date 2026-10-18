# headreg:internal/put_index —— 写入「名字 -> 数字 id」索引，供按名字查询 O(1) 命中
# 入口：@s = 玩家本人（要读它的 headreg.id）；宏 $(name) = 该玩家的档案名字
# 注意：玩家名只含字母数字下划线，可以安全地当作 storage 路径段
$execute store result storage headreg:index $(name) int 1 run scoreboard players get @s headreg.id

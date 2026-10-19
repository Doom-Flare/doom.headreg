# headreg:internal/decode_b64 —— base64 载荷解出 ts_sec（由 build/gen.mjs 生成，勿手改）
# 入口：storage headreg:tmp b64 = textures 的完整 base64 载荷
# 出口：#ts_sec headreg.calc = epoch 秒；载荷形状不对（太短 / 首位不是 1..2 / 越界）时为 0
# 原理：无宏，64 路逐字面分派查表把字符折成 6bit，再拼字节、按十进制累加，全程不产生字符串。
#       只取前 10 位数字（毫秒后 3 位丢弃）。
scoreboard players set #ts_sec headreg.calc 0
scoreboard players set #dabort headreg.calc 0
# set string 越界会报错且不钳位，故先量长度：需要字符 [24,38)，长度至少 38
scoreboard players set #blen headreg.calc 0
execute store result score #blen headreg.calc run data get storage headreg:tmp b64
execute unless score #blen headreg.calc matches 38.. run scoreboard players set #dabort headreg.calc 1
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 24 25
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c0 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c0 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c0 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c0 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c0 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c0 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c0 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c0 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c0 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c0 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c0 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c0 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c0 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c0 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c0 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c0 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c0 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c0 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c0 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c0 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c0 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c0 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c0 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c0 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c0 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c0 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c0 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c0 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c0 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c0 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c0 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c0 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c0 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c0 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c0 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c0 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c0 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c0 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c0 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c0 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c0 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c0 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c0 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c0 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c0 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c0 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c0 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c0 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c0 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c0 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c0 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c0 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c0 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c0 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c0 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c0 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c0 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c0 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c0 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c0 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c0 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c0 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c0 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c0 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 25 26
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c1 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c1 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c1 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c1 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c1 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c1 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c1 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c1 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c1 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c1 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c1 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c1 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c1 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c1 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c1 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c1 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c1 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c1 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c1 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c1 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c1 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c1 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c1 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c1 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c1 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c1 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c1 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c1 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c1 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c1 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c1 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c1 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c1 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c1 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c1 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c1 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c1 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c1 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c1 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c1 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c1 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c1 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c1 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c1 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c1 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c1 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c1 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c1 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c1 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c1 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c1 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c1 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c1 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c1 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c1 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c1 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c1 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c1 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c1 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c1 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c1 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c1 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c1 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c1 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 26 27
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c2 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c2 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c2 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c2 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c2 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c2 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c2 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c2 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c2 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c2 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c2 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c2 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c2 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c2 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c2 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c2 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c2 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c2 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c2 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c2 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c2 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c2 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c2 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c2 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c2 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c2 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c2 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c2 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c2 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c2 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c2 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c2 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c2 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c2 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c2 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c2 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c2 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c2 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c2 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c2 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c2 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c2 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c2 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c2 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c2 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c2 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c2 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c2 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c2 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c2 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c2 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c2 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c2 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c2 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c2 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c2 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c2 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c2 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c2 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c2 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c2 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c2 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c2 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c2 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 27 28
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c3 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c3 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c3 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c3 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c3 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c3 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c3 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c3 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c3 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c3 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c3 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c3 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c3 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c3 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c3 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c3 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c3 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c3 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c3 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c3 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c3 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c3 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c3 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c3 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c3 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c3 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c3 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c3 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c3 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c3 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c3 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c3 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c3 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c3 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c3 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c3 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c3 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c3 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c3 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c3 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c3 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c3 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c3 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c3 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c3 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c3 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c3 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c3 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c3 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c3 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c3 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c3 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c3 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c3 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c3 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c3 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c3 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c3 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c3 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c3 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c3 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c3 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c3 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c3 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 28 29
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c4 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c4 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c4 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c4 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c4 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c4 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c4 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c4 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c4 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c4 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c4 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c4 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c4 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c4 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c4 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c4 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c4 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c4 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c4 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c4 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c4 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c4 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c4 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c4 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c4 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c4 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c4 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c4 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c4 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c4 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c4 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c4 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c4 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c4 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c4 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c4 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c4 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c4 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c4 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c4 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c4 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c4 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c4 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c4 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c4 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c4 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c4 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c4 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c4 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c4 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c4 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c4 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c4 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c4 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c4 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c4 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c4 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c4 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c4 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c4 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c4 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c4 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c4 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c4 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 29 30
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c5 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c5 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c5 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c5 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c5 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c5 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c5 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c5 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c5 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c5 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c5 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c5 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c5 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c5 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c5 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c5 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c5 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c5 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c5 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c5 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c5 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c5 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c5 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c5 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c5 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c5 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c5 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c5 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c5 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c5 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c5 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c5 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c5 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c5 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c5 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c5 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c5 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c5 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c5 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c5 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c5 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c5 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c5 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c5 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c5 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c5 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c5 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c5 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c5 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c5 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c5 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c5 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c5 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c5 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c5 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c5 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c5 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c5 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c5 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c5 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c5 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c5 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c5 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c5 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 30 31
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c6 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c6 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c6 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c6 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c6 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c6 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c6 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c6 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c6 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c6 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c6 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c6 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c6 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c6 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c6 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c6 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c6 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c6 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c6 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c6 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c6 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c6 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c6 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c6 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c6 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c6 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c6 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c6 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c6 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c6 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c6 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c6 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c6 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c6 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c6 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c6 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c6 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c6 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c6 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c6 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c6 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c6 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c6 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c6 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c6 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c6 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c6 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c6 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c6 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c6 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c6 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c6 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c6 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c6 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c6 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c6 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c6 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c6 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c6 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c6 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c6 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c6 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c6 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c6 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 31 32
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c7 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c7 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c7 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c7 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c7 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c7 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c7 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c7 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c7 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c7 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c7 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c7 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c7 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c7 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c7 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c7 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c7 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c7 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c7 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c7 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c7 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c7 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c7 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c7 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c7 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c7 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c7 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c7 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c7 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c7 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c7 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c7 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c7 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c7 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c7 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c7 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c7 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c7 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c7 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c7 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c7 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c7 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c7 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c7 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c7 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c7 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c7 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c7 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c7 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c7 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c7 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c7 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c7 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c7 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c7 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c7 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c7 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c7 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c7 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c7 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c7 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c7 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c7 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c7 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 32 33
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c8 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c8 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c8 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c8 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c8 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c8 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c8 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c8 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c8 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c8 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c8 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c8 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c8 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c8 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c8 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c8 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c8 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c8 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c8 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c8 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c8 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c8 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c8 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c8 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c8 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c8 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c8 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c8 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c8 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c8 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c8 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c8 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c8 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c8 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c8 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c8 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c8 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c8 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c8 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c8 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c8 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c8 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c8 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c8 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c8 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c8 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c8 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c8 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c8 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c8 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c8 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c8 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c8 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c8 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c8 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c8 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c8 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c8 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c8 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c8 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c8 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c8 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c8 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c8 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 33 34
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c9 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c9 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c9 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c9 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c9 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c9 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c9 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c9 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c9 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c9 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c9 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c9 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c9 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c9 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c9 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c9 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c9 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c9 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c9 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c9 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c9 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c9 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c9 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c9 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c9 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c9 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c9 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c9 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c9 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c9 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c9 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c9 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c9 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c9 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c9 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c9 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c9 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c9 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c9 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c9 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c9 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c9 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c9 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c9 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c9 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c9 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c9 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c9 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c9 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c9 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c9 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c9 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c9 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c9 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c9 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c9 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c9 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c9 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c9 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c9 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c9 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c9 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c9 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c9 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 34 35
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c10 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c10 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c10 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c10 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c10 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c10 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c10 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c10 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c10 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c10 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c10 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c10 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c10 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c10 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c10 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c10 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c10 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c10 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c10 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c10 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c10 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c10 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c10 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c10 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c10 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c10 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c10 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c10 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c10 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c10 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c10 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c10 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c10 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c10 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c10 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c10 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c10 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c10 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c10 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c10 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c10 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c10 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c10 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c10 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c10 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c10 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c10 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c10 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c10 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c10 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c10 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c10 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c10 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c10 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c10 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c10 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c10 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c10 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c10 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c10 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c10 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c10 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c10 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c10 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 35 36
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c11 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c11 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c11 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c11 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c11 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c11 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c11 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c11 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c11 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c11 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c11 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c11 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c11 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c11 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c11 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c11 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c11 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c11 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c11 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c11 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c11 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c11 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c11 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c11 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c11 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c11 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c11 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c11 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c11 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c11 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c11 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c11 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c11 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c11 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c11 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c11 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c11 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c11 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c11 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c11 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c11 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c11 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c11 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c11 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c11 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c11 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c11 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c11 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c11 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c11 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c11 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c11 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c11 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c11 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c11 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c11 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c11 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c11 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c11 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c11 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c11 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c11 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c11 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c11 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 36 37
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c12 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c12 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c12 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c12 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c12 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c12 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c12 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c12 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c12 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c12 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c12 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c12 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c12 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c12 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c12 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c12 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c12 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c12 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c12 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c12 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c12 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c12 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c12 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c12 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c12 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c12 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c12 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c12 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c12 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c12 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c12 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c12 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c12 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c12 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c12 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c12 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c12 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c12 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c12 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c12 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c12 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c12 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c12 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c12 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c12 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c12 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c12 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c12 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c12 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c12 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c12 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c12 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c12 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c12 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c12 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c12 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c12 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c12 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c12 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c12 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c12 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c12 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c12 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c12 headreg.calc 63
execute if score #dabort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 37 38
execute if score #dabort headreg.calc matches 0 run scoreboard players set #c13 headreg.calc 0
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"B"} run scoreboard players set #c13 headreg.calc 1
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"C"} run scoreboard players set #c13 headreg.calc 2
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"D"} run scoreboard players set #c13 headreg.calc 3
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"E"} run scoreboard players set #c13 headreg.calc 4
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"F"} run scoreboard players set #c13 headreg.calc 5
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"G"} run scoreboard players set #c13 headreg.calc 6
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"H"} run scoreboard players set #c13 headreg.calc 7
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"I"} run scoreboard players set #c13 headreg.calc 8
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"J"} run scoreboard players set #c13 headreg.calc 9
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"K"} run scoreboard players set #c13 headreg.calc 10
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"L"} run scoreboard players set #c13 headreg.calc 11
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"M"} run scoreboard players set #c13 headreg.calc 12
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"N"} run scoreboard players set #c13 headreg.calc 13
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"O"} run scoreboard players set #c13 headreg.calc 14
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"P"} run scoreboard players set #c13 headreg.calc 15
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Q"} run scoreboard players set #c13 headreg.calc 16
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"R"} run scoreboard players set #c13 headreg.calc 17
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"S"} run scoreboard players set #c13 headreg.calc 18
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"T"} run scoreboard players set #c13 headreg.calc 19
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"U"} run scoreboard players set #c13 headreg.calc 20
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"V"} run scoreboard players set #c13 headreg.calc 21
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"W"} run scoreboard players set #c13 headreg.calc 22
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"X"} run scoreboard players set #c13 headreg.calc 23
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Y"} run scoreboard players set #c13 headreg.calc 24
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"Z"} run scoreboard players set #c13 headreg.calc 25
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"a"} run scoreboard players set #c13 headreg.calc 26
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"b"} run scoreboard players set #c13 headreg.calc 27
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"c"} run scoreboard players set #c13 headreg.calc 28
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"d"} run scoreboard players set #c13 headreg.calc 29
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"e"} run scoreboard players set #c13 headreg.calc 30
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"f"} run scoreboard players set #c13 headreg.calc 31
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"g"} run scoreboard players set #c13 headreg.calc 32
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"h"} run scoreboard players set #c13 headreg.calc 33
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"i"} run scoreboard players set #c13 headreg.calc 34
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"j"} run scoreboard players set #c13 headreg.calc 35
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"k"} run scoreboard players set #c13 headreg.calc 36
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"l"} run scoreboard players set #c13 headreg.calc 37
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"m"} run scoreboard players set #c13 headreg.calc 38
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"n"} run scoreboard players set #c13 headreg.calc 39
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"o"} run scoreboard players set #c13 headreg.calc 40
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"p"} run scoreboard players set #c13 headreg.calc 41
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"q"} run scoreboard players set #c13 headreg.calc 42
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"r"} run scoreboard players set #c13 headreg.calc 43
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"s"} run scoreboard players set #c13 headreg.calc 44
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"t"} run scoreboard players set #c13 headreg.calc 45
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"u"} run scoreboard players set #c13 headreg.calc 46
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"v"} run scoreboard players set #c13 headreg.calc 47
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"w"} run scoreboard players set #c13 headreg.calc 48
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"x"} run scoreboard players set #c13 headreg.calc 49
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"y"} run scoreboard players set #c13 headreg.calc 50
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"z"} run scoreboard players set #c13 headreg.calc 51
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"0"} run scoreboard players set #c13 headreg.calc 52
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"1"} run scoreboard players set #c13 headreg.calc 53
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"2"} run scoreboard players set #c13 headreg.calc 54
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"3"} run scoreboard players set #c13 headreg.calc 55
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"4"} run scoreboard players set #c13 headreg.calc 56
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"5"} run scoreboard players set #c13 headreg.calc 57
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"6"} run scoreboard players set #c13 headreg.calc 58
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"7"} run scoreboard players set #c13 headreg.calc 59
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"8"} run scoreboard players set #c13 headreg.calc 60
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"9"} run scoreboard players set #c13 headreg.calc 61
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"+"} run scoreboard players set #c13 headreg.calc 62
execute if score #dabort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"/"} run scoreboard players set #c13 headreg.calc 63
# 字节 18（第 1 位数字）<- base64 字符 24 / 25
scoreboard players operation #t1 headreg.calc = #c0 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k4 headreg.calc
scoreboard players operation #t2 headreg.calc = #c1 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k16 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d0 headreg.calc = #byte headreg.calc
scoreboard players operation #d0 headreg.calc -= #k48 headreg.calc
execute unless score #d0 headreg.calc matches 0..9 run scoreboard players set #d0 headreg.calc 0
# 字节 19（第 2 位数字）<- base64 字符 25 / 26
scoreboard players operation #t1 headreg.calc = #c1 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k16 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k16 headreg.calc
scoreboard players operation #t2 headreg.calc = #c2 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k4 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d1 headreg.calc = #byte headreg.calc
scoreboard players operation #d1 headreg.calc -= #k48 headreg.calc
execute unless score #d1 headreg.calc matches 0..9 run scoreboard players set #d1 headreg.calc 0
# 字节 20（第 3 位数字）<- base64 字符 26 / 27
scoreboard players operation #t1 headreg.calc = #c2 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k4 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k64 headreg.calc
scoreboard players operation #t2 headreg.calc = #c3 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d2 headreg.calc = #byte headreg.calc
scoreboard players operation #d2 headreg.calc -= #k48 headreg.calc
execute unless score #d2 headreg.calc matches 0..9 run scoreboard players set #d2 headreg.calc 0
# 字节 21（第 4 位数字）<- base64 字符 28 / 29
scoreboard players operation #t1 headreg.calc = #c4 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k4 headreg.calc
scoreboard players operation #t2 headreg.calc = #c5 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k16 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d3 headreg.calc = #byte headreg.calc
scoreboard players operation #d3 headreg.calc -= #k48 headreg.calc
execute unless score #d3 headreg.calc matches 0..9 run scoreboard players set #d3 headreg.calc 0
# 字节 22（第 5 位数字）<- base64 字符 29 / 30
scoreboard players operation #t1 headreg.calc = #c5 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k16 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k16 headreg.calc
scoreboard players operation #t2 headreg.calc = #c6 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k4 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d4 headreg.calc = #byte headreg.calc
scoreboard players operation #d4 headreg.calc -= #k48 headreg.calc
execute unless score #d4 headreg.calc matches 0..9 run scoreboard players set #d4 headreg.calc 0
# 字节 23（第 6 位数字）<- base64 字符 30 / 31
scoreboard players operation #t1 headreg.calc = #c6 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k4 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k64 headreg.calc
scoreboard players operation #t2 headreg.calc = #c7 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d5 headreg.calc = #byte headreg.calc
scoreboard players operation #d5 headreg.calc -= #k48 headreg.calc
execute unless score #d5 headreg.calc matches 0..9 run scoreboard players set #d5 headreg.calc 0
# 字节 24（第 7 位数字）<- base64 字符 32 / 33
scoreboard players operation #t1 headreg.calc = #c8 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k4 headreg.calc
scoreboard players operation #t2 headreg.calc = #c9 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k16 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d6 headreg.calc = #byte headreg.calc
scoreboard players operation #d6 headreg.calc -= #k48 headreg.calc
execute unless score #d6 headreg.calc matches 0..9 run scoreboard players set #d6 headreg.calc 0
# 字节 25（第 8 位数字）<- base64 字符 33 / 34
scoreboard players operation #t1 headreg.calc = #c9 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k16 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k16 headreg.calc
scoreboard players operation #t2 headreg.calc = #c10 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k4 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d7 headreg.calc = #byte headreg.calc
scoreboard players operation #d7 headreg.calc -= #k48 headreg.calc
execute unless score #d7 headreg.calc matches 0..9 run scoreboard players set #d7 headreg.calc 0
# 字节 26（第 9 位数字）<- base64 字符 34 / 35
scoreboard players operation #t1 headreg.calc = #c10 headreg.calc
scoreboard players operation #t1 headreg.calc %= #k4 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k64 headreg.calc
scoreboard players operation #t2 headreg.calc = #c11 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d8 headreg.calc = #byte headreg.calc
scoreboard players operation #d8 headreg.calc -= #k48 headreg.calc
execute unless score #d8 headreg.calc matches 0..9 run scoreboard players set #d8 headreg.calc 0
# 字节 27（第 10 位数字）<- base64 字符 36 / 37
scoreboard players operation #t1 headreg.calc = #c12 headreg.calc
scoreboard players operation #t1 headreg.calc *= #k4 headreg.calc
scoreboard players operation #t2 headreg.calc = #c13 headreg.calc
scoreboard players operation #t2 headreg.calc /= #k16 headreg.calc
scoreboard players operation #byte headreg.calc = #t1 headreg.calc
scoreboard players operation #byte headreg.calc += #t2 headreg.calc
scoreboard players operation #d9 headreg.calc = #byte headreg.calc
scoreboard players operation #d9 headreg.calc -= #k48 headreg.calc
execute unless score #d9 headreg.calc matches 0..9 run scoreboard players set #d9 headreg.calc 0
# 十进制累加（Horner）：首位必须是 1 或 2，否则一律判为坏载荷
execute unless score #d0 headreg.calc matches 1..2 run scoreboard players set #dabort headreg.calc 1
scoreboard players set #tsn headreg.calc 0
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d0 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d2 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d3 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d4 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d5 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d6 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d7 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d8 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc
execute if score #dabort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d9 headreg.calc
execute if score #dabort headreg.calc matches 0 if score #tsn headreg.calc matches 1000000000.. run scoreboard players operation #ts_sec headreg.calc = #tsn headreg.calc
data remove storage headreg:tmp cmp

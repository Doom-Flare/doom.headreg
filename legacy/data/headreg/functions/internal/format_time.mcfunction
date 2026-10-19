# headreg:internal/format_time —— epoch 秒 → 14 个一位数字分量（全程不产生字符串）
# 前置：#t headreg.calc = epoch 秒；base 层 internal/render_date 把 #t 解成 #ry #rmo #rd #rh #rmi #rs
# 后置：headreg:tmp fmt = {ya,yb,yc,yd, moh,mol, dh,dl, hh,hl, mih,mil, sh,sl}
# 为什么拆成一位一位：legacy 不能拼字符串，补零只能靠「逐位输出」。把十位/个位各存一个 0..9 的
#     整数，tellraw 里每个分数段各渲染一位，01-05 03:07:09 这种形态天然正确，不需要条件分支。
function headreg:internal/render_date
scoreboard players set #dt10 headreg.calc 10
scoreboard players set #dt100 headreg.calc 100
scoreboard players set #dt1000 headreg.calc 1000
# 年 4 位
scoreboard players operation #ya headreg.calc = #ry headreg.calc
scoreboard players operation #ya headreg.calc /= #dt1000 headreg.calc
scoreboard players operation #yb headreg.calc = #ry headreg.calc
scoreboard players operation #yb headreg.calc /= #dt100 headreg.calc
scoreboard players operation #yb headreg.calc %= #dt10 headreg.calc
scoreboard players operation #yc headreg.calc = #ry headreg.calc
scoreboard players operation #yc headreg.calc /= #dt10 headreg.calc
scoreboard players operation #yc headreg.calc %= #dt10 headreg.calc
scoreboard players operation #yd headreg.calc = #ry headreg.calc
scoreboard players operation #yd headreg.calc %= #dt10 headreg.calc
# 月 / 日 / 时 / 分 / 秒：各拆十位与个位
scoreboard players operation #moh headreg.calc = #rmo headreg.calc
scoreboard players operation #moh headreg.calc /= #dt10 headreg.calc
scoreboard players operation #mol headreg.calc = #rmo headreg.calc
scoreboard players operation #mol headreg.calc %= #dt10 headreg.calc
scoreboard players operation #dh headreg.calc = #rd headreg.calc
scoreboard players operation #dh headreg.calc /= #dt10 headreg.calc
scoreboard players operation #dl headreg.calc = #rd headreg.calc
scoreboard players operation #dl headreg.calc %= #dt10 headreg.calc
scoreboard players operation #hh headreg.calc = #rh headreg.calc
scoreboard players operation #hh headreg.calc /= #dt10 headreg.calc
scoreboard players operation #hl headreg.calc = #rh headreg.calc
scoreboard players operation #hl headreg.calc %= #dt10 headreg.calc
scoreboard players operation #mih headreg.calc = #rmi headreg.calc
scoreboard players operation #mih headreg.calc /= #dt10 headreg.calc
scoreboard players operation #mil headreg.calc = #rmi headreg.calc
scoreboard players operation #mil headreg.calc %= #dt10 headreg.calc
scoreboard players operation #sh headreg.calc = #rs headreg.calc
scoreboard players operation #sh headreg.calc /= #dt10 headreg.calc
scoreboard players operation #sl headreg.calc = #rs headreg.calc
scoreboard players operation #sl headreg.calc %= #dt10 headreg.calc
data remove storage headreg:tmp fmt
execute store result storage headreg:tmp fmt.ya int 1 run scoreboard players get #ya headreg.calc
execute store result storage headreg:tmp fmt.yb int 1 run scoreboard players get #yb headreg.calc
execute store result storage headreg:tmp fmt.yc int 1 run scoreboard players get #yc headreg.calc
execute store result storage headreg:tmp fmt.yd int 1 run scoreboard players get #yd headreg.calc
execute store result storage headreg:tmp fmt.moh int 1 run scoreboard players get #moh headreg.calc
execute store result storage headreg:tmp fmt.mol int 1 run scoreboard players get #mol headreg.calc
execute store result storage headreg:tmp fmt.dh int 1 run scoreboard players get #dh headreg.calc
execute store result storage headreg:tmp fmt.dl int 1 run scoreboard players get #dl headreg.calc
execute store result storage headreg:tmp fmt.hh int 1 run scoreboard players get #hh headreg.calc
execute store result storage headreg:tmp fmt.hl int 1 run scoreboard players get #hl headreg.calc
execute store result storage headreg:tmp fmt.mih int 1 run scoreboard players get #mih headreg.calc
execute store result storage headreg:tmp fmt.mil int 1 run scoreboard players get #mil headreg.calc
execute store result storage headreg:tmp fmt.sh int 1 run scoreboard players get #sh headreg.calc
execute store result storage headreg:tmp fmt.sl int 1 run scoreboard players get #sl headreg.calc

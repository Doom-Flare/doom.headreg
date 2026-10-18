# headreg:internal/diag_snap —— 诊断快照（临时，修完即删）
# 把结算链路上每个关键变量落到 storage headreg:diag，字段缺失 = 该记分板未赋值。
data modify storage headreg:diag root.phase set value "settle"
execute store result storage headreg:diag root.obj int 1 run scoreboard players get #gt headreg.calc
execute store result storage headreg:diag root.found int 1 run scoreboard players get #found headreg.calc
execute store result storage headreg:diag root.pending int 1 run scoreboard players get #settle_pending headreg.calc
execute store result storage headreg:diag root.tt int 1 run scoreboard players get #tt headreg.calc
execute store result storage headreg:diag root.bt int 1 run scoreboard players get #bt headreg.calc
execute store result storage headreg:diag root.bs int 1 run scoreboard players get #bs headreg.calc
execute store result storage headreg:diag root.d int 1 run scoreboard players get #d headreg.calc
execute store result storage headreg:diag root.sec int 1 run scoreboard players get #sec headreg.calc
execute store result storage headreg:diag root.sp int 1 run scoreboard players get #sp headreg.calc
execute store result storage headreg:diag root.lv int 1 run scoreboard players get #lv headreg.calc
execute store result storage headreg:diag root.play int 1 run scoreboard players get @s headreg.play
execute store result storage headreg:diag root.join_play int 1 run scoreboard players get @s headreg.join_play
execute store result storage headreg:diag root.join_leave int 1 run scoreboard players get @s headreg.join_leave
execute store result storage headreg:diag root.leave int 1 run scoreboard players get @s headreg.leave
execute store result storage headreg:diag root.last_seen int 1 run scoreboard players get @s headreg.last_seen
execute store result storage headreg:diag root.id int 1 run scoreboard players get @s headreg.id

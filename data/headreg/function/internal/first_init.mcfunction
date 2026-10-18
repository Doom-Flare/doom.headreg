# headreg:internal/first_init —— 只在整个世界第一次加载本包时执行
scoreboard objectives add headreg.calc dummy
scoreboard objectives add headreg.id dummy
scoreboard objectives add headreg.next dummy
scoreboard players set #v headreg.calc 0
scoreboard players set #prem headreg.calc 0
scoreboard players set #found headreg.calc 0
scoreboard players set #sec headreg.calc 0
scoreboard players set #t headreg.calc 0
scoreboard players set #init headreg.next 0

# headreg:internal/first_init —— 一次性建表（由 load 以 headreg:meta obj 标记守卫，只跑一次）
# legacy 的 objective 清单与主线一致；headreg.rec 专放 #cur / #hit，与 headreg.calc 的临时量隔离。
scoreboard objectives add headreg.id dummy
scoreboard objectives add headreg.calc dummy
scoreboard objectives add headreg.next dummy
scoreboard objectives add headreg.rec dummy
scoreboard objectives add headreg.last_seen dummy
scoreboard objectives add headreg.seen_tick dummy
scoreboard objectives add headreg.query trigger
scoreboard objectives add headreg.qlist trigger
scoreboard objectives add headreg.test dummy

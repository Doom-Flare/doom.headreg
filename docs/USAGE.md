# doom.headreg 使用说明

一个纯数据包（不用装 mod），给服务器加两件事：

1. **登记玩家**：谁进过服、什么时候、待了多久、来了几次。
2. **分辨正版号**：靠玩家皮肤档案里的 `textures` 字段判断，不联网、不查 API。

支持 **1.19.4 ~ 26.3 共 25 个版本**，每个版本都真机跑过。界面还有英文 / 法文 / 西班牙文和简中四份文案（要另装一个小资源包，见第八节）。按你的服务器版本取仓库 `dist/` 里对应的包（README 的「版本支持」表有对照）。有一点要先说明：

> 1.19.4 / 1.20 / 1.20.1 用的是另一套代码（仓库 `legacy/` 目录），能记的东西一样，但差三样：**只能按编号查、不能按名字查**；时间只精确到秒；「上次和谁一起走的」判定会有顺序依赖。其他版本用主线那套。

---

## 一、装

1. 把对应版本的 `doom.headreg` 文件夹放进 `<服务器目录>/world/datapacks/`。
2. 服务器里执行 `/reload`（或重启服务器）。
3. 确认装好了：敲 `/function headreg:api/list`，应回一行 `[headreg] 已登记玩家：`（装失败会刷红字报错，成功时不吭声）。
4. 想更彻底地自检，跑 `/function headreg:test/run`，主线包看到 `72/72`、legacy 包看到 `13/13` 全过即可。主线套件分 6 段、段间隔 1 tick 续跑，`/function` 之后约 6 tick 才出报告。
   > 判据读计分板 `#calls` / `#pass` / `#fail headreg.test`（套件用 `tellraw` 上报，不进服务器日志；RCON 只会回 `Running function …`）。
> **`#done headreg.test` 是完成标志**：全部断言跑完才置 1，开头一律先归零。中途被链长截断、或只手动跑了前几段，都停在 0 —— 外部脚本轮询它比看 `#calls` 是否稳定更可靠（`#stg` 归零也可能是「从没开始过」）。
   > 套件本身要 8.6 万条命令，超过默认的 `max_command_sequence_length`（65536），所以才拆成 6 段。**不要**为了跑自检去改链长上限。

> 只装数据包，不用改 `server.properties`。正版检测在 `online-mode=true` 才有意义（下面会讲）。

---

## 二、玩家怎么用（不用给 OP）

进服后自动登记，什么都不用做。想看的时候：

| 想干什么 | 输入 |
|---|---|
| 看服务器上有哪些人登记过 | `/trigger headreg.qlist set 1` |
| 看自己的记录 | `/trigger headreg.query set 1` |

`qlist` 会给一份名单，每人一行：编号、名字、正版还是离线、上次来的日期。
`query` 给你自己的：编号、名字、正版状态、第一次来的时间、这一次来的时间、一共登记几次 / 离开几次、上一段在线了多久、你的 UUID、最近 10 段历史（每段的进入 → 离开 → 时长）。

> 这两个是 `/trigger`，普通玩家就能用，不会给 OP 权限。用完触发器会自动归零，可以反复敲。

---

## 三、管理员命令

| 命令 | 作用 |
|---|---|
| `/function headreg:api/register` | 手动给**执行者自己**登记/更新一次（正常进服会自动跑，这个用于调试） |
| `/function headreg:api/list` | 控制台列出全部登记（`id / 名字 / 正版 / 时间`） |
| `/function headreg:api/query` | 查执行者自己的完整记录 |
| `/function headreg:api/query_id {id:10}` | 按编号查 |
| `/function headreg:api/query_name {name:"Doom_Flare"}` | 按名字查 |
| `/function headreg:api/clear` | 清掉**执行者自己**的登记记录（编号保留，不会重排） |
| `/function headreg:api/audit` | 自查：7 项一致性检查，正常就一行绿字，有问题逐条红字列出来 |
| `/function headreg:test/run` | 跑包内自带的测试（主线 72 个，分 6 段约 6 tick 跑完；legacy 13 个，一次跑完） |

`query_id` / `query_name` 是宏函数，要带参数调用，直接在命令里写 `{id:10}` 或 `{name:"Doom_Flare"}`。

---

## 四、它到底记了什么

每个玩家一个数字编号，记录按编号分桶存着。字段大意：

- `name` / `uuid_str`：名字和 UUID（`uuid_str` 是给人看的 `8-4-4-4-12` 形式，由档案里的 4 个 int 现算）
- `premium`：`1b` = 档案里有皮肤数据（正版环境），`0b` = 没有（离线号 / 无皮肤）
- `ts_ms` / `date_str`：档案时间戳，以及格式化后的「这次档案被拉取的时间」
- `first_*`：第一次登记的时间；`now_*` / `date_str`：最近一次
- `reg_count` / `prev_leave`：登记过几次 / 记录到几次离开
- `prev_play`：**上一段会话在线了多少 tick**（20 tick = 1 秒）
- `last_leave_sec`：上一段离开的墙上时间（秒）
- `history[]`：最近 **10** 段会话，每段含进入时刻、离开时刻、时长（秒），超过 10 段自动丢最旧的
- `exit_kind`：上次是怎么结束的 —— `solo`（一个人）、`personal`（别人还在）、`global`（大家一起走/关服）

另外有一张「名字 → 编号」的索引表，所以能按名字查；删档时索引会一起回收。

---

## 五、做不到的事（先说明白，免得踩坑）

1. **不知道你是怎么退出的**（正常退出 / 掉线 / 被踢，数据包里分不出来）。
2. **离开时刻是推算的**，不是当场记的：离开那一刻没有命令能执行，所以下次进服时才补算，误差来自「档案时间戳 → 真正进服」之间的几秒（实测 1–4 秒）。时长本身是准的（用原版 `play_time` 差值，离开就冻结）。
3. **`premium=1b` 只代表档案里有皮肤数据**，不等于「这个人买过游戏」：签名不会校验，理论上可伪造；离线模式下所有人都是 `0b`。
4. **纯离线服没有时间**：数据包里没有取墙钟的手段，必须靠一个正版档案的时间戳来「对表」。一个正版玩家都没来过，就只记次数和时长，不写日期、不写历史。反过来，只要来过一次正版，之后所有人（包括离线号）时间就都正常了。
5. **历史最多 10 段**，超出丢最旧的；`duration` 与「离开减进入」可能差 1 秒（取整）。
6. 服务器**重启**不会把历史时刻算错——上一轮的时钟锚点会被留档，重启前结束的那一段仍然按当时的时间算（这条是 10-18 修掉的，早于此版本的包没这能力）。
7. 时钟只往**前**校正，不会往回拨。服务器时钟比真实时间快的话它自己修不回来：包内判断的依据是玩家档案里的 Mojang 时间戳，而那个值有缓存、偶尔会偏旧，允许回拨就会把本来准的时钟拉坏。
8. 停服的那段时间是**不算数**的。包内计时靠游戏 tick，服务器关着就没有 tick，所以停 34 秒再开，时钟就落后 34 秒，等下一次有正版玩家进服才补回来。
9. **查一个历史攒满 10 段的玩家，单次查询实测 716 条命令**（默认上限 6.5536 万，占 1.1%）。v1.0.5 及更早这里是 6.2 万条、余量只剩 4.8% —— 差别来自 v1.0.6 把日期换算的起算年从 1970 抬到了时间戳所在年代，现在满历史与零历史的开销基本相同。

---

## 六、常见问题

**Q：敲 `/trigger headreg.qlist` 没反应？**
A：要写 `set 1`，即 `/trigger headreg.qlist set 1`。另外首次装包后需要有人进服触发一次初始化的 tick。

**Q：名单里时间显示 `-`？**
A：这个人是离线号（没有皮肤档案），或者服务器还没被任何正版档案「对过表」。

**Q：`api/audit` 报红字？**
A：那是真问题，把红字原文发出来。常见的两类：索引和档案对不上（手改过 storage）、已结算却缺 `prev_play`（数据被外部工具改坏）。

**Q：想清空重来？**
A：逐个玩家 `/function headreg:api/clear`；要彻底清，停服删 `world/datapacks/doom.headreg` 并清掉存档里的 `headreg:*` 计分板与 storage（或用新世界）。

**Q：会不会卡？**
A：常态开销很小：每 tick 三次遍历在线玩家（查新进服 / 判断重连 / 刷 `last_seen`），人少时就是几条命令；注册那一刻才做重活（一次 base64 解码，约 200 条命令，一次性）。自测用例是手动跑的（主线 72 条、legacy 13 条），不会自动执行。

---

## 七、时区

包里的时间默认按 UTC 写。人在国内的话，把服务器时区切成 `shanghai`，所有人看到的就都是北京时间，不用自己加 8 小时。

```mcfunction
function headreg:api/tz                       # 看现在是什么时区、偏移多少、是不是夏令时
function headreg:api/tz_set {tz:"shanghai"}   # 切成北京时间
```

能直接用的名字有 10 个：`utc` · `shanghai` · `tokyo` · `kolkata` · `nepal` · `london` · `paris` · `new_york` · `los_angeles` · `sydney`。

伦敦、巴黎、纽约、洛杉矶、悉尼这五个会自动处理夏令时。到了切换那天，偏移自己变，不用你再动。

切完之后旧记录要重算一遍，每 tick 处理一条。人少的话几秒就完；人多的话刚切完去查，可能还有几条显示的是旧时区，稍等一下再查。

名字打错不会出事：`tz_set` 先检查名字，认不出来就回一行红字，时区原样不动。

想加一个没有的时区，比如 +5:30：

```mcfunction
data merge storage headreg:tz {p:{"myzone":{b:19800,d:0b,r:"none"}}}
function headreg:api/tz_set {tz:"myzone"}
```

`b` 是偏移多少秒（+5:30 = 19800），`d` 是有没有夏令时，`r` 是跟哪套规则（`none` / `eu` / `us` / `au`）。自己加的条目重启和 `/reload` 都不会丢。

---

## 八、想让界面显示英文 / 法文 / 西班牙文

数据包本身只带中文文案。想要别的语言，另外装这个资源包：

```text
dist/doom.headreg-resourcepack.zip
```

**单人 / 局域网**：把 zip 放进 `.minecraft/resourcepacks/`（不要解压），然后在「选项 → 资源包」里启用。这个 zip 的内层不带顶层目录，`pack.mcmeta` 就在 zip 根 —— 多套一层游戏就不认，会报 `Missing metadata in pack …`。注意数据包 zip 正好相反（它带一层 `doom.headreg/`，是解压用的），两种包别混。

**专用服务器**：把 zip 放到服务器能访问的直链上，在 `server.properties` 里写：

```properties
resource-pack=https\://你的地址/doom.headreg-resourcepack.zip
resource-pack-sha1=<zip 的 SHA-1，小写，可以留空>
resource-pack-id=<一个 UUID，例如 7b1a2c3d-4e5f-4a6b-8c9d-0e1f2a3b4c5d>
resource-pack-prompt={"text":"安装 doom.headreg 文案包以显示你自己的语言","color":"yellow"}
```

- `.properties` 里的 `:` 必须转义成 `\:`，URL 协议冒号和 prompt 里的 JSON 冒号都算。
- `resource-pack-id` 必须是合法 UUID，写字符串会报 `Failed to parse … into UUID`。
- `resource-pack-sha1` 填错不会挡住玩家，但服务端日志会刷一条 `ERROR` + `IllegalStateException … requested: server_resource_pack`。
- 想让玩家必须装，再加 `require-resource-pack=true` —— 拒绝的玩家会被直接踢出。
- 改完要重启服务器，这几项不吃 `/reload`。

不装也完全没问题，中文照常显示。装了之后，客户端语言是英文 / 法文 / 西班牙文 / 简中的玩家会自动看到对应语言；哪条没翻到就退回中文，不会出现 `headreg.field.zone` 这种键名。

---

## 九、卸载

删掉 `world/datapacks/doom.headreg`，`/reload`。存档里留下的 `headreg:*` 计分板与 storage 不影响游戏，想干净就一并清掉。

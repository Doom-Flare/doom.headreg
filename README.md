# doom.headreg

给 Minecraft 服务器记「玩家上线档案」的纯数据包：**谁来过、来了几次、每次待多久、上次什么时候走的、最近 10 段会话是什么样**。

不装 mod、不改配置、不需要前置；没有 OP 的普通玩家也能用 `/trigger` 查自己的记录。

- **实测版本**：**1.20.2 – 26.3，共 22 个版本全部真机跑通**（每版 37/37 断言、0 条加载错误），映射表见下方「版本支持」
- **本仓 `data/` 是 1.21 – 26.2 那一类**（16 个版本共用同一份数据树）；其余版本请取 `dist/` 里对应的区间包
- **依赖**：无。`data/minecraft/tags/function/{load,tick}.json` 已接好，放进 `world/datapacks/` 再 `/reload` 即可
- **自检**：包内 37 个断言 + `api/audit` 7 项一致性检查

---

## 安装

1. 按你的服务器版本取 `dist/` 里对应的区间包（见下方「版本支持」表），解压后把整个 `doom.headreg/` 放进 `world/datapacks/`
2. 执行 `/reload`（或重启服务器）
3. 确认：`/function headreg:api/list` 应回一行 `[headreg] 已登记玩家：`（装载失败会刷红字，成功时不提示）
4. 自检：`/function headreg:test/run` → 看到 `37/37` 即正常

下载后核对：`dist/SHA256SUMS.txt`（release 里同名附件）列出的是**每个区间包**的校验值，不是解压后的文件。

---

## 版本支持

22 个版本逐个真机跑过（起服 → 部署 → `/reload` → 逐个点名全部函数 → 跑包内 37 条断言）。下表就是实测边界，**没有「理论上应该可以」的行**。

| 取哪个包 | MC 版本 | `pack_format` |
|---|---|---|
| `dist/doom.headreg-26.3.zip` | 26.3 | 121.0 |
| `dist/doom.headreg-1.21-26.2.zip` | 1.21 · 1.21.1 · 1.21.2 · 1.21.3 · 1.21.4 · 1.21.5 · 1.21.6 · 1.21.7 · 1.21.8 · 1.21.9 · 1.21.10 · 1.21.11 · 26.1 · 26.1.1 · 26.1.2 · 26.2 | 48.0 – 107.1 |
| `dist/doom.headreg-1.20.5-1.20.6.zip` | 1.20.5 · 1.20.6 | 41.0 |
| `dist/doom.headreg-1.20.3-1.20.4.zip` | 1.20.3 · 1.20.4 | 26.0 |
| `dist/doom.headreg-1.20.2.zip` | 1.20.2 | 18.0 |

同一行的版本共用**完全相同**的数据树，只是 `pack.mcmeta` 的区间不同 —— 所以一行只有一个包。包里附带的 `pack.mcmeta` 已经写好该行覆盖的区间，直接丢进去即可。

**1.20.1 及更早不支持**：那些版本没有函数宏（`$` 前缀）也没有 `return` 命令，本包核心链路建立在这两者之上，改不动。

---

## 玩家怎么用（不需要 OP）

进服自动登记，玩家什么都不用做。

| 想干什么 | 命令 |
|---|---|
| 看服务器上都有谁登记过、各自编号 | `/trigger headreg.qlist set 1` |
| 查某个编号的档案 | `/trigger headreg.query set 10` |

输出长这样：

```text
[headreg] #1 Doom_Flare   正版 1b
  初次 2026-10-17 15:21:45   本次 2026-10-17 15:48:46
  登记 8 次   离开 1 次   上段在线 1524 tick
  uuid 069a79f4-44e9-4726-a5be-fca90e38aaf5
  历史会话 2 段（旧 → 新）
   #1 2026-10-17 15:22:10 → 2026-10-17 15:24:31   141 秒
   #2 2026-10-17 15:48:46 → 2026-10-17 15:49:02   16 秒
```

`/trigger` 只能传整数，所以玩家侧只能按编号查；编号从 `qlist` 里拿。

## 管理员命令

```mcfunction
execute as <玩家> run function headreg:api/register      # 手动登记一次（正常进服会自动跑）
execute as <玩家> run function headreg:api/query         # 回显他自己的档案
execute as <玩家> run function headreg:api/clear         # 只删档案、保留编号
function headreg:api/list                                # 列出全部登记
function headreg:api/query_id {id:10}                    # 按编号查
function headreg:api/query_name {name:"Doom_Flare"}      # 按名字查（底层是名字索引）
execute as <玩家> run function headreg:api/audit         # 只读自检，7 项一致性
function headreg:test/run                                # 包内 37 个断言
```

这几个 api 都用 `tellraw @s` 输出，所以要 `execute as <在线玩家>` 才看得到结果；控制台执行只有返回值、没有可见文本。

---

## 它记了什么

每个玩家一个稳定编号，按编号分桶存在 `storage headreg:data`：

| 字段 | 含义 |
|---|---|
| `name` / `uuid_str` / `uuid` | 名字与 UUID（`uuid_str` 是 `8-4-4-4-12` 形式） |
| `premium` | `1b` = 档案里含 `textures`；`0b` = 没有（离线档案） |
| `ts_ms` / `date_str` | 从档案 base64 载荷解出的时间戳，以及格式化后的日期 |
| `first_date_str` / `first_ts_ms` | 第一次登记的时间 |
| `reg_count` | 登记过几次 |
| `prev_play` | 上一段会话在线多少 tick（20 tick = 1 秒） |
| `last_leave_sec` | 上次离开的墙上时间（秒） |
| `exit_kind` | 上次怎么结束的：`solo` 只有他 / `personal` 别人还在 / `global` 一起走 |
| `exit_peers` / `exit_seen` | 同 tick 消失的已登记玩家数 / 扫描到的同伴数 |
| `history[]` | 最近 **10** 段会话，每段 `{in_str, in_sec, out_str, out_sec, dur_sec}` |

另有一张 `headreg:index`（名字 → 编号）支撑按名字查，删档时自动回收。

## 技术要点

**时间戳是真解出来的，不是猜的。** 玩家的头颅档案 `properties[].value` 是一段 base64 编码的 JSON，里面带 13 位毫秒时间戳。本包在 mcfunction 内完成 base64 解码、定位 JSON 里的 `timestamp`、取 13 位数字、再走纯算术日历（闰年规则 $4 \land (\lnot 100 \lor 400)$）渲染成 `YYYY-MM-DD HH:MM:SS`。整条链路没有外部工具。

**会话时长用原版统计，不轮询。** `headreg.play` 挂在 `minecraft.custom:minecraft.play_time` 上，服务端自己按 tick 递增、离线冻结、重登续涨；离开没有命令执行上下文，所以结算挪到下次进服做：时长 = `play - join_play`（离开那一刻已冻结，精确），离开时刻由 `last_seen` 折算成 epoch。

**跨重启不会把时刻整体后移。** `gametime` 在停机期间不前进、墙钟前进，所以 epoch↔tick 的线性关系在重启点断裂。`load` 会把上一轮锚点留档到 `headreg:clock.prev`，并用 `schedule … 1t` 记下 `clock.boot`；结算时若 `last_seen < boot`（离开发生在本次开机之前）就用留档锚点，另加可信度守卫（`prev.sec ≥ 1e9`、`prev.tick ≥ 1`），不可信则回落当前锚点。

**多人隔离。** 每个玩家按数字编号分桶，`exit_kind` 靠同 tick 旁证扫描区分"一个人走 / 还有人 / 一起走"。

## 已知边界（装之前建议先读）

1. **不知道玩家是怎么退出的**：正常退出、掉线、被踢，`leave_game` 统计都是 +1，数据包内无法区分；只有"服务端关服、统计未落盘"这一种情况差值为 0。
2. **离开时刻是倒推的**：误差来自"档案时间戳 → 真正进服"之间的几秒（实测 1–4 秒）。时长本身是准的。
3. **`premium=1b` 不等于"买过游戏"**：只代表档案里有皮肤数据；签名不校验，可伪造；离线模式下所有人都是 `0b`。
4. **纯离线服没有时间**：数据包读不到墙钟，必须靠一个正版档案"对表"。一个正版都没来过，就只记次数和时长，日期显示 `-`、历史为空。只要来过一次正版，之后所有人（含离线号）时间就都正常。
5. **历史最多 10 段**，超出丢最旧的；`dur_sec` 与 `out_sec - in_sec` 可能差 1 秒（取整）。
6. **`/reload` 会覆盖 `clock.prev`**：当次运行内仍是精确映射，但跨重启的留档退化为旧行为。

## 兼容性

版本支持表在前面的「版本支持」一节，那里每一行都是实测边界。

- 本仓 `pack.mcmeta` 声明 `supported_formats` 48–107.1（1.21.0 – 26.2）—— 这正好是本仓 `data/` 实测跑通的区间。
- 1.20.x 与 26.3 请用 `dist/` 里对应的包，它们的 `pack.mcmeta` 各自只声明自己那一格，**不写宽区间**：装错版本会立刻报错，而不是静默跑一半。
- 1.20.2 – 1.20.4 的两个补丁（抓头改用 `item_modifiers/fill_head.json`、1.20.2 拆 `return run`）只存在于 `dist/` 的包里，源码树保持 1.21+ 的写法。

## 仓库结构

```text
doom.headreg/
├── pack.mcmeta              # supported_formats 48–107.1（1.21 – 26.2）
├── data/
│   ├── headreg/function/    # 77 个 mcfunction（api / internal / test）
│   └── minecraft/tags/function/{load,tick}.json
├── dist/                    # 5 个区间包 + manifest.json + SHA256SUMS.txt
├── docs/USAGE.md            # 玩家向说明（说人话版）
└── .github/                 # 离线静态门（泄漏扫描 / 包体检查 / 发行物一致性）
```

## 开发与校验

本机不需要 Minecraft 就能跑三个静态门（另有 `.github/tools/build_variants.mjs` 用来重新生成 5 个区间包）：

```bash
node .github/tools/check_leak.mjs    # 泄漏扫描 + 顶层结构白名单
node .github/tools/check_pack.mjs    # JSON 可解析 / mcfunction 行级合法性 / 函数引用闭包
node .github/tools/check_dist.mjs    # 5 个区间包各自与「包体 + 该版本变换」逐字节一致 + sha256 对得上
```

真机断言需要 Fabric 服务端与 RCON，测试台在私有开发仓库，不随本仓分发。

## 许可

见 [LICENSE](./LICENSE)：可自由安装、游玩、自行修改；**二次发布修改版或商用需先取得许可**。

---

更偏玩家口吻的说明见 [docs/USAGE.md](./docs/USAGE.md)。

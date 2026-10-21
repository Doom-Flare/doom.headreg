# 变更日志 · doom.headreg

> **口径**：namespace `headreg`（玩家上线档案：自动登记 / 正版判定 / 档案时间戳解码 / 会话时长与历史）。
> 实测支持 **25 个 MC 版本（1.19.4 – 26.3）**，按数据树分 7 类，`dist/` 里每类一个区间包（映射表见 README「版本支持」）。
> 主线（22 版，按数据树分 5 类）的包无依赖；自断言 `headreg:test/run`（**56 个用例**，分 5 段跨 tick 跑）+ 只读自检 `headreg:api/audit`（7 项）。
> legacy 树（3 版：1.19.4 / 1.20 / 1.20.1）是**独立实现**，自断言 13 个用例，能力上限见 README「版本支持」。
> 判定**必须**读计分板 `#pass/#fail/#calls headreg.test`（套件用 tellraw 上报，不进服务端日志）。
> 套件分 5 段、段间 `schedule … 1t` 续跑，`/function` 之后要等约 5 tick（0.25 秒）才出结果；切勿在 5 tick 内就下结论。
> 下方各版本条目里的 **37 / 77** 是当时的实测数字，不是当前树 —— v1.0.3 起主线是 **56 条断言 / 100 个函数**。
>
> ✅ **2026-10-18 起主线 37/37，2026-10-21 扩到 56/56；2026-10-19 起 legacy 13/13 全绿**，并在 25 个 MC 版本上逐版复跑。

---

## 2026-10-21 · v1.0.3 —— 时区 preset 与四语文案

### 功能

- **时区 preset**：所有时间串不再写死 UTC。`/function headreg:api/tz` 看当前时区，`/function headreg:api/tz_set {tz:"paris"}` 切过去。内建 10 个 preset（`utc` · `shanghai` · `tokyo` · `kolkata` · `nepal` · `london` · `paris` · `new_york` · `los_angeles` · `sydney`），含 +5:30 与 +5:45 的半小时偏移。
- **夏令时自动算**：欧洲 / 北美 / 澳洲三套规则写在 `internal/tz_rule_{eu,us,au}.mcfunction` 里，纯日历算术。切到 `paris` 之后，3 月最后一个周日到 10 月最后一个周日之间自动 +1 小时，不需要手动改。
- **旧记录跟着重渲染**：切时区后，已存在的档案按 id 逐条重算 `*_str` 字段（每 tick 一条）。`*_sec` 与 `*_ms` 始终保持 UTC 原值，只有给人看的字符串会变。
- **四语文案**：118 条界面文案全部改成 `{"translate":…,"fallback":…}` 形态，配套资源包提供英文 / 法文 / 西班牙文 / 简中。不装资源包显示包内中文 fallback。

### 兼容性

- 支持版本不变，仍是 **1.19.4 – 26.3 共 25 个版本**。主线断言从 37 条扩到 **56 条**（新增 19 条全部是时区用例：17 条渲染、2 条归档重渲染）。
- 时区是**主线独有**：legacy 树（1.19.4 / 1.20 / 1.20.1）的时间串仍是 UTC，`api/query_id` 等处的标签保留 `(UTC)` 字样，断言仍是 13 条。
- 资源包格式与数据包格式是**两套编号**（1.21.11 是资源包 75.0 / 数据包 94.1）。资源包 `pack.mcmeta` 声明 `pack_format 13` / `supported_formats 13–97`，覆盖全部 25 个版本。

### 工程

- **宏观命令链上限催生的分帧重渲染**：单条满历史档案重渲染 ≈ 23 次 `render_date` ≈ 2.5 万条命令，而 `maxCommandChainLength` 是 65536。同步扫全表会在第 3 条记录处被静默截断，所以 `tz_refresh_all` 改用 `schedule … 1t replace` 每 tick 推进一条。
- **自检套件也撞上了同一条上限**：56 条断言里 30 条要调 `render_date`，单次约 2689 条命令，合计约 8.5 万条 —— 超过 65536 就会被 `Command execution stopped due to limit` 静默截断（26.3 首次暴露）。`test/run` 因此按「每段 ≤ 10 次渲染」拆成 `run` / `run_core` / `run_clock` / `run_tz` / `run_tz_dst` 五段，段间 `schedule … 1t replace` 续跑，每段 2–3 万条。计数 `#calls/#pass/#fail` 跨段累加，报告只在最后一段出一次。
- **`tz_apply` 不改调用方的 `#ts`**：偏移只叠进私有量 `#tso`。`clock_anchor` 依赖 `#ts` 的原值，一旦被改，时钟锚定会整体漂移。
- **未锚定时不判 DST**：`#sec = 0` 时 `tz_apply` 的两道护栏会把偏移压成 0，`api/tz` 因此拆成「未锚定」与「已锚定」两条路径，未锚定时显示待判定而不是假 0 秒。
- `apply.mjs` 把 `data` 与 `legacy/data` 下 28 个文件里的中文 `text` 字面量机械替换成 `translate` 组件，`--check` 与 `--revert` 双向可逆。
- 三个静态门扩到资源包：`check_pack.mjs` 把 `resourcepack` 列为第三个包并同时遍历 `data` / `assets`，`check_leak.mjs` 顶层白名单加 `resourcepack`，`build_variants.mjs` 追加第 8 个发行物（资源包 zip）。

### 修掉的三个缺陷

三个都是**静默**的：不报错、不影响断言，只在特定世界状态下才显形。

- **测试套件会永久毁掉 `clock.boot`**：`test/run.mcfunction` 原本只在 `headreg:clock` 已有 `sec` 时才做备份，于是"从未锚定过的世界"（纯离线服、新开档）跑一次自检，`boot` 就再也回不来了。改成无条件整块备份 `root`（含 `boot` 与 `prev`），跑完整块写回。
- **`list_one` 会打空行**：判据是 `root.$(i)` 这个桶是否存在，但删档后桶可能只残留空壳、没有 `data` 子树，于是列表里出现一行全空白。改判 `root.$(i).data`。
- **`query_id` 同源缺陷（8 处）**：`api/query_id.mcfunction` 的第 7 / 9 / 10 / 11 / 12 / 13 / 14 / 22 行全是同一个判据，查一个已删的编号会打出半截卡片而不是"无此编号"。同样改判 `root.$(id).data`。

legacy 树不受影响：那边没有 `boot` 概念，`list_one` / `query_id` 走的是 `headreg:tmp cur` + `#hit headreg.rec` 的另一套写法。

### 真机验证

- **25 个版本逐个真机复测，全部 56/56（legacy 3 版 13/13）、0 条加载错误。** 每档都是「干净世界 → 装 `dist/` 对应区间包 → 起服 → 把链长强制归一到 65536 → `/reload` → `function headreg:test/run` → 轮询计分板到落定」：
  - 1.19.4 · 1.20 · 1.20.1 → 13/13（legacy 树）
  - 1.20.2 – 1.21.10 共 19 版 → 56/56（旧 gamerule 名 `maxCommandChainLength`）
  - 1.21.11 – 26.3 共 6 版 → 56/56（新 gamerule 名 `max_command_sequence_length`）
- 强制链长归一化是这一轮的关键：26.3 的默认值就是 65536，此前失败的根因正是「单次自检约 8.5 万条 > 65536」，不是功能不兼容。分段改造后 26.3 在默认世界上直接 56/56。
- 时区往返 utc → shanghai → utc → paris → los_angeles → utc，`root.10` 的三个日期字段与 history 全部跟随，回到 utc 后与基线逐字一致。
- 时区往返 utc → shanghai → utc → paris → los_angeles → utc，`root.10` 的三个日期字段与 history 全部跟随，回到 utc 后与基线逐字一致。
- `api/tz_set {tz:"nope"}` 早退不写 config；自定义 preset 写进 `headreg:tz` 后能跨 `/reload` 存活，也能被 `tz_set` 接受。

### 已知边界（新增）

- **时区不会自己跟着服务器走**：偏移由 `tz_set` 那一刻写入，之后只有夏令时会被自动算出。换了机房或改了系统时区，要管理员再切一次。
- **切时区不是瞬时完成**：旧档案逐条重渲染，每 tick 一条。人多的服切完立刻查询，可能看到部分记录还是旧时区。
- **时钟偏快不会自愈**：`internal/clock_anchor.mcfunction:12` 的门限是 `#gap >= 1`，只向前校正。服务器时钟比真实时间快的时候 `#gap` 为负，直接跳过。这是刻意的——档案时间可能命中 ProfileResolver 缓存而偏旧，若允许回拨会把已经准确的时钟拉回去。
- **停机期间不补偿**：时基是 `clock.sec + floor((gametime − clock.tick) / 20)`，`gametime` 不含停机时间。停服 34 秒再开，时钟就落后 34 秒，直到下一次有正版档案进服才被重锚拉回。

---

## 2026-10-19 · v1.0.2 —— 补上 1.19.4 / 1.20 / 1.20.1

### 功能

数据包本身的功能没有变化。这一版把「能装到哪些版本」的下沿从 1.20.2 推到 **1.19.4**。

### 兼容性

- **实测支持 1.19.4 – 26.3，共 25 个版本**：在 v1.0.1 的 22 版之外新增 1.19.4 · 1.20 · 1.20.1。每版都做过「起服 → 部署 → `/reload` → 逐个点名全部函数 → 跑包内断言」，结果 0 条加载错误、legacy 13/13 通过。
- **这 3 版不是主线的降级变体，是另写的一套**。主线的核心链路依赖函数宏（`$` 前缀）与 `return` 命令，这两样在 1.20.1 及更早都不完整 —— 1.19.4 两样都没有，1.20 / 1.20.1 有宏有 `return` 但主线其余写法仍不适用。所以 `legacy/` 是独立实现：**两级字面分派表**（`#b = id/64`、`#o = id%64`，16 桶 × 64 槽）+ 固定中转槽，**全程不用宏、不用 `return`**，用 `#abort` 标志替代早退。
- **一次访问的成本与玩家总数无关**：字面分派固定 80 条命令，不管登记了 1 个人还是 1023 个人。上限 1023（1024 会算到不存在的第 17 个桶、静默丢数据）。
- **legacy 的三条能力上限**（README「版本支持」有详述）：① 没有名字索引，只能按编号查；② 时间只到秒，`ts_sec` 是 int32，**2038-01-19 之后溢出**；③ `exit_kind` 有顺序依赖 —— 同一批一起退出的人里只有**最后结算**的那个能判成 `global`，先结算的会得到 `personal`，这是 O(1) 全局哨兵的结构性限制。
- legacy 包内断言是 **13 条**（不是主线当时的 37 条），判据同样读 `#pass/#fail/#calls headreg.test`。

### 工程

- 版本表从 5 类扩到 7 类。`build_variants.mjs` 的 `GROUPS` 每项新增可选字段 `src`：缺省 `'.'` 指仓库根的主线数据树，`'legacy'` 指 `legacy/` 下的无宏数据树。legacy 组跳过全部补丁（补丁是按主线代码写的）。
- `check_pack.mjs` 改为同时扫描两棵树，且「函数引用是否悬空」按包内实际存在的 `function` / `functions` 目录判定 —— 原来写死单数，会把 legacy 的 141 处引用全判成悬空。
- `check_leak.mjs` 的顶层白名单加入 `legacy`。
- `legacy/build/gen.mjs`：纯 Node 无依赖的变体生成器，产出 53 个机械文件（分派表 / base64 解码表 / 日历表）。同一个输入连跑两次字节一致。

### 修掉的三个真缺陷（都只影响 legacy 树）

- **缺 tick 钩子**：legacy 树最初没有 `tick.mcfunction` 也没有 `minecraft/tags/functions/tick.json`，`on_join` 从未被调用 ⇒ 注册从未发生。补写 tick 入口，并用 `headreg.seen_tick`（每 tick 刷成当前 `gametime`）判「新进服」—— 不能用 epoch 秒级的 `last_seen`，它 20 tick 才动一次。
- **`#abort` 全局共享导致注册静默不写盘**：`settle_session` 开头把 `#abort` 置 0、因缺 `prev` 置 1，返回后标志仍是 1 ⇒ register 后续的 `push_data` / `report_ok` 全被跳过，`headreg:data` 一直是 `{}`。改为每个函数用私有 token（`#sabort` / `#nabort` / `#cabort` …），register 保留 `#abort`。
- **`prof.props` 形状不匹配导致正版永远判 0**：1.19.4 的 `SkullOwner.Properties.textures` 是 `[{Value,Signature}]`，而 `classify` 按现代形状 `[{name:"textures",value}]` 判定。在 `grab_head` 里归一化，4 行搞定。

### 已知边界（legacy 树新增）

- **盗版玩家进不了时钟**：legacy 的 `clock_anchor` 靠档案时间戳校正 `headreg:clock`，离线档案没有 `textures` ⇒ 没有时间戳 ⇒ **一个正版玩家都没来过时，全服时间不走**，legacy 只记次数、不结算会话。（主线没有这个洞：它的锚点另有来源。）
- `api/list` 是递归实现，满表 1023 份会撞默认 `maxCommandChainLength=65536`。

---

## 2026-10-18 · v1.0.1 —— 多版本支持

### 功能

无功能变更。这一版只改「能装到哪些版本」和发布形态。

### 兼容性

- **实测支持 1.20.2 – 26.3，共 22 个版本**（*v1.0.2 起扩到 25 版*）：1.20.2 · 1.20.3 · 1.20.4 · 1.20.5 · 1.20.6 · 1.21 · 1.21.1 · 1.21.2 · 1.21.3 · 1.21.4 · 1.21.5 · 1.21.6 · 1.21.7 · 1.21.8 · 1.21.9 · 1.21.10 · 1.21.11 · 26.1 · 26.1.1 · 26.1.2 · 26.2 · 26.3。每版都做过「起服 → 部署 → `/reload` → 逐个点名全部 77 个函数 → 跑 37 条断言」，结果 0 条加载错误、37/37 通过。
- 验证对象是 **`dist/` 里的 zip 本身**（解包后逐版重跑，22/22 通过），不是只验源码树 —— 避免「源码没问题但打包打坏了」。
- 22 个版本只落成 **5 类**数据树，差异仅在 `pack.mcmeta` 的区间声明、函数目录单复数、以及两类代码补丁。每个 zip 顶层是 `doom.headreg/`，直接丢进 `world/datapacks/`。
- **1.20.2 – 1.20.4 需要两个补丁**（`dist/` 里已打好，源码树不含）：① 抓头颅的 `item modify` 内联 JSON 在 1.20.4 及更早不存在，改用 `item_modifiers/fill_head.json` 资源文件，并把读回路径从 `item.components."minecraft:profile"` 换成 `item.tag.SkullOwner` 再归一化成现代结构；② 1.20.2 没有 `return run`，两处拆成两行。
- **1.20.1 及更早不支持**（*这一条在 v1.0.2 被推翻：legacy 树已补上 1.19.4 / 1.20 / 1.20.1*）：实测确认那些版本**没有函数宏**（`$` 前缀）也**没有 `return` 命令**，本包 85 行宏与整套早退逻辑无处安放，属重写而非移植。`pack.mcmeta` 因此不再谎报宽区间，每个包只声明自己跑过的 format 点。

### 工程

- 仓库内新增变体构建器 `.github/tools/build_variants.mjs`：从仓库根 `data/` 生成 5 个区间包，`check_dist.mjs` 与它共用同一套变换函数，避免两份逻辑分叉。
- `check_dist.mjs` 重写：解出每个 zip，逐字节比对「用仓库 `data/` 跑同一套变换」的结果，并核对 `SHA256SUMS.txt` 与 `manifest.json`。
- 根 `pack.mcmeta` 从 `48..94` 改为 `48..107`（对应 1.21 – 26.2 那 16 个版本共用的数据树）。

---

## 2026-10-18 · v1.0.0 —— 首个公开版本

### 功能

- **自动登记**：玩家进服即登记，分配稳定数字编号，按编号分桶存 `storage headreg:data`。
- **正版判定**：读玩家档案里的 `properties.textures`，命中为 `1b`，否则 `0b`（离线档案）。
- **真时间戳**：mcfunction 内完成 base64 解码 → 定位 JSON 的 `timestamp` → 取 13 位毫秒 → 纯算术日历渲染成 `YYYY-MM-DD HH:MM:SS`。
- **会话统计**：登记次数、离开次数、上一段在线 tick、本次结束方式（`solo` / `personal` / `global`）。
- **历史会话**：最近 10 段，每段进出时刻与时长。
- **名字索引**：`headreg:index` 支撑按名字查，删档时自动回收。
- **玩家自助**：`/trigger headreg.qlist set 1`（名单）、`/trigger headreg.query set <编号>`（本人档案），无需 OP。
- **只读自检**：`api/audit` 7 项一致性检查，绿字一行或逐条红字 + 汇总。

### 本次修掉的三个真缺陷

- **`api/query_id` 查不存在的编号会多打一行**：命中判断只覆盖了前 5 行，末尾「历史会话 暂无」漏了 `if data` 门 ⇒ 查 `{id:99}` 时除了红字「没有 id 为 99 的登记记录」还跟着一句让人误解的空历史提示。已给该行补上桶存在判断。
- **`api/audit` 对离线档案误报**：离线档案合法地没有 `last_leave_sec`，原本被判失败。改为只对 `premium:1b` 的档案要求该字段。
- **跨重启结算整体后移一个停机时长**：`gametime` 在停机期间不走、墙钟在走，用新锚点折算重启前的 `last_seen` 会整体偏移。改为 `load` 留档 `clock.prev` + `schedule 1t` 记 `clock.boot`，结算时按 `last_seen < boot` 选锚点，并加可信度守卫（`sec ≥ 1e9`、`tick ≥ 1`），不可信则回落当前锚点。

### 兼容性

- **只在 1.21.11 做过真机验证**（37/37 断言、0 条加载错误）。`pack.mcmeta` 当时写的是 `pack_format 94` / `supported_formats 48..94`，那是按 format 号推的区间，**其余版本没有实测过**。
- 后续的 `v1.0.1` 才把支持面做成实测边界（1.20.2 – 26.3 共 22 版），并拆成 5 个区间包。

### 已知边界（首发即声明）

- 无法区分正常退出 / 掉线 / 被踢（`leave_game` 三者都是 +1）。
- 离开时刻由 `last_seen` 倒推，误差 1–4 秒；时长本身用 `play_time` 差值，精确。
- `premium=1b` 只证明"档案含皮肤数据"，不等于"已购买"，且签名不校验、可伪造。
- 纯离线服无墙钟锚点 ⇒ 不写日期、不写历史；只要有一个正版档案登录过即恢复。
- 历史上限 10 段；`dur_sec` 与两端差可能差 1 秒。

### 工程

- 三个离线静态门（`.github/tools/`）：泄漏扫描 + 顶层白名单 / 包体与函数引用闭包 / 发行物逐字节一致（`check_dist.mjs` 现在对 5 个区间包分别校验：解出来的内容必须等于把仓库 `data/` 经同一套变换得到的结果）。
- 变体构建器 `.github/tools/build_variants.mjs`：从仓库根 `data/` 生成 5 个区间包，与 `check_dist.mjs` 共用同一套变换函数，避免两份逻辑分叉。
- 开发期沉淀的三条 1.21.11 宏约束（`$` 行必须含变量、`$` 行不能 `return`、含 `$(…)` 的行必须自带 `$`）已写进各函数注释。

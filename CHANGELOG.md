# 变更日志 · doom.headreg

> **口径**：namespace `headreg`（玩家上线档案：自动登记 / 正版判定 / 档案时间戳解码 / 会话时长与历史）。
> 实测支持 **25 个 MC 版本（1.19.4 – 26.3）**，按数据树分 7 类，`dist/` 里每类一个区间包（映射表见 README「版本支持」）。
> 主线（22 版，按数据树分 5 类）的包无依赖；自断言 `headreg:test/run`（**72 个用例**，分 6 段跨 tick 跑）+ 只读自检 `headreg:api/audit`（7 项）。
> legacy 树（3 版：1.19.4 / 1.20 / 1.20.1）是**独立实现**，自断言 13 个用例，能力上限见 README「版本支持」。
> 判定**必须**读计分板 `#pass/#fail/#calls headreg.test`（套件用 tellraw 上报，不进服务端日志）。
> `#done headreg.test` 是完成标志（跑完置 1，开头先归零），轮询它比靠 `#calls` 稳定推断可靠。
> 套件分 6 段、段间 `schedule … 1t` 续跑，`/function` 之后要等约 6 tick（0.3 秒）才出结果；切勿在 6 tick 内就下结论。
> 下方各版本条目里的 **37 / 56 / 77** 是当时的实测数字，不是当前树 —— v1.0.6 起主线是 **72 条断言 / 108 个函数**（v1.0.5 是 101 个）。
>
> ✅ **2026-10-18 起主线 37/37，2026-10-21 扩到 56/56；2026-10-19 起 legacy 13/13 全绿**，并在 25 个 MC 版本上逐版复跑。
> ✅ **2026-10-22 · v1.0.4**：修掉满历史档案查不出历史明细（默认链长下 tellraw 被截断），自检套件加 `#done` 完成标志；25 版逐版复测仍全绿。
> ✅ **2026-10-22 · v1.0.5**：修掉 `audit_seg` 末段同时触发两条判定时 `#bad` 重复计数（「失败 2 项 / 共 7 项」自相矛盾）；自检套件补 `api/audit` 16 例（第 6 段），主线 56 → 72 条断言。
> ✅ **2026-10-24 · v1.0.6**：日期换算不再从 1970 年逐年生减（`render_date` 2660 → 332 条）、皮肤载荷不再整包落桶（记录 1954 B → 409 B）、三处扫描改走活跃 id 列表（`api/list` 7036 → 380 条）。25 版逐版复测仍全绿。

---

## 未发布 —— 贡献者区在 README 顶部

### 为什么不在 GitHub 的 Contributors 栏里

仓库页右侧那个 **Contributors** 小岛是按**提交作者**统计的，不接受手工添加：官方文档写明「You can view the top 100 contributors to a repository」，「including commit co-authors」只在 GitHub Enterprise Server 上成立（`{{% ifversion ghes %}}` 分支），github.com 上连 `Co-authored-by:` 里的联合作者都不计入。

要让它出现另一个账号，只有一条路：让真实提交的 **author email** 与那个账号绑定的邮箱一致。`deepseek-ai` 是 Organization，没有 `<id>+<login>@users.noreply.github.com` 这种 no-reply 地址（那是个人账号专有格式），公开邮箱只有 `service@deepseek.com`（客服信箱，不是账号绑定地址）；`on-behalf-of:` 尾注要求签名提交 + 组织成员身份 + 组织已验证域名，三者都不满足。

实测佐证：全站用 `148330874+deepseek-ai@users.noreply.github.com` 的提交有 8 条，所在仓的 `/contributors` 接口里 `deepseek-ai` 一个都没出现。

### 改法：README 顶部一块贡献者区

在 README 的标题与「安装」之间插入 `## 贡献者`：两列表格（头像 + 名字 + 角色 + 主页链接），GitHub 渲染出来就是熟悉的头像墙形态。

- `Doom_Flare` —— 作者 · 维护者 —— <https://github.com/Doom-Flare>
- `DeepSeek` —— 协作 —— <https://github.com/deepseek-ai>

头像走 `https://avatars.githubusercontent.com/u/<id>?v=4&s=120`（`202896874` / `148330874`），不新增仓库文件，`check_leak` 的外链与顶层白名单都不受影响。

### 连带

`README.md` 与 `CHANGELOG.md` 都在 8 个区间包的 `PACK_TOP_FILES` 里 ⇒ `dist/` 全部重打（**每个包 +1519 B**），`SHA256SUMS.txt` 与 `manifest.json` 同步更新。`data/` 与 `resourcepack/assets/` 一个字节没动，25 版真机矩阵沿用 v1.0.6。

### 闸门

- `check_leak.mjs` ✅ 0 处泄漏 · 12 个顶级条目全在白名单内（244 个已跟踪文件）
- `check_pack.mjs` ✅ 0 个问题（main 108 函数 / 1906 行 / 233 引用；legacy 100 / 5071 / 142）
- `check_dist.mjs` ✅ 8 个 zip 逐字节一致 + sha256 对得上 + manifest 一致
- `_work/i18n/apply.mjs --check` ✅ 已应用 194 组件 · 待变换 0 · 未映射 0

---

## 2026-10-24 · v1.0.6 —— 三处改造：日期换算、皮肤载荷、活跃 id 列表

### ① 日期换算不再从 1970 年逐年生减

- **原实现**：`internal/sub_year.mcfunction` 每减掉一整年就递归一层，一层 19 条命令。一次 `render_date` 从 1970 年起算 —— 2026 年的时间戳要白跑 56 层。
- **更糟的是跑了两遍**：`internal/tz_prep.mcfunction:9` 一次（算时区偏移所需的年份）、`internal/render_date.mcfunction:20-23` 再一次（真正渲染）。满历史档案一次查询里这层重复占 92%。
- **修法**：新增 `internal/sub_year_seed.mcfunction`，用 400 年整周期 146097 天一次整除估出起始年（`#yq = floor(#days*400/146097) - 1`），再用 `#ycs = #yq*365 + (yq+1)/4 - (yq+69)/100 + (yq+369)/400` 反算已过天数，剩下的交给原有循环补齐。`sub_year.mcfunction:9` 加一道守卫：剩余天数 ≥ 366 才走估算段（365 时估算必得 0 年，纯属白跑）。
- **验算**：纯 JS 逐条模拟 0 – 400000 天（≈1970 – 3065），偏差 **0 例**，最大补年循环 **2**（分布 0 次 386 / 1 次 399191 / 2 次 424）。真机 60 点批量比对（含 0 / 1 / 364 / 365 / 366 / 367 / 闰年边界 / 世纪边界 / 400 年边界 + 26 个伪随机点）同样 0 例。
- **实测**：`render_date` utc **2660 → 332**（8.0×）、paris **2694 → 371**（7.3×）；满历史 `api/query_id` **62379 → 716**（87×），零历史 **8134 → 716**（11.4×）。改后满历史与零历史同为 716，说明链长已由固定开销主导，历史段几乎免费；余量从 4.8% 抬到 **98.9%**。
- 新增常量 `#k146097 headreg.calc`（400 年整周期天数）。

### ② 皮肤载荷不再整包写进存档

- **原实现**：`internal/push_data.mcfunction` 是整体覆盖写（`set from storage … root.working_data`），注册链路里的临时字段一起进了桶：`properties`（完整 textures base64 + 684 字符签名）、切窗口用的 `value`、20 字符片段 `b64`，以及全包无人读取的 `uuid`。
- **实测体积**：正版档案 **1954 B**，剥掉这四件后 **409 B** —— 省 **79.1%**。附带效果是完整纹理 base64 与签名不再长期躺在 `world/data/command_storage_headreg.dat` 里。
- **修法**：在覆盖写之前加 4 条 `data remove`；同时删掉 `api/register.mcfunction` 里那句死写 `uuid set from … .id`（显示用的是 `build_uuid` 现算的 `uuid_str`）。`headreg:lut b64` 是 base64 查找表，属于另一个 storage 命名空间，与本次无关，原样保留。
- `api/query.mcfunction:33` 会显示 `fetched_at`，故该字段保留；`ts_ms` / `now_date_str` 等有显示路径的字段一并保留。

### ③ 三处扫描改走活跃 id 列表（不再按「已分配最大 id」走）

- **原实现**：`internal/assign_id.mcfunction` 单调递增发号，号码永不回收；`#init headreg.next` 是「发出去的最大号」而不是「有多少人」。实际 22 个桶时它是 1001，于是三处扫描各扫 1000 个空号：`api/list` 7×max+7（1001 → **7036** 条，max_id 涨到 ~9360 就会撞 65536 静默截断）、结算时 `scan_peer` 每次扫 1..max、`tz_refresh_scan` 每 tick 一条（22 个真实玩家也要 **1001 tick ≈ 50 秒**）。
- **修法**：新增 `storage headreg:ids list` = `[{id:1001},{id:1002},…]`（复合元素，因为只有复合才支持按谓词删与成员判定），随分配 append。三处扫描改成按下标遍历这个列表。新增 6 个函数：`ids_len` / `ids_at`（下标 → 真实 id）/ `ids_add`（带查重）/ `ids_rebuild` / `ids_rebuild_scan` / `ids_rebuild_add`；`load.mcfunction` 用 `meta ids1` 门给老存档做一次性重建（按 1..max 全扫一遍，之后永不再走）。
- **实测**：`api/list` 最小命令链 **7036 → 380**；`tz_refresh_all` 扫完整表 **1208 ms / 23 条**（改前 1001 tick）；`scan_peer` 直驱 `#glob=22 #seen=22 #ln=23`。真实客户端抓包确认列表里显示的是 `#777` / `#1001` 这类真实 id，不是下标。
- **`api/clear` 不动列表**：它只删 `root.<id>.data`、保留 `headreg.id` 记分板值，重注册因此不走 `assign_id`；此时若把列表项删掉，这个号会被永久漏扫。
- 落笔时踩到并绕开的三个坑：带 `$(x)` 的函数必须由 `function … with` 调用，否则宏行不展开且整条静默失效；`store result` 在 NBT 路径失败时写 0 而不是保留旧值，哨兵必须先显式清零；完成标志不能复用游标归零（`#init=1` 时会让 id 1 被跳过），改用独立 `#rbd`。

### 兼容性

- 支持版本、`pack.mcmeta`、资源包格式、文案**全部不变**，仍是 1.19.4 – 26.3 共 25 个版本、主线 72 条断言 / legacy 13 条。
- 主线函数 **101 → 108**（7 个新增：`sub_year_seed` + 6 个 `ids_*`）。
- 数据结构有一处新增（`headreg:ids` 与 `meta ids1`），老存档首次加载自动重建，无需手动迁移；档案桶少四个字段。
- legacy 树**不动**：它的 `register` 早已手工清掉 `properties` / `b64`，也没有 `list_scan` / `scan_peer` / `tz_refresh` / `assign_id` 这套扫描结构。

### 真机验证

- 25 个版本逐个真机复测，全部 `#calls == #pass`、`#fail = 0`、`#done = 1`、0 条加载错误：legacy 三版 13/13，其余 22 版 72/72。口径同 v1.0.5。
- 定向验收（1.21.10）：日期换算 60 点比对 0 偏差；`api/query_id` 对 2 段历史档案重渲染后 7 个时间字段全部按当前时区改写；新注册档案字段里确认无 `properties` / `value` / `b64` / `uuid`。

## 2026-10-22 · v1.0.5 —— audit_seg 重复计数修复 + api/audit 补 16 例自检

### 修掉一个只在脏数据上出现的计数 bug

- **现象**：对一份「末段同时不自洽」的档案跑 `/function headreg:api/audit`，汇总行会打出「✗ 失败 **2** 项 / 共 **7** 项」——失败数比检查项还多，自相矛盾。
- **根因**：`internal/audit_seg.mcfunction` 里两条判定各带一条独立的 `scoreboard players add #bad … 1`：一条查 `dur_sec` 与 `out_sec-in_sec` 是否相符（容差 ±1 秒），一条查末段时长是否为正。这两条**并不互斥**：`in_sec=100, out_sec=100, dur_sec=5` 时差值 `#d=0`（非正）而 `#e=3`（差 3 秒），两条同时命中 ⇒ `#bad` 加 2，而这一整段在 `audit_id.mcfunction` 只对应 1 个 `#n`。
- **修法**：引入共用标志 `#h`（objective `headreg.audit`）。两条判定只把 `#h` 置 1，末尾统一 `execute if score #h headreg.audit matches 1 run scoreboard players add #bad headreg.audit 1`。两条红字提示**都保留**（用户仍能看到两处具体问题），只是失败项只记一次。`audit_seg.mcfunction` 由 11 行变 13 行。
- **影响面**：`#h` 在全仓只被 `internal/decode_b64.mcfunction` 用在 `headreg.calc` objective，与 `headreg.audit` 互不相干。不涉及数据结构、不涉及任何正常档案（真实档案的 `dur_sec` 由 `settle_session` 写入，天然自洽）。
- **legacy 树不动**：`legacy/…/audit_seg.mcfunction` 是逐槽位展开的另一套实现，`#au_bad` 与 `#au_n` 都以「段」为单位累加，不存在这种错配。

### 自检套件补上 api/audit 覆盖（第 6 段 16 例）

- `api/audit` 此前**零测试覆盖**——`data/headreg/function/test/` 里 grep `audit` 命中 0 行。
- 新增 `data/headreg/function/test/run_audit.mcfunction`（16 例）：空档案 / 合法单段 / 时长不符 / 上条的回归夹具 / `dur_sec=0` / `out<in` 但时长自洽 / 末段 `out` 晚于 `last_leave_sec` / `exit_kind` 非枚举值 / 已结算缺 `prev_play` / 已结算 `prev_clean:0b` 放行 / 未结算不判 / 名字索引回指错 id / 无 `name` / 正版已结算缺 `last_leave_sec` / 完整正版全过 / `history` 超 10 段。
- 断言只读计分板 `#bad` / `#n headreg.audit`，不依赖 tellraw——控制台执行时 `@s` 是服务端，tellraw 既不进聊天也不进日志。
- 套件因此由 5 段变 **6 段**、56 例变 **72 例**，报告改由第 6 段发出，`#done headreg.test` 也在第 6 段末尾才置 1。
- **回归有效性已验证**：把旧 `audit_seg` 放回去只跑第 6 段 → `16 例过 15 例、挂 1 例`（挂的正是那条回归夹具）；换回新实现 → 16/16。

### 兼容性

- 支持版本、`pack.mcmeta`、资源包格式、118 项文案**全部不变**，仍是 1.19.4 – 26.3 共 25 个版本、主线 72 条断言 / legacy 13 条。
- 只改了 1 个 audit 函数 + 测试套件 + 文档，没有新增依赖、没有改数据结构、没有改时钟与渲染链路。

### 真机验证

- 25 个版本逐个真机复测，全部 `#calls == #pass`、`#fail = 0`、`#done = 1`、0 条加载错误：legacy 三版 13/13，其余 22 版 72/72。口径同 v1.0.4（干净世界 → 装区间包 → 起服 → 链长归一到 65536 → `/reload` → `function headreg:test/run` → 轮询 `#done`）。

## 2026-10-22 · v1.0.4 —— 满历史档案的历史明细修复 + 自检完成标志

### 修掉一个静默缺陷：满历史档案查不出历史明细

- **现象**：某个玩家历史攒满 10 段之后，查他（`api/query` / `api/query_id` / `/trigger headreg.query`）只能看到「历史会话 10 段（旧 → 新）」这行表头，**下面 10 行明细一行都不显示**。不报错、不打红字、数据也没坏（`data get` 能看到 `in_str`/`out_str` 全在），只是用户看不到。
- **根因是重复渲染，不是渲染失败**：`api/query_id.mcfunction:9` 的 `tz_rec_all` 已经按当前时区把该档案**全部 23 个**时间显示字段写过一遍；`internal/render_history_one.mcfunction` 又对其中 20 个（10 段 × in/out）调了两次 `tz_rh` 重写一遍。单次 `render_date` 实测 2694 条命令，这层重复就是 **≈ 54000 条**白烧。
- **为什么表现为明细全丢**：默认 `max_command_sequence_length` 是 65536。重渲染吃掉大头，递归到 `render_history` 时预算已经见底 —— 数据早就写完了，tellraw 那 10 行却一句都轮不到。日志里会有 1 条 `Command execution stopped due to limit (executed 65536 commands)`。
- **修法**：删掉 `internal/render_history_one.mcfunction` 里那层重复，只保留 `$tellraw`。该函数**唯一**调用者是 `internal/render_history.mcfunction:7`，而后者的**唯一**调用者是 `api/query_id.mcfunction:21` —— 顺序上 `tz_rec_all` 永远在前，值完全相同，所以删掉不影响任何路径。缺 `*_sec` 的老档案本来就不该重算，行为也不变。
- **实测**：同一条 10 段满历史档案，修前默认链长下 0 行明细、修后 10 行齐全；链长梯度 65536→0 行 / 75000→2 / 90000→5 / 100000→6 / 110000→8，修后 65536 直接满。

### 新增 `#done headreg.test` 完成标志

- 自检套件原本没有任何「跑完了」的信号，外部脚本只能轮询 `#calls/#pass/#fail`，靠「`pass+fail===calls` 且连续两次不变」去猜。`#stg` 不能顶替：它归零既可能是跑完了，也可能是从没开始。
- 现在开头一律先置 0，**全部断言跑完**（第 5 段报告之后 / legacy 报告之后）才置 1。中途被链长截断、或只手动跑了前几段，都停在 0。
- 主线与 legacy 两棵树都加了；多版本回归脚本的判定改用 `#done===1`，不再靠 `#calls` 签名稳定推断。

### 兼容性

- 支持版本、`pack.mcmeta`、资源包格式、118 项文案**全部不变**，仍是 1.19.4 – 26.3 共 25 个版本、主线 56 条断言 / legacy 13 条。
- 只改了 1 个渲染函数 + 2 个自检函数 + 文档，没有新增依赖、没有改数据结构、没有改时钟链路。

### 真机验证

- **25 个版本逐个真机复测，全部 `#calls == #pass`、`#fail = 0`、`#done = 1`、0 条加载错误**：legacy 三版（1.19.4 / 1.20 / 1.20.1）13/13，其余 22 版 56/56。每档都是「干净世界 → 装 `dist/` 对应区间包 → 起服 → 链长归一到 65536 → `/reload` → `function headreg:test/run` → 轮询 `#done`」。
- 满历史修复的真机验收：构造 10 段满历史档案（23 个字段全填 `SENTINEL`），查询后 23 个字段全部按当前时区重算、机器人从客户端视角收到完整 10 行明细。
- 老档案回归：只有 `in_str`/`out_str`、没有 `_sec` 的旧记录查询后原样保留，不被写成空值。
- 三个静态门全绿：`check_pack` 0 问题（主线 100 函数 / 1672 行 / 202 引用，legacy 100 函数 / 5071 行 / 142 引用）、`check_leak` 0 处泄漏（236 个已跟踪文件）、`check_dist` 8 个发行物逐字节一致。

### 已知边界（新增）

- **单条满历史查询本身已逼近默认链长**：修完仍需 62379 条命令，是 65536 的 95.2%。给人看的明细省下来了，但数据重渲染那 23 次 `render_date` 省不掉。真要更宽的余量得改造 `tz_apply`/`render_date` 的复用方式，不在本版范围。
- **同 tick 多人查询互不抢预算**：每个执行上下文各有独立配额，实测 2～3 人同 tick 各查一条满历史，双方都完整渲染；日志里各留一条触顶记录属正常痕迹。

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
  - 1.20.2 – 1.21.10 共 16 版 → 56/56（旧 gamerule 名 `maxCommandChainLength`）
  - 1.21.11 – 26.3 共 6 版 → 56/56（新 gamerule 名 `max_command_sequence_length`）
- 强制链长归一化是这一轮的关键：26.3 的默认值就是 65536，此前失败的根因正是「单次自检约 8.5 万条 > 65536」，不是功能不兼容。分段改造后 26.3 在默认世界上直接 56/56。
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

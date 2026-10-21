# doom.headreg · legacy 树（1.19.4 / 1.20 / 1.20.1）

> 这份文档只讲 **legacy 树**，即 `legacy/` 目录下那一套。
> 主线（1.20.2 – 26.3）的行为见仓库根的 `README.md`，两者**不完全相同**。

## 为什么单独有这么一棵树

1.21 的 `pack.mcmeta` 新规则、`function/` 单数目录、`return run` 语法都还没有，
所以 legacy 树是**独立实现**，不是主线裁剪出来的。

它存在于 `legacy/`，由 `legacy/build/gen.mjs` 生成三份变体：

| 版本 | `pack_format` | 说明 |
|---|---|---|
| 1.19.4 | 12 | 没有函数宏、也没有 `/return` |
| 1.20 | 15 | 有宏、有 `return` |
| 1.20.1 | 15 | 同 1.20 |

## 与主线的能力差异（重要）

| 能力 | 主线 | legacy |
|---|---|---|
| `exit_kind` 判定依据 | 扫描所有已登记玩家的 `last_seen` | 只读两个全局哨兵 |
| `exit_peers` | **真实计数** | **恒为 0**（结构性限制） |
| `exit_seen` | 有 | 无此字段 |
| 名字索引 `headreg:index` | 有 | 无 |
| `uuid_str` / `date_str` / `ts_ms` | 有（字符串形式） | 只有整数秒 `ts_sec` |
| 时间精度 | 毫秒 | 秒 |

## `exit_kind` 的语义限定（必读）

**这是 legacy 树最容易被误读的地方。**

主线用 `internal/scan_peer` 遍历 `id = 1..max`，把每个人的 `last_seen` 和自己比一遍，
落在 `±2 tick` 窗口内就算命中 —— **跟结算顺序无关**，谁先结算都判得对。

legacy 用的是 **O(1) 全局哨兵** `root.g_last` / `root.g_last2`，
哨兵**只在结算时才推进**。于是：

```
A、B 同一秒退出（last_seen 都是 T）

   B 先重新登录 → 结算
     此刻 g_last / g_last2 还是空的
     ⇒ #p1 = #p2 = 0 ⇒ exit_kind = "personal"   ✗

   A 后重新登录 → 结算
     g_last2 里有 B（T, id=2），g_last 被 A 自己占位
     ⇒ |T − T| = 0 ≤ 2 ⇒ exit_kind = "global"   ✓
```

**结论：同一批退出的人里，只有最后结算的那个能判成 `global`，先结算的会得到 `personal`。**

这不是缺陷，是哨兵机制的结构性限制 —— 先结算的人无从得知后结算者的离开时刻，
因为那个时刻要等他结算时才写进哨兵。而 `execute as @a` 是串行的，
两个人不可能在同一 tick 都触发结算。

### 使用者该知道什么

- 看到 `exit_kind: "global"` ⇒ **我离开时确实有人和我同时走**（可信）
- 看到 `exit_kind: "personal"` ⇒ **没有证据表明有人和我同时走**，但这 **不等于** 我是单独走的
  —— 有可能我也是同批里的一员，只是先结算
- 需要**精确人数**时不要用 legacy，用主线版的 `exit_peers`

### 实测证据

`_work/multiver/_two_tick.mjs`（A、B 同秒退出后同时重登）：

```
PremA last_seen = 1792343747
PremB last_seen = 1792343747      ← 同一秒，同批退出成立
root.g_last  = 1792343747 (id=1)
root.g_last2 = 1792343747 (id=2)

root.1.data.exit_kind = "global"     ← 后结算者
root.2.data.exit_kind = "personal"   ← 先结算者
```

`_two_debug.mjs` 做了控制变量（只让 B 先登录，观察哨兵推进过程），结论一致。

## 为什么不修

评估过三条路，都不划算：

1. **把 `scan_peer` 搬过来** —— 每次结算要递归遍历 `1..1023`。
   主线这么做是因为它本来就设计成那样；legacy 要覆盖 1.19.4–1.20.1，
   这些版本的性能余量没测过，而 `settle_session` 当前是 13/13 全绿的状态。
2. **把判定推迟到两人都有记录** —— mcfunction 没有"等别人结算"的能力。
3. **改哨兵推进顺序** —— 治不了"先结算者无从得知后结算者"这个根本性不对称。

如果将来确实需要精确判定，正确做法是移植 `scan_peer`，但那要单独排期并做性能评估。

## 其他已知边界

与主线相同的那几条（不知道怎么退出的、时刻是倒推的、`premium` 不等于买过游戏、
纯离线服没有时间、历史最多 10 段）见根 `README.md` 的「已知边界」。
legacy 额外还有：

- **没有名字索引**：不能按名字查，只能按编号
- **时间只有秒级**：`ts_sec` 是 int32，**2038-01-19 之后溢出**
- **`prev_play` 是秒折算成 tick**（×20 存进主线的字段名），精度低于主线

## 开发与校验

```bash
# 重新生成 53 个机械文件（分派表 / base64 解码表 / 日历表），
# 直接写进 legacy/data/headreg/functions/internal/；纯 Node 无依赖，同一输入连跑两次字节一致
node legacy/build/gen.mjs

# 仓库内三道静态门（不需要 Minecraft）
node .github/tools/check_pack.mjs    # 函数引用闭包（同时扫主线树与 legacy 树）
node .github/tools/check_dist.mjs    # 8 个区间包各自与源树逐字节一致
```

包内自断言套件：`function headreg:test/run`，13 条断言。
判定读计分板 `#pass/#fail/#calls headreg.test`（套件用 tellraw 上报，不进服务端日志）。

装法：把 `dist/doom.headreg-1.19.4.zip` 或 `dist/doom.headreg-1.20-1.20.1.zip` 解到
`world/datapacks/`，进服后 `/reload`。**1.19.4 不会自动启用 `world/datapacks/` 下的包**，
要补一条 `/datapack enable "file/doom.headreg"`。

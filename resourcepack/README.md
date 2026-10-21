# doom.headreg 配套资源包

数据包本体（`doom.headreg-*.zip`）能独立工作：所有提示都带内建中文 `fallback`，不装这个资源包也看得懂。

这个包只做一件事 —— **把界面文案换成玩家自己的客户端语言**：

| 语言 | locale |
| --- | --- |
| 英语（美国） | `en_us` |
| 法语（法国） | `fr_fr` |
| 西班牙语（西班牙） | `es_es` |
| 简体中文 | `zh_cn` |

## 装法

### 单人 / 局域网

1. 把 `doom.headreg-resourcepack.zip` 丢进 `.minecraft/resourcepacks/`（**不要解压**）。
2. 游戏内 选项 → 资源包 → 启用它 → 拖到「已选择」列表的最上面。
3. 服务器端同时把数据包放进 `world/datapacks/`。

> 这个 zip 的**内层没有单独的顶层目录**：`pack.mcmeta`、`assets/`、`README.md` 都在 zip 根。
> 这是资源包的必需形态 —— 游戏按「zip 根下有 `pack.mcmeta`」来认包，多套一层就会报
> `Missing metadata in pack …` 而完全不加载。真要解压，请先自己建一个目录再解压进去
> （例如 `resourcepacks/doom.headreg-resourcepack/`），别把文件平铺在 `resourcepacks/` 下。
> **数据包 zip 恰好相反**：那个带一层 `doom.headreg/`，是给「解压后放目录」用的，
> 直接把数据包 zip 丢进 `world/datapacks/` 反而不认。两种包形态不同，别混着来。

### 专用服务器（推荐）

把资源包放到任意 HTTP 可访问的位置，然后在 `server.properties` 里指向它：

```properties
resource-pack=https\://example.com/doom.headreg-resourcepack.zip
resource-pack-sha1=<zip 的 SHA-1，小写十六进制>
resource-pack-id=<一个 UUID，例如 7b1a2c3d-4e5f-4a6b-8c9d-0e1f2a3b4c5d>
resource-pack-prompt={"text":"安装 doom.headreg 文案包以显示你自己的语言","color":"yellow"}
```

> `.properties` 里 `:` 要写成 `\:`，包括 URL 里的协议冒号和 `resource-pack-prompt` 内部的 JSON 冒号。漏转义会解析出错。

- `resource-pack-prompt` 接受与聊天组件完全相同的语法，所以写 `{"translate":"…"}` 也能用；上面给的是纯文本形式，任何语言下都显示同一句。
- 想让玩家必须装，再加 `require-resource-pack=true` —— **注意拒绝的玩家会被直接踢出服务器**。
- SHA-1 用 `sha1sum doom.headreg-resourcepack.zip` 单独算。**填错不会挡住玩家**（实测客户端照样进服），但服务端 `logs/latest.log` 会刷一条 `ERROR` 和一段 `IllegalStateException: Unexpected request for task finish, current task: prepare_spawn, requested: server_resource_pack` 堆栈；填对了就没有这条日志。
- `resource-pack-id` 必须是合法 UUID。写成任意字符串时服务端启动日志会报 `Failed to parse '…' into UUID`。
- 以上几个键**只在服务器启动时读取**，改完要重启，`/reload` 不生效。

## 不装会怎样

数据包里的每个文案都写成 `{"translate":"headreg.…","fallback":"中文原文"}`。客户端查不到翻译键时的回退顺序是：

**当前语言 → `en_us` → `fallback` → 裸键名**

所以没装资源包时，所有玩家（包括英文客户端）都会看到中文原文 —— 而不是一串 `headreg.field.now` 这样的键名。

想改成"默认英文、装了包才是中文"，把数据包源码里 fallback 的中文换掉重新打包即可；不要在语言文件里删键，删了就会掉到裸键名。

## 版本

`pack.mcmeta` 里 `pack_format` 是 13（1.19.4 的资源包格式），并用 `supported_formats` 声明 13–97 全覆盖。资源包格式号与数据包格式号是两套编号（例如 1.21.11 资源 75.0 / 数据 94.1），不要拿数据包的号来填。

1.20 / 1.20.1 的资源包格式是 15，比这里的 13 新，游戏会提示「为旧版本制作」，直接启用即可，语言文件本身与版本无关。

## 许可

与数据包本体相同，见仓库根 `LICENSE`。

// .github/tools/build_variants.mjs —— 由仓库自身的 data/ 产出 5 个区间包。
//
//   node .github/tools/build_variants.mjs           # 写 dist/ 下 5 个 zip + manifest.json + SHA256SUMS.txt
//   node .github/tools/build_variants.mjs --dry     # 只算不写
//   DOOM_ROOT=<仓库> node .github/tools/build_variants.mjs    # 对另一个克隆构建
//
// 输入只有仓库自己：根 data/ 是 1.21–26.2 那一类数据树；根 pack.mcmeta 提供描述文字；
// 根 README.md / LICENSE / CHANGELOG.md / docs/USAGE.md 原样进包。
// 每次运行都现读磁盘，不内联、不缓存 —— 文档改了重跑一次就进包。
//
// 变换只有这一份实现：check_dist.mjs 直接 import 本文件的 variantFiles() 算「应得内容」。
// 检查脚本若另抄一套，两份迟早分叉，届时分不清是包错了还是检查错了。
import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';
import crypto from 'node:crypto';
import { fileURLToPath } from 'node:url';

// 仓库根：优先 DOOM_ROOT，否则取本文件上两级。
// 不用 import.meta.dirname —— 它要 Node ≥ 20.11，Node 18 与 20.0–20.10 会直接崩；
// fileURLToPath 自 Node 10 起就有，别人 clone 下来不管什么小版本都能跑。
export const ROOT = process.env.DOOM_ROOT
  ? path.resolve(process.env.DOOM_ROOT)
  : path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
export const DIST = path.join(ROOT, 'dist');

/* ------------------------------------------------------------------ *
 * 一、版本表与聚类
 * ------------------------------------------------------------------ */

/**
 * 版本比较：cmp('26.3','1.21.11') > 0。段数不同按缺位补 0。
 * 只比数字段，'1.21.11' 与 '1.21' 是 11 > 0，不是字符串序。
 */
export function vcmp(a, b) {
  const pa = String(a).split('.').map(Number);
  const pb = String(b).split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i++) {
    const x = pa[i] || 0;
    const y = pb[i] || 0;
    if (x !== y) return x - y;
  }
  return 0;
}

/**
 * 22 个实测版本按「数据树逐字节相同」分 5 类。
 *
 * versions  该类的 MC 版本列表，顺序即首版 → 末版；首末两个版本的名字同时决定
 *           zip 命名与 mcmeta 区间（单版类 min = max）。
 * pack      该类的 data pack format 首/尾，写成字符串（"88.0" 这类带小版本号的
 *           必须留字符串，否则 88.0 会被读成 88）。
 * style     目录单复数，与 dirStyle(versions[0]) 必须一致（构建时会断言）。
 * patches   该类要打的补丁 id，与 since/until 的语义判定必须一致（构建时会断言）。
 */
export const GROUPS = [
  // ── legacy 数据树（无宏，1.19.4 – 1.20.1）────────────────────────────
  // 这一档不是主线的降级变体，而是另一套用「字面分派表 + 固定中转槽」实现同样功能的代码，
  // 放在仓库的 legacy/ 下。src 缺省为 '.'，这里显式指到 legacy。
  // 三者数据树逐字节相同，只是 mcmeta 的 pack_format 不同（12 / 15 / 15）。
  {
    versions: ['1.19.4'],
    pack: ['12', '12'],
    style: 'plural',
    src: 'legacy',
    patches: [],
  },
  {
    versions: ['1.20', '1.20.1'],
    pack: ['15', '15'],
    style: 'plural',
    src: 'legacy',
    patches: [],
  },
  {
    versions: ['1.20.2'],
    pack: ['18', '18'],
    style: 'plural',
    patches: ['P2-legacy-skullowner-head', 'P3-no-return-run'],
  },
  {
    versions: ['1.20.3', '1.20.4'],
    pack: ['26', '26'],
    style: 'plural',
    patches: ['P2-legacy-skullowner-head'],
  },
  {
    versions: ['1.20.5', '1.20.6'],
    pack: ['41', '41'],
    style: 'plural',
    patches: [],
  },
  {
    versions: ['1.21', '1.21.1', '1.21.2', '1.21.3', '1.21.4', '1.21.5', '1.21.6',
      '1.21.7', '1.21.8', '1.21.9', '1.21.10', '1.21.11',
      '26.1', '26.1.1', '26.1.2', '26.2'],
    pack: ['48', '107.1'],
    style: 'singular',
    patches: [],
  },
  {
    versions: ['26.3'],
    pack: ['121.0', '121.0'],
    style: 'singular',
    patches: ['P1-item-modifier-type-key'],
  },
];

/** format 字符串/数组 → [maj, min]。'88.0' → [88, 0]，'107' → [107, 0]。 */
export function parseFormat(pack) {
  if (Array.isArray(pack)) return pack;
  const s = String(pack).split('.');
  return [Number(s[0]), s[1] ? Number(s[1]) : 0];
}

/** 包内顶层文件（每次构建现读仓库根）。 */
export const PACK_TOP_FILES = ['pack.mcmeta', 'README.md', 'LICENSE', 'CHANGELOG.md', 'docs/USAGE.md'];

/* ------------------------------------------------------------------ *
 * 二、目录单复数
 * ------------------------------------------------------------------ */

/**
 * 1.21.0 起 function/ 与 tags/function/ 改成单数；1.20.x 仍是复数。
 * 26.x（主版本号 > 1）按新版走单数。
 */
export function dirStyle(ver) {
  const [a, b] = ver.split('.').map(Number);
  if (a > 1) return 'singular';
  if (a === 1 && b >= 21) return 'singular';
  return 'plural';
}

/** 该类的数据目录名（含 tags 下的二级名）。 */
const fnDir = (style) => (style === 'plural' ? 'functions' : 'function');
const tagDir = (style) => (style === 'plural' ? 'functions' : 'function');
const itemModDir = (style) => (style === 'plural' ? 'item_modifiers' : 'item_modifier');

/* ------------------------------------------------------------------ *
 * 三、mcmeta
 * ------------------------------------------------------------------ */

/** 描述文字现读仓库根 —— build() 与 check_dist.mjs 用同一取值口径。 */
export function readDesc() {
  return JSON.parse(fs.readFileSync(path.join(ROOT, 'pack.mcmeta'), 'utf8')).pack.description;
}

/**
 * 区间 mcmeta。区间取该类的首尾实测版本（单版类 min = max）。
 *   maj < 82 ：pack_format + supported_formats + min_format/max_format 都写
 *              （老版本读前面的，新版本读后面的）
 *   maj >= 82：只留 min_format/max_format —— 新 schema 已把 pack_format 移出，
 *              留着反而会被判非法
 */
export function mcmeta(packLo, packHi, desc) {
  const [maj, min] = parseFormat(packLo);
  const [hmaj, hmin] = parseFormat(packHi);
  const p = {};
  if (maj < 82) {
    p.pack_format = maj;
    p.supported_formats = { min_inclusive: maj, max_inclusive: hmaj };
    p.min_format = [maj, min];
    p.max_format = [hmaj, hmin];
  } else {
    p.min_format = [maj, min];
    p.max_format = [hmaj, hmin];
  }
  p.description = desc;
  return { pack: p };
}

/* ------------------------------------------------------------------ *
 * 四、版本补丁
 * ------------------------------------------------------------------ */

// legacy 版 grab_head（1.20.2–1.20.4）：该区间没有 item components，fill_player_head
// 只能经 item_modifiers/fill_head.json 引用，profile 落在 item.tag.SkullOwner，
// 故在此归一化成现代的 {name,id,properties}，让后续 classify / extract_ts / build_uuid
// 链路完全不变。逐字取自真机验收过的产物（结尾带换行）。
const LEGACY_GRAB_HEAD = [
  '# headreg:internal/grab_head —— 抓执行者头颅到共享中转槽，并读回 profile',
  '# 入口：@s = 目标玩家',
  '# 出口：storage headreg:data root.working_data = {name,id,properties}（现代形状）；',
  '#       #found = 1 成功 / 0 失败',
  '# 本文件是 legacy（1.20.2–1.20.4）专用变体：该区间没有 item components，',
  '# fill_player_head 只能经 item_modifiers/fill_head.json 引用，profile 落在',
  '# item.tag.SkullOwner（Id/Name/Properties.textures），故在此归一化成现代 shape，',
  '# 让 classify / extract_ts / build_uuid 之后的链路完全不变。',
  'data remove storage headreg:data root.working_data',
  'execute in minecraft:overworld run item replace entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 with minecraft:player_head 1',
  'execute as @s in minecraft:overworld run item modify entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] container.0 headreg:fill_head',
  'execute store success score #found headreg.calc run data modify storage headreg:data root.working_data set from entity @e[type=minecraft:item_display,tag=headreg.display,limit=1] item.tag.SkullOwner',
  'execute if score #found headreg.calc matches 1 run data modify storage headreg:data root.working_data.name set from storage headreg:data root.working_data.Name',
  'execute if score #found headreg.calc matches 1 run data modify storage headreg:data root.working_data.id set from storage headreg:data root.working_data.Id',
  'execute if data storage headreg:data root.working_data.Properties.textures[0].Value run data modify storage headreg:data root.working_data.properties set value [{name:"textures",value:""}]',
  'execute if data storage headreg:data root.working_data.Properties.textures[0].Value run data modify storage headreg:data root.working_data.properties[0].value set from storage headreg:data root.working_data.Properties.textures[0].Value',
  'data remove storage headreg:data root.working_data.Name',
  'data remove storage headreg:data root.working_data.Id',
  'data remove storage headreg:data root.working_data.Properties',
].join('\n') + '\n';

// 2 空格缩进 + 结尾换行：与历史产物逐字节相同。
const LEGACY_FILL_HEAD_JSON = JSON.stringify(
  { function: 'minecraft:fill_player_head', entity: 'this' }, null, 2) + '\n';

/**
 * 三条已知破坏点，全部是真机实测出来的，不是查资料：
 *
 *  P2  1.19.4–1.20.4：没有 item components，也没有 item modifier 内联 JSON。
 *      `item modify ... container.0 {function:"minecraft:fill_player_head",entity:"this"}`
 *        → "Expected whitespace to end one argument ... ntainer.0 <--[HERE]"（三种键名写法都报同一错）
 *      `item modify ... container.0 headreg:fill_head`（文件引用）→ "Modified 1 slot(s)" 成功
 *
 *  P3  1.19.4–1.20.2：没有 `return run`，`return` 只吃整数值。
 *      → "Expected integer at position 66: ...un return"
 *      做法：拆成两行，先干活再 `return 0` 收尾。
 *
 *  P1  26.3 起：item modifier 内联 JSON 的判别键 function: → type:。
 *      同一行 1.21.11 返回 "No entity was found"（语法通过），26.3 返回 "No key type in MapLike[...]"。
 *
 * since / until 都是闭区间（since ≤ v ≤ until 才打），until 缺省表示一直到最新版。
 * 每个 patch 的 apply(files, style) 直接改内存树，不落盘 —— check_dist 才算得出「应得内容」。
 */
export const PATCHES = [
  {
    id: 'P2-legacy-skullowner-head',
    since: '1.19.4',
    until: '1.20.4',
    apply(files, style) {
      const key = 'data/headreg/' + fnDir(style) + '/internal/grab_head.mcfunction';
      if (!files.has(key)) throw new Error('P2 找不到 ' + key);
      files.set('data/headreg/' + itemModDir(style) + '/fill_head.json',
        Buffer.from(LEGACY_FILL_HEAD_JSON, 'utf8'));
      files.set(key, Buffer.from(LEGACY_GRAB_HEAD, 'utf8'));
    },
  },
  {
    id: 'P3-no-return-run',
    since: '1.19.4',
    until: '1.20.2',
    apply(files, style) {
      // [文件, 原文, 拆成的两行]
      const rewrites = [
        ['internal/list_scan.mcfunction',
          'execute if score #li headreg.calc > #init headreg.next run return run data remove storage headreg:scan larg',
          ['execute if score #li headreg.calc > #init headreg.next run data remove storage headreg:scan larg',
            'execute if score #li headreg.calc > #init headreg.next run return 0']],
        ['internal/render_history.mcfunction',
          'execute if score #qi headreg.calc > #qlen headreg.calc run return run data remove storage headreg:scan harg',
          ['execute if score #qi headreg.calc > #qlen headreg.calc run data remove storage headreg:scan harg',
            'execute if score #qi headreg.calc > #qlen headreg.calc run return 0']],
      ];
      for (const [rel, from, to] of rewrites) {
        const key = 'data/headreg/' + fnDir(style) + '/' + rel;
        if (!files.has(key)) throw new Error('P3 找不到 ' + key);
        const t = files.get(key).toString('utf8');
        if (!t.includes(from)) throw new Error('P3 在 ' + key + ' 里没找到待拆的行');
        // 用函数式替换：替换串里有 `$` 时字符串形式会被当成捕获组引用。
        files.set(key, Buffer.from(t.replace(from, () => to.join('\n')), 'utf8'));
      }
    },
  },
  {
    id: 'P1-item-modifier-type-key',
    since: '26.3',
    apply(files, style) {
      const key = 'data/headreg/' + fnDir(style) + '/internal/grab_head.mcfunction';
      if (!files.has(key)) throw new Error('P1 找不到 ' + key);
      const t = files.get(key).toString('utf8');
      const n = t.replace(/\{function:"minecraft:fill_player_head"/g,
        () => '{type:"minecraft:fill_player_head"');
      if (n === t) throw new Error('P1 在 ' + key + ' 里没找到 {function:"minecraft:fill_player_head"');
      files.set(key, Buffer.from(n, 'utf8'));
    },
  },
];

/** 该补丁是否作用于此版本：since ≤ v ≤ until（until 缺省 = 无上界）。 */
export function patchApplies(p, ver) {
  if (vcmp(ver, p.since) < 0) return false;
  if (p.until && vcmp(ver, p.until) > 0) return false;
  return true;
}

/* ------------------------------------------------------------------ *
 * 五、算出一个区间包的内容（全在内存里）
 * ------------------------------------------------------------------ */

const walk = (d, rel, out) => {
  const names = fs.readdirSync(d, { withFileTypes: true })
    .sort((x, y) => (x.name < y.name ? -1 : x.name > y.name ? 1 : 0));
  for (const e of names) {
    const r = rel ? rel + '/' + e.name : e.name;
    if (e.isDirectory()) walk(path.join(d, e.name), r, out);
    else out.push(r);
  }
  return out;
};

/**
 * 应得内容：{ 相对路径 → Buffer }。
 *
 * 步骤与原验收链路一致，顺序不能换：
 *   ① 复制仓库 data/
 *   ② plural 类改名 function → functions、tags/function → tags/functions
 *   ③ 按 since/until 打补丁（表里顺序 P2 → P3 → P1）
 *   ④ pack.mcmeta 按该类区间生成；README/CHANGELOG/LICENSE/USAGE 现读仓库根
 */
export function variantFiles(group) {
  // src 缺省 '.' = 仓库根的主线数据树（1.20.2 – 26.3）；
  // legacy = 无宏数据树（1.19.4 – 1.20.1），结构同为 <src>/data/**，但代码是另一套。
  const srcRoot = path.join(ROOT, group.src || '.');
  const isLegacy = srcRoot !== ROOT;
  const dataSrc = path.join(srcRoot, 'data');
  if (!fs.existsSync(dataSrc)) throw new Error('没有 data/：' + dataSrc);

  const files = new Map();
  for (const rel of walk(dataSrc, '', [])) {
    files.set('data/' + rel, fs.readFileSync(path.join(dataSrc, rel)));
  }

  const style = group.style;
  if (style === 'plural') {
    // 逐命名空间改名：<ns>/function → <ns>/functions，<ns>/tags/function → <ns>/tags/functions
    const renamed = new Map();
    for (const [k, v] of files) {
      const parts = k.split('/');
      if (parts[2] === 'function') parts[2] = 'functions';
      if (parts[2] === 'tags' && parts[3] === 'function') parts[3] = 'functions';
      renamed.set(parts.join('/'), v);
    }
    files.clear();
    for (const [k, v] of renamed) files.set(k, v);
  }

  // 断言表里声明的 style / patches 与语义判定一致 —— 表写错时立刻炸，不要默默产出一个歪包。
  const v0 = group.versions[0];
  if (dirStyle(v0) !== style) {
    throw new Error('版本表自相矛盾：' + v0 + ' 的目录风格应为 ' + dirStyle(v0) + '，表里写 ' + style);
  }
  const want = isLegacy ? [] : PATCHES.filter((p) => patchApplies(p, v0)).map((p) => p.id);
  const declared = group.patches.slice().sort();
  if (want.slice().sort().join(',') !== declared.join(',')) {
    throw new Error('版本表自相矛盾：' + v0 + ' 应打 [' + want.join(', ') + ']，表里写 [' + declared.join(', ') + ']');
  }
  // 同类里每个版本必须打出同一组补丁，否则这个区间包就不该合成一个。
  for (const v of group.versions) {
    const w = isLegacy ? '' : PATCHES.filter((p) => patchApplies(p, v)).map((p) => p.id).sort().join(',');
    if (w !== declared.join(',')) {
      throw new Error('同类版本补丁不一致：' + v + ' 要 [' + w + ']，该类声明 [' + declared.join(',') + ']');
    }
  }

  for (const p of PATCHES) {
    if (declared.includes(p.id)) p.apply(files, style);
  }

  const desc = readDesc();
  files.set('pack.mcmeta', Buffer.from(
    JSON.stringify(mcmeta(group.pack[0], group.pack[1], desc), null, 2) + '\n', 'utf8'));
  for (const f of PACK_TOP_FILES) {
    if (f === 'pack.mcmeta') continue;
    const p = path.join(ROOT, f);
    if (fs.existsSync(p)) files.set(f, fs.readFileSync(p));
  }
  return files;
}

/** 区间包命名：单版 <ver>，多版 <首版>-<尾版>。 */
export function zipName(group) {
  const first = group.versions[0];
  const last = group.versions[group.versions.length - 1];
  return 'doom.headreg-' + (first === last ? first : first + '-' + last) + '.zip';
}

/* ------------------------------------------------------------------ *
 * 六、最小 zip 写入器
 * ------------------------------------------------------------------ */

const CRC_TABLE = (() => {
  const a = new Int32Array(256);
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
    a[n] = c;
  }
  return a;
})();

const crc32 = (b) => {
  let c = -1;
  for (const x of b) c = CRC_TABLE[(c ^ x) & 0xff] ^ (c >>> 8);
  return (c ^ -1) >>> 0;
};

// member 时间戳固定 1980-01-01 00:00:00 —— 同一份内容永远产出同一个 zip。
const DOS_TIME = 0;
const DOS_DATE = (1 << 5) | 1;
const ZIP_TOP = 'doom.headreg/';

/**
 * 写 zip：只有文件条目、无目录条目、顶层前缀 doom.headreg/、
 * 条目按路径字典序、文件名带 UTF-8 标志位 0x0800。
 * 压缩用 deflateRaw，压不小就 store（与原产物同一策略）。
 */
export function writeZip(zipPath, files) {
  const names = [...files.keys()].sort();
  const chunks = [];
  const central = [];
  let off = 0;
  for (const name of names) {
    const raw = files.get(name);
    const nb = Buffer.from(ZIP_TOP + name, 'utf8');
    const def = zlib.deflateRawSync(raw, { level: 9 });
    const store = def.length >= raw.length;
    const data = store ? raw : def;
    const method = store ? 0 : 8;
    const crc = crc32(raw);

    const l = Buffer.alloc(30);
    l.writeUInt32LE(0x04034b50, 0);
    l.writeUInt16LE(20, 4);          // version needed
    l.writeUInt16LE(0x0800, 6);      // UTF-8 文件名
    l.writeUInt16LE(method, 8);
    l.writeUInt16LE(DOS_TIME, 10);
    l.writeUInt16LE(DOS_DATE, 12);
    l.writeUInt32LE(crc, 14);
    l.writeUInt32LE(data.length, 18);
    l.writeUInt32LE(raw.length, 22);
    l.writeUInt16LE(nb.length, 26);
    l.writeUInt16LE(0, 28);
    chunks.push(l, nb, data);

    const c = Buffer.alloc(46);
    c.writeUInt32LE(0x02014b50, 0);
    c.writeUInt16LE(20, 4);          // version made by
    c.writeUInt16LE(20, 6);          // version needed
    c.writeUInt16LE(0x0800, 8);
    c.writeUInt16LE(method, 10);
    c.writeUInt16LE(DOS_TIME, 12);
    c.writeUInt16LE(DOS_DATE, 14);
    c.writeUInt32LE(crc, 16);
    c.writeUInt32LE(data.length, 20);
    c.writeUInt32LE(raw.length, 24);
    c.writeUInt16LE(nb.length, 28);
    c.writeUInt32LE(off, 42);
    central.push(Buffer.concat([c, nb]));
    off += 30 + nb.length + data.length;
  }
  const cb = Buffer.concat(central);
  const eo = Buffer.alloc(22);
  eo.writeUInt32LE(0x06054b50, 0);
  eo.writeUInt16LE(names.length, 8);
  eo.writeUInt16LE(names.length, 10);
  eo.writeUInt32LE(cb.length, 12);
  eo.writeUInt32LE(off, 16);
  fs.writeFileSync(zipPath, Buffer.concat([...chunks, cb, eo]));
}

/* ------------------------------------------------------------------ *
 * 七、读回 zip
 * ------------------------------------------------------------------ */

/** 读 zip → { names, data(name) }。目录条目也会出现在 names 里（以 / 结尾）。 */
export function readZip(file) {
  const buf = fs.readFileSync(file);
  let eocd = -1;
  for (let i = buf.length - 22; i >= 0 && i > buf.length - 66000; i--) {
    if (buf.readUInt32LE(i) === 0x06054b50) { eocd = i; break; }
  }
  if (eocd < 0) throw new Error('不是 zip（找不到 EOCD）：' + path.basename(file));
  const count = buf.readUInt16LE(eocd + 10);
  let off = buf.readUInt32LE(eocd + 16);
  const names = [];
  const entries = new Map();
  for (let i = 0; i < count; i++) {
    const method = buf.readUInt16LE(off + 10);
    const csize = buf.readUInt32LE(off + 20);
    const nlen = buf.readUInt16LE(off + 28);
    const elen = buf.readUInt16LE(off + 30);
    const clen = buf.readUInt16LE(off + 32);
    const lho = buf.readUInt32LE(off + 42);
    const name = buf.toString('utf8', off + 46, off + 46 + nlen);
    entries.set(name, { method, csize, lho });
    names.push(name);
    off += 46 + nlen + elen + clen;
  }
  const data = (name) => {
    const e = entries.get(name);
    if (!e) return null;
    const nlen = buf.readUInt16LE(e.lho + 26);
    const elen = buf.readUInt16LE(e.lho + 28);
    const start = e.lho + 30 + nlen + elen;
    const raw = buf.subarray(start, start + e.csize);
    return e.method === 0 ? Buffer.from(raw) : zlib.inflateRawSync(raw);
  };
  return { names, data };
}

/* ------------------------------------------------------------------ *
 * 八、主流程
 * ------------------------------------------------------------------ */

const sha256 = (buf) => crypto.createHash('sha256').update(buf).digest('hex');

/**
 * 产出全部区间包。write=false 时只算不写，返回的 bytes/sha256 为空。
 * 返回 clusters（manifest 的 clusters 数组形状）。
 */
export function buildAll({ write = true } = {}) {
  fs.mkdirSync(DIST, { recursive: true });
  const clusters = [];
  for (const g of GROUPS) {
    const files = variantFiles(g);
    const name = zipName(g);
    const p = path.join(DIST, name);
    if (write) writeZip(p, files);
    const buf = write ? fs.readFileSync(p) : null;
    const meta = JSON.parse(files.get('pack.mcmeta').toString('utf8')).pack;
    clusters.push({
      zip: name,
      from: g.versions[0],
      to: g.versions[g.versions.length - 1],
      versions: g.versions,
      style: g.style,
      patches: g.patches,
      meta,
      entries: files.size,
      bytes: buf ? buf.length : 0,
      sha256: buf ? sha256(buf) : '',
    });
  }
  return clusters;
}

/** 写 zip + manifest.json + SHA256SUMS.txt（--write 与直接运行都走这里）。 */
export function writeDist() {
  const clusters = buildAll({ write: true });
  fs.writeFileSync(path.join(DIST, 'manifest.json'),
    JSON.stringify({ at: new Date().toISOString(), clusters }, null, 2) + '\n');
  fs.writeFileSync(path.join(DIST, 'SHA256SUMS.txt'),
    clusters.map((c) => c.sha256 + '  ' + c.zip).join('\n') + '\n');
  return clusters;
}

function main() {
  const dry = process.argv.includes('--dry');
  if (dry) {
    for (const c of buildAll({ write: false })) {
      console.log(c.zip.padEnd(36) + String(c.entries).padStart(3) + ' 条目  ' + c.versions.join(', '));
    }
    console.log('\n--dry：只算内容，没有写盘。');
    return;
  }
  const clusters = writeDist();
  for (const c of clusters) {
    console.log(c.zip.padEnd(36) + String(c.entries).padStart(3) + ' 条目  ' + c.versions.join(', '));
  }
  console.log('\nclusters=' + clusters.length + '  versions=' +
    clusters.reduce((s, c) => s + c.versions.length, 0));
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main();

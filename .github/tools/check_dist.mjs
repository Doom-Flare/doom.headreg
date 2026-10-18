// .github/tools/check_dist.mjs —— 发行物可复现性检查。
//
//   node .github/tools/check_dist.mjs           # 检查
//   node .github/tools/check_dist.mjs --write   # 重新打 zip 并更新 manifest.json / SHA256SUMS.txt
//
// 查四件事：
//   ① zip 与「应得内容」逐字节一致 —— 解 zip，与 build_variants.mjs 现算的内容比对。
//      为什么：玩家从 Releases 下的 zip，和仓库里的源码必须是一个东西。
//      应得内容 = 仓库 data/ + 该类补丁 + 该类 mcmeta + 仓库根文档，全部由
//      build_variants.mjs 的 variantFiles() 算出来 —— 变换只有那一份实现。
//   ② sha256 与 SHA256SUMS.txt 一致 —— 每个 zip 重算一遍，与清单里那串比对。
//   ③ 清单覆盖完整 —— dist/ 里每个 zip 都要在 SHA256SUMS.txt 里有一行。
//      为什么：README 写了「dist/ 里每个 zip 的 sha256 都写在 SHA256SUMS.txt」。
//      漏一行，玩家校验时会跳过它、拿到坏文件也不知道。
//   ④ manifest.json 与实际文件一致 —— 每个 zip 的存在、条目数、字节数、sha256 都要对得上。
//      为什么：发版页和 README 的版本表是照 manifest 的，它错等于对外说错话。
//
// zip 的形态（与原产物一致）：仅文件条目、无目录条目、顶层前缀 doom.headreg/。
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {
  ROOT, DIST, GROUPS, variantFiles, zipName, writeZip, readZip,
} from './build_variants.mjs';

const WRITE = process.argv.includes('--write');
const TOP = 'doom.headreg/';

// 每个区间包 ↔ 它应得的内容（按版本表逐个算，不写死文件名）
const PAIRS = GROUPS.map((g) => ({ zip: zipName(g), group: g }));

let errors = 0;
const err = (msg) => { errors++; console.log('  ❌ ' + msg); };

if (WRITE) {
  // 重新打包：内容以仓库当前状态为准，再重算 manifest 与清单。
  fs.mkdirSync(DIST, { recursive: true });
  const clusters = [];
  for (const { zip, group } of PAIRS) {
    const files = variantFiles(group);
    writeZip(path.join(DIST, zip), files);
    const buf = fs.readFileSync(path.join(DIST, zip));
    clusters.push({
      zip,
      from: group.versions[0],
      to: group.versions[group.versions.length - 1],
      versions: group.versions,
      style: group.style,
      patches: group.patches,
      meta: JSON.parse(files.get('pack.mcmeta').toString('utf8')).pack,
      entries: files.size,
      bytes: buf.length,
      sha256: crypto.createHash('sha256').update(buf).digest('hex'),
    });
    console.log('  ✍ 重打 ' + zip + '（' + files.size + ' 条目）');
  }
  fs.writeFileSync(path.join(DIST, 'manifest.json'),
    JSON.stringify({ at: new Date().toISOString(), clusters }, null, 2) + '\n');
  fs.writeFileSync(path.join(DIST, 'SHA256SUMS.txt'),
    clusters.map((c) => c.sha256 + '  ' + c.zip).join('\n') + '\n');
  console.log('  ✍ 重算 manifest.json 与 SHA256SUMS.txt');
}

console.log('=== ① zip 与应得内容逐字节一致 ===');
for (const { zip, group } of PAIRS) {
  const zipPath = path.join(DIST, zip);
  if (!fs.existsSync(zipPath)) { err('缺 ' + zip); continue; }

  const z = readZip(zipPath);
  // zip 形态：只允许文件条目，且每个条目都带顶层前缀
  const dirEntries = z.names.filter((n) => n.endsWith('/'));
  if (dirEntries.length) err(zip + ' 里有 ' + dirEntries.length + ' 个目录条目（应只有文件条目）');
  const inZip = new Map();
  for (const n of z.names) {
    if (n.endsWith('/')) continue;
    if (!n.startsWith(TOP)) { err(zip + ' 有不带顶层前缀 ' + TOP + ' 的条目 ' + n); continue; }
    inZip.set(n.slice(TOP.length), z.data(n));
  }

  const want = variantFiles(group);
  const missing = [...want.keys()].filter((f) => !inZip.has(f));
  const extra = [...inZip.keys()].filter((f) => !want.has(f));
  let diff = 0;
  for (const f of [...want.keys()].filter((x) => inZip.has(x))) {
    if (!inZip.get(f).equals(want.get(f))) { diff++; err(zip + ' 内容不同: ' + f); }
  }
  if (missing.length) err(zip + ' 缺 ' + missing.length + ' 个文件: ' + missing.slice(0, 3).join(', '));
  if (extra.length) err(zip + ' 多 ' + extra.length + ' 个文件: ' + extra.slice(0, 3).join(', '));
  if (!missing.length && !extra.length && !diff && !dirEntries.length) {
    console.log('  ✅ ' + zip + '（' + want.size + ' 文件逐字节一致，覆盖 ' +
      group.versions.length + ' 个版本）');
  }
}

console.log('\n=== ② sha256 与 SHA256SUMS.txt 一致 ===');
const sumsPath = path.join(DIST, 'SHA256SUMS.txt');
let listed = new Map();
if (!fs.existsSync(sumsPath)) {
  err('缺 SHA256SUMS.txt');
} else {
  for (const l of fs.readFileSync(sumsPath, 'utf8').trim().split('\n')) {
    const [h, f] = l.trim().split(/\s+/);
    if (h && f) listed.set(f, h);
  }
  for (const [f, h] of listed) {
    const p = path.join(DIST, f);
    if (!fs.existsSync(p)) { err('清单列了但文件不在: ' + f); continue; }
    const real = crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex');
    if (real !== h) err(f + ' 的 sha256 对不上（清单 ' + h.slice(0, 12) + '… 实际 ' + real.slice(0, 12) + '…）');
    else console.log('  ✅ ' + f);
  }

  console.log('\n=== ③ 清单覆盖完整 ===');
  const zips = fs.readdirSync(DIST).filter((f) => f.endsWith('.zip'));
  const notListed = zips.filter((f) => !listed.has(f));
  const notFile = [...listed.keys()].filter((f) => !zips.includes(f));
  if (notListed.length) err('这几个 zip 没列进 SHA256SUMS.txt: ' + notListed.join(', '));
  if (notFile.length) err('清单里这几行没有对应文件: ' + notFile.join(', '));
  // 反向也要管：dist/ 里不该躺着版本表之外的 zip（比如被取代的旧单版包）
  const known = new Set(PAIRS.map((p) => p.zip));
  const stale = zips.filter((f) => !known.has(f));
  if (stale.length) err('dist/ 里有版本表之外的 zip（旧产物？）: ' + stale.join(', '));
  if (!notListed.length && !notFile.length && !stale.length) {
    console.log('  ✅ ' + zips.length + ' 个 zip 全部在清单里，且没有多余 zip');
  }
}

console.log('\n=== ④ manifest.json 与实际文件一致 ===');
const manPath = path.join(DIST, 'manifest.json');
if (!fs.existsSync(manPath)) {
  err('缺 manifest.json');
} else {
  let man = null;
  try { man = JSON.parse(fs.readFileSync(manPath, 'utf8')); } catch (e) { err('manifest.json 解析失败：' + e.message); }
  const clusters = man && Array.isArray(man.clusters) ? man.clusters : null;
  if (!clusters) {
    err('manifest.json 没有 clusters 数组');
  } else {
    // 与版本表逐项对齐：顺序、zip 名、覆盖版本都要一模一样
    if (clusters.length !== GROUPS.length) {
      err('manifest 有 ' + clusters.length + ' 类，版本表有 ' + GROUPS.length + ' 类');
    }
    for (let i = 0; i < GROUPS.length; i++) {
      const g = GROUPS[i];
      const name = zipName(g);
      const c = clusters[i];
      if (!c) { err('manifest 缺第 ' + (i + 1) + ' 类（' + name + '）'); continue; }
      if (c.zip !== name) { err('manifest 第 ' + (i + 1) + ' 类 zip 名是 ' + c.zip + '，应为 ' + name); continue; }
      const vs = g.versions.join(',');
      if ((c.versions || []).join(',') !== vs) err(name + ' 覆盖版本对不上：manifest=' + (c.versions || []).join(','));
      if (c.from !== g.versions[0] || c.to !== g.versions[g.versions.length - 1]) {
        err(name + ' 的 from/to 对不上（manifest ' + c.from + '..' + c.to + '）');
      }

      const p = path.join(DIST, name);
      if (!fs.existsSync(p)) { err('manifest 列了但文件不在: ' + name); continue; }
      const buf = fs.readFileSync(p);
      const real = crypto.createHash('sha256').update(buf).digest('hex');
      if (c.sha256 !== real) err(name + ' manifest 的 sha256 与文件不符（' + String(c.sha256).slice(0, 12) + '… ≠ ' + real.slice(0, 12) + '…）');
      if (c.bytes !== buf.length) err(name + ' manifest 的字节数是 ' + c.bytes + '，实际 ' + buf.length);

      // 条目数与 mcmeta 也从 zip 里现读一遍，防止 manifest 是手改的
      const z = readZip(p);
      const files = z.names.filter((n) => !n.endsWith('/'));
      if (c.entries !== files.length) err(name + ' manifest 的条目数是 ' + c.entries + '，实际 ' + files.length);
      const metaBuf = z.data(TOP + 'pack.mcmeta');
      if (!metaBuf) {
        err(name + ' 里没有 pack.mcmeta');
      } else {
        const meta = JSON.parse(metaBuf.toString('utf8')).pack;
        if (JSON.stringify(meta) !== JSON.stringify(c.meta)) err(name + ' manifest 的 meta 与包内 pack.mcmeta 不符');
        if ((meta.description || '') !== JSON.parse(fs.readFileSync(path.join(ROOT, 'pack.mcmeta'), 'utf8')).pack.description) {
          err(name + ' 的 description 与仓库根 pack.mcmeta 不符');
        }
        const hasPackFormat = Object.prototype.hasOwnProperty.call(meta, 'pack_format');
        if (meta.min_format[0] >= 82 && hasPackFormat) {
          err(name + ' 的 min_format≥82 却还留着 pack_format（新 schema 不认）');
        }
      }
    }
    if (!errors) console.log('  ✅ ' + clusters.length + ' 类全部与 manifest 一致');
    else console.log('  （manifest 共 ' + clusters.length + ' 类，上面是差异）');
  }
}

console.log('\n' + (errors ? '❌ ' + errors + ' 个问题' : '✅ 全部通过'));
if (!WRITE && errors) console.log('（改完重跑本脚本；要重打 zip 并重算清单就加 --write）');
process.exit(errors ? 1 : 0);

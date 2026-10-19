#!/usr/bin/env node
// build/gen.mjs —— legacy 基础层的机械文件生成器（纯 Node，无依赖）
//
// 产出（全部落在 data/headreg/functions/internal/）：
//   open_bucket.mcfunction + open_b.0..15.mcfunction      两级字面分派读
//   commit_bucket.mcfunction + commit_b.0..15.mcfunction  两级字面分派写
//   del_bucket.mcfunction + del_b.0..15.mcfunction        两级字面分派删
//   decode_b64.mcfunction                                 base64 -> ts_sec（64 路逐字面查表）
//   month_scan.mcfunction                                 年内第几天 -> 月/日（24 个月首常量）
//
// 口径：16 桶 × 64 偏移 = 槽位 0..1023；open_b.<b> 的第 M 行对应 id = b*64+M。
// 槽位号就是 id 本身，故 id=1024 会算成 #b=16（不存在的桶）而静默失效 —— assign_id 因此把上限压到 1023。
// 幂等：同样的输入连跑两次，产物逐字节相同（无时间戳、无随机、Map 保序）。
//
// 用法：node build/gen.mjs        （在 legacy/ 下执行）

import { writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
const OUT = resolve(HERE, '..', 'data', 'headreg', 'functions', 'internal');
const BUCKETS = 16;
const PER = 64;
const files = new Map();

// ---------------------------------------------------------------- 两级分派

const HEAD = {
  open: [
    '# headreg:internal/open_bucket —— 两级字面分派：读（由 build/gen.mjs 生成，勿手改）',
    '# 入口：#cur headreg.rec = 1..1023（槽位号 = id；1024 会落到不存在的 16 号桶）',
    '# 出口：headreg:tmp cur = root.<cur>.data 的副本；该 id 无记录时 headreg:tmp cur 保持缺席',
    '# 分桶：#b = #cur / 64（0..15），#o = #cur % 64（0..63）；open_b.<b> 第 M 行对应 id = b*64+M',
  ],
  commit: [
    '# headreg:internal/commit_bucket —— 两级字面分派：写（由 build/gen.mjs 生成，勿手改）',
    '# 入口：#cur headreg.rec = 1..1023，headreg:tmp cur = 待写回的记录',
    '# 出口：root.<cur>.data = headreg:tmp cur；tmp cur 为空时不写（避免把桶写成空对象）',
    '# 分桶：#b = #cur / 64（0..15），#o = #cur % 64（0..63）；commit_b.<b> 第 M 行对应 id = b*64+M',
  ],
  del: [
    '# headreg:internal/del_bucket —— 两级字面分派：删（由 build/gen.mjs 生成，勿手改）',
    '# 入口：#cur headreg.rec = 1..1023（槽位号 = id；1024 会落到不存在的 16 号桶）',
    '# 出口：root.<cur>.data 被移除（该 id 无记录时不报错、不产生空桶）',
    '# 分桶：#b = #cur / 64（0..15），#o = #cur % 64（0..63）；del_b.<b> 第 M 行对应 id = b*64+M',
  ],
};
const PRELUDE = [
  'scoreboard players operation #b headreg.calc = #cur headreg.rec',
  'scoreboard players operation #b headreg.calc /= #k64 headreg.calc',
  'scoreboard players operation #o headreg.calc = #cur headreg.rec',
  'scoreboard players operation #o headreg.calc %= #k64 headreg.calc',
];

for (const kind of ['open', 'commit', 'del']) {
  const rows = HEAD[kind].concat(PRELUDE);
  for (let b = 0; b < BUCKETS; b++) {
    rows.push('execute if score #b headreg.calc matches ' + b + ' run function headreg:internal/' + kind + '_b.' + b);
  }
  files.set(kind + '_bucket.mcfunction', rows);
}

for (const kind of ['open', 'commit', 'del']) {
  for (let b = 0; b < BUCKETS; b++) {
    const rows = [];
    for (let m = 0; m < PER; m++) {
      const id = b * PER + m;
      const sel = 'execute if score #o headreg.calc matches ' + m;
      if (kind === 'open') {
        rows.push(sel + ' run data modify storage headreg:tmp cur set from storage headreg:data root.' + id + '.data');
      } else if (kind === 'commit') {
        rows.push(sel + ' if data storage headreg:tmp cur run data modify storage headreg:data root.' + id + '.data set from storage headreg:tmp cur');
      } else {
        rows.push(sel + ' run data remove storage headreg:data root.' + id + '.data');
      }
    }
    files.set(kind + '_b.' + b + '.mcfunction', rows);
  }
}

// ---------------------------------------------------------------- base64 -> ts_sec

// 真实 Mojang 纹理载荷是 pretty-print JSON，前缀恰 18 字节：'{\n  "timestamp" : '
// 字节 18 对齐 base64 字符 24（24*6/8 = 18），故 timestamp 的十进制数字从字符 24 起。
// 秒级时间戳 = 前 10 位数字（13 位毫秒的前 10 位），需字符 [24,38) 共 14 个。
const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
const WIN = 24;
const CHARS = 14;

const dec = [
  '# headreg:internal/decode_b64 —— base64 载荷解出 ts_sec（由 build/gen.mjs 生成，勿手改）',
  '# 入口：storage headreg:tmp b64 = textures 的完整 base64 载荷',
  '# 出口：#ts_sec headreg.calc = epoch 秒；载荷形状不对（太短 / 首位不是 1..2 / 越界）时为 0',
  '# 原理：无宏，64 路逐字面分派查表把字符折成 6bit，再拼字节、按十进制累加，全程不产生字符串。',
  '#       只取前 10 位数字（毫秒后 3 位丢弃）。',
  'scoreboard players set #ts_sec headreg.calc 0',
  'scoreboard players set #abort headreg.calc 0',
  '# set string 越界会报错且不钳位，故先量长度：需要字符 [24,38)，长度至少 38',
  'scoreboard players set #blen headreg.calc 0',
  'execute store result score #blen headreg.calc run data get storage headreg:tmp b64',
  'execute unless score #blen headreg.calc matches 38.. run scoreboard players set #abort headreg.calc 1',
];

for (let i = 0; i < CHARS; i++) {
  const s = WIN + i;
  const e = s + 1;
  // 单字符落进 cmp.k，再用键锚定的复合匹配比对（与主线 classify 的 root.working_data{premium:1b} 同一形状）
  dec.push('execute if score #abort headreg.calc matches 0 run data modify storage headreg:tmp cmp.k set string storage headreg:tmp b64 ' + s + ' ' + e);
  dec.push('execute if score #abort headreg.calc matches 0 run scoreboard players set #c' + i + ' headreg.calc 0');
  for (let k = 1; k < 64; k++) {
    dec.push('execute if score #abort headreg.calc matches 0 if data storage headreg:tmp cmp{k:"' + ALPHABET[k] +
      '"} run scoreboard players set #c' + i + ' headreg.calc ' + k);
  }
}

// 每 4 个字符折成 3 个字节：hi = c*4 + c1/16；mid = (c%16)*16 + c/4；lo = (c%4)*64 + c
const SPEC = [
  ['hi', 0, 1],
  ['mid', 1, 2],
  ['lo', 2, 3],
  ['hi', 4, 5],
  ['mid', 5, 6],
  ['lo', 6, 7],
  ['hi', 8, 9],
  ['mid', 9, 10],
  ['lo', 10, 11],
  ['hi', 12, 13],
];
SPEC.forEach((spec, d) => {
  const kind = spec[0];
  const a = spec[1];
  const b = spec[2];
  dec.push('# 字节 ' + (18 + d) + '（第 ' + (d + 1) + ' 位数字）<- base64 字符 ' + (WIN + a) + ' / ' + (WIN + b));
  if (kind === 'hi') {
    dec.push('scoreboard players operation #t1 headreg.calc = #c' + a + ' headreg.calc');
    dec.push('scoreboard players operation #t1 headreg.calc *= #k4 headreg.calc');
    dec.push('scoreboard players operation #t2 headreg.calc = #c' + b + ' headreg.calc');
    dec.push('scoreboard players operation #t2 headreg.calc /= #k16 headreg.calc');
  } else if (kind === 'mid') {
    dec.push('scoreboard players operation #t1 headreg.calc = #c' + a + ' headreg.calc');
    dec.push('scoreboard players operation #t1 headreg.calc %= #k16 headreg.calc');
    dec.push('scoreboard players operation #t1 headreg.calc *= #k16 headreg.calc');
    dec.push('scoreboard players operation #t2 headreg.calc = #c' + b + ' headreg.calc');
    dec.push('scoreboard players operation #t2 headreg.calc /= #k4 headreg.calc');
  } else {
    dec.push('scoreboard players operation #t1 headreg.calc = #c' + a + ' headreg.calc');
    dec.push('scoreboard players operation #t1 headreg.calc %= #k4 headreg.calc');
    dec.push('scoreboard players operation #t1 headreg.calc *= #k64 headreg.calc');
    dec.push('scoreboard players operation #t2 headreg.calc = #c' + b + ' headreg.calc');
  }
  dec.push('scoreboard players operation #byte headreg.calc = #t1 headreg.calc');
  dec.push('scoreboard players operation #byte headreg.calc += #t2 headreg.calc');
  dec.push('scoreboard players operation #d' + d + ' headreg.calc = #byte headreg.calc');
  dec.push('scoreboard players operation #d' + d + ' headreg.calc -= #k48 headreg.calc');
  dec.push('execute unless score #d' + d + ' headreg.calc matches 0..9 run scoreboard players set #d' + d + ' headreg.calc 0');
});

dec.push('# 十进制累加（Horner）：首位必须是 1 或 2，否则一律判为坏载荷');
dec.push('execute unless score #d0 headreg.calc matches 1..2 run scoreboard players set #abort headreg.calc 1');
dec.push('scoreboard players set #tsn headreg.calc 0');
dec.push('execute if score #abort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d0 headreg.calc');
for (let i = 1; i < 10; i++) {
  dec.push('execute if score #abort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc *= #k1e1 headreg.calc');
  dec.push('execute if score #abort headreg.calc matches 0 run scoreboard players operation #tsn headreg.calc += #d' + i + ' headreg.calc');
}
dec.push('execute if score #abort headreg.calc matches 0 if score #tsn headreg.calc matches 1000000000.. run scoreboard players operation #ts_sec headreg.calc = #tsn headreg.calc');
dec.push('data remove storage headreg:tmp cmp');
files.set('decode_b64.mcfunction', dec);

// ---------------------------------------------------------------- month_scan

// 月首（年内第几天，0 基）。闰年只影响 3 月及以后。
const START_COMMON = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
const START_LEAP = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];

const mon = [
  '# headreg:internal/month_scan —— 年内第几天 -> 月 / 日（由 build/gen.mjs 生成，勿手改）',
  '# 入口：#doy = 年内第几天（0 基），#leap = 1/0，#mon 必须已置 0',
  '# 出口：#mon = 1..12，#doy 被改写成当月第几天（1 基）',
  '',
  '# --- 倒扫命中月份（12 -> 1，第一个满足的就是答案） ---',
];
for (let m = 12; m >= 1; m--) {
  const c = START_COMMON[m - 1];
  const l = START_LEAP[m - 1];
  mon.push('execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 0 if score #doy headreg.calc matches ' + c + '.. run scoreboard players set #mon headreg.calc ' + m);
  mon.push('execute if score #mon headreg.calc matches 0 if score #leap headreg.calc matches 1 if score #doy headreg.calc matches ' + l + '.. run scoreboard players set #mon headreg.calc ' + m);
}
mon.push('');
mon.push('# --- 折算成「日」：day = doy - (月首 - 1) ---');
for (let m = 12; m >= 1; m--) {
  if (m === 1) {
    mon.push('execute if score #mon headreg.calc matches 1 if score #leap headreg.calc matches 0 run scoreboard players add #doy headreg.calc 1');
    mon.push('execute if score #mon headreg.calc matches 1 if score #leap headreg.calc matches 1 run scoreboard players add #doy headreg.calc 1');
  } else {
    mon.push('execute if score #mon headreg.calc matches ' + m + ' if score #leap headreg.calc matches 0 run scoreboard players remove #doy headreg.calc ' + (START_COMMON[m - 1] - 1));
    mon.push('execute if score #mon headreg.calc matches ' + m + ' if score #leap headreg.calc matches 1 run scoreboard players remove #doy headreg.calc ' + (START_LEAP[m - 1] - 1));
  }
}
files.set('month_scan.mcfunction', mon);

// ---------------------------------------------------------------- 落盘

mkdirSync(OUT, { recursive: true });
let totalBytes = 0;
let totalLines = 0;
for (const entry of files) {
  const name = entry[0];
  const body = entry[1].join('\n') + '\n';
  writeFileSync(join(OUT, name), body, { encoding: 'utf8' });
  totalBytes += Buffer.byteLength(body, 'utf8');
  totalLines += entry[1].length;
  console.log('  ' + name.padEnd(26, ' ') + entry[1].length + ' 行');
}
console.log('');
console.log('生成了 ' + files.size + ' 个文件，共 ' + totalLines + ' 行，' + totalBytes + ' 字节');
console.log('输出目录 ' + OUT);

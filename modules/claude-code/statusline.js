#!/usr/bin/env node
// Claude Code status line in the style of statusline.sh's "Two-Line Cockpit",
// folded into one line: mode, model, effort, directory, branch, then context,
// session time and plan usage. Colors are Gruvbox Dark, to match the
// terminal. Reads the status JSON on stdin. Needs a Nerd Font for the branch
// glyph.
'use strict';

const { execFileSync } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');

const BRANCH = '';
const GIT_TTL_MS = 5000;
const CACHE_DIR = process.env.XDG_RUNTIME_DIR || os.tmpdir();
const RESET = '\x1b[0m';

// Gruvbox Dark, as in Ghostty's "Gruvbox Dark" theme.
const G = {
  bg0: '#282828',
  bg2: '#504945',
  bg3: '#665c54',
  bg4: '#7c6f64',
  fg0: '#fbf1c7',
  fg1: '#ebdbb2',
  fg4: '#a89984',
  green: '#98971a',
  yellow: '#d79921',
  brightRed: '#fb4934',
  brightBlue: '#83a598',
  brightPurple: '#d3869b',
  brightAqua: '#8ec07c',
  brightOrange: '#fe8019',
  fadedRed: '#9d0006',
  fadedYellow: '#b57614',
  fadedBlue: '#076678',
  fadedAqua: '#427b58',
};

// Pills are [bg, fg]: bright colors take dark text, faded ones light text.
const C = {
  host: [G.bg3, G.fg1],
  model: [G.brightOrange, G.bg0],
  dir: [G.bg2, G.fg1],
  gitClean: [G.green, G.bg0],
  gitDirty: [G.yellow, G.bg0],
  limit5h: [G.fadedAqua, G.fg0],
  limit7d: [G.fadedBlue, G.fg0],
  limitWarn: [G.fadedYellow, G.fg0],
  limitHot: [G.fadedRed, G.fg0],
  effort: G.fg4,
  sep: G.bg4,
  ctx: G.brightAqua,
  warn: G.brightOrange,
  hot: G.brightRed,
  time: G.brightPurple,
};

const MODES = {
  auto: ['auto', [G.brightBlue, G.bg0]],
  plan: ['plan', [G.brightAqua, G.bg0]],
  acceptEdits: ['accept edits', [G.brightPurple, G.bg0]],
  bypassPermissions: ['bypass', [G.brightRed, G.bg0]],
  dontAsk: ["don't ask", [G.brightRed, G.bg0]],
};

const rgb = (hex) => [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16)).join(';');
const fg = (hex) => `38;2;${rgb(hex)}`;
const bg = (hex) => `48;2;${rgb(hex)}`;
const paint = (text, ...codes) => `\x1b[${codes.join(';')}m${text}${RESET}`;
const pill = (text, [b, f], ...style) => paint(` ${text} `, ...style, fg(f), bg(b));
const DOT = paint(' · ', fg(C.sep));

// An item is drawn as `sep` then forms[0]; fitting moves it to its next,
// narrower form, or drops it once it has none left.
const item = (key, sep, ...forms) => ({ key, sep, forms });

function visibleWidth(s) {
  const plain = s.replace(/\x1b\[[0-9;]*m/g, '');
  return [...plain].reduce((n, ch) => n + (ch === '⚡' ? 2 : 1), 0);
}

// Narrow the line until it fits, one step per key in `steps`; keys that
// aren't listed are never dropped.
function fit(items, steps, cols) {
  const draw = () => items.map((it, i) => (i ? it.sep : '') + it.forms[0]).join('');
  if (cols > 0) {
    for (const key of steps) {
      if (visibleWidth(draw()) <= cols) break;
      const i = items.findIndex((it) => it.key === key);
      if (i < 0) continue;
      if (items[i].forms.length > 1) items[i].forms.shift();
      else items.splice(i, 1);
    }
  }
  return draw();
}

function truncLeft(s, max) {
  return s.length > max ? '…' + s.slice(s.length - max + 1) : s;
}

function truncRight(s, max) {
  return s.length > max ? s.slice(0, max - 1) + '…' : s;
}

function fmtTokens(n) {
  if (n < 1000) return String(Math.round(n));
  return n < 1e6 ? `${+(n / 1000).toFixed(1)}k` : `${+(n / 1e6).toFixed(1)}M`;
}

function fmtDuration(ms) {
  const total = Math.floor(ms / 1000);
  if (total < 60) return `${total}s`;
  const m = Math.floor(total / 60);
  const s = total % 60;
  if (m < 60) return s ? `${m}m ${s}s` : `${m}m`;
  return m % 60 ? `${Math.floor(m / 60)}h ${m % 60}m` : `${Math.floor(m / 60)}h`;
}

const fmtPct = (p) => (Number.isInteger(p) ? `${p}` : p.toFixed(1));

function tildify(dir) {
  const home = os.homedir();
  return dir === home || dir.startsWith(home + '/') ? '~' + dir.slice(home.length) : dir;
}

// The status payload has no permission mode, but the transcript logs it, so
// take the last one from its tail.
function permissionMode(transcript) {
  if (!transcript) return null;
  try {
    const fd = fs.openSync(transcript, 'r');
    const size = fs.fstatSync(fd).size;
    const len = Math.min(size, 65536);
    const buf = Buffer.alloc(len);
    fs.readSync(fd, buf, 0, len, size - len);
    fs.closeSync(fd);
    const tail = buf.toString('utf8');
    const i = tail.lastIndexOf('"permissionMode":"');
    return i < 0 ? null : tail.slice(i + 18, tail.indexOf('"', i + 18));
  } catch {
    return null;
  }
}

function parseGitStatus(out) {
  const info = { branch: '', ahead: 0, behind: 0, changes: 0 };
  let oid = '';
  for (const line of out.split('\n')) {
    if (line.startsWith('# branch.head ')) info.branch = line.slice(14);
    else if (line.startsWith('# branch.oid ')) oid = line.slice(13);
    else if (line.startsWith('# branch.ab ')) {
      const m = line.match(/\+(\d+) -(\d+)/);
      if (m) [info.ahead, info.behind] = [+m[1], +m[2]];
    } else if (line && !line.startsWith('#')) info.changes++;
  }
  if (info.branch === '(detached)') info.branch = oid.slice(0, 7);
  return info;
}

function git(args, cwd, timeout) {
  return execFileSync('git', ['--no-optional-locks', ...args], {
    cwd,
    encoding: 'utf8',
    timeout,
    stdio: ['ignore', 'pipe', 'ignore'],
  });
}

// `git status` is slow in big trees (Yocto, kernels), so results are cached
// per directory for a few seconds, including "not a repo" and timeouts.
function gitInfo(cwd) {
  const key = crypto.createHash('sha1').update(cwd).digest('hex').slice(0, 12);
  const file = path.join(CACHE_DIR, `claude-statusline-git-${key}.json`);
  try {
    if (Date.now() - fs.statSync(file).mtimeMs < GIT_TTL_MS) {
      return JSON.parse(fs.readFileSync(file, 'utf8'));
    }
  } catch {}
  let info = null;
  try {
    info = parseGitStatus(git(['status', '--porcelain=v2', '--branch'], cwd, 400));
  } catch (e) {
    if (e.code === 'ETIMEDOUT') {
      try {
        const branch = git(['rev-parse', '--abbrev-ref', 'HEAD'], cwd, 200).trim();
        info = { branch, ahead: 0, behind: 0, changes: null };
      } catch {}
    }
  }
  try {
    fs.writeFileSync(file, JSON.stringify(info));
  } catch {}
  return info;
}

function statusLine(data, cols) {
  const items = [];
  if (process.env.SSH_CONNECTION || process.env.WSL_DISTRO_NAME) {
    items.push(item('host', ' ', pill(os.hostname(), C.host)));
  }
  const mode = MODES[permissionMode(data.transcript_path)];
  if (mode) items.push(item('mode', ' ', pill(mode[0], mode[1], '1')));

  const name = (data.model && data.model.display_name) || 'Claude';
  items.push(item('model', ' ', pill(name, C.model, '1')));
  let effort = data.thinking && data.thinking.enabled && data.effort ? data.effort.level || '' : '';
  if (data.fast_mode) effort += effort ? ' ⚡' : '⚡';
  if (effort) items.push(item('effort', ' ', paint(effort, fg(C.effort))));

  const cwd = (data.workspace && data.workspace.current_dir) || data.cwd || process.cwd();
  items.push(item('dir', ' ', pill(truncLeft(tildify(cwd), 40), C.dir), pill(path.basename(cwd) || cwd, C.dir)));

  const g = gitInfo(cwd);
  if (g && g.branch) {
    const colors = g.changes === 0 ? C.gitClean : C.gitDirty;
    let text = `${BRANCH} ${truncRight(g.branch, 28)}`;
    if (g.changes === null) text += ' ?';
    else if (g.changes) text += ` ●${g.changes}`;
    if (g.ahead) text += ` ↑${g.ahead}`;
    if (g.behind) text += ` ↓${g.behind}`;
    items.push(item('git', ' ', pill(text, colors, '3'), pill(`${BRANCH} ${truncRight(g.branch, 16)}`, colors, '3')));
  }

  const cw = data.context_window || {};
  if (typeof cw.used_percentage === 'number') {
    const p = Math.max(0, Math.min(100, cw.used_percentage));
    const color = p >= 80 ? C.hot : p >= 50 ? C.warn : C.ctx;
    const pct = paint('ctx ', fg(color)) + paint(`${fmtPct(p)}%`, '1', fg(color));
    const tokens = cw.context_window_size
      ? ` ${fmtTokens(cw.total_input_tokens || (p / 100) * cw.context_window_size)}/${fmtTokens(cw.context_window_size)}`
      : '';
    items.push(item('ctx', ' ', pct + tokens, pct));
  } else {
    items.push(item('ctx', ' ', paint('ctx --', fg(C.ctx))));
  }

  const cost = data.cost || {};
  if (cost.total_duration_ms) items.push(item('time', DOT, paint(fmtDuration(cost.total_duration_ms), '3', fg(C.time))));

  const rl = data.rate_limits || {};
  const limits = [];
  for (const [label, w, base] of [['5H', rl.five_hour, C.limit5h], ['7D', rl.seven_day, C.limit7d]]) {
    if (!w || typeof w.used_percentage !== 'number') continue;
    const p = w.used_percentage;
    limits.push(pill(`${label} ${fmtPct(p)}%`, p >= 80 ? C.limitHot : p >= 50 ? C.limitWarn : base, '1'));
  }
  if (limits.length) items.push(item('limits', DOT, limits.join(paint('·', fg(C.sep)))));

  return fit(items, ['time', 'ctx', 'git', 'dir', 'dir', 'effort', 'host', 'git'], cols);
}

let data = {};
try {
  data = JSON.parse(fs.readFileSync(0, 'utf8'));
} catch {}

// Leave a little room so a line never touches the last column.
const cols = (+process.env.COLUMNS || 0) - 2;
process.stdout.write(statusLine(data, cols));

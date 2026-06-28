#!/bin/bash
# ────────────────────────────────────────────────────────────
#  Focus & Play — macOS App Builder
#  Usage: bash build-focusplay.sh
#  Creates FocusPlay.app on your Desktop, then opens it.
# ────────────────────────────────────────────────────────────
set -euo pipefail

APP="$HOME/Desktop/FocusPlay.app"
CONTENTS="$APP/Contents"
MACOS="$CONTENTS/MacOS"
RES="$CONTENTS/Resources"

echo ""
echo "  Building FocusPlay.app…"
echo ""

# Remove existing if present
[ -d "$APP" ] && rm -rf "$APP"

# Directory structure
mkdir -p "$MACOS" "$RES"

# ── Info.plist ─────────────────────────────────────────────
cat > "$CONTENTS/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>FocusPlay</string>
  <key>CFBundleIdentifier</key><string>com.focusplay.app</string>
  <key>CFBundleName</key><string>Focus and Play</string>
  <key>CFBundleDisplayName</key><string>Focus and Play</string>
  <key>CFBundleVersion</key><string>1.0</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>LSUIElement</key><false/>
  <key>LSMinimumSystemVersion</key><string>12.0</string>
</dict>
</plist>
PLIST

# ── Launcher ───────────────────────────────────────────────
cat > "$MACOS/FocusPlay" << 'LAUNCHER'
#!/bin/bash
RES="$(cd "$(dirname "$0")/../Resources" && pwd)"
HTML="file://$RES/index.html"

for BROWSER in \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
  "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
  if [ -f "$BROWSER" ]; then
    "$BROWSER" \
      --app="$HTML" \
      --window-size=400,660 \
      --window-position=160,60 \
      --no-first-run \
      --no-default-browser-check \
      --disable-translate \
      --disable-extensions \
      2>/dev/null &
    exit 0
  fi
done

# Safari fallback
open -a Safari "$RES/index.html"
LAUNCHER

chmod +x "$MACOS/FocusPlay"

# ── App HTML ───────────────────────────────────────────────
cat > "$RES/index.html" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="theme-color" content="#F2F1F6">
<title>Focus &amp; Play</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{
  --bg:#F2F1F6;--surface:#FFFFFF;--surface2:#F9F9F9;
  --border:rgba(0,0,0,0.09);--border-strong:rgba(0,0,0,0.14);
  --text:#1C1C1E;--text2:#6C6C70;--text3:#AEAEB2;
  --accent:#007AFF;--accent-bg:rgba(0,122,255,0.1);
  --green:#34C759;--orange:#FF9500;
  --shadow:0 1px 2px rgba(0,0,0,0.05),0 4px 16px rgba(0,0,0,0.07);
  --radius:10px;
}
@media(prefers-color-scheme:dark){
  :root{
    --bg:#1C1C1E;--surface:#2C2C2E;--surface2:#3A3A3C;
    --border:rgba(255,255,255,0.1);--border-strong:rgba(255,255,255,0.15);
    --text:#FFFFFF;--text2:rgba(235,235,245,.8);--text3:rgba(235,235,245,.4);
    --accent:#0A84FF;--accent-bg:rgba(10,132,255,.18);
    --shadow:0 1px 2px rgba(0,0,0,.3),0 4px 16px rgba(0,0,0,.3);
  }
}
html,body{height:100%;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,'SF Pro Text',system-ui,sans-serif;background:var(--bg);color:var(--text);-webkit-font-smoothing:antialiased;user-select:none}
body{display:flex;flex-direction:column}
.content{flex:1;overflow:hidden;position:relative}
.panel{position:absolute;inset:0;overflow-y:auto;padding:16px;display:none}
.panel.active{display:block}
::-webkit-scrollbar{width:5px}::-webkit-scrollbar-track{background:transparent}::-webkit-scrollbar-thumb{background:var(--border-strong);border-radius:3px}
.tabbar{display:flex;flex-shrink:0;border-top:0.5px solid var(--border);background:rgba(242,241,246,.92);-webkit-backdrop-filter:blur(20px);backdrop-filter:blur(20px)}
@media(prefers-color-scheme:dark){.tabbar{background:rgba(28,28,30,.92)}}
.tb{flex:1;border:none;background:transparent;padding:8px 4px 10px;cursor:pointer;display:flex;flex-direction:column;align-items:center;gap:3px;font-family:-apple-system,system-ui,sans-serif}
.tb svg{color:var(--text3);transition:color .15s}.tb .lbl{font-size:10px;font-weight:500;color:var(--text3);letter-spacing:.2px;transition:color .15s}
.tb.active svg,.tb.active .lbl{color:var(--accent)}
.card{background:var(--surface);border-radius:12px;padding:14px 16px;margin-bottom:12px;box-shadow:var(--shadow)}
.sec-lbl{font-size:11px;font-weight:600;color:var(--text2);letter-spacing:.5px;text-transform:uppercase;margin-bottom:10px}
.pills{display:flex;background:rgba(118,118,128,.12);border-radius:9px;padding:2px;margin-bottom:14px}
.pill{flex:1;padding:5px 8px;border-radius:7px;border:none;cursor:pointer;font-size:13px;font-weight:500;background:transparent;color:var(--text2);font-family:-apple-system,system-ui,sans-serif;transition:all .18s}
.pill.on{background:var(--surface);color:var(--text);box-shadow:0 1px 3px rgba(0,0,0,.12)}
.btn-primary{background:var(--accent);color:#fff;border:none;border-radius:var(--radius);padding:10px 18px;font-size:14px;font-weight:600;cursor:pointer;font-family:-apple-system,system-ui,sans-serif;transition:opacity .12s}
.btn-primary:active{opacity:.8}
.btn-ghost{background:transparent;color:var(--accent);border:none;font-size:13px;font-weight:500;cursor:pointer;padding:6px 10px;border-radius:8px;font-family:-apple-system,system-ui,sans-serif}
.btn-ghost:hover{background:var(--accent-bg)}
/* FOCUS */
.focus-wrap{display:flex;flex-direction:column;align-items:center;padding:16px 0 8px;gap:16px}
.ring-wrap{position:relative;width:210px;height:210px}
.time-ctr{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center}
.time-num{font-size:50px;font-weight:200;letter-spacing:-3px;line-height:1;font-variant-numeric:tabular-nums;color:var(--text)}
.time-sublbl{font-size:11px;color:var(--text2);margin-top:5px;letter-spacing:1px;text-transform:uppercase;font-weight:500}
.t-btns{display:flex;gap:14px;align-items:center}
.btn-play{width:62px;height:62px;border-radius:31px;border:none;background:var(--accent);color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 14px rgba(0,122,255,.35);transition:transform .1s}
.btn-play:active{transform:scale(.93)}
.btn-sm{width:40px;height:40px;border-radius:20px;border:0.5px solid var(--border-strong);background:var(--surface);cursor:pointer;color:var(--text2);display:flex;align-items:center;justify-content:center;box-shadow:var(--shadow)}
.sess-row{display:flex;gap:5px;align-items:center;min-height:12px;margin-top:2px}
.sdot{width:8px;height:8px;border-radius:4px;background:var(--accent);opacity:.7}
/* TODO */
.add-row{display:flex;gap:8px;margin-bottom:14px}
.add-row input,.conv-input,.rng-in{font-family:-apple-system,system-ui,sans-serif;color:var(--text);background:var(--surface);border:0.5px solid var(--border-strong);outline:none;border-radius:var(--radius)}
.add-row input:focus,.conv-input:focus,.rng-in:focus{border-color:var(--accent)}
.add-row input{flex:1;height:40px;padding:0 12px;font-size:14px}
@media(prefers-color-scheme:dark){.add-row input,.conv-input,.rng-in{background:var(--surface2)}}
.todo-item{display:flex;align-items:center;gap:10px;padding:11px 14px;background:var(--surface);border-bottom:0.5px solid var(--border)}
.todo-item:first-child{border-radius:12px 12px 0 0}.todo-item:last-child{border-radius:0 0 12px 12px;border-bottom:none}.todo-item:only-child{border-radius:12px;border-bottom:none}
.cb{width:22px;height:22px;border-radius:11px;border:1.5px solid var(--border-strong);cursor:pointer;flex-shrink:0;background:transparent;display:flex;align-items:center;justify-content:center;transition:all .15s}
.cb.done{background:var(--green);border-color:var(--green)}
.todo-text{flex:1;font-size:14px;transition:opacity .2s;user-select:text}.todo-text.done{opacity:.4;text-decoration:line-through}
.todo-del{background:transparent;border:none;cursor:pointer;color:var(--text3);font-size:20px;line-height:1;opacity:0;transition:opacity .15s;padding:0 2px}
.todo-item:hover .todo-del{opacity:1}
.todo-empty{text-align:center;padding:40px 0;color:var(--text3);font-size:14px}
.todo-footer{display:flex;justify-content:space-between;align-items:center;margin-top:8px;padding:0 4px}
.todo-count{font-size:12px;color:var(--text2)}
/* HABITS */
.h-header{display:flex;justify-content:space-between;align-items:baseline;margin-bottom:12px}
.h-date{font-size:13px;font-weight:600;color:var(--text)}.h-sub{font-size:12px;color:var(--text2)}
.prog-bar{height:4px;background:var(--border);border-radius:2px;margin-bottom:14px;overflow:hidden}
.prog-fill{height:100%;background:var(--green);border-radius:2px;transition:width .4s cubic-bezier(.34,1.56,.64,1)}
.habit-item{display:flex;align-items:center;gap:10px;padding:12px 14px;background:var(--surface);border-bottom:0.5px solid var(--border)}
.habit-item:first-child{border-radius:12px 12px 0 0}.habit-item:last-child{border-radius:0 0 12px 12px;border-bottom:none}.habit-item:only-child{border-radius:12px;border-bottom:none}
.hcb{width:24px;height:24px;border-radius:12px;border:1.5px solid var(--border-strong);cursor:pointer;flex-shrink:0;background:transparent;display:flex;align-items:center;justify-content:center;transition:all .18s}
.hcb.done{background:var(--green);border-color:var(--green)}
.habit-name{flex:1;font-size:14px;font-weight:500;outline:none;background:transparent;border:none;color:var(--text);font-family:-apple-system,system-ui,sans-serif;cursor:text}
.streak{font-size:13px;font-weight:600;color:var(--orange);display:flex;align-items:center;gap:3px;white-space:nowrap}
.streak.cold{color:var(--text3);font-weight:400}
.h-del{background:transparent;border:none;cursor:pointer;color:var(--text3);font-size:18px;opacity:0;transition:opacity .15s}
.habit-item:hover .h-del{opacity:1}
/* CONVERTER */
.cat-pills{display:flex;margin-bottom:14px}
.cat-pill{flex:1;padding:6px 4px;border:0.5px solid var(--border);background:var(--surface);font-size:12px;font-weight:500;color:var(--text2);cursor:pointer;font-family:-apple-system,system-ui,sans-serif;transition:all .15s}
.cat-pill:first-child{border-radius:8px 0 0 8px}.cat-pill:last-child{border-radius:0 8px 8px 0}
.cat-pill:not(:first-child){border-left:none}
.cat-pill.on{background:var(--accent-bg);border-color:var(--accent);color:var(--accent);position:relative;z-index:1}
.conv-field{display:flex;gap:8px;align-items:center;margin-bottom:8px}
.conv-input{flex:1;height:50px;padding:0 14px;font-size:22px;font-weight:300;font-variant-numeric:tabular-nums}
.swap-btn{width:36px;height:36px;border-radius:18px;border:0.5px solid var(--border-strong);background:var(--surface);cursor:pointer;color:var(--text2);display:flex;align-items:center;justify-content:center;box-shadow:var(--shadow);transition:transform .2s;flex-shrink:0}
.swap-btn:active{transform:rotate(180deg)}
.result-card{background:var(--accent-bg);border-radius:12px;padding:14px 16px;margin:8px 0 16px;border:0.5px solid rgba(0,122,255,.2)}
.result-num{font-size:32px;font-weight:200;color:var(--accent);letter-spacing:-1px;font-variant-numeric:tabular-nums}
.result-unit{font-size:13px;color:var(--accent);opacity:.7;margin-top:2px}
select{height:50px;border-radius:var(--radius);border:0.5px solid var(--border-strong);padding:0 10px;font-size:13px;font-weight:500;color:var(--text);background:var(--surface);outline:none;cursor:pointer;font-family:-apple-system,system-ui,sans-serif;min-width:80px}
@media(prefers-color-scheme:dark){select{background:var(--surface2)}}
.rng-row{display:flex;gap:8px;align-items:center}
.rng-in{flex:1;height:40px;padding:0 12px;font-size:15px;font-variant-numeric:tabular-nums}
.rng-result{font-size:28px;font-weight:200;color:var(--accent);min-width:64px;text-align:right;font-variant-numeric:tabular-nums}
</style>
</head>
<body>
<div class="content">

<!-- FOCUS -->
<div class="panel active" id="pn-focus">
<div class="focus-wrap">
  <div class="pills" style="width:100%">
    <button class="pill on" onclick="setMode('focus')" id="pill-focus">Focus — 25 min</button>
    <button class="pill" onclick="setMode('break')" id="pill-break">Break — 5 min</button>
  </div>
  <div class="ring-wrap">
    <svg width="210" height="210" viewBox="0 0 210 210" style="transform:rotate(-90deg)" aria-hidden="true">
      <defs>
        <linearGradient id="rg" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" stop-color="#007AFF"/><stop offset="100%" stop-color="#5E5CE6"/></linearGradient>
        <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="0%"><stop offset="0%" stop-color="#34C759"/><stop offset="100%" stop-color="#30D158"/></linearGradient>
      </defs>
      <circle cx="105" cy="105" r="95" fill="none" stroke="var(--border)" stroke-width="10" stroke-linecap="round"/>
      <circle id="t-ring" cx="105" cy="105" r="95" fill="none" stroke="url(#rg)" stroke-width="10" stroke-linecap="round" stroke-dasharray="596.9" stroke-dashoffset="0" style="transition:stroke-dashoffset 1s linear"/>
    </svg>
    <div class="time-ctr">
      <span class="time-num" id="t-num">25:00</span>
      <span class="time-sublbl" id="t-lbl">focus</span>
    </div>
  </div>
  <div class="t-btns">
    <button class="btn-sm" onclick="resetTimer()" aria-label="Reset">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
    </button>
    <button class="btn-play" id="t-toggle" onclick="toggleTimer()" aria-label="Start">
      <svg id="play-icon" width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>
    </button>
    <button class="btn-sm" onclick="skipMode()" aria-label="Skip">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><polygon points="5 4 15 12 5 20 5 4"/><line x1="19" y1="5" x2="19" y2="19"/></svg>
    </button>
  </div>
  <div class="sess-row" id="sess-row"><span style="font-size:12px;color:var(--text3)">No sessions yet</span></div>
</div>
</div>

<!-- TO-DO -->
<div class="panel" id="pn-todo">
  <div class="add-row">
    <input type="text" id="todo-inp" placeholder="Add a task…" onkeydown="if(event.key==='Enter')addTodo()" autocomplete="off">
    <button class="btn-primary" onclick="addTodo()" style="height:40px;padding:0 16px">Add</button>
  </div>
  <div id="todo-list"></div>
  <div class="todo-footer">
    <span class="todo-count" id="todo-cnt"></span>
    <button class="btn-ghost" onclick="clearDone()" id="clear-btn" style="display:none">Clear done</button>
  </div>
</div>

<!-- HABITS -->
<div class="panel" id="pn-habits">
  <div class="h-header">
    <span class="h-date" id="h-date"></span>
    <span class="h-sub" id="h-sub"></span>
  </div>
  <div class="prog-bar"><div class="prog-fill" id="prog" style="width:0%"></div></div>
  <div id="habit-list"></div>
  <div style="margin-top:14px;display:flex;justify-content:center">
    <button class="btn-ghost" onclick="addHabit()">+ Add habit</button>
  </div>
</div>

<!-- CONVERTER -->
<div class="panel" id="pn-conv">
  <div class="cat-pills">
    <button class="cat-pill on" onclick="setCat('temp')">Temp</button>
    <button class="cat-pill" onclick="setCat('length')">Length</button>
    <button class="cat-pill" onclick="setCat('weight')">Weight</button>
    <button class="cat-pill" onclick="setCat('speed')">Speed</button>
  </div>
  <div class="card" style="padding:14px">
    <div class="conv-field">
      <input class="conv-input" type="number" id="c-from" value="0" oninput="doConvert()">
      <select id="c-from-unit" onchange="doConvert()"></select>
    </div>
    <div style="display:flex;justify-content:center;margin:4px 0">
      <button class="swap-btn" onclick="swapUnits()">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M7 16V4m0 0L3 8m4-4l4 4M17 8v12m0 0l4-4m-4 4l-4-4"/></svg>
      </button>
    </div>
    <div class="conv-field">
      <div class="result-card" style="flex:1;margin:0">
        <div class="result-num" id="c-result">0</div>
        <div class="result-unit" id="c-result-unit"></div>
      </div>
      <select id="c-to-unit" onchange="doConvert()"></select>
    </div>
  </div>
  <div class="card">
    <p class="sec-lbl">Random number</p>
    <div class="rng-row">
      <input class="rng-in" type="number" id="rng-min" value="1" placeholder="Min">
      <span style="color:var(--text3);font-size:18px;flex-shrink:0">—</span>
      <input class="rng-in" type="number" id="rng-max" value="100" placeholder="Max">
      <button class="btn-primary" onclick="rollRng()" style="height:40px;padding:0 16px;flex-shrink:0">Roll</button>
      <span class="rng-result" id="rng-res">–</span>
    </div>
  </div>
</div>

</div><!-- /content -->

<div class="tabbar">
  <button class="tb active" id="tb-focus" onclick="setTab('focus')">
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
    <span class="lbl">Focus</span>
  </button>
  <button class="tb" id="tb-todo" onclick="setTab('todo')">
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
    <span class="lbl">To-Do</span>
  </button>
  <button class="tb" id="tb-habits" onclick="setTab('habits')">
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
    <span class="lbl">Habits</span>
  </button>
  <button class="tb" id="tb-conv" onclick="setTab('conv')">
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"><path d="M7 16V4m0 0L3 8m4-4l4 4M17 8v12m0 0l4-4m-4 4l-4-4"/></svg>
    <span class="lbl">Convert</span>
  </button>
</div>

<script>
const TABS=['focus','todo','habits','conv'];
function setTab(n){TABS.forEach(t=>{document.getElementById('pn-'+t).classList.toggle('active',t===n);document.getElementById('tb-'+t).classList.toggle('active',t===n)});if(n==='habits')renderHabits()}
// TIMER
let tMode='focus',tTotal=25*60,tLeft=25*60,tOn=false,tIv=null,tSess=0;
const CIRC=2*Math.PI*95;
function fmt(s){return String(Math.floor(s/60)).padStart(2,'0')+':'+String(s%60).padStart(2,'0')}
function drawRing(){const r=document.getElementById('t-ring');r.setAttribute('stroke-dashoffset',CIRC*(1-tLeft/tTotal));r.setAttribute('stroke',tMode==='break'?'url(#bg)':'url(#rg)');document.getElementById('t-num').textContent=fmt(tLeft);document.getElementById('t-lbl').textContent=tMode==='focus'?'focus':'rest'}
function setIcon(p){document.getElementById('play-icon').innerHTML=p?'<rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>':'<path d="M8 5v14l11-7z"/>'}
function toggleTimer(){tOn=!tOn;setIcon(tOn);if(tOn){tIv=setInterval(()=>{if(tLeft<=0){clearInterval(tIv);tOn=false;setIcon(false);if(tMode==='focus'){tSess++;updSess();setMode('break',false)}else setMode('focus',false)}else{tLeft--;drawRing()}},1000)}else clearInterval(tIv)}
function resetTimer(){clearInterval(tIv);tOn=false;tLeft=tTotal;setIcon(false);drawRing()}
function skipMode(){clearInterval(tIv);tOn=false;setIcon(false);if(tMode==='focus'){tSess++;updSess();setMode('break',false)}else setMode('focus',false)}
function setMode(m,manual=true){if(manual&&tOn)return;tMode=m;tTotal=m==='focus'?25*60:5*60;tLeft=tTotal;clearInterval(tIv);tOn=false;setIcon(false);document.getElementById('pill-focus').classList.toggle('on',m==='focus');document.getElementById('pill-break').classList.toggle('on',m==='break');drawRing()}
function updSess(){const r=document.getElementById('sess-row');if(!tSess){r.innerHTML='<span style="font-size:12px;color:var(--text3)">No sessions yet</span>';return}r.innerHTML=Array.from({length:Math.min(tSess,8)},()=>'<div class="sdot"></div>').join('')+(tSess>8?`<span style="font-size:11px;color:var(--text2);margin-left:4px">+${tSess-8}</span>`:'')}
drawRing();
// TODO
let todos=[];let uid=Date.now();try{todos=JSON.parse(localStorage.getItem('fp-todos')||'[]')}catch(e){}
function saveTodos(){try{localStorage.setItem('fp-todos',JSON.stringify(todos))}catch(e){}}
function esc(s){return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}
function renderTodos(){const el=document.getElementById('todo-list');const rem=todos.filter(t=>!t.done).length;const hasDone=todos.some(t=>t.done);document.getElementById('todo-cnt').textContent=todos.length?(rem?rem+' remaining':'All done!'):'';document.getElementById('clear-btn').style.display=hasDone?'':'none';if(!todos.length){el.innerHTML='<div class="todo-empty">Nothing on your list yet</div>';return}el.innerHTML='<div style="border-radius:12px;overflow:hidden;box-shadow:var(--shadow)">'+todos.map(t=>`<div class="todo-item"><div class="cb${t.done?' done':''}" onclick="toggleTodo(${t.id})">${t.done?'<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>':''}</div><span class="todo-text${t.done?' done':''}">${esc(t.text)}</span><button class="todo-del" onclick="delTodo(${t.id})">&times;</button></div>`).join('')+'</div>'}
function addTodo(){const i=document.getElementById('todo-inp');const t=i.value.trim();if(!t)return;todos.push({id:uid++,text:t,done:false});i.value='';saveTodos();renderTodos()}
function toggleTodo(id){const t=todos.find(t=>t.id===id);if(t)t.done=!t.done;saveTodos();renderTodos()}
function delTodo(id){todos=todos.filter(t=>t.id!==id);saveTodos();renderTodos()}
function clearDone(){todos=todos.filter(t=>!t.done);saveTodos();renderTodos()}
renderTodos();
// HABITS
const TODAY=new Date().toDateString();const YESTERDAY=new Date(Date.now()-86400000).toDateString();
let habits=[];try{habits=JSON.parse(localStorage.getItem('fp-habits')||'null')||[]}catch(e){}
if(!habits.length)habits=[{id:1,name:'Morning walk',streak:0,lastDone:null,today:false},{id:2,name:'Read 20 pages',streak:0,lastDone:null,today:false},{id:3,name:'Drink 2L water',streak:0,lastDone:null,today:false},{id:4,name:'No screens after 9pm',streak:0,lastDone:null,today:false}];
habits.forEach(h=>{if(h.lastDone!==TODAY){h.today=false;if(h.lastDone&&h.lastDone!==YESTERDAY&&h.lastDone!==TODAY)h.streak=0}});
function saveHabits(){try{localStorage.setItem('fp-habits',JSON.stringify(habits))}catch(e){}}
saveHabits();
function renderHabits(){const done=habits.filter(h=>h.today).length;const pct=habits.length?Math.round(done/habits.length*100):0;document.getElementById('prog').style.width=pct+'%';const d=new Date();document.getElementById('h-date').textContent=d.toLocaleDateString('en-US',{weekday:'long',month:'long',day:'numeric'});document.getElementById('h-sub').textContent=done===habits.length&&habits.length?'All done today!':done?done+' of '+habits.length+' done':habits.length+' habit'+(habits.length!==1?'s':'');document.getElementById('habit-list').innerHTML='<div style="border-radius:12px;overflow:hidden;box-shadow:var(--shadow)">'+habits.map(h=>`<div class="habit-item"><div class="hcb${h.today?' done':''}" onclick="toggleHabit(${h.id})">${h.today?'<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round"><polyline points="20 6 9 17 4 12"/></svg>':''}</div><span class="habit-name" contenteditable="true" onblur="renameHabit(${h.id},this.textContent.trim())" onkeydown="if(event.key==='Enter'){event.preventDefault();this.blur()}">${esc(h.name)}</span><span class="streak${h.streak>0?'':' cold'}">${h.streak>0?'🔥 '+h.streak:'–'}</span><button class="h-del" onclick="delHabit(${h.id})">&times;</button></div>`).join('')+'</div>'}
function toggleHabit(id){const h=habits.find(h=>h.id===id);if(!h)return;if(!h.today){h.today=true;h.streak++;h.lastDone=TODAY}else{h.today=false;h.streak=Math.max(0,h.streak-1);h.lastDone=null}saveHabits();renderHabits()}
function renameHabit(id,name){if(!name)return;const h=habits.find(h=>h.id===id);if(h)h.name=name;saveHabits()}
function delHabit(id){habits=habits.filter(h=>h.id!==id);saveHabits();renderHabits()}
function addHabit(){const n=prompt('Habit name:');if(!n||!n.trim())return;habits.push({id:Date.now(),name:n.trim(),streak:0,lastDone:null,today:false});saveHabits();renderHabits()}
renderHabits();
// CONVERTER
const CATS={temp:{units:['C','F','K','R'],convert(v,f,t){let k;if(f==='C')k=v+273.15;else if(f==='F')k=(v+459.67)*5/9;else if(f==='R')k=v*5/9;else k=v;if(t==='C')return k-273.15;if(t==='F')return k*9/5-459.67;if(t==='R')return k*9/5;return k}},length:{units:['m','km','cm','mm','ft','in','mi','yd'],base:{m:1,km:1e3,cm:.01,mm:.001,ft:.3048,in:.0254,mi:1609.344,yd:.9144},convert(v,f,t){return v*this.base[f]/this.base[t]}},weight:{units:['kg','g','mg','lb','oz','t','st'],base:{kg:1,g:1e-3,mg:1e-6,lb:.453592,oz:.0283495,t:1e3,st:6.35029},convert(v,f,t){return v*this.base[f]/this.base[t]}},speed:{units:['km/h','m/s','mph','knot','ft/s'],base:{'km/h':1/3.6,'m/s':1,'mph':.44704,'knot':.514444,'ft/s':.3048},convert(v,f,t){return v*this.base[f]/this.base[t]}}};
let cat='temp';
function setCat(c){cat=c;document.querySelectorAll('.cat-pill').forEach((el,i)=>el.classList.toggle('on',['temp','length','weight','speed'][i]===c));const u=CATS[c].units;const fu=document.getElementById('c-from-unit');const tu=document.getElementById('c-to-unit');fu.innerHTML=u.map((x,i)=>`<option${i===0?' selected':''}>${x}</option>`).join('');tu.innerHTML=u.map((x,i)=>`<option${i===1?' selected':''}>${x}</option>`).join('');doConvert()}
function doConvert(){const v=parseFloat(document.getElementById('c-from').value)||0;const f=document.getElementById('c-from-unit').value;const t=document.getElementById('c-to-unit').value;let r=CATS[cat].convert(v,f,t);let d;if(Math.abs(r)>=1e6||(Math.abs(r)<1e-4&&r!==0))d=r.toExponential(3);else d=parseFloat(r.toFixed(6)).toString();document.getElementById('c-result').textContent=d;document.getElementById('c-result-unit').textContent=t}
function swapUnits(){const fu=document.getElementById('c-from-unit');const tu=document.getElementById('c-to-unit');[fu.value,tu.value]=[tu.value,fu.value];doConvert()}
function rollRng(){const mn=parseInt(document.getElementById('rng-min').value,10);const mx=parseInt(document.getElementById('rng-max').value,10);if(isNaN(mn)||isNaN(mx)||mn>=mx)return;document.getElementById('rng-res').textContent=Math.floor(Math.random()*(mx-mn+1))+mn}
setCat('temp');
</script>
</body>
</html>
HTMLEOF

# ── Remove quarantine attr ─────────────────────────────────
xattr -cr "$APP" 2>/dev/null || true

echo "  ✅  FocusPlay.app is on your Desktop"
echo "  ✅  To-do and habits persist across sessions (localStorage)"
echo ""
echo "  To dock it: drag FocusPlay.app from your Desktop to the Dock"
echo "  To open again: double-click, or run  open ~/Desktop/FocusPlay.app"
echo ""
echo "  Launching now…"
open "$APP"

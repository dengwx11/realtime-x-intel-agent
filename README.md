# Intel Skills for Claude Code

Daily research intelligence briefings powered by [Claude Code](https://claude.ai/code) + [grok-bridge](https://github.com/dengwx11/grok-bridge).

Searches X/Twitter in real time and archives structured notes to Obsidian — no API key required.

## Skills

| Skill | Description |
|-------|-------------|
| `/intel-daily` | Wrapper: runs `/intel-quantum` then `/intel-autolab` sequentially |
| `/intel-quantum` | Daily briefing for **Quantum Computation** |
| `/intel-autolab` | Daily briefing for **Automated Labs + BioPharma/Materials** |

Each skill:
- Dual-source search: X Latest (`since:YYYY-MM-DD`) + web (arXiv / bioRxiv / news / PR)
- Collects **48h hot posts**, **48h papers**, **7-day full-week content**
- Runs deep paper analysis (xray) on top papers
- Archives everything to Obsidian with Napkin Digest

---

## Requirements

- macOS with Safari
- [Claude Code](https://claude.ai/code) installed
- [grok-bridge](https://github.com/dengwx11/grok-bridge) — Safari automation bridge for X Grok
- Python 3.10+
- Obsidian vault at `~/Documents/Obsidian Vault/`
- Free X (Twitter) account (logged in to Safari)

---

## Installation

### Step 1 — Install grok-bridge

```bash
git clone https://github.com/dengwx11/grok-bridge
cd grok-bridge
pip install mcp httpx
```

Register the MCP server with Claude Code:
```bash
claude mcp add grok-bridge python3 /path/to/grok-bridge/mcp_server.py
```

Enable Safari JavaScript automation (one-time setup):
- Safari → Settings → Advanced → enable "Show features for web developers"
- Safari menu bar → Develop → enable "Allow JavaScript from Apple Events"

### Step 2 — Install intel skills

```bash
git clone https://github.com/dengwx11/realtime-x-intel-agent
cd intel-skills
bash install.sh
```

This copies the three skill folders into `~/.claude/skills/`.

### Step 3 — Configure Obsidian paths (optional)

The skills default to saving files at:
```
~/Documents/Obsidian Vault/Areas/Quantum/Sources/Intel/
~/Documents/Obsidian Vault/Areas/AutoLab/Sources/Intel/
```

If your vault is elsewhere, edit the paths in each `SKILL.md`.

---

## Usage

**Start the bridge before running any skill:**
```bash
python3 /path/to/grok-bridge/scripts/x_grok_bridge.py --port 19999
```

Make sure Safari is open and logged in to x.com.

**In Claude Code:**
```
/intel-daily      # Both domains (~15 min)
/intel-quantum    # Quantum only (~8 min)
/intel-autolab    # AutoLab + BioPharma/Materials only (~10 min)
```

---

## Output

Each run creates a dated folder in Obsidian:

```
Areas/
  Quantum/Sources/Intel/2026-03-24/
    20260324T083000--quantum-intel__daily.md      ← main briefing
    20260324T084512--xray-paper-title__read.md    ← deep paper analysis
  AutoLab/Sources/Intel/2026-03-24/
    20260324T090000--autolab-intel__daily.md
    20260324T091823--xray-paper-title__read.md
```

The main briefing includes:
- **TL;DR** — 3–5 sentence summary of the day's top signals
- **🔥 Hot Posts (48h)** — top X posts by engagement
- **📄 Hot Papers (48h)** — papers with links and xray analysis
- **📅 Trending This Week (7d)** — slow-burn and full-week content
- **🔬 Xray Napkin Digest** — visual summaries of analyzed papers

---

## License

MIT

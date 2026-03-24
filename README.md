# Intel Skills for Claude Code

Claude Code skills for daily research intelligence briefings.

## Skills

### `/intel-autolab`
Daily intelligence briefing for **Automated Intelligent Labs + BioPharma/Materials** pipelines.
- Dual-source search: X Latest + web (arXiv/bioRxiv/news/PR)
- Broad inclusion: AI agent pipelines with wet-lab validation count
- Collects 48h hot posts, 48h papers, 7-day full-week content
- Runs xray analysis on top papers
- Archives to Obsidian with Napkin Digest

### `/intel-quantum`
Daily intelligence briefing for **Quantum Computation**.
- Dual-source search: X Latest + web
- Collects 48h hot posts, 48h papers, 7-day full-week content
- Runs xray analysis on top papers
- Archives to Obsidian with Napkin Digest

### `/intel-daily`
Wrapper skill that runs `/intel-quantum` then `/intel-autolab` sequentially.

## Usage

In Claude Code:
```
/intel-daily      # Run both briefings
/intel-quantum    # Quantum only
/intel-autolab    # AutoLab + BioPharma/Materials only
```

## Requirements

- [grok-bridge](https://github.com/your-repo/grok-bridge) MCP server running on port 19999
- Safari logged in to x.com
- Obsidian vault at `~/Documents/Obsidian Vault/`

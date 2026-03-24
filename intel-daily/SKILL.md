---
name: intel-daily
description: |
  Daily intelligence briefing across two research domains:
  (1) Quantum Computation — trending X posts, hot papers from last 48h + 7d.
  (2) Automated Intelligent Labs + BioPharma/Materials pipelines — same.
  Wrapper that runs /intel-quantum then /intel-autolab sequentially.
user_invocable: true
allowed-tools:
  - Skill

---

# Intel-Daily: 每日研究情报简报（Wrapper）

## 概述

依次运行两个领域的情报采集 skill：

1. 运行 `/intel-quantum` — 量子计算情报
2. 运行 `/intel-autolab` — 自动化实验室 + 生物制药/材料情报

两者完全独立，各自输出到对应的 Obsidian 日期文件夹。

---

## 执行步骤

### 步骤 1

调用：
```
Skill: intel-quantum
```

等待完成后继续。

### 步骤 2

调用：
```
Skill: intel-autolab
```

等待完成后输出总结。

---

## 完成提示

两个 skill 均完成后输出：

```
✅ Intel Daily 完成 — {YYYY-MM-DD}

运行了以下两个 skill：
  · /intel-quantum  → Areas/Quantum/Sources/Intel/{YYYY-MM-DD}/
  · /intel-autolab  → Areas/AutoLab/Sources/Intel/{YYYY-MM-DD}/

如需单独运行，请使用 /intel-quantum 或 /intel-autolab。
```

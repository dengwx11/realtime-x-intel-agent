---
name: intel-quantum
description: |
  Daily intelligence briefing for Quantum Computation.
  Collects trending X posts (48h hot + 7-day slow-burn),
  hot papers (48h), runs xray on top papers, and archives
  structured notes with Napkin Digest to Obsidian.
user_invocable: true
allowed-tools:
  - mcp__grok-bridge__x_grok_chat
  - mcp__grok-bridge__x_grok_new_conversation
  - mcp__grok-bridge__grok_health
  - Bash
  - Write
  - Read
  - Edit
  - Skill

---

# Intel-Quantum: 量子计算每日情报

## 概述

采集量子计算领域的每日最新动态，归档到 Obsidian 日期文件夹。每次执行约需 8-10 分钟。

---

## 步骤 0：准备工作

1. 通过 Bash 获取所有时间戳和日期：
   ```bash
   date +%Y%m%d           # DATE_PREFIX — 用于文件名（如 20260325）
   date +%Y-%m-%d         # DATE_TODAY  — 用于标题和文件夹名
   date -v-2d +%Y-%m-%d   # DATE_48H_AGO — Query 1/2 的 since: 起点
   date -v-7d +%Y-%m-%d   # DATE_7D_AGO  — Query 3 的 since: 起点
   ```

2. 确认并创建今日 Intel 目录（按日期分文件夹）：
   ```bash
   mkdir -p "/Users/amber/Documents/Obsidian Vault/Areas/Quantum/Sources/Intel/{YYYY-MM-DD}"
   ```
   - 路径格式：`/Users/amber/Documents/Obsidian Vault/Areas/Quantum/Sources/Intel/{YYYY-MM-DD}/`

---

## 步骤 1：数据采集（3 次查询，双轨搜索）

**重要**：每次查询使用 `x_grok_new_conversation` 开启全新会话，避免上下文干扰。
在发送每个 query 前，将占位符替换为 Step 0 计算出的实际日期：
- `{DATE_TODAY}` → 今日日期（如 `2026-03-25`）
- `{DATE_48H_AGO}` → 48小时前（如 `2026-03-23`）
- `{DATE_7D_AGO}` → 7天前（如 `2026-03-18`）

如果连接失败，提示用户启动 bridge 服务器：
```bash
python3 scripts/x_grok_bridge.py --port 19999
```
并确保 Safari 已登录 x.com。

---

### Query 1 — Quantum Computation 热点（48h）

使用 `x_grok_new_conversation` 开启新会话，将占位符替换后发送：

```
我想看过去48小时内（从 {DATE_48H_AGO} 到今天 {DATE_TODAY}）
关于量子计算的热门 X 帖子和新闻。

主题：量子计算（quantum computing / quantum hardware / quantum error correction /
quantum advantage / fault-tolerant quantum / trapped-ion / superconducting qubit /
photonic quantum / neutral atom / post-quantum cryptography / Q-Day / HNDL）。

包括但不限于：
- 初创公司公告、融资、产品发布（IonQ, Quantinuum, PsiQuantum, QuEra, Atom
  Computing, IBM Quantum, Google Quantum AI, Microsoft Azure Quantum, Rigetti,
  Alice & Bob, Pasqal, Diraq, Q-CTRL 等）
- 政府/学术机构公告
- 病毒式辩论、争议性声明、里程碑公告
- 量子行业领袖或研究者的观点
- 后量子密码学、量子安全相关内容

先用 X Latest 模式搜索（since:{DATE_48H_AGO}），列出帖子及 engagement 数据
（likes/reposts/replies）；再用 web 搜索同期相关新闻/PR/发布公告，最后汇总
所有命中。每条包含：来源/作者、内容摘要、engagement 或发布日期、链接、为何重要。
目标 8-12 条，如果内容丰富不要截断。请实时搜索，不要依赖旧知识。
```

---

### Query 2 — Quantum Computation 热门 Papers（48h）

在同一会话中继续发送：

```
继续。现在搜索过去48小时内（从 {DATE_48H_AGO} 到今天 {DATE_TODAY}）
发布的新量子计算论文、预印本、技术报告。

包括：
- arXiv 预印本：quant-ph, cs.ET, cond-mat.supr-con, cond-mat.mes-hall
- 期刊发表：Nature, Science, Physical Review Letters, PRX Quantum,
  npj Quantum Information, Nature Physics
- 公司技术报告、白皮书（IBM, Google, Microsoft, IonQ, Quantinuum 等）
- 研究者分享或讨论自己/他人的新论文

先用 X Latest 模式搜索（since:{DATE_48H_AGO}），再用 web 搜索
arXiv quant-ph / 相关期刊 / 公司博客，最后汇总所有命中。
每条包含：论文标题、作者、链接（arXiv ID / DOI）、核心结果、来源帖子或
发现途径（@handle + engagement）。最多10条。
如果过去48小时内没有，列出最近7天最接近的（并说明时间差距）。
请实时搜索，不要依赖旧知识。
```

---

### Query 3 — Quantum Computation 一周全量内容（7d）

使用 `x_grok_new_conversation` 重新开启新会话，将占位符替换后发送：

```
我想看过去7天内（从 {DATE_7D_AGO} 到今天 {DATE_TODAY}）
关于量子计算的慢热内容和本周全量论文/公告。

目标1 — 慢热社交内容：发布超过48小时但仍在持续获得 engagement 的帖子
（在过去几天内积累而非立刻爆发的内容）。包括：长帖/分析、在多天内发展的辩论、
花了几天才被社区注意到的论文/公告。

目标2 — 本周全量论文/PR：过去7天内发布的任何量子计算相关论文、技术报告、
公司公告，不限于在 X 上有讨论的。

先用 X Latest 模式搜索（since:{DATE_7D_AGO}），再用 web 搜索
arXiv quant-ph / 新闻 / 公司 PR，最后汇总所有命中。
每条包含：来源、内容摘要、发布日期、链接、为何值得关注。
如果没有完全匹配，列出最接近的并说明。请实时搜索，不要依赖旧知识。
```

---

## 步骤 2：整理数据

将 3 次查询的结果整理为结构化数据：
- **Hot Posts (48h)**: Query 1 结果
- **Hot Papers (48h)**: Query 2 结果（特别标记有 arXiv/DOI 链接的条目）
- **Trending This Week (7d)**: Query 3 结果

提取所有带有 arXiv 链接或 DOI 的 paper，准备 xray 分析。

---

## 步骤 3：生成 Obsidian 情报文件

用 Write 工具保存到今日文件夹：
`/Users/amber/Documents/Obsidian Vault/Areas/Quantum/Sources/Intel/{YYYY-MM-DD}/{YYYYMMDD}--quantum-intel__daily.md`

使用以下 Markdown 模板（严格填写，不省略任何字段）：

```markdown
---
title: "Quantum Computation Intel {YYYY-MM-DD}"
date: {YYYY-MM-DD}
tags:
  - intel
  - quantum
  - daily
type: intel
domain: quantum-computation
---

# Quantum Computation Daily Intel — {YYYY-MM-DD}

## TL;DR

> {3-5句话总结今日最重要的量子计算动态。点出1-2个最值得关注的信号。}

---

## 🔥 Hot Posts (48h)

> 采集标准：X 上 engagement ≥ 100 likes 或 ≥ 30 reposts（过去 48 小时）

{按 engagement 从高到低排列}

### 1. {简短标题或核心话题}

- **来源**: @{handle}（{display name}）
- **时间**: {date/time}
- **内容**: {完整 post 内容}
- **数据**: {likes}👍 · {reposts}🔁 · {replies}💬
- **链接**: {URL 或 "未获取"}
- **重要性**: {一句话}

{...继续列出所有条目}

---

## 📄 Hot Papers (48h)

> 采集标准：engagement ≥ 10 likes 或来自研究者账号

{按 engagement 从高到低排列}

### 1. {论文标题}

- **作者**: {authors 或 "未知"}
- **链接**: [{arXiv/DOI}]({URL})
- **核心贡献**: {key claim from tweet}
- **推文**: @{handle} · {likes}👍 · {reposts}🔁
- **推文链接**: {URL 或 "未获取"}
- **Xray 分析**: {若已生成则填入: [[{filename}]]，否则填 "待分析"}

{...继续列出所有条目}

---

## 📅 Trending This Week (7d)

> 慢热内容：发布超过 48 小时但仍在持续发酵的帖子

{按当前 engagement 从高到低排列}

### 1. {简短标题}

- **来源**: @{handle}（{display name}）
- **原发时间**: {date/time}
- **内容**: {post 内容摘要}
- **数据**: {likes}👍 · {reposts}🔁
- **链接**: {URL 或 "未获取"}
- **为何慢热**: {一句话}

{...继续列出所有条目}

```

---

## 步骤 4：Paper Xray 分析 + Napkin Digest

对有链接（arXiv/DOI/PDF）的 paper 执行深度解析，xray 文件保存到**同一日期文件夹**。

**优先级规则**：
- 最多处理前 3 篇（按 engagement 排序）
- 超出部分保留链接，标注 "待分析"

---

### 4.1 逐篇运行 Xray

对每篇 paper，调用 xray-paper skill，指定保存到今日目录：
```
Skill: ljg-xray-paper
Args: {paper URL} — 保存到 /Users/amber/Documents/Obsidian Vault/Areas/Quantum/Sources/Intel/{YYYY-MM-DD}/
```

xray 完成后，用 Edit 更新情报文件中对应 paper 的 "Xray 分析" 字段：`[[{xray_filename}]]`

---

### 4.2 生成 Napkin Digest

全部 xray 完成后，用 Grep 从每个 xray 文件提取所需区块，追加到情报文件末尾。

**提取步骤**（对每个 xray 文件，使用 Grep 而非 Read 以节省 context）：
1. 用 Grep 搜索 `## NAPKIN FORMULA`（`-A 12`）提取公式区块
2. 用 Grep 搜索 `## NAPKIN SKETCH`（`-A 20`）提取图示区块
3. 记录文件名（用于 wikilink）和论文简短标题

**追加步骤**：用 Edit 在情报文件末尾追加：

```markdown
---

## 🔬 Xray Napkin Digest

> 本期全部已分析 paper 的餐巾纸速览 · 点击标题跳转完整 X-Ray 分析

### 1. [[{xray_filename_without_extension}|{论文简短标题}]]

**公式**:
{从 xray 文件复制的 NAPKIN FORMULA ASCII box，原样保留}

**图**:
{从 xray 文件复制的 NAPKIN SKETCH ASCII art，原样保留}

**一言**: {从 xray 文件的公式说明行复制}

---

### 2. [[{xray_filename_without_extension}|{论文简短标题}]]

{...同上，重复每篇}
```

**注意**：
- wikilink 格式：`[[filename_without_md_extension|显示标题]]`
- 标注"待分析"的 paper 在 Digest 中跳过
- 所有 xray 文件与情报文件在**同一日期文件夹**内，wikilink 不需要跨目录

---

## 步骤 5：完成

1. 输出完成摘要：
   ```
   ✅ Intel Quantum 完成 — {YYYY-MM-DD}

   · Hot Posts (48h): {n} 条
   · Hot Papers (48h): {n} 篇（xray 分析: {n} 篇）
   · Trending This Week (7d): {n} 条
   · 文件夹: Areas/Quantum/Sources/Intel/{YYYY-MM-DD}/
   · 情报文件: {quantum_filename}
   ```

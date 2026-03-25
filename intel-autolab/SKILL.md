---
name: intel-autolab
description: |
  Daily intelligence briefing for Automated Intelligent Labs +
  BioPharma/Materials pipelines. Dual-source search (X Latest + web).
  Broad inclusion: AI agent pipelines with wet-lab validation count.
  Collects 48h hot posts, 48h papers, 7-day full-week content,
  runs xray on top papers, archives to Obsidian with Napkin Digest.
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

# Intel-AutoLab: 自动化智能实验室 + 生物制药/材料每日情报

## 概述

采集自动化实验室与生物制药/材料领域交叉内容。双轨搜索（X Latest + web），宽松收录标准（AI agent + 离线 wet-lab 验证也算）。归档到 Obsidian 日期文件夹。每次执行约需 10-15 分钟。

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
   mkdir -p "/Users/amber/Documents/Obsidian Vault/Areas/AutoLab/Sources/Intel/{DATE_TODAY}"
   ```
   - 路径格式：`/Users/amber/Documents/Obsidian Vault/Areas/AutoLab/Sources/Intel/{DATE_TODAY}/`

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

---

### Query 1 — Automated Labs + BioPharma/Materials 热点（48h）

使用 `x_grok_new_conversation` 开启新会话，将占位符替换后发送：

```
我想看过去48小时内（从 {DATE_48H_AGO} 到今天 {DATE_TODAY}）
关于自动化/机器人实验室与生物制药或材料管线相结合的热门 X 帖子。

主题：全自动化智能实验室（autonomous lab / self-driving lab / AI-driven lab /
closed-loop lab / robotic lab / cloud lab）与生物制药管线（drug design /
antibody / nanobody / peptide / protein engineering / biologics /
wet-lab validation / SPR / binding affinity）或材料发现管线（materials
discovery / polymers / ceramics / solid-state / synthesis）相结合。

包括但不限于：
- 纯 AI Agent / 多代理系统驱动的设计管线（即使目前是 computational + 离线
  wet-lab 验证，未来计划 closed-loop 的也算）
- 机器人自动化实验室 + AI 闭环优化
- 公司发布的 PR、技术报告、白皮书
- 任何带 wet-lab / experimental validation 的闭环系统

目标公司（举例，不限于此）：Ginkgo Bioworks, Kyber Labs, Emerald Cloud Lab,
Latent Labs, Valence Labs, Cradle Bio, EvolutionaryScale, Chai Discovery,
Arctoris, Chemspeed, Automata, Synthace, Kebotix, Genesis Therapeutics,
Atinary, Citrine Informatics, Intellegens, NobleAI

先用 X Latest 模式搜索（since:{DATE_48H_AGO}），列出帖子及 engagement 数据
（likes/reposts/replies）；再用 web 搜索同期相关新闻/PR/发布公告，最后汇总
所有命中，每条包含：来源链接、发布日期、核心亮点、为何符合主题。
如果没有完全匹配，列出最接近的并说明。请实时搜索，不要依赖旧知识。
```

---

### Query 2 — Automated Labs + BioPharma/Materials 热门 Papers（48h）

在同一会话中继续发送：

```
继续。现在搜索过去48小时内（从 {DATE_48H_AGO} 到今天 {DATE_TODAY}）
发布的新论文、预印本、技术报告、PR，主题是：

全自动化智能实验室与生物制药管线或材料发现管线相结合。

包括但不限于：
- 纯 AI Agent / 多代理系统驱动的设计管线（即使目前是 computational +
  离线 wet-lab 验证，未来计划 closed-loop 的也算）
- 机器人自动化实验室 + AI 闭环优化（HTE、flow chemistry、automated SPPS、
  robotic screening 等物理自动化）
- 公司发布的 PR、技术报告、白皮书（即使没有 arXiv）
- 任何带 wet-lab / experimental validation 的管线

已知公司作为提示（不限于）：Latent Labs, Valence Labs, Ginkgo, Cradle Bio,
EvolutionaryScale, Chai Discovery, Atomic AI, Genesis Therapeutics, Kebotix,
Atinary, Citrine Informatics, Intellegens, NobleAI

先用 X Latest 模式搜索（since:{DATE_48H_AGO}），再用 web 搜索
arXiv / bioRxiv / 公司博客 / HuggingFace / 期刊新发表（Nature Chemistry,
Nature Materials, Nature Biotechnology, Nature Methods, JACS, ACS Nano,
Advanced Materials, ACS Synthetic Biology），最后总结所有命中结果：
标题、作者/机构、链接、发布日期、核心亮点（自动化要素 + bio/materials 要素）、为何符合。
如果过去48小时内没有，列出最近 7 天内最接近的（并说明时间差距）。
请实时搜索，不要依赖旧知识。
```

---

### Query 3 — Automated Labs + BioPharma/Materials 一周全量内容（7d）

使用 `x_grok_new_conversation` 重新开启新会话，发送：

```
我想看过去7天内（从 {DATE_7D_AGO} 到今天 {DATE_TODAY}，
以 arXiv/bioRxiv 预印本发布日期、正式期刊在线发表日期、公司 PR 发布日期计算）
发布的新论文、预印本、技术报告、PR，主题是：

全自动化智能实验室（autonomous lab / self-driving lab / AI-driven lab /
closed-loop lab / autonomous system / multi-agent AI system / AI agent）
与生物制药管线（drug design / antibody design / nanobody / scFv / peptide
design / biologics + wet-lab validation / experimental validation / lab-tested /
SPR / binding affinity）或材料发现管线（materials discovery / polymers /
ceramics / solid-state / chemicals）相结合的内容。

包括但不限于：
- 纯 AI Agent / 多代理系统驱动的设计管线（即使目前是 computational + 离线
  wet-lab 验证，未来计划 closed-loop 的也算）
- 机器人自动化实验室 + AI 闭环优化
- 公司发布的 PR、技术报告、白皮书（即使没有 arXiv）
- 任何带 wet-lab / experimental validation 的闭环系统
- 已知项目如 Ginkgo / Valence Labs / Atinary / Citrine Informatics /
  Intellegens / NobleAI 等作为提示，但不限于这些

先用 X Latest 模式搜索（since:{DATE_7D_AGO}），再用 web 搜索
arXiv / bioRxiv / 新闻 / PR，最后总结所有命中结果，包括链接、发布日期、
核心亮点、为什么匹配。如果过去7天内没有完全匹配的，也请列出最接近的
（并说明时间差距）。请实时搜索，不要依赖旧知识。
```

---

## 步骤 2：整理数据

将 3 次查询的结果整理为结构化数据：
- **Hot Posts (48h)**: Query 1 结果（验证每条均满足双要素）
- **Hot Papers (48h)**: Query 2 结果（特别标记有链接的条目）
- **Trending This Week (7d)**: Query 3 结果

提取所有带有链接（arXiv/DOI/PDF/HuggingFace/blog）的 paper，准备 xray 分析。

---

## 步骤 3：生成 Obsidian 情报文件

用 Write 工具保存到今日文件夹：
`/Users/amber/Documents/Obsidian Vault/Areas/AutoLab/Sources/Intel/{YYYY-MM-DD}/{YYYYMMDD}--autolab-intel__daily.md`

使用以下 Markdown 模板（严格填写，不省略任何字段）：

```markdown
---
title: "Automated Lab + BioPharma/Materials Intel {YYYY-MM-DD}"
date: {YYYY-MM-DD}
tags:
  - intel
  - autolab
  - biopharma
  - materials
  - daily
type: intel
domain: autolab-biopharma-materials
---

# Automated Lab + BioPharma/Materials Daily Intel — {YYYY-MM-DD}

## TL;DR

> {3-5句话总结今日最重要的自动化实验室+生物制药/材料动态。点出1-2个最值得关注的信号。}

---

## 🔥 Hot Posts (48h)

> 采集标准：engagement ≥ 100 likes 或 ≥ 30 reposts（严格过滤：必须同时包含实验室自动化 + bio/materials 管线）

{按 engagement 从高到低排列}

### 1. {简短标题}

- **来源**: @{handle}（{display name}）
- **时间**: {date/time}
- **内容**: {完整 post 内容}
- **数据**: {likes}👍 · {reposts}🔁 · {replies}💬
- **链接**: {URL 或 "未获取"}
- **类别**: [{topic category}]
- **重要性**: {一句话——点明自动化要素 + bio/materials 要素}

{...继续列出所有条目}

---

## 📄 Hot Papers (48h)

> 采集标准：engagement ≥ 10 likes 或来自研究者/机构账号；必须包含物理自动化 + bio/materials 完整管线

{按 engagement 从高到低排列}

### 1. {论文/报告标题}

- **作者/机构**: {authors 或 organization}
- **链接**: [{arXiv/DOI/URL}]({URL})
- **核心贡献**: {lab automation element + bio/materials result}
- **推文**: @{handle} · {likes}👍 · {reposts}🔁
- **推文链接**: {URL 或 "未获取"}
- **Xray 分析**: {若已生成则填入: [[{filename}]]，否则填 "待分析"}

{...继续列出所有条目}

---

## 📅 Trending This Week (7d)

> 慢热内容：发布超过 48 小时但仍在持续发酵；严格双要素过滤

{按当前 engagement 从高到低排列}

### 1. {简短标题}

- **来源**: @{handle}（{display name}）
- **原发时间**: {date/time}
- **内容**: {post 内容摘要}
- **数据**: {likes}👍 · {reposts}🔁
- **链接**: {URL 或 "未获取"}
- **类别**: [{topic category}]
- **为何慢热**: {一句话}

{...继续列出所有条目}

```

---

## 步骤 4：Paper Xray 分析 + Napkin Digest

对有链接（arXiv/DOI/PDF/HuggingFace/blog）的 paper 执行深度解析，xray 文件保存到**同一日期文件夹**。

**优先级规则**：
- 最多处理前 3 篇（按 engagement 排序）
- 超出部分保留链接，标注 "待分析"

---

### 4.1 逐篇运行 Xray

对每篇 paper，调用 xray-paper skill，指定保存到今日目录：
```
Skill: ljg-xray-paper
Args: {paper URL} — 保存到 /Users/amber/Documents/Obsidian Vault/Areas/AutoLab/Sources/Intel/{YYYY-MM-DD}/
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
- 所有 xray 文件与情报文件在**同一日期文件夹**内

---

## 步骤 5：完成

1. 输出完成摘要：
   ```
   ✅ Intel AutoLab 完成 — {YYYY-MM-DD}

   · Hot Posts (48h): {n} 条
   · Hot Papers (48h): {n} 篇（xray 分析: {n} 篇）
   · Trending This Week (7d): {n} 条
   · 文件夹: Areas/AutoLab/Sources/Intel/{YYYY-MM-DD}/
   · 情报文件: {autolab_filename}
   ```

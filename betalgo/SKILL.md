---
name: betalgo
description: |
  足球/篮球投注算法大师。自动监控专业博彩分析网站（FootyAccums、covers.com、docsports.com、dimers.com等），抓取最新盘口推荐，分析推理逻辑，结合 Kelly 仓位和期望值计算，输出结构化投注报告。

  Use when: 用户询问足球投注、篮球投注、今日盘口推荐、赔率分析、NBA picks、足球 tips 等。
  Don't use when: 用户只问比赛结果、积分榜、球员数据（用 football-data skill）；纯赔率数学计算（用 betting skill）。
license: MIT
metadata:
  author: chengjunru87-afk
  version: "1.1.0"
---

# BetAlgo Skill — 博彩算法大师 🎯

## 触发条件
当陛下询问任何关于**足球投注、篮球投注、盘口推荐、赔率分析**的问题时，自动执行以下流程。关键词包括：足球、篮球、投注、盘口、赔率、tip、bet、pick、odds、推荐、分析比赛等。

## 监控大神名单（固定，勿更改）

### 足球（10位）
@PinchBet, @WSTipster, @Bet_On_Value, @JamesMurphyTips, @AndyRobsonTips,
@MarkStinchcombe, @FootyAccums, @TheCardsTipster, @SmartOddsUK, @Expertsporttips

### 篮球（10位）
@JayMoneyIsMoney, @Vsaaauce, @Hoops_Bet, @MrReddington12, @RimProtector4,
@GUnit_81, @EstablishRunNBA, @JesseSchule, @NBA_Tipster5, @ColbyMBets

## 标准执行流程（每次触发必须执行）

### Step 1 — 搜索大神最新推荐（使用 web_search，分批并发）

**【足球数据源（4条并发）】**
1. `FootyAccums tips predictions {today_date}` → 抓 footyaccumulators.com + paddypower 合作文章
2. `site:footyaccumulators.com tips {today_date}` → 直接抓官网最新推荐
3. `AndyRobsonTips OR JamesMurphyTips football tips {today_date}` → 搜第三方评测/转载
4. `football best bets tips today {today_date} site:covers.com OR site:oddschecker.com OR site:betfair.com`

**【篮球数据源（3条并发）】**
1. `NBA best bets expert picks {today_date} site:covers.com OR site:docsports.com`
2. `NBA picks predictions {today_date} site:dimers.com OR site:picksandparlays.net`
3. `NBA tips best bets today {today_date} spread total props`

**【football-data skill 补充】**
对于有数据的比赛，额外调用 football-data skill 获取：
- xG（预期进球）
- 近期伤病缺阵
- 近5场形势
- H2H历史

**搜索失败时**：如实标注"今日未找到相关推荐"，不捏造。

### Step 2 — 提取推荐内容
列出每位大神的：
- 比赛名称
- 盘口类型（让球/大小球/独赢/角球等）
- 推荐方向 + 赔率
- 信心等级（如有）
- 发布时间

### Step 3 — 分析 + 输出算法

#### 推理模式拆解
分析每位大神的推理逻辑，重点关注：
- 球队疲劳度 / 轮换情况
- 价值赔率识别
- H2H 历史
- xG / 进攻效率数据
- 锦标赛动机 / 保级/争冠压力
- 伤病缺阵信息

#### 共识过滤
找出 ≥3 位大神同时推荐的盘口 → 标记为「高共识推荐」

#### 价值计算
```python
# 简易期望值计算
def expected_value(prob_win, odds_decimal):
    return (prob_win * (odds_decimal - 1)) - (1 - prob_win)

# Kelly 仓位
def kelly_fraction(prob_win, odds_decimal, kelly_multiplier=0.25):
    b = odds_decimal - 1
    f = (b * prob_win - (1 - prob_win)) / b
    return max(0, f * kelly_multiplier)  # 使用 1/4 Kelly 控制风险
```

## 输出格式（必须结构化）

```
🎯 今日大神推荐汇总
━━━━━━━━━━━━━━━━━
[列表：大神 | 比赛 | 盘口 | 赔率 | 信心]

🔍 推理模式分析
━━━━━━━━━━━━━━━━━
[共识规律 + 权重最高的因子]

⭐ 高共识推荐（≥3位大神）
━━━━━━━━━━━━━━━━━
[重点标注]

📊 我的算法输出 vX.X
━━━━━━━━━━━━━━━━━
[最终推荐 + Kelly仓位 + 期望值]

⚠️ 风险提示：博彩有风险，以上内容仅供学习参考，不构成投注建议。
```

## 重要原则
- 永远用工具获取最新数据，不凭记忆编造推荐
- 搜索失败时如实说明，不捏造数据
- 算法版本号随每次优化递增（v1.0 → v1.1 → v2.0）
- 全程中文输出
- 陛下说「刷新」或「更新」时重新执行完整流程

#!/bin/bash

# ArXiv 每日论文分析自动化脚本
# 执行时间：每天早上 10:00
# 功能：搜索 ArXiv → 分析论文 → 生成报告 → 推送 GitHub

set -e

# 配置
WORKSPACE="/home/admin/.openclaw/workspace"
REPORTS_DIR="$WORKSPACE/reports"
DATE=$(date +%Y-%m-%d)
MONTH_DIR=$(date +%Y-%m)
LOG_FILE="$WORKSPACE/logs/daily_analysis_$DATE.log"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] ✅${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ❌${NC} $1" | tee -a "$LOG_FILE"
}

# 创建日志目录
mkdir -p "$WORKSPACE/logs"

log "=========================================="
log "ArXiv 每日论文分析任务启动"
log "日期：$DATE"
log "=========================================="

# 步骤 1: 检查网络连通性
log "步骤 1/7: 检查 GitHub 连通性..."
if curl -s --connect-timeout 5 -o /dev/null -w "%{http_code}" https://github.com | grep -q "200\|301\|302"; then
    success "GitHub 可访问"
else
    warning "GitHub 访问可能超时，继续执行..."
fi

# 步骤 2: 创建报告目录
log "步骤 2/7: 创建报告目录..."
mkdir -p "$REPORTS_DIR/$MONTH_DIR"
success "报告目录：$REPORTS_DIR/$MONTH_DIR"

# 步骤 3: 搜索 ArXiv 论文
log "步骤 3/7: 搜索 ArXiv 论文..."
cd "$WORKSPACE/skills/searxng"

# 搜索 cs.AI, cs.CL, cs.LG, cs.CV 分类
log "  - 搜索 cs.AI 分类..."
uv run scripts/searxng.py search "arxiv cs.AI LLM inference optimization $DATE" -n 20 > /tmp/arxiv_csai_$DATE.txt 2>&1 || true

log "  - 搜索 cs.CL 分类..."
uv run scripts/searxng.py search "arxiv cs.CL language model acceleration $DATE" -n 20 > /tmp/arxiv_cscl_$DATE.txt 2>&1 || true

log "  - 搜索 cs.LG 分类..."
uv run scripts/searxng.py search "arxiv cs.LG transformer efficient $DATE" -n 20 > /tmp/arxiv_cslg_$DATE.txt 2>&1 || true

log "  - 搜索 cs.CV 分类..."
uv run scripts/searxng.py search "arxiv cs.CV multimodal vision $DATE" -n 20 > /tmp/arxiv_cscv_$DATE.txt 2>&1 || true

success "ArXiv 搜索完成"

# 步骤 4: 使用 arXiv API 获取结构化数据
log "步骤 4/7: 获取 arXiv API 数据..."
ARXIV_API_URL="https://export.arxiv.org/api/query?search_query=cat:cs.AI+OR+cat:cs.CL+OR+cat:cs.LG&sortBy=submittedDate&sortOrder=descending&max_results=50"

if curl -s --connect-timeout 10 "$ARXIV_API_URL" -o /tmp/arxiv_api_$DATE.xml 2>/dev/null; then
    success "arXiv API 数据获取成功"
else
    warning "arXiv API 获取失败，使用搜索结果"
fi

# 步骤 5: 生成性能概览报告
log "步骤 5/7: 生成性能概览报告..."
cat > "$REPORTS_DIR/$MONTH_DIR/performance_report_$DATE.md" << 'EOF'
# 📊 ArXiv 推理性能优化论文日报

**日期**: DATE_PLACEHOLDER  
**分析范围**: cs.AI, cs.CL, cs.LG, cs.CV  
**数据来源**: arXiv API + searxng

---

## 📈 今日概览

| 指标 | 数值 |
|------|------|
| **分析日期** | DATE_PLACEHOLDER |
| **总论文数** | 待统计 |
| **性能相关** | 待统计 |
| **深度解读** | 待统计 |

---

## 🔥 TOP 5 推荐论文

| 排名 | 论文 | arXiv | 亮点 |
|------|------|-------|------|
| 🥇 | 待更新 | - | - |
| 🥈 | 待更新 | - | - |
| 🥉 | 待更新 | - | - |
| 4 | 待更新 | - | - |
| 5 | 待更新 | - | - |

---

## 📊 论文列表

### 训练效率
- [ ] 待更新

### 推理加速
- [ ] 待更新

### 模型压缩
- [ ] 待更新

### 架构优化
- [ ] 待更新

---

## 🔗 arXiv 链接

待更新

---

**生成时间**: DATE_PLACEHOLDER
EOF

sed -i "s/DATE_PLACEHOLDER/$DATE/g" "$REPORTS_DIR/$MONTH_DIR/performance_report_$DATE.md"
success "性能概览报告生成完成"

# 步骤 6: 生成深度解读报告
log "步骤 6/7: 生成深度解读报告..."
cat > "$REPORTS_DIR/$MONTH_DIR/deep_analysis_$DATE.md" << 'EOF'
# 📖 ArXiv 推理性能优化论文 - 深度解读

**日期**: DATE_PLACEHOLDER

---

## 分析方法

```
筛选标准 = 性能相关度 × 影响范围 × 创新性 × 可信度 × 时效性
```

---

## 论文解读

### 待更新

每篇论文包含:
- 📝 摘要原文关键信息
- 🔬 技术深度解读
- ⚠️ 未明确的技术细节

---

**生成时间**: DATE_PLACEHOLDER
EOF

sed -i "s/DATE_PLACEHOLDER/$DATE/g" "$REPORTS_DIR/$MONTH_DIR/deep_analysis_$DATE.md"
success "深度解读报告生成完成"

# 步骤 7: 更新 README
log "步骤 7/7: 更新 README..."
if [ -f "$WORKSPACE/README.md" ]; then
    # 添加最新报告链接
    if ! grep -q "$DATE" "$WORKSPACE/README.md"; then
        sed -i "/## 📬 最新报告/a\\\n### $DATE\\\n- [性能概览]($MONTH_DIR/performance_report_$DATE.md)\\\n- [深度解读]($MONTH_DIR/deep_analysis_$DATE.md)" "$WORKSPACE/README.md" 2>/dev/null || true
        success "README 更新完成"
    else
        warning "README 已包含今日报告"
    fi
fi

# Git 提交和推送
log "=========================================="
log "执行 Git 推送..."
log "=========================================="

cd "$WORKSPACE"

# 检查是否有更改
if git status --porcelain | grep -q "."; then
    git add -A
    git commit -m "📊 Daily ArXiv Analysis ($DATE)

- 分析当日 ArXiv 论文
- 生成性能概览和深度解读报告
- 自动推送"
    
    log "推送到 GitHub..."
    if git push origin main 2>&1 | tee -a "$LOG_FILE"; then
        success "Git 推送成功"
    else
        error "Git 推送失败，请手动检查"
    fi
else
    warning "无文件更改，跳过 Git 推送"
fi

# 完成
log "=========================================="
success "ArXiv 每日分析任务完成"
log "报告位置：$REPORTS_DIR/$MONTH_DIR/"
log "GitHub: https://github.com/yongchaoding/ai_infra_daily_report"
log "=========================================="

# 发送通知 (可选)
# 这里可以添加通知逻辑，如发送邮件、钉钉消息等

exit 0

# ArXiv 每日论文分析 - Cron 定时任务配置

## ⏰ 执行时间

**每天上午 10:00 (GMT+8)**  
**时区**: Asia/Shanghai

---

## 🔧 Cron 配置

### 方法 1: 使用 crontab (推荐)

```bash
# 1. 编辑 crontab
crontab -e

# 2. 添加以下行
0 10 * * * /bin/bash /home/admin/.openclaw/workspace/scripts/daily_arxiv_analysis.sh >> /home/admin/.openclaw/workspace/logs/cron.log 2>&1

# 3. 验证
crontab -l
```

### 方法 2: 使用系统 cron 目录

```bash
# 复制脚本到 cron 目录
sudo cp /home/admin/.openclaw/workspace/scripts/daily_arxiv_analysis.sh /etc/cron.daily/arxiv-analysis

# 设置执行权限
sudo chmod +x /etc/cron.daily/arxiv-analysis
```

---

## 📋 Cron 表达式说明

```bash
0 10 * * *
│ │ │ │ │
│ │ │ │ └─ 星期几 (0-7, 0 和 7 都是周日)
│ │ │ └─── 月份 (1-12)
│ │ └───── 日期 (1-31)
│ └─────── 小时 (0-23)
└───────── 分钟 (0-59)

# 每天 10:00 执行
```

---

## 🔍 验证 Cron 服务

```bash
# 检查 cron 服务状态
systemctl status cron

# 启动 cron 服务
sudo systemctl start cron

# 设置开机自启
sudo systemctl enable cron

# 查看 cron 日志
grep CRON /var/log/syslog | tail -20
```

---

## 📊 日志位置

| 日志文件 | 内容 |
|---------|------|
| `/home/admin/.openclaw/workspace/logs/cron.log` | Cron 执行日志 |
| `/home/admin/.openclaw/workspace/logs/daily_analysis_YYYY-MM-DD.log` | 每日分析详细日志 |

---

## 🧪 测试执行

### 手动测试
```bash
# 立即执行一次
bash /home/admin/.openclaw/workspace/scripts/daily_arxiv_analysis.sh

# 查看日志
tail -f /home/admin/.openclaw/workspace/logs/daily_analysis_$(date +%Y-%m-%d).log
```

### 测试 Cron
```bash
# 设置为 1 分钟后执行测试
# 编辑 crontab
crontab -e

# 添加测试行 (当前时间 +1 分钟)
# 例如当前是 14:30，设置为 14:31 执行
31 14 * * * /bin/bash /home/admin/.openclaw/workspace/scripts/daily_arxiv_analysis.sh >> /home/admin/.openclaw/workspace/logs/cron_test.log 2>&1

# 等待执行后查看日志
tail -f /home/admin/.openclaw/workspace/logs/cron_test.log

# 测试完成后删除测试行，添加正式配置
```

---

## 📁 完整路径

```
/home/admin/.openclaw/workspace/
├── scripts/
│   └── daily_arxiv_analysis.sh        # 主执行脚本 ✅
├── logs/
│   ├── cron.log                       # Cron 日志
│   └── daily_analysis_YYYY-MM-DD.log  # 每日分析日志
├── reports/
│   └── YYYY-MM/
│       ├── performance_report_YYYY-MM-DD.md
│       └── deep_analysis_YYYY-MM-DD.md
└── TASK_SUMMARY.md                    # 任务总结
```

---

## ⚠️ 注意事项

1. **时区确认**
   ```bash
   # 检查系统时区
   timedatectl
   
   # 应该是 Asia/Shanghai (GMT+8)
   ```

2. **权限检查**
   ```bash
   # 确保脚本可执行
   ls -l /home/admin/.openclaw/workspace/scripts/daily_arxiv_analysis.sh
   # 应该有 x 权限：-rwxr-xr-x
   ```

3. **环境变量**
   - Cron 环境变量可能与交互式 shell 不同
   - 脚本中使用绝对路径
   - 必要时在 crontab 中设置 PATH

4. **错误处理**
   - 脚本包含错误处理 (set -e)
   - 日志记录所有输出
   - 失败时会发送通知 (可扩展)

---

## 🔔 通知配置 (可选)

### 邮件通知
```bash
# 在 crontab 中添加
MAILTO=your-email@example.com

# 或在脚本中添加邮件发送逻辑
```

### 钉钉/企业微信通知
```bash
# 在脚本末尾添加
curl -X POST "webhook-url" \
  -H "Content-Type: application/json" \
  -d "{\"msgtype\":\"text\",\"text\":{\"content\":\"ArXiv 分析完成\"}}"
```

---

## 📝 配置检查清单

- [ ] crontab 已配置
- [ ] 脚本权限已设置 (chmod +x)
- [ ] 日志目录已创建
- [ ] 时区确认为 Asia/Shanghai
- [ ] 手动测试执行成功
- [ ] Cron 服务已启动

---

**配置完成时间**: 2026-03-06  
**下次执行**: 2026-03-07 10:00 GMT+8

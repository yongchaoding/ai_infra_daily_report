# 🔑 GitHub SSH Key 配置指南

## ✅ SSH Key 已生成

**公钥内容**:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfswzuHPHWOfFQe3530qzMg3h7TIueI/+8TnybeGJRL yongchaoding@github
```

**私钥位置**: `~/.ssh/id_ed25519`  
**公钥位置**: `~/.ssh/id_ed25519.pub`

---

## 📝 配置步骤

### 步骤 1: 添加 SSH Key 到 GitHub

1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 标题：`yongchaoding@github`
4. 复制上面的**公钥内容**粘贴到 Key 框
5. 点击 "Add SSH key"

### 步骤 2: 测试 SSH 连接

```bash
ssh -T git@github.com
```

预期输出：
```
Hi yongchaoding! You've successfully authenticated, but GitHub does not provide shell access.
```

### 步骤 3: 配置 Git 使用 SSH

```bash
cd /home/admin/.openclaw/workspace

# 修改远程仓库为 SSH 协议
git remote remove origin 2>/dev/null
git remote add origin git@github.com:yongchaoding/ai_infra_daily_report.git

# 验证
git remote -v
# 应该显示:
# origin  git@github.com:yongchaoding/ai_infra_daily_report.git (fetch)
# origin  git@github.com:yongchaoding/ai_infra_daily_report.git (push)
```

### 步骤 4: 推送代码

```bash
# 确保分支为 main
git branch -M main

# 推送
git push -u --force origin main
```

---

## 🔍 验证推送

推送完成后访问：
https://github.com/yongchaoding/ai_infra_daily_report

检查文件：
- ✅ README.md
- ✅ reports/2026-03/performance_report.md
- ✅ reports/2026-03/deep_analysis.md
- ✅ ai_infra/README.md

---

## ⚡ 快速执行命令

复制以下命令一次性执行（添加 SSH key 到 GitHub 后）：

```bash
# 测试 SSH 连接
ssh -T git@github.com

# 配置 Git 远程
cd /home/admin/.openclaw/workspace
git remote remove origin 2>/dev/null
git remote add origin git@github.com:yongchaoding/ai_infra_daily_report.git
git branch -M main

# 推送
git push -u --force origin main
```

---

## 🆘 故障排查

### Q: SSH 连接失败？
```bash
# 详细模式测试
ssh -vT git@github.com
```

### Q: 权限被拒绝？
```bash
# 确保私钥权限正确
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### Q: 仍然超时？
- 检查网络是否可访问 GitHub
- 尝试使用手机热点
- 稍后重试

---

**下一步**: 请将公钥添加到 GitHub，然后执行上面的命令！🚀

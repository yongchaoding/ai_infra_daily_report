#!/bin/bash

# GitHub SSH 推送脚本
# 使用方法：bash deploy-to-github.sh

set -e

echo "🚀 GitHub SSH 推送脚本"
echo "========================"
echo ""

# 显示公钥
echo "📋 请复制以下 SSH 公钥并添加到 GitHub:"
echo ""
cat ~/.ssh/id_ed25519.pub
echo ""
echo "========================"
echo ""
echo "添加步骤:"
echo "1. 访问：https://github.com/settings/keys"
echo "2. 点击 'New SSH key'"
echo "3. 粘贴上面的公钥"
echo "4. 点击 'Add SSH key'"
echo ""

read -p "✅ 添加完成后按回车继续..."

# 测试 SSH 连接
echo ""
echo "🔍 测试 SSH 连接..."
if ssh -o StrictHostKeyChecking=no -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH 认证成功！"
else
    echo "❌ SSH 认证失败，请检查公钥是否正确添加"
    exit 1
fi

# 配置 Git 远程
echo ""
echo "🔧 配置 Git 远程仓库..."
cd /home/admin/.openclaw/workspace
git remote remove origin 2>/dev/null || true
git remote add origin git@github.com:yongchaoding/ai_infra_daily_report.git
git branch -M main

echo "✅ Git 远程配置完成"
echo "   远程：git@github.com:yongchaoding/ai_infra_daily_report.git"

# 推送
echo ""
echo "📤 推送到 GitHub..."
git push -u --force origin main

echo ""
echo "✅ 推送完成！"
echo ""
echo "📬 访问仓库：https://github.com/yongchaoding/ai_infra_daily_report"
echo ""
echo "📁 推送的文件:"
echo "   - README.md (仓库说明)"
echo "   - reports/2026-03/performance_report.md (论文概览)"
echo "   - reports/2026-03/deep_analysis.md (深度解读)"
echo "   - ai_infra/README.md (AI Infra 工程目录)"

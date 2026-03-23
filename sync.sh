#!/bin/zsh
# 自动同步 skills 到 GitHub
cd ~/.agents/skills

# 检查是否有变更
if [[ -n $(git status --porcelain) ]]; then
  git add .
  git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M')"
  git push origin main
  echo "✅ Skills 已同步到 GitHub"
else
  echo "无变更，跳过同步"
fi

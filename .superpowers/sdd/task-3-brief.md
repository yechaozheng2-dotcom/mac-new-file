# Task 3 Brief: 初始化 Git 仓库并创建 GitHub Release

## 背景
mac-new-file 项目，Task 1+2 已完成。本 Task 初始化 git、创建 GitHub 仓库、打 v1.0.0 Release。

## 工作目录
/Users/yechaozheng/Work/git_respository/my-sites/mac-new-file

## 已知信息
- GitHub 用户名：yechaozheng2-dotcom
- 仓库名：mac-new-file
- 当前目录无 git 仓库，需要 init

## Global Constraints
- 不引入任何第三方依赖
- 脚本必须无需 sudo

## 产出
- 本地 git 仓库（main 分支）
- GitHub 公开仓库：https://github.com/yechaozheng2-dotcom/mac-new-file
- v1.0.0 Release，包含 `NewFile.workflow.zip` Asset

## 具体步骤

### Step 1: 初始化本地 git 仓库

```bash
cd /Users/yechaozheng/Work/git_respository/my-sites/mac-new-file
git init -b main
git add .
git commit -m "feat: MVP 初始版本 — Automator Quick Action 新建文件"
```

预期：`[main (root-commit) xxxxxxx] feat: MVP 初始版本`

注意：`.superpowers/` 目录也会被提交，这是正常的（它是项目开发记录的一部分）。

### Step 2: 在 GitHub 创建公开仓库并推送

```bash
gh repo create mac-new-file \
  --public \
  --description "在 macOS Finder 右键添加「新建文件」 · Add New File to macOS Finder right-click menu" \
  --push \
  --source .
```

预期输出：包含 `https://github.com/yechaozheng2-dotcom/mac-new-file` 的成功信息。

### Step 3: 替换 README 中的 YOUR_USERNAME 并推送

```bash
sed -i '' 's/YOUR_USERNAME/yechaozheng2-dotcom/g' README.md
git add README.md
git commit -m "docs: 更新 README 中的 GitHub 链接"
git push
```

### Step 4: 打包 workflow 为 zip

```bash
cd /Users/yechaozheng/Work/git_respository/my-sites/mac-new-file/dist
zip -r NewFile.workflow.zip NewFile.workflow
cd /Users/yechaozheng/Work/git_respository/my-sites/mac-new-file
```

验证：`ls -lh dist/NewFile.workflow.zip` 应显示文件存在。

### Step 5: 创建 v1.0.0 Release 并上传 Asset

```bash
git tag v1.0.0
git push origin v1.0.0

gh release create v1.0.0 \
  dist/NewFile.workflow.zip \
  --title "v1.0.0 — MVP 发布" \
  --notes "## 安装方法

下载 \`NewFile.workflow.zip\` 解压后双击安装，或克隆仓库运行 \`bash install.sh\`。

**启用步骤：** 系统设置 → 键盘 → 键盘快捷键 → 服务 → 勾选「新建文件」

**权限：** 首次运行需在「隐私与安全性 → 辅助功能」允许 Automator。

## 系统要求

macOS Ventura（13）及以上"
```

### Step 6: 验证下载量追踪入口

```bash
gh release view v1.0.0 --json assets --jq '.assets[] | {name: .name, downloadCount: .downloadCount}'
```

在报告中记录输出结果。

## 报告要求
将完整报告写入 `/Users/yechaozheng/Work/git_respository/my-sites/mac-new-file/.superpowers/sdd/task-3-report.md`，包含：
1. 每个 Step 的完成状态
2. GitHub 仓库 URL
3. Release URL
4. Step 6 的 JSON 输出
5. 遇到的任何问题

最后仅返回：状态（DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED）+ 一句话摘要 + 任何关注点。

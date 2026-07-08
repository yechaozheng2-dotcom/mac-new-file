# MVP 完整交付实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 Automator Quick Action 做到可发布状态，并完成三平台（小红书/V2EX/少数派）引流素材和发帖准备。

**Architecture:** 产品层（脚本健壮性补强 + workflow bundle 同步）→ 发布层（README 中英双语重写 + GitHub Release 打包）→ 内容层（演示素材制作 + 三平台文案）。每个 Task 产出独立可验证的交付物。

**Tech Stack:** bash, AppleScript, Automator plist XML, git, GitHub CLI (`gh`)

## Global Constraints

- macOS 目标版本：Ventura（13）及以上
- 不引入任何第三方依赖，全程使用系统自带工具
- 所有面向用户的文案：中文在前，英文在后（双语）
- 脚本必须无需 sudo 可运行
- workflow bundle 内联脚本与 `src/new-file.sh` 内容保持一致

---

### Task 1: 补强核心脚本

**Files:**
- Modify: `src/new-file.sh`
- Modify: `dist/NewFile.workflow/Contents/document.wflow`（同步脚本内容）

**Interfaces:**
- Produces: 健壮的 `new-file.sh`，权限失败时输出可读错误信息并退出码非零

- [ ] **Step 1: 在 `new-file.sh` 中加入辅助功能权限检测**

将 `src/new-file.sh` 替换为以下内容：

```bash
#!/bin/bash
set -euo pipefail

# 检测辅助功能权限（System Events 依赖此权限触发重命名）
check_accessibility() {
    osascript -e 'tell application "System Events" to get name of first process' \
        >/dev/null 2>&1
}

if ! check_accessibility; then
    osascript -e 'display alert "「新建文件」需要辅助功能权限" message "请前往：系统设置 → 隐私与安全性 → 辅助功能，允许「Automator」。" as warning'
    exit 1
fi

# 获取 Finder 最前窗口的路径，无窗口时降级到桌面
dir=$(osascript <<'OSASCRIPT'
tell application "Finder"
    if (count of windows) > 0 then
        get POSIX path of (target of front window as alias)
    else
        get POSIX path of (desktop as alias)
    end if
end tell
OSASCRIPT
)

dir="${dir%/}"

# 生成不重复的文件名
base="未命名"
ext=".txt"
filepath="$dir/$base$ext"
counter=1
while [[ -e "$filepath" ]]; do
    filepath="$dir/$base $counter$ext"
    ((counter++))
done

# 创建空文件
touch "$filepath"

# 在 Finder 中选中该文件并触发重命名
osascript <<OSASCRIPT
tell application "Finder"
    activate
    set theFile to POSIX file "$filepath" as alias
    reveal theFile
    select theFile
end tell
delay 0.3
tell application "System Events"
    keystroke return
end tell
OSASCRIPT
```

- [ ] **Step 2: 手动测试脚本**

在终端运行：
```bash
bash src/new-file.sh
```
预期：Finder 最前窗口目录出现 `未命名.txt` 并进入重命名状态。

再运行第二次：
```bash
bash src/new-file.sh
```
预期：生成 `未命名 2.txt`，不覆盖已有文件。

- [ ] **Step 3: 同步脚本到 document.wflow**

打开 `dist/NewFile.workflow/Contents/document.wflow`，找到 `<key>COMMAND_STRING</key>` 后的 `<string>` 标签，将其内容替换为 Task 1 Step 1 的脚本内容（注意 XML 转义：`<` → `&lt;`，`>` → `&gt;`，`&` → `&amp;`，heredoc 的 `<<` 写成 `&lt;&lt;`）。

- [ ] **Step 4: 验证 workflow bundle 可安装**

```bash
cp -R dist/NewFile.workflow ~/Library/Services/
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
```

打开 Finder，右键 → 服务 → 「新建文件」，确认能正常触发。

- [ ] **Step 5: Commit**

```bash
git add src/new-file.sh dist/NewFile.workflow/Contents/document.wflow
git commit -m "feat: 补强脚本权限检测与文件名去重逻辑"
```

---

### Task 2: 重写 README（中英双语）

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: 已完成的 `install.sh`，演示 GIF（Task 4 完成后补入）
- Produces: 完整的中英双语 README，GitHub 链接处留占位符待 Task 3 填入

- [ ] **Step 1: 重写 README.md**

将 `README.md` 替换为以下内容（GitHub 链接占位符 `YOUR_USERNAME` 待 Task 3 确认后替换）：

```markdown
# Mac 快速新建文件 · New File for macOS Finder

> 在 macOS Finder 右键菜单添加「新建文件」，一键创建空白文本文件并直接进入重命名状态。  
> Add "New File" to macOS Finder's right-click menu — create a blank text file instantly, ready to rename.

<!-- 演示 GIF（安装完成后补录） -->

---

## 安装 · Installation

### 方法一：一键脚本（推荐）· Script (recommended)

```bash
git clone https://github.com/YOUR_USERNAME/mac-new-file.git
cd mac-new-file
bash install.sh
```

### 方法二：手动安装 · Manual

1. 下载 [NewFile.workflow.zip](../../releases/latest) 并解压  
   Download [NewFile.workflow.zip](../../releases/latest) and unzip
2. 双击 `NewFile.workflow`，点击「安装」  
   Double-click `NewFile.workflow` and click "Install"

---

## 启用 · Enable

安装后在系统设置中勾选服务 / After install, enable the service:

1. **系统设置 → 键盘 → 键盘快捷键 → 服务**  
   System Settings → Keyboard → Keyboard Shortcuts → Services
2. 在「文件和文件夹」下找到「新建文件」，勾选  
   Find "新建文件" under "Files and Folders", check to enable

**使用 / Usage：** Finder 任意目录空白处右键 → 服务 → 新建文件  
Right-click empty space in Finder → Services → 新建文件

> macOS Ventura+：右键菜单直接显示，无需展开「服务」子菜单。  
> macOS Ventura+: appears directly in right-click menu, no need to expand "Services".

---

## 权限说明 · Permissions

首次运行会弹出权限请求 / On first run, macOS will ask for:

- **辅助功能 / Accessibility**：用于触发 Finder 重命名动作（模拟 Return 键）  
  Required to trigger Finder's rename action (simulates the Return key)

前往：系统设置 → 隐私与安全性 → 辅助功能 → 允许「Automator」  
Go to: System Settings → Privacy & Security → Accessibility → allow "Automator"

---

## 卸载 · Uninstall

```bash
rm -rf ~/Library/Services/NewFile.workflow
```

---

## 技术说明 · How It Works

基于 macOS 原生 Automator Quick Action，无第三方依赖，无网络请求。  
Built with macOS native Automator Quick Action. No third-party dependencies, no network requests.

核心脚本 / Core script: [`src/new-file.sh`](src/new-file.sh)

---

## License

MIT
```

- [ ] **Step 2: 检查所有链接有效性**

确认以下两处链接格式正确：
- `[NewFile.workflow.zip](../../releases/latest)` — GitHub releases 相对路径
- `[src/new-file.sh](src/new-file.sh)` — 仓库内相对路径

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: 重写 README 为中英双语"
```

---

### Task 3: 初始化 Git 仓库并创建 GitHub Release

**Files:**
- 无新文件，操作 git 仓库和 GitHub

**Interfaces:**
- Consumes: 全部已有文件
- Produces: GitHub 仓库 URL，`v1.0.0` Release，`NewFile.workflow.zip` Asset（可追踪下载量）

- [ ] **Step 1: 初始化本地 git 仓库**

```bash
cd /Users/yechaozheng/Work/git_respository/my-sites/mac-new-file
git init
git add .
git commit -m "feat: MVP 初始版本 — Automator Quick Action 新建文件"
```

预期输出：`[main (root-commit) xxxxxxx] feat: MVP 初始版本`

- [ ] **Step 2: 在 GitHub 创建仓库**

```bash
gh repo create mac-new-file --public --description "在 macOS Finder 右键添加「新建文件」 · Add New File to macOS Finder right-click menu" --push --source .
```

预期输出：仓库 URL，形如 `https://github.com/YOUR_USERNAME/mac-new-file`

- [ ] **Step 3: 更新 README 中的 GitHub 用户名**

将 README.md 中的 `YOUR_USERNAME` 替换为实际用户名：

```bash
# 替换为实际 GitHub 用户名
sed -i '' 's/YOUR_USERNAME/实际用户名/g' README.md
git add README.md
git commit -m "docs: 更新 README 中的 GitHub 链接"
git push
```

- [ ] **Step 4: 打包 workflow 为 zip**

```bash
cd dist
zip -r NewFile.workflow.zip NewFile.workflow
cd ..
```

- [ ] **Step 5: 创建 v1.0.0 Release 并上传 Asset**

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

预期：浏览器可访问 `https://github.com/YOUR_USERNAME/mac-new-file/releases/tag/v1.0.0`，Assets 列表包含 `NewFile.workflow.zip`。

- [ ] **Step 6: 确认下载量追踪入口**

访问：`https://github.com/YOUR_USERNAME/mac-new-file/releases/tag/v1.0.0`，Asset 旁边会显示下载次数。也可用命令查询：

```bash
gh release view v1.0.0 --json assets --jq '.assets[] | {name: .name, downloadCount: .downloadCount}'
```

---

### Task 4: 录制演示素材

**Files:**
- 新增：`assets/demo.gif`（嵌入 README）
- 新增：`assets/demo-video.mp4`（小红书用，不提交到 git，体积过大）
- 新增：`assets/screenshot-*.png`（3-4 张截图）

**Interfaces:**
- Produces: `assets/demo.gif`，供 Task 5 嵌入 README

- [ ] **Step 1: 录制屏幕**

使用 QuickTime Player：
1. 打开 QuickTime → 文件 → 新建屏幕录制
2. 录制以下完整流程（30 秒内）：
   - 打开 Finder，进入任意目录
   - 空白处右键 → 服务 → 新建文件
   - 直接输入文件名（如 `hello`）→ 回车确认
   - 文件创建完成
3. 保存为 `assets/demo-source.mov`

- [ ] **Step 2: 导出竖版视频（小红书用）**

使用 QuickTime 或系统自带"照片"剪辑，裁剪为 15 秒内，导出为 `assets/demo-vertical.mp4`（9:16 比例，如 1080×1920）。此文件不提交 git。

- [ ] **Step 3: 截取关键帧截图**

从录制视频中截取 3-4 张截图，保存为：
- `assets/screenshot-rightclick.png` — 右键菜单出现「新建文件」
- `assets/screenshot-created.png` — 文件已创建进入重命名状态
- `assets/screenshot-settings.png` — 系统设置勾选服务的位置

可使用 macOS 截图工具（Shift+Cmd+4）直接截取。

- [ ] **Step 4: 转换 GIF 用于 README**

使用系统自带 `ffmpeg`（如已安装）或在线工具将 `demo-source.mov` 转为 GIF：

```bash
# 如果已安装 ffmpeg
ffmpeg -i assets/demo-source.mov -vf "fps=10,scale=600:-1:flags=lanczos" -loop 0 assets/demo.gif
```

如未安装 ffmpeg，使用 https://ezgif.com/video-to-gif 在线转换，目标：< 5MB，宽度 600px。

- [ ] **Step 5: 将 GIF 嵌入 README**

编辑 `README.md`，找到 `<!-- 演示 GIF（安装完成后补录） -->` 注释行，替换为：

```markdown
![演示 · Demo](assets/demo.gif)
```

- [ ] **Step 6: Commit**

```bash
git add assets/demo.gif assets/screenshot-*.png README.md
git commit -m "docs: 添加演示 GIF 和截图素材"
git push
```

---

### Task 5: 撰写三平台发帖文案

**Files:**
- 新增：`docs/content/xiaohongshu.md` — 小红书图文文案
- 新增：`docs/content/v2ex.md` — V2EX 帖子文案
- 新增：`docs/content/sspai.md` — 少数派 Matrix 文案

**Interfaces:**
- Consumes: GitHub Release URL（Task 3），截图（Task 4）
- Produces: 三份可直接复制粘贴发布的文案

- [ ] **Step 1: 创建 content 目录**

```bash
mkdir -p docs/content
```

- [ ] **Step 2: 写小红书文案**

新建 `docs/content/xiaohongshu.md`：

```markdown
# 小红书发帖文案

## 标题（二选一）
- Mac 终于有右键新建文件了！免费工具分享
- 用了 10 年 Mac 才发现这个缺陷，现在补上了

## 正文

每次想新建个 txt 记个东西，都要：
打开 TextEdit → 新建 → Cmd+S → 找到目标文件夹 → 保存

Windows 右键就能新建文件，Mac 为什么不行？！

今天自己做了一个免费工具，装完之后：
右键 → 新建文件 → 直接输入文件名 ✅

**安装超简单，3 步搞定：**
1. 下载 NewFile.workflow（GitHub 链接在评论区）
2. 双击安装
3. 系统设置 → 键盘 → 服务 → 勾选「新建文件」

完全免费，开源，不联网，macOS Ventura 以上可用~

## 配图顺序
1. screenshot-rightclick.png（右键菜单效果）
2. screenshot-created.png（文件创建并重命名）
3. screenshot-settings.png（系统设置勾选位置）
4. demo-vertical.mp4（演示视频，发视频笔记用）

## 话题标签
#Mac技巧 #macOS #效率工具 #程序员 #Mac用户 #生产力工具
```

- [ ] **Step 3: 写 V2EX 文案**

新建 `docs/content/v2ex.md`：

```markdown
# V2EX 发帖文案

## 节点
Apple

## 标题
[Show V2EX] 用 Automator 给 macOS Finder 加了个右键「新建文件」

## 正文

macOS Finder 一直没有 Windows 那种右键新建文件的功能，
每次都要绕一大圈，这个摩擦点烦了很久。

用 Automator Quick Action 做了个免费工具解决这个问题：

- 右键 → 服务 → 新建文件
- 在当前目录创建 `未命名.txt`，直接进入重命名状态
- 已有同名文件时自动生成 `未命名 2.txt`
- 无第三方依赖，macOS Ventura+ 可用

GitHub：https://github.com/YOUR_USERNAME/mac-new-file

欢迎提 issue 或 PR。
```

- [ ] **Step 4: 写少数派 Matrix 文案**

新建 `docs/content/sspai.md`：

```markdown
# 少数派 Matrix 文案

## 标题
给 macOS Finder 补上右键「新建文件」功能 — 免费 Automator 工具

## 正文（约 500 字）

macOS 的 Finder 有一个长期被吐槽的缺陷：右键菜单没有「新建文件」选项。
Windows 用户切换到 Mac 后，这个习惯动作会让人反复踩坑。

每次想新建一个空白文本文件，标准流程是：
打开 TextEdit（或 VS Code）→ 新建文档 → Command+S → 导航到目标目录 → 输入文件名 → 保存。
五步操作，换来一个空文件。

### 解决方案

用 macOS 自带的 Automator 制作了一个 Quick Action（服务菜单项），
安装后在 Finder 任意目录右键，点击「新建文件」即可：

1. 在当前目录创建 `未命名.txt`
2. 自动选中文件并进入重命名状态
3. 已有同名文件时自动递增（`未命名 2.txt`、`未命名 3.txt`……）

### 安装方法

**方法一（推荐）：**
```bash
git clone https://github.com/YOUR_USERNAME/mac-new-file.git
cd mac-new-file
bash install.sh
```

**方法二：** 在 [GitHub Releases](https://github.com/YOUR_USERNAME/mac-new-file/releases/latest) 下载 `NewFile.workflow.zip`，解压后双击安装。

安装后需在「系统设置 → 键盘 → 键盘快捷键 → 服务」中勾选「新建文件」启用。
首次运行会请求辅助功能权限（用于触发 Finder 重命名动作），在「隐私与安全性 → 辅助功能」允许即可。

### 技术细节

基于 Automator Quick Action + Shell 脚本 + AppleScript，
无第三方依赖，不联网，支持 macOS Ventura（13）及以上。

完全开源免费：https://github.com/YOUR_USERNAME/mac-new-file

## 配图
- screenshot-rightclick.png
- screenshot-created.png  
- screenshot-settings.png
```

- [ ] **Step 5: 将三份文案中的 YOUR_USERNAME 替换为实际 GitHub 用户名**

```bash
# 替换为实际用户名
GITHUB_USER="实际用户名"
sed -i '' "s/YOUR_USERNAME/$GITHUB_USER/g" docs/content/v2ex.md
sed -i '' "s/YOUR_USERNAME/$GITHUB_USER/g" docs/content/sspai.md
```

- [ ] **Step 6: Commit**

```bash
git add docs/content/
git commit -m "docs: 添加三平台发帖文案"
git push
```

---

### Task 6: 发布三平台内容

**Files:**
- 无代码变更，纯发布操作

**Interfaces:**
- Consumes: 三份文案（Task 5），截图和视频素材（Task 4），GitHub Release URL（Task 3）

- [ ] **Step 1: 发布小红书**

1. 打开小红书 App
2. 选择发布视频笔记，上传 `assets/demo-vertical.mp4`
3. 按 `docs/content/xiaohongshu.md` 填写标题和正文
4. 评论区补充 GitHub Release 链接
5. 添加话题标签，发布时间选工作日 20:00-22:00

- [ ] **Step 2: 发布 V2EX**

1. 登录 V2EX，进入 Apple 节点
2. 按 `docs/content/v2ex.md` 发帖，配上 `screenshot-rightclick.png`

- [ ] **Step 3: 发布少数派 Matrix**

1. 登录少数派，进入 Matrix 创作者中心
2. 按 `docs/content/sspai.md` 发布快讯，配上三张截图

- [ ] **Step 4: 记录发布链接**

新建 `docs/content/published-links.md`：

```markdown
# 已发布链接

| 平台 | 链接 | 发布时间 |
|------|------|----------|
| 小红书 | （填入帖子链接） | 2026-07-xx |
| V2EX | （填入帖子链接） | 2026-07-xx |
| 少数派 | （填入帖子链接） | 2026-07-xx |
| GitHub Release | https://github.com/YOUR_USERNAME/mac-new-file/releases/tag/v1.0.0 | 2026-07-08 |
```

```bash
git add docs/content/published-links.md
git commit -m "docs: 记录三平台发布链接"
git push
```

- [ ] **Step 5: 验证下载量追踪**

发布 24 小时后检查 Release Asset 下载量：

```bash
gh release view v1.0.0 --json assets --jq '.assets[] | {name: .name, downloadCount: .downloadCount}'
```

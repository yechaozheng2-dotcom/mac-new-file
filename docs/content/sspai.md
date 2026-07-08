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
git clone https://github.com/yechaozheng2-dotcom/mac-new-file.git
cd mac-new-file
bash install.sh
```

**方法二：** 在 [GitHub Releases](https://github.com/yechaozheng2-dotcom/mac-new-file/releases/latest) 下载 `NewFile.workflow.zip`，解压后双击安装。

安装后需在「系统设置 → 键盘 → 键盘快捷键 → 服务」中勾选「新建文件」启用。
首次运行会请求辅助功能权限（用于触发 Finder 重命名动作），在「隐私与安全性 → 辅助功能」允许即可。

### 技术细节

基于 Automator Quick Action + Shell 脚本 + AppleScript，
无第三方依赖，不联网，支持 macOS Ventura（13）及以上。

完全开源免费：https://github.com/yechaozheng2-dotcom/mac-new-file

## 配图
- screenshot-rightclick.png
- screenshot-created.png
- screenshot-settings.png

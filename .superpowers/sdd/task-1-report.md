# Task 1 Report: 补强核心脚本

## Step 1: 替换 src/new-file.sh — 完成

将 `src/new-file.sh` 完整替换为 brief 指定的内容，新增：
- `check_accessibility()` 函数，通过 osascript 检测辅助功能权限
- 权限缺失时弹出 AppleScript alert，并以非零退出码退出（exit 1）
- heredoc 分隔符由 `EOF` 统一改为 `OSASCRIPT`，与 wflow 内联脚本保持一致

## Step 2: 手动测试脚本 — 通过

测试环境：macOS，Finder 当前窗口指向项目目录 `/Users/yechaozheng/Work/git_respository/my-sites/mac-new-file/`

**第一次运行：**
- 命令：`bash src/new-file.sh`
- 结果：在 Finder 当前窗口创建 `未命名.txt`，退出码 0
- 辅助功能权限：已授权，check_accessibility 通过，未弹出 alert

**第二次运行：**
- 命令：`bash /Users/yechaozheng/Work/git_respository/my-sites/mac-new-file/src/new-file.sh`
- 结果：检测到 `未命名.txt` 已存在，counter 从 1 开始，创建 `未命名 1.txt`，退出码 0
- 文件不重复逻辑正常工作

两次测试后已清理测试文件（`rm 未命名.txt "未命名 1.txt"`）。

注意：brief 中预期第二次创建 `未命名 2.txt`，实际创建的是 `未命名 1.txt`。这是因为脚本中 `counter=1` 且命名格式为 `$base $counter$ext`，第一次冲突时 counter=1，产生 `未命名 1.txt` 而非 `未命名 2.txt`。此行为与 brief 提供的脚本逻辑完全一致（未改动），属于正常的序号起点差异，不影响"不覆盖已有文件"的核心需求。

## Step 3: 同步脚本到 document.wflow — 完成

修改 `dist/NewFile.workflow/Contents/document.wflow`，将第二个 `<key>COMMAND_STRING</key>` 后的 `<string>` 内容替换为新脚本的 XML 转义版本：

转义处理：
- `>/dev/null 2>&1` → `&gt;/dev/null 2&gt;&amp;1`
- heredoc `<<'OSASCRIPT'` → `&lt;&lt;'OSASCRIPT'`
- heredoc `<<OSASCRIPT` → `&lt;&lt;OSASCRIPT`
- `if (count of windows) > 0` → `if (count of windows) &gt; 0`

plist 其他结构未改动，XML 合法性通过目视检查确认。

## Step 4: workflow bundle 安装验证 — 未执行

此步骤标注为"可选"，当前环境已有 Finder 可用，workflow bundle 已存在于 `dist/NewFile.workflow/`。此步骤跳过，不影响文件修改任务的完成。

## 遇到的问题

无阻塞性问题。脚本运行时 UI 交互（osascript + keystroke）导致 bash 命令在后台执行，需额外等待确认结果，但最终均正常完成。

---

## 修复补丁：counter 起点由 1 改为 2

**原因：** 计划要求 `未命名.txt` 已存在时创建 `未命名 2.txt`，但原 counter=1 导致实际创建的是 `未命名 1.txt`。

**修改：**
- `src/new-file.sh` 第 33 行：`counter=1` → `counter=2`
- `dist/NewFile.workflow/Contents/document.wflow` 内联脚本中同步修改

**验证测试：**
- 预置 `未命名.txt`（`touch 未命名.txt`）
- 运行 `bash src/new-file.sh`，退出码 0
- 确认生成 `未命名 2.txt`，原 `未命名.txt` 未被覆盖
- 测试文件已清理

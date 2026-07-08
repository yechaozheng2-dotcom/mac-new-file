# Task 1 Brief: 补强核心脚本

## 背景
这是 mac-new-file 项目的第一个 Task，补强已存在的 Automator Quick Action 脚本。

## 工作目录
/Users/yechaozheng/Work/git_respository/my-sites/mac-new-file

## Global Constraints
- macOS 目标版本：Ventura（13）及以上
- 不引入任何第三方依赖，全程使用系统自带工具
- 脚本必须无需 sudo 可运行
- workflow bundle 内联脚本与 `src/new-file.sh` 内容保持一致

## 要修改的文件
- Modify: `src/new-file.sh`
- Modify: `dist/NewFile.workflow/Contents/document.wflow`

## 产出
健壮的 `new-file.sh`，权限失败时弹出 AppleScript alert 并退出码非零。

## 具体步骤

### Step 1: 替换 `src/new-file.sh` 为以下内容（完整替换）

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

### Step 2: 手动测试脚本
运行 `bash src/new-file.sh` 两次，确认：
- 第一次：在 Finder 当前窗口创建 `未命名.txt` 并进入重命名状态
- 第二次：创建 `未命名 2.txt`（不覆盖已有文件）

在报告中说明测试结果。

### Step 3: 同步脚本到 document.wflow
打开 `dist/NewFile.workflow/Contents/document.wflow`，找到第二个 `<key>COMMAND_STRING</key>` 后的 `<string>...</string>` 标签（第一个是空 dict，第二个才是脚本内容），将其内容替换为 Step 1 脚本的 XML 转义版本：
- `<` → `&lt;`
- `>` → `&gt;`
- `&` → `&amp;`
- heredoc 的 `<<'OSASCRIPT'` 写成 `&lt;&lt;'OSASCRIPT'`
- heredoc 的 `<<OSASCRIPT` 写成 `&lt;&lt;OSASCRIPT`

注意：只替换 `<string>` 标签的内容，不要改动 plist 的其他结构。

### Step 4: 验证 workflow bundle（可选，如有 Finder 可手动测试）
```bash
cp -R dist/NewFile.workflow ~/Library/Services/
/System/Library/CoreServices/pbs -flush 2>/dev/null || true
```

注意：此项目目前**没有 git 仓库**，不需要 commit，只需完成文件修改。

## 报告要求
将完整报告写入 `/Users/yechaozheng/Work/git_respository/my-sites/mac-new-file/.superpowers/sdd/task-1-report.md`，包含：
1. 每个 Step 的完成状态
2. Step 2 的测试结果描述
3. document.wflow 修改说明
4. 遇到的任何问题

最后仅返回：状态（DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED）+ 一句话测试摘要 + 任何关注点。

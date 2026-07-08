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
counter=2
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

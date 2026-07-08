# Mac 快速新建文件 · New File for macOS Finder

> 在 macOS Finder 右键菜单添加「新建文件」，一键创建空白文本文件并直接进入重命名状态。  
> Add "New File" to macOS Finder's right-click menu — create a blank text file instantly, ready to rename.

<!-- 演示 GIF（安装完成后补录） -->

---

## 安装 · Installation

### 方法一：一键脚本（推荐）· Script (recommended)

```bash
git clone https://github.com/yechaozheng2-dotcom/mac-new-file.git
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

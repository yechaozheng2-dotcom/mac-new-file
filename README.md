# New File for macOS Finder

> Add a "New File" option to macOS Finder's right-click menu — create a blank text file instantly, ready to rename.

<!-- Demo GIF (add after recording) -->

---

## Installation

### Option 1: Script (recommended)

```bash
git clone https://github.com/yechaozheng2-dotcom/mac-new-file.git
cd mac-new-file
bash install.sh
```

### Option 2: Manual

1. Download [NewFile.workflow.zip](../../releases/latest) and unzip
2. Double-click `NewFile.workflow` and click "Install"

---

## Enable

After installation, enable the service in System Settings:

1. **System Settings → Keyboard → Keyboard Shortcuts → Services**
2. Under "General", find **New File** and check to enable

**Usage:** Right-click any file or folder in Finder → Quick Actions → New File

---

## Permissions

On first run, macOS will ask for Accessibility permission:

- Go to **System Settings → Privacy & Security → Accessibility**
- Allow **Automator**

---

## Uninstall

```bash
rm -rf ~/Library/Services/NewFile.workflow
```

---

## How It Works

Built with macOS native Automator Quick Action. No third-party dependencies, no network requests.

Core script: [`src/new-file.sh`](src/new-file.sh)

---

## Requirements

macOS Ventura (13) or later

---

## License

MIT

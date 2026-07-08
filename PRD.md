# Mac 快速新建文件工具 — 产品需求文档

## 背景与痛点

macOS Finder 右键菜单没有"新建文本文件"选项（Windows 有），用户每次想新建一个空白 .txt / .md 文件，必须：
1. 打开文本编辑器（TextEdit / VS Code 等）
2. 新建文件
3. Command+S 另存到目标目录

每天重复几十次，是 Mac 用户高频抱怨的微摩擦。V2EX、知乎等国内社区有大量相关讨论。

---

## 产品目标

在 macOS Finder 右键菜单中加入「新建文件」入口，用户在任意目录右键即可快速新建指定类型的空白文件，直接进入命名状态。

---

## 功能需求

### MVP（第一阶段，Automator 实现，零成本）

- 右键菜单新增「新建文本文件」
- 在当前目录创建 `未命名.txt`，自动进入重命名状态
- 支持在 Finder 空白处右键、在文件夹图标上右键

### V2（第二阶段，独立 App，付费）

- 支持多种文件类型：`.txt` / `.md` / `.json` / `.csv` / 自定义
- 可配置默认文件名模板（如 `YYYY-MM-DD.md`）
- 菜单栏图标 + 设置界面
- App Store 上架，一次性买断 $1.99 / ¥6

---

## 技术方案

### MVP 方案：Automator Quick Action

```
工具：macOS 自带 Automator
类型：Quick Action（服务）
触发：Finder 右键菜单
实现：Shell 脚本在当前目录创建空文件并触发重命名
分发：导出 .workflow 文件，GitHub 免费下载
```

核心脚本逻辑：
```bash
# 获取当前 Finder 目录
dir=$(osascript -e 'tell app "Finder" to get POSIX path of (target of front window as alias)')
# 创建文件
touch "$dir/未命名.txt"
# 触发 Finder 重命名（模拟 Enter 键）
open "$dir/未命名.txt"
```

### V2 方案：Swift + FinderSync Extension

```
语言：Swift
框架：FinderSync Extension（官方 API，支持右键菜单注入）
需要：Apple 开发者账号 $99/年
分发：App Store
```

---

## 竞品分析

| 工具 | 平台 | 价格 | 缺点 |
|------|------|------|------|
| New File Menu | App Store | $4.99 | 英文界面，国内用户少 |
| XtraFinder | 免费 | 免费 | 已停止更新，不支持新 macOS |
| PopClip 插件 | 付费 | 需购买 PopClip | 依赖第三方 |
| 手动 Automator | 自己配置 | 免费 | 需要技术门槛，普通用户做不了 |

**机会点**：没有一个简单、免费、中文友好、支持新版 macOS 的解决方案。

---

## 变现路径

1. **MVP 阶段**：GitHub 开源免费下载，积累用户口碑
2. **V2 阶段**：App Store 付费版 $1.99（买断），支持自定义模板等高级功能
3. **后续**：小红书 / V2EX / 少数派投稿引流，靠口碑扩散

---

## 开发优先级

| 阶段 | 工作量 | 收益 |
|------|--------|------|
| MVP（Automator） | 2-4 小时 | 验证需求，积累 GitHub Star |
| V2（Swift App） | 1-2 周 | App Store 变现 |

---

## 参考资料

- V2EX 原始讨论：https://www.v2ex.com/t/1224166
- Apple FinderSync Extension 文档：https://developer.apple.com/documentation/findersync
- Automator Quick Action 教程：搜索 "macOS Automator Quick Action new file"

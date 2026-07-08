# Mac 快速新建文件工具

## 项目简介

解决 macOS Finder 没有"右键新建文件"的高频痛点。分两阶段：
1. **MVP**：Automator Quick Action，零成本，快速验证需求
2. **V2**：Swift App + FinderSync Extension，App Store 上架变现

## 当前阶段

**MVP 阶段** — 用 Automator 做一个 Quick Action，导出 .workflow 文件发布到 GitHub。

## 技术栈

- MVP：macOS Automator + Shell 脚本 + AppleScript
- V2：Swift 5，FinderSync Extension，SwiftUI

## 关键文件

- `PRD.md` — 完整产品需求文档
- `src/` — 源码目录（待创建）
- `dist/` — 打包产物（待创建）

## 第一步任务

1. 用 Automator 创建 Quick Action，实现右键新建 .txt 文件
2. 测试：在 Finder 任意目录右键能看到"新建文本文件"
3. 导出为 `NewFile.workflow`
4. 写安装说明 README

## 注意事项

- MVP 不需要 Apple 开发者账号，完全免费
- V2 需要 $99/年 开发者账号才能上 App Store
- 目标用户：国内 Mac 用户，中文界面友好

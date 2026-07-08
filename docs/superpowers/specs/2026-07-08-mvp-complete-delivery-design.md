# MVP 完整交付设计

**日期：** 2026-07-08  
**目标：** Automator workflow 发布 + 三平台内容引流，以 GitHub Release Asset 500 次下载为成功标准

---

## 一、整体结构

MVP 完整交付分三个层次：

| 层次 | 内容 | 目的 |
|------|------|------|
| 产品层 | workflow 脚本 + bundle + 安装脚本 | 可用、健壮、无门槛安装 |
| 发布层 | GitHub 仓库 + Release + 中英双语 README | 可追踪下载量，对外可信度 |
| 内容层 | 演示素材 + 三平台发帖 | 引流，驱动 500 次下载 |

---

## 二、产品层

### 目录结构

```
mac-new-file/
├── src/
│   └── new-file.sh          # 核心脚本
├── dist/
│   └── NewFile.workflow/
│       └── Contents/
│           ├── Info.plist   # 服务声明，菜单名"新建文件"
│           └── document.wflow  # Automator 动作（内联脚本）
├── docs/
│   └── superpowers/specs/   # 设计文档
├── install.sh               # 一键安装脚本
└── README.md                # 中英双语
```

### 核心脚本（`src/new-file.sh`）

职责：
1. 获取 Finder 最前窗口路径，无窗口时降级到桌面
2. 生成不重复文件名（`未命名.txt` → `未命名 2.txt` → …）
3. 创建空文件
4. 在 Finder 中选中文件并触发重命名（模拟 Return 键）
5. 辅助功能权限未授权时，弹出友好提示而不是静默失败

### workflow bundle

`document.wflow` 内联脚本内容与 `src/new-file.sh` 保持一致。MVP 阶段手动同步，不引入构建脚本。

### `install.sh`

三步，无需 sudo：
1. 复制 `dist/NewFile.workflow` 到 `~/Library/Services/`
2. 执行 `pbs -flush` 刷新 Services 注册表
3. 打印后续操作步骤（如何在系统设置中勾选启用）

---

## 三、发布层

### README 结构（中英双语，中文在前）

1. 顶部演示 GIF（安装完成后补录）
2. 一句话痛点描述
3. 安装方式（脚本一键 + 手动双击两种）
4. 使用步骤（在系统设置勾选服务）
5. 权限说明（截图标注辅助功能授权位置）
6. 卸载方法
7. 英文版（同等内容，英文关键词便于 SEO）

### GitHub Release 流程

1. 打 tag `v1.0.0`
2. 将 `dist/NewFile.workflow` 压缩为 `NewFile.workflow.zip` 作为 Release Asset
3. Release notes 中文撰写，包含安装步骤摘要

**下载量追踪：** GitHub Release Asset 下载计数即为"500 次"指标的数据源，可通过 GitHub API 或仓库 Insights 查看。

---

## 四、内容层

### 素材制作（前置，所有平台共用）

| 素材 | 规格 | 用途 |
|------|------|------|
| 屏幕录像 | QuickTime，30 秒内，横版 | 剪辑源文件 |
| 竖版短视频 | 15 秒，9:16 | 小红书 |
| 关键帧截图 | 3-4 张 | 小红书图文、V2EX 配图 |
| 横版 GIF | 循环，<5MB | GitHub README |

录制内容：打开 Finder → 空白处右键 → 服务 → 新建文件 → 直接输入文件名 → 回车确认。

### 小红书

- 形式：15 秒竖版视频 + 图文
- 标题方向：突出痛点共鸣，例如"Mac 终于有右键新建文件了！免费工具分享"
- 正文结构：痛点 → 解决方案 → 3 步安装 → GitHub 链接
- 发布时间：工作日晚 8-10 点

### V2EX

- 节点：`Apple`
- 标题：`[Show V2EX] macOS Finder 右键新建文件 — 免费 Automator 工具`
- 正文：简短，直接给 GitHub Release 链接 + 一句话说明 + 演示截图

### 少数派

- 形式：Matrix 快讯（创作者社区，无需编辑审核）
- 长度：500 字左右
- 内容：使用场景介绍 + 安装说明 + 演示截图
- 附 GitHub Release 链接

---

## 五、成功标准

- **核心指标：** GitHub Release Asset（`NewFile.workflow.zip`）下载量达到 500 次
- **时间预期：** 三平台发布后 1 个月内
- **数据查看：** GitHub 仓库 → Releases → 对应 Asset 下载计数

---

## 六、不在范围内

- V2 Swift App 开发
- 多文件类型支持
- 自定义文件名模板
- App Store 上架

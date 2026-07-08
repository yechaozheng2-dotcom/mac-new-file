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

GitHub：https://github.com/yechaozheng2-dotcom/mac-new-file

欢迎提 issue 或 PR。

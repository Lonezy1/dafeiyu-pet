# 大肥鱼桌宠 · 一键安装

在 Windows 上一键安装并启动「大肥鱼」桌宠（[PC2005-cloud/dsh-pet](https://github.com/PC2005-cloud/dsh-pet) 的 **standalone 独立模式**，不需要安装 DSH）。

## 一句话安装（推荐）

对豆包（或任意 AI 助手）说：

> 帮我在电脑上安装大肥鱼桌宠，运行这个命令：`powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://cdn.jsdelivr.net/gh/Lonezy1/dafeiyu-pet@main/install.ps1 | iex"`

或者自己打开 **PowerShell**，粘贴一行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://cdn.jsdelivr.net/gh/Lonezy1/dafeiyu-pet@main/install.ps1 | iex"
```

> 脚本仅 3KB，走 jsDelivr CDN（国内可访问）；真正的安装包全部走国内 npmmirror 镜像。

## 手动安装

1. 下载本仓库的 `install.bat` 和 `install.ps1`，**放在同一个文件夹**
2. 双击 `install.bat`

脚本会自动完成：

1. 检测 Node.js（没有则自动下载便携版，约 35MB，免管理员）
2. 配置 npm 与 Electron 国内镜像
3. 安装 `dsh-pet`（约 62MB，已安装则自动跳过）
4. 在桌面创建「启动大肥鱼.bat」
5. 启动桌宠（首次会下载 Electron 运行时约 115MB，之后不再下载）

## 日常使用

- **启动**：双击桌面的「启动大肥鱼.bat」（无需联网下载）
- **关闭**：在黑色命令行窗口按 `Ctrl + C`，或直接关闭窗口
- **开机自启**：按 `Win + R` 输入 `shell:startup`，把桌面启动器拖进该文件夹

## 说明

- 总下载量约 200MB（Node 视情况 + dsh-pet 62MB + Electron 115MB），全部走国内镜像
- standalone 模式仅保留动画、拖拽、多开等观赏互动；余额、碎碎念、AI 对话等依赖 DSH 的功能不可用
- 动画素材版权归原项目作者所有，**禁止商用**，二创分发须署名 https://github.com/PC2005-cloud/dsh-pet
- 本仓库只是安装脚本，桌宠本体来自上游开源项目，使用中遇到问题请参考原项目

## 致谢

- 桌宠本体：[PC2005-cloud/dsh-pet](https://github.com/PC2005-cloud/dsh-pet)
- 大肥鱼形象：DeepSeek 社区二创

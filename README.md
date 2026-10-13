# serverspec — 服务器运行说明

本目录在服务器上映射为 **`~/.serverspec`**（与仓库 `spec/serverspec/` 同一内容，便于固定路径加载 `sp` 等脚本）。

## 映射到主目录（一次性）

```bash
cd /path/to/nginxRouter/spec/serverspec
./link-home.sh
```

然后在 `~/.bashrc` 末尾加入：

```bash
[ -f "$HOME/.serverspec/sp.sh" ] && . "$HOME/.serverspec/sp.sh"
```

执行 `source ~/.bashrc` 后，终端输入 **`sp`** 打开快速启动菜单（Codex / Claude Code / ngxmgr / Mihomo）。

| 路径 | 说明 |
|------|------|
| `~/.serverspec/sp.sh` | 快速启动菜单（符号链接指向仓库内本文件） |
| `~/.serverspec/spec/` | 运行规范文档 |
| `~/.serverspec/env/` | 本地 env（不提交 Git，若存在） |

## 文档

- [工具集与外网访问](spec/01-toolkit-and-internet.md)：使用 `gh`、`devtools` 文件说明与外网访问方法。
- [本工程 Python 环境](spec/02-python-environment.md)：平台后端及部署应用使用的 Python 环境。

GitHub 变量可放在 `spec/serverspec/env/.env` 或上级 `env/.env`。环境变量文件不提交到 Git 或 GitHub。

上级索引见 [spec/README.md](../README.md)。

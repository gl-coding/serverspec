# Spec 01 — 工具集与外网访问

## GitHub CLI

服务器操作 GitHub 使用 `gh`：查看仓库、Issue、PR、Actions，以及任务需要的 GitHub 操作。

2026-10-09 已安装 `gh 2.45.0`，并为服务器 `root` 用户保存持久登录，GitHub 用户为 `gl-coding`。GitHub 变量 `GITHUB_PAT_TOKEN` 放在 `spec/serverspec/env/.env`，从上级工程 `env/.env` 复制，不在规范中记录令牌值。`gh` 不会自动读取该文件或识别这个变量名；本次已通过 `gh auth login --with-token` 保存登录。

```bash
gh --version
gh auth status
gh api user --jq .login
gh repo view gl-coding/nginxRouter
gh pr list --repo gl-coding/nginxRouter
gh issue list --repo gl-coding/nginxRouter
gh run list --repo gl-coding/nginxRouter
```

## devtools 文件

环境变量文件 `spec/serverspec/env/.env`、`spec/serverspec/env/.env.*` 不提交到 Git 或 GitHub，变量值不写入文档。

| 路径 | 用途 |
|---|---|
| `devtools/codex/env.sh` | 为当前 shell 设置代理环境变量 |
| `devtools/codex/run.sh` | 加载代理、切到工程根目录并运行 Codex，透传参数 |
| `devtools/codex/exec.sh` | 加载代理、切到工程根目录并运行 `codex exec`，透传参数 |
| `devtools/codex/README.md` | 工程内 Codex 使用说明 |
| `devtools/claude/run.sh` | DeepSeek 后端的 Claude Code（读 `env/.env.claude.local`） |
| `devtools/claude/README.md` | Claude Code 安装与 Key 说明 |
| `devtools/opencode/run.sh` | DeepSeek 后端的 OpenCode（读 `env/.env.opencode.local` 或共用 Claude 的 Key） |
| `devtools/opencode/README.md` | OpenCode 安装与默认模型说明 |
| `~/.serverspec/sp.sh` | 终端 `sp` 快速启动菜单（映射自 `spec/serverspec/sp.sh`，见 `spec/serverspec/link-home.sh`） |
| `devtools/mihomo/run.sh` | 启动本目录的 Mihomo 二进制与配置 |
| `devtools/mihomo/mihomo` | 本机代理二进制 |
| `devtools/mihomo/iKuuu_V2.yaml` | 默认代理配置，含私有节点信息，不提交 Git |
| `devtools/mihomo/README.md` | 代理启动与使用说明 |
| `devtools/vscode/README.md` | VS Code Remote SSH 连接说明 |

`devtools/vscode/README.md` 提到的 `vscode.sh` 当前目录中不存在。

## 外网访问方法

本工程通过本机 Mihomo 提供出站代理：HTTP / Mixed 代理端口 `127.0.0.1:7890`，控制 API 为 `127.0.0.1:9090`。7890 用于工具访问外网，9090 用于管理代理。

需要启动代理且确认尚未运行时：

```bash
cd /root/nginxRouter
./devtools/mihomo/run.sh
```

该命令在前台运行。默认读取 `devtools/mihomo/iKuuu_V2.yaml`；可通过 `MIHOMO_CONFIG` 指定其他配置路径。已有代理运行时无需重复启动。

在另一个终端加载代理并使用外网工具：

```bash
cd /root/nginxRouter
source devtools/codex/env.sh
gh api user --jq .login
```

`env.sh` 在变量未设置或为空时设置以下默认值；已有值保留：

```text
http_proxy=http://127.0.0.1:7890
https_proxy=http://127.0.0.1:7890
ALL_PROXY=http://127.0.0.1:7890
```

变量作用于当前 shell 及随后启动的工具，退出终端后不会自动保留。Codex 的两个包装脚本会自行加载 `env.sh`。

## 软件源直连

本次安装 `gh` 时，腾讯云 Ubuntu 软件源经代理返回 502，apt 直连后安装成功。遇到相同情况，可仅对该次 apt 命令指定直连：

```bash
apt-get -o Acquire::http::Proxy=DIRECT -o Acquire::https::Proxy=DIRECT update
apt-get -o Acquire::http::Proxy=DIRECT -o Acquire::https::Proxy=DIRECT install -y gh
```

该配置只作用于本次命令，不修改其他工具的代理设置。

# Spec 02 — 本工程 Python 环境

## 平台后端

AI Desk 平台后端、独立 MCP 服务、`ngx` 和 `ngx-server` 使用：

```text
/root/nginxRouter/platform/backend/.venv
```

2026-10-10 起使用系统 **`/usr/bin/python3`**（与共享运行时一致，当前为 3.12.3）。依赖清单为 `/root/nginxRouter/platform/backend/requirements.txt`（含 `psutil` 等系统信息采集依赖）。

直接使用解释器：

```bash
cd /root/nginxRouter/platform/backend
/root/nginxRouter/platform/backend/.venv/bin/python --version
/root/nginxRouter/platform/backend/.venv/bin/python manage.py check
```

交互式激活：

```bash
source /root/nginxRouter/platform/backend/.venv/bin/activate
```

安装脚本生成的 `nginxmgr.service` 使用该环境的 Gunicorn，`mcp-server.service` 使用该环境的 Python。

## 平台部署的业务应用

Django / 全栈业务应用使用共享环境：

```text
/root/app/.shared_venv
```

2026-10-10 核实 Python 版本为 3.12.3（与平台后端 venv 同源解释器）。

```bash
/root/app/.shared_venv/bin/python --version
```

部署引擎使用该环境的 Python 执行迁移和静态文件收集，使用同环境的 Gunicorn 启动应用。

应用固定依赖清单源码为 `/root/nginxRouter/platform-requirements.txt`，运行副本为 `/root/app/platform-requirements.txt`。

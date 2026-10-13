# 由 sp() 每次 source，更新菜单后无需重新 login，直接再运行 sp 即可
_nginxrouter_root() {
  local spec_dir
  spec_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  cd "$spec_dir/../.." && pwd -P
}

_sp_run() {
  local root
  root="$(_nginxrouter_root)"
  local codex_runner="$root/devtools/codex/run.sh"
  local codex_resume="$root/devtools/codex/resume.sh"
  local claude_runner="$root/devtools/claude/run.sh"
  local opencode_runner="$root/devtools/opencode/run.sh"
  local opencode_resume="$root/devtools/opencode/resume.sh"
  local mihomo_runner="$root/devtools/mihomo/run.sh"
  local sp_choice

  printf '%s\n' \
    'Codex（1–4 含 git 友好：danger-full-access + 按需确认）：' \
    "  1) 启动新会话         $codex_runner --git-friendly" \
    "  2) 恢复最近会话       $codex_resume --last" \
    "  3) 选择历史会话       $codex_resume" \
    "  4) 查看全部会话       $codex_resume --all" \
    'Claude Code（DeepSeek）：' \
    "  5) 启动 Claude Code   $claude_runner" \
    "  6) 继续最近对话       $claude_runner --continue" \
    "  7) 选择历史会话       $claude_runner --resume" \
    'OpenCode（DeepSeek）：' \
    "  8) 启动 OpenCode TUI   $opencode_runner" \
    "  9) 继续最近会话       $opencode_runner --continue" \
    " 10) 选择历史会话       $opencode_resume" \
    " 11) OpenCode Web 界面   $opencode_runner web" \
    " 12) 列出 OpenCode 会话   $opencode_runner session list" \
    'ngxmgr / 平台：' \
    " 13) 平台 restart        $root/scripts/ngx-server restart" \
    " 14) 前端 build+reload  $root/scripts/ngx-server restart frontend" \
    ' 15) 重启 ngxmgr 后端       systemctl restart nginxmgr' \
    ' 16) 重启 ngxmgr 与 MCP     systemctl restart nginxmgr mcp-server' \
    ' 17) 查看 ngxmgr 状态       systemctl status nginxmgr mcp-server --no-pager' \
    '代理：' \
    " 18) 启动 Mihomo（前台） $mihomo_runner" \
    '  0) 退出'
  read -r -p '请选择 [0-18]：' sp_choice || return 0

  case "$sp_choice" in
    0|'') return 0 ;;
    1)
      [[ -x "$codex_runner" ]] || { printf '不可执行：%s\n' "$codex_runner" >&2; return 1; }
      "$codex_runner" --git-friendly
      ;;
    2|3|4)
      [[ -x "$codex_resume" ]] || { printf '不可执行：%s\n' "$codex_resume" >&2; return 1; }
      case "$sp_choice" in
        2) "$codex_resume" --last ;;
        3) "$codex_resume" ;;
        4) "$codex_resume" --all ;;
      esac
      ;;
    5|6|7)
      [[ -x "$claude_runner" ]] || { printf '不可执行：%s\n' "$claude_runner" >&2; return 1; }
      case "$sp_choice" in
        5) "$claude_runner" ;;
        6) "$claude_runner" --continue ;;
        7) "$claude_runner" --resume ;;
      esac
      ;;
    8|9|10|11|12)
      [[ -x "$opencode_runner" ]] || { printf '不可执行：%s\n' "$opencode_runner" >&2; return 1; }
      case "$sp_choice" in
        8) "$opencode_runner" ;;
        9) "$opencode_runner" --continue ;;
        10)
          [[ -x "$opencode_resume" ]] || { printf '不可执行：%s\n' "$opencode_resume" >&2; return 1; }
          "$opencode_resume"
          ;;
        11) "$opencode_runner" web ;;
        12) "$opencode_runner" session list ;;
      esac
      ;;
    13)
      [[ -x "$root/scripts/ngx-server" ]] || { printf '缺少 %s\n' "$root/scripts/ngx-server" >&2; return 1; }
      "$root/scripts/ngx-server" restart
      ;;
    14)
      [[ -x "$root/scripts/ngx-server" ]] || { printf '缺少 %s\n' "$root/scripts/ngx-server" >&2; return 1; }
      "$root/scripts/ngx-server" restart frontend
      ;;
    15) systemctl restart nginxmgr ;;
    16) systemctl restart nginxmgr mcp-server ;;
    17) systemctl status nginxmgr mcp-server --no-pager ;;
    18) "$mihomo_runner" ;;
    *) printf '%s\n' '无效选项，请重新运行 sp。' >&2; return 1 ;;
  esac
}

_sp_run

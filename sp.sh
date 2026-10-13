# nginxRouter 快速启动菜单（安装见 spec/serverspec/link-home.sh）
# ~/.bashrc: [ -f "$HOME/.serverspec/sp.sh" ] && . "$HOME/.serverspec/sp.sh"

_nginxrouter_root() {
  local spec_dir
  # ~/.serverspec 常为指向 spec/serverspec/ 的符号链接，须 pwd -P 才能得到仓库根
  spec_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  cd "$spec_dir/../.." && pwd -P
}

sp() {
  local root
  root="$(_nginxrouter_root)"
  local codex_runner="$root/devtools/codex/run.sh"
  local claude_runner="$root/devtools/claude/run.sh"
  local opencode_runner="$root/devtools/opencode/run.sh"
  local opencode_resume="$root/devtools/opencode/resume.sh"
  local mihomo_runner="$root/devtools/mihomo/run.sh"
  local sp_choice

  printf '%s\n' \
    'Codex 命令：' \
    "  1) 启动新会话         $codex_runner" \
    "  2) 恢复最近会话       $codex_runner resume --last" \
    "  3) 选择历史会话       $codex_runner resume" \
    "  4) 查看全部会话       $codex_runner resume --all" \
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
    'ngxmgr 服务命令：' \
    ' 13) 重启 ngxmgr 后端       systemctl restart nginxmgr' \
    ' 14) 重启 ngxmgr 与 MCP     systemctl restart nginxmgr mcp-server' \
    ' 15) 查看 ngxmgr 服务状态   systemctl status nginxmgr mcp-server --no-pager' \
    '代理命令：' \
    " 16) 启动 Mihomo 代理（前台） $mihomo_runner" \
    '  0) 退出'
  read -r -p '请选择 [0-16]：' sp_choice || return 0

  case "$sp_choice" in
    0|'') return 0 ;;
    1|2|3|4)
      if [[ ! -x "$codex_runner" ]]; then
        printf '启动脚本不存在或不可执行：%s\n' "$codex_runner" >&2
        return 1
      fi
      case "$sp_choice" in
        1) "$codex_runner" ;;
        2) "$codex_runner" resume --last ;;
        3) "$codex_runner" resume ;;
        4) "$codex_runner" resume --all ;;
      esac
      ;;
    5|6|7)
      if [[ ! -x "$claude_runner" ]]; then
        printf '启动脚本不存在或不可执行：%s\n' "$claude_runner" >&2
        return 1
      fi
      case "$sp_choice" in
        5) "$claude_runner" ;;
        6) "$claude_runner" --continue ;;
        7) "$claude_runner" --resume ;;
      esac
      ;;
    8|9|10|11|12)
      if [[ ! -x "$opencode_runner" ]]; then
        printf '启动脚本不存在或不可执行：%s\n' "$opencode_runner" >&2
        return 1
      fi
      case "$sp_choice" in
        8) "$opencode_runner" ;;
        9) "$opencode_runner" --continue ;;
        10)
          if [[ ! -x "$opencode_resume" ]]; then
            printf '启动脚本不存在或不可执行：%s\n' "$opencode_resume" >&2
            return 1
          fi
          "$opencode_resume"
          ;;
        11) "$opencode_runner" web ;;
        12) "$opencode_runner" session list ;;
      esac
      ;;
    13) systemctl restart nginxmgr ;;
    14) systemctl restart nginxmgr mcp-server ;;
    15) systemctl status nginxmgr mcp-server --no-pager ;;
    16) "$mihomo_runner" ;;
    *) printf '%s\n' '无效选项，请重新运行 sp。' >&2; return 1 ;;
  esac
}

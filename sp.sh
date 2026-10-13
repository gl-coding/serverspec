# nginxRouter 快速启动菜单（安装见 spec/serverspec/link-home.sh）
# ~/.bashrc: [ -f "$HOME/.serverspec/sp.sh" ] && . "$HOME/.serverspec/sp.sh"
#
# sp() 每次运行都会 source sp-menu.sh，改菜单后无需重新登录，直接再输入 sp。

sp() {
  # shellcheck disable=SC1091
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sp-menu.sh"
}

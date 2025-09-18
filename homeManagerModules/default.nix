{ ... }:

{
  imports = [
    ./cli.nix # default: true
    ./desktop.nix # default: false
    ./devel/devel.nix # default: true (jetbrains false)
    ./dunst.nix # default: false
    ./env.nix # default: true
    ./ghostty/ghostty.nix # default: false
    ./hyprland/hyprland.nix # default: false
    ./kde.nix # default: false
    ./neovim/neovim.nix # default: false
    ./rofi/rofi.nix # default: false
    ./shell.nix # default: true
    ./ssh.nix # default: true
    ./stylix.nix # default: false
    ./vesktop/vesktop.nix # default: false
    ./vim/vim.nix # default: true
    ./waybar.nix # default: false
    ./wine.nix # default: false
  ];
}

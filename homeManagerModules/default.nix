{ ... }:

{
  imports = [
    ./cli.nix # default: true
    ./cursor.nix # default: false
    ./desktop.nix # default: false
    ./devel/devel.nix # default: true (jetbrains false)
    ./env.nix # default: true
    ./ghostty/ghostty.nix # default: false
    ./hyprland/hyprland.nix # default: false
    ./kde.nix # default: false
    ./neovim/neovim.nix # default: false
    ./rofi/rofi.nix # default: false
    ./shell.nix # default: true
    ./ssh.nix # default: true
    ./vesktop/vesktop.nix # default: false
    ./vim/vim.nix # default: true
    ./wine.nix # default: false
  ];
}

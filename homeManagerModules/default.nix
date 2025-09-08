{ ... }:

{
  imports = [
    ./cursor.nix  # default: false
    ./desktop.nix # default: false
    ./env.nix     # default: true
    ./neovim.nix  # default: false
    ./shell.nix   # default: true
    ./ssh.nix     # default: true
  ];
}

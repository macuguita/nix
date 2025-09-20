{ ... }:

{
  imports = [
    ./cli.nix # default: true
    ./devel/devel.nix # default: true (jetbrains false)
    ./env.nix # default: true
    ./neovim/neovim.nix # default: fasle
    ./shell.nix # default: true
    ./ssh.nix # default: true
    ./vim/vim.nix # default: true
  ];
}

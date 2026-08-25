{ pkgs, ... }:
{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl

    killall
    file
    coreutils
    gnused
    rsync
    tree
    ripgrep
    fzf

    zip
    unzip
    zstd
    gnutar
    gzip
  ];

  programs = {
    gnupg.agent = {
      enable = true;

      enableSSHSupport = true;
    };
  };
}

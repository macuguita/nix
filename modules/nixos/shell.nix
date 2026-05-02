{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    trash-cli

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
    git.enable = true;

    gnupg.agent = {
      enable = true;

      enableSSHSupport = true;
    };

    bat = {
      enable = true;
      settings = {
        "style" = "plain";
      };
    };

  };
}

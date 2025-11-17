{ pkgs, ... }:

{
  imports = [
  ];

  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    btop
    prismlauncher
    blockbench
    discord
    qbittorrent
    mpv
  ];

  homebrew = {
    enable = true;
    user = "raul";

    brews = [
      "coreutils"
    ];

    casks = [
      "helium-browser"
      "zotero"
    ];

    onActivation.cleanup = "uninstall";
  };

  system.stateVersion = 5;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
  };

  users.users.raul = {
    home = "/Users/raul";
    description = "raul";
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
}

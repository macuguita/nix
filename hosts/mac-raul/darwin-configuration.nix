{ pkgs, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    btop
  ];

  homebrew = {
    enable = true;
    user = "raul";

    brews = [
      "coreutils"
    ];

    casks = [
      "prismlauncher"
      "ghostty"
      "blockbench"
      "discord"
      "qbittorrent"
    ];
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

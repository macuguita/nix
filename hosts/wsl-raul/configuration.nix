{ pkgs
, ...
}:

{
  imports = [
    ./../../nixosModules/default.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "wsl-raul";
  };

  users.users.raul = {
    isNormalUser = true;
    description = "raul";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
    ];
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  wsl.enable = true;
  wsl.defaultUser = "raul";

  system.stateVersion = "25.05"; # Did you read the comment?
}

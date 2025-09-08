{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../../nixosModules/default.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    loader.systemd-boot.enable      = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName              = "pc-raul";
    networkmanager.enable = true;
  };

  programs.zsh = {
    enable                    = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable    = true;
  };

  users.users.raul = {
    isNormalUser = true;
    description  = "raul";
    shell        = pkgs.zsh;
    extraGroups  = [
      "networkmanager"
      "wheel"
    ];
  };

  services.openssh.enable = true;

  myNixos = {
    flatpak.enable  = true;
    fonts.enableAll = true;
    greetd.enable   = true;
    samba.enable    = true;
    steam.enable    = true;
    xdg.enable      = true;
  };

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
  };

  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pulseaudio
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  security.rtkit.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";

}

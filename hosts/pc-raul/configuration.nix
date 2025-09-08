{ config, pkgs, lib, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ./../../nixosModules/steam.nix
    ./../../nixosModules/localization.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "pc-raul";
    networkmanager.enable = true;
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  users.users.raul = {
    isNormalUser = true;
    description = "raul";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  services.openssh.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.zsh}/bin/zsh -l -c Hyprland";
        user = "raul";
      };
      default_session = initial_session;
    };
  };


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.samba = {
    enable = true;
    settings = {
      root = {
        path = "/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "raul";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pulseaudio
  ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.kwallet
    ];
  };

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  fonts.packages = with pkgs; [
    nerd-fonts.noto
    maple-mono.NL-NF-unhinted
  ];

  security.rtkit.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

  system.stateVersion = "25.05";

}

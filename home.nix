{ config, pkgs, ... }:

{
  home.username = "raul";
  home.homeDirectory = "/home/raul";

  home.packages = with pkgs; [
    neovim
    vesktop
    prismlauncher
    sound-theme-freedesktop
    ffmpeg
    imagemagick
    bat
    btop
    fastfetch
    waybar
    wf-recorder
    grim
    slurp
    dunst
    libnotify
    hyprpaper
    hyprlock
    hyprpicker
    hypridle
    hyprsunset
    hyprpolkitagent
    hyprland-qt-support
    ghostty
    rofi-wayland
    firefox
    fzf
    steam
    pavucontrol
    pywal16
    kdePackages.dolphin
    kdePackages.ark
  ];

  programs.firefox = {
    enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 20;
  };

  home.stateVersion = "25.05";
}


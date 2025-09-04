{ config, pkgs, inputs, ... }:

{
  home.username = "raul";
  home.homeDirectory = "/home/raul";

  home.packages = with pkgs; [
    neovide
    vesktop
    prismlauncher
    wl-clipboard
    ffmpeg
    imagemagick
    bat
    btop
    gcc
    fastfetch
    cargo
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
    yt-dlp
    mpv
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kio
    kdePackages.kio-admin
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.kservice
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.baloo
    kdePackages.baloo-widgets
    kdePackages.ffmpegthumbs
    kdePackages.gwenview
    kdePackages.okular
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
  };

  home.file.".local/share/sounds/freedesktop".source = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop";

  home.shellAliases = {
    cat = "bat";
    grep = "grep --color=auto";
    mv = "mv -i";
    rm = "rm -Iv";
    n = "nvim";
    p = "ps aux | grep $1";
    ls = "ls -h --color=auto --group-directories-first";
    la = "ls -lah --color=auto --group-directories-first";
    wget = "wget --hsts-file=${config.xdg.cacheHome}/wget-hsts";
  };

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


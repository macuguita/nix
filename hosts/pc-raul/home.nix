{ pkgs, ... }:

{
  imports = [
    ./../../homeManagerModules/default.nix
  ];
  home.username      = "raul";
  home.homeDirectory = "/home/raul";

  myHome = {
    cursor.enable = true;
    desktop = {
      firefox.enable  = true;
      darkMode.enable = true;
    };
    neovim.enable = true;
  };

  gtk.enable = true;

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
    bluetui
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
    qbittorrent
    pavucontrol
    pywal16
    yt-dlp
    mpv
    wineWowPackages.stable
    winetricks
    woomer
    jdk
    glfw
    jetbrains.idea-community-bin
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

  home.file.".local/share/sounds/freedesktop".source =
    "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop";

  home.stateVersion = "25.05";
}

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
      firefox.enable     = true;
      minecraft.enable   = true;
      darkMode.enable    = true;
    };
    devel.enableJetbrains = true;
    ghostty.enable        = true;
    hyprland.enable       = true;
    kde.enable            = true;
    neovim.enable         = true;
    rofi.enable           = true;
    vesktop.enable        = true;
    wine.enable           = true;
  };

  gtk.enable = true;

  home.packages = with pkgs; [
    wl-clipboard # put in built nix script
    wf-recorder # put in built nix script
    grim # put in built nix script
    slurp # put in built nix script
    btop
    bluetui
    ghostty
    qbittorrent
    mpv
    filezilla
  ];

  home.file.".local/share/sounds/freedesktop".source =
    "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop";

  home.stateVersion = "25.05";
}

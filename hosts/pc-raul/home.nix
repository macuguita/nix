{ pkgs, config, ... }:

let
  changeVolume = import ./../../homeManagerModules/scripts/changeVolume.nix { inherit pkgs; };
  colorPicker = import ./../../homeManagerModules/scripts/colorPicker.nix { inherit pkgs config; };
  discordAudio = import ./../../homeManagerModules/scripts/discordAudio.nix { inherit pkgs; };
  m3u8toMP4 = import ./../../homeManagerModules/scripts/m3u8toMP4.nix { inherit pkgs; };
  optimizeImage = import ./../../homeManagerModules/scripts/optimizeImage.nix { inherit pkgs; };
  optimizeVideo = import ./../../homeManagerModules/scripts/optimizeVideo.nix { inherit pkgs; };
  record = import ./../../homeManagerModules/scripts/record.nix { inherit pkgs; };
  screenshot = import ./../../homeManagerModules/scripts/screenshot.nix { inherit pkgs; };
  screenTemperature = import ./../../homeManagerModules/scripts/screenTemperature.nix { inherit pkgs; };
  shittifyVideo = import ./../../homeManagerModules/scripts/shittifyVideo.nix { inherit pkgs; };
  toggleAutoclicker = import ./../../homeManagerModules/scripts/toggleAutoclicker.nix { inherit pkgs; };
  youtubeToMP3 = import ./../../homeManagerModules/scripts/youtubeToMP3.nix { inherit pkgs; };
  youtubeToMP4 = import ./../../homeManagerModules/scripts/youtubeToMP4.nix { inherit pkgs; };
in
{
  imports = [
    ./../../homeManagerModules/default.nix
  ];
  home.username = "raul";
  home.homeDirectory = "/home/raul";

  myHome = {
    desktop = {
      firefox.enable = true;
      minecraft.enable = true;
    };
    devel.enableJetbrains = true;
    dunst.enable = true;
    ghostty.enable = true;
    hyprland.enable = true;
    kde.enable = true;
    neovim.enable = true;
    rofi.enable = true;
    stylix.enable = true;
    vesktop.enable = true;
    waybar.enable = true;
    wine.enable = true;
  };

  stylix = {
    image = ./wallpaper.jpg;
    targets = {
      "neovim".enable = false;
      "firefox".enable = false;
      "hyprland".enable = false;
      qt.enable = true;
      qt.platform = "qtct";
    };
  };

  gtk.enable = true;

  home.packages = [
    changeVolume
    colorPicker
    discordAudio
    m3u8toMP4
    optimizeImage
    optimizeVideo
    record
    screenshot
    screenTemperature
    shittifyVideo
    toggleAutoclicker
    youtubeToMP3
    youtubeToMP4
    pkgs.btop
    pkgs.bluetui
    pkgs.ghostty
    pkgs.qbittorrent
    pkgs.mpv
    pkgs.filezilla
  ];

  home.stateVersion = "25.05";
}

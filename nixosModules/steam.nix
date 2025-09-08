{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.myNixos.steam = {
    enable = mkOption {
      type        = types.bool;
      default     = false;
      description = "Enable steam and gaming optimizations";
    };
  };

  config = lib.mkIf config.myNixos.steam.enable {
    hardware.graphics.enable = lib.mkDefault true;
    hardware.graphics.extraPackages = with pkgs; [
      amdvlk
    ];
    hardware.graphics.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];

    programs = {
      gamemode.enable  = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        extraPackages = with pkgs; [
          SDL2
          gamescope
          er-patcher
        ];
        protontricks.enable = true;
      };
    };
  };
}

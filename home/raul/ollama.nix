{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf osConfig.macuguita.localAi.enable {
    programs.opencode.enable = true;

    services.ollama = mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
    };
  };
}

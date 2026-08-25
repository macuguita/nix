{
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.localAi.enable {
    programs.opencode.enable = true;

    services.ollama = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
    };
  };
}

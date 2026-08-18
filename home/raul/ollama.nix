{
  osConfig,
  lib,
  ...
}:
{
  config = lib.mkIf osConfig.macuguita.localAi.enable {
    services.ollama = {
      enable = true;
    };

    programs.opencode.enable = true;
  };
}

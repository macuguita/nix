{ ... }:
{
  dendritic.homeModules."home/raul/programs/ai" =
    {
      lib,
      pkgs,
      ...
    }:
    let
      # The agents shell out to these at runtime, so make sure they are on PATH
      # no matter which shell or group launched the program.
      runtimeInputs = with pkgs; [
        git
        ripgrep
      ];

      withRuntimeTools =
        package:
        pkgs.symlinkJoin {
          name = "${package.name}-wrapped";
          paths = [ package ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram "$out/bin/${package.meta.mainProgram}" \
              --suffix PATH : ${lib.makeBinPath runtimeInputs}
          '';
        };
    in
    {
      packages = [
        (withRuntimeTools pkgs.opencode)
        (withRuntimeTools <| pkgs.mistral-vibe.overrideAttrs (old:
        {
          doCheck = false;
          doInstallCheck = false;
        }))
      ];

      xdg.config.files = {
        "opencode/cli.json" = {
          generator = (pkgs.formats.json { }).generate "opencode-cli.json";
          value = {
            theme = {
              name = "catppuccin";
              mode = "dark";
            };
          };
        };
      };
    };
}

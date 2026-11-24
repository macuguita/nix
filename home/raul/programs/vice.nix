{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/vice" =
    { pkgs, ... }:
    {
      xdg.config.files."vice/config.toml" = {
        generator = (pkgs.formats.toml { }).generate "vice-config.toml";
        value = {
          hotkeys = {
            # Shift+Meta+6: "+"-joined evdev names, modifiers first;
            # right-hand variants (KEY_RIGHT*) collapse to the left ones.
            clip = "KEY_LEFTSHIFT+KEY_LEFTMETA+KEY_6";
          };
          recording = {
            capture_microphone = true;
          };
          discord = {
            enabled = false;
          };
        };
      };
    };

  dendritic.nixosModules."nixos/vice" =
    { pkgs, ... }:
    {
      imports = [ inputs.vice.nixosModules.default ];

      # Installs vice-clipper, the uaccess udev rule for the evdev hotkey
      # listener, programs.gpu-screen-recorder (setcap wrapper) and the
      # `vice` user daemon, which auto-starts with the graphical session.
      services.vice = {
        enable = true;

        package = pkgs.vice-clipper.overrideAttrs (old: {
          # test_flatpak_app's overlay fallback test needs a real layer-shell
          # session inside a Flatpak and always fails in the nix sandbox.
          # (unittestCheckHook runs in preDistPhases, so doCheck=false is
          # not enough — this is the hook's kill switch.)
          dontUseUnittestCheck = true;
        });
      };
    };
}

{ inputs, ... }:
{
  dendritic.nixosModules."nixos/security" =
    { ... }:
    {
      security = {
        sudo.enable = false;
        doas = {
          enable = true;
          extraRules = [
            {
              users = [ "raul" ];
              keepEnv = true;
              persist = true;
            }
          ];
        };
        polkit.enable = true;
      };
    };
}

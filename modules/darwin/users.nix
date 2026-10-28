{ config, inputs, ... }:
{
  dendritic.darwinModules."darwin/users" =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "homemanager.bak";
        users.raul = config.dendritic.homeProfiles."raul-darwin";
      };

      users.users.raul = {
        home = "/Users/raul";
        shell = pkgs.zsh;
      };

      system.primaryUser = "raul";
    };
}

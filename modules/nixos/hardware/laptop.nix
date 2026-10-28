{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/laptop" =
    { ... }:
    {
      services.upower = {
        enable = true;

        percentageLow = 20;
        percentageCritical = 5;
        percentageAction = 3;

        criticalPowerAction = "Hibernate";
      };
    };
}

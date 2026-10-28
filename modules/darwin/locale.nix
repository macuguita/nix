{ inputs, ... }:
{
  dendritic.darwinModules."darwin/locale" =
    { ... }:
    {
      time.timeZone = "Europe/Madrid";
    };
}

{ inputs, ... }:
{
  dendritic.nixosModules."nixos/local-ai" =
    { pkgs, ... }:
    {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
      };
    };
}

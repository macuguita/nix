{ ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };
    overlays = [
      (final: prev: {
        python3 = prev.python3.override {
          packageOverrides = pyfinal: pyprev: {
            jedi-language-server = pyprev.jedi-language-server.overridePythonAttrs (old: {
              # Disable the runtime deps check that enforces jedi<0.20
              pythonRelaxDeps = [ "jedi" ];
            });
          };
        };
      })
    ];
  };
}

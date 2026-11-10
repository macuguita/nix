{
  lib,
  pkgs,
  stdenvNoCC,
  fetchurl,
  undmg,
  ...
}:
let
  inherit (lib.licenses) unfree;
  inherit (lib.sourceTypes) binaryNativeCode;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docker-desktop";
  version = "4.98.0";

  src = fetchurl {
    url = "https://desktop.docker.com/mac/main/arm64/245422/Docker.dmg";
    hash = "sha256-nG8Tzk7doqvyDYAVUrasuWrNPWSz6RtQxEhDU4AnWLU=";
  };

  nativeBuildInputs = [ undmg ];

  dontConfigure = true;
  dontBuild = true;

  # Keep the bundle byte-identical to Docker's signature. Patching shebangs
  # or stripping inside the sealed .app invalidates its code signature, which
  # makes Gatekeeper refuse to open the app.
  dontFixup = true;

  unpackPhase = ''
    runHook preUnpack
    undmg "$src"
    runHook postUnpack
  '';

  sourceRoot = "Docker.app";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R . "$out/Applications/Docker.app"
    runHook postInstall
  '';

  meta = {
    description = "Docker Desktop";
    homepage = "https://www.docker.com/products/docker-desktop/";
    license = unfree;
    sourceProvenance = [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" ];
  };

  # nix-update convention: bump version/url/hash from the official appcast.
  # Run directly with: ./packages/docker-desktop/update.sh
  passthru.updateScript = pkgs.writeShellScript "update-docker-desktop" ''
    exec ${./update.sh} "$@"
  '';
})

{
  rustPlatform,
  lib,
  makeBinaryWrapper,
  pulseaudio,
  wf-recorder,
}:
let
  inherit (lib)
    importTOML
    makeBinPath
    ;
  inherit (lib.fileset)
    toSource
    unions
    ;
  inherit (lib.sourceTypes) fromSource;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "record";
  inherit (finalAttrs.passthru.cargoToml.package) version;

  src = toSource {
    root = ./.;
    fileset = unions [
      ./src
      ./Cargo.lock
      ./Cargo.toml
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  passthru = {
    cargoToml = importTOML ./Cargo.toml;
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${
        makeBinPath [
          pulseaudio
          wf-recorder
        ]
      }
  '';

  meta = {
    description = "Script for recording";
    mainProgram = finalAttrs.pname;
    sourceProvenance = [
      fromSource
    ];
  };
})

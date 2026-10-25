{
  rustPlatform,
  lib,
  makeBinaryWrapper,
  pulseaudio,
  wf-recorder,
}:
let
  fs = lib.fileset;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "record";
  inherit (finalAttrs.passthru.cargoToml.package) version;

  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./src
      ./Cargo.lock
      ./Cargo.toml
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  passthru = {
    cargoToml = lib.importTOML ./Cargo.toml;
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ pulseaudio wf-recorder ]}
  '';

  meta = {
    description = "Script for recording";
    mainProgram = finalAttrs.pname;
    license = lib.licenses.eupl12;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
  };
})

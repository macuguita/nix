{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk17,
  ...
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vineflower";
  version = "1.12.0";

  src = fetchurl {
    url = "https://github.com/Vineflower/vineflower/releases/download/${finalAttrs.version}/vineflower-${finalAttrs.version}.jar";
    hash = "sha256-Hfz+l0OVc0+kZ85iBmHHYj0FuoNnDeBSmx+9Y/9Ui50=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/vineflower
    cp $src $out/share/vineflower/app.jar

    makeWrapper ${lib.getExe jdk17} $out/bin/vineflower \
      --add-flags "-jar $out/share/vineflower/app.jar"

    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "vineflower";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

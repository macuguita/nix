{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  libicns,
  writeText,
  jdk17,
  packwiz,
  ...
}:
let
  inherit (lib.lists)
    optional
    optionals
    ;
  inherit (lib.meta) getExe;
  inherit (lib.sources) sourceTypes;
  inherit (lib.strings)
    makeBinPath
    optionalString
    ;
  inherit (lib.generators) toPlist;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pw-gui";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/AmberIsFrozen/PW-GUI/releases/download/v${finalAttrs.version}/PW-GUI-v${finalAttrs.version}.jar";
    hash = "sha256-S7ls/SuLrzKs2gVWt/Ca7fYyA0N9wSJmuo4ugb01Qi8=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/AmberIsFrozen/PW-GUI/refs/heads/dev/assets/pwgui_icon.ico";
    hash = "sha256-1tlnuiPDJshRtQB5qjqGsw9r5XgtZyyqA4hghbR34Ow=";
  };

  infoPlist = writeText "Info.plist" (
    toPlist { escape = true; } {
      CFBundleName = "PW-GUI";
      CFBundleDisplayName = "PW-GUI";
      CFBundleIdentifier = "com.amberisfrozen.pw-gui";
      CFBundleVersion = finalAttrs.version;
      CFBundleShortVersionString = finalAttrs.version;
      CFBundlePackageType = "APPL";
      CFBundleExecutable = "pw-gui";
      CFBundleIconFile = "pw-gui.icns";
      NSHighResolutionCapable = true;
    }
  );

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ]
  ++ optionals stdenvNoCC.hostPlatform.isLinux [ copyDesktopItems ]
  ++ optionals stdenvNoCC.hostPlatform.isDarwin [ libicns ];

  desktopItems = optional stdenvNoCC.hostPlatform.isLinux (makeDesktopItem {
    name = "pw-gui";
    exec = "pw-gui";
    icon = "pw-gui";
    desktopName = "PW-GUI";
    genericName = "Minecraft Modpack Manager";
    categories = [ "Game" ];
    terminal = false;
  });

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/pw-gui
    cp $src $out/share/pw-gui/app.jar

  ''
  + optionalString stdenvNoCC.hostPlatform.isLinux ''
    for size in 16 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick '${finalAttrs.icon}[0]' -background none -resize "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/pw-gui.png
    done

    makeWrapper ${getExe jdk17} $out/bin/pw-gui \
      --add-flags "-jar $out/share/pw-gui/app.jar" \
      --prefix PATH : ${makeBinPath [ packwiz ]}

  ''
  + optionalString stdenvNoCC.hostPlatform.isDarwin ''
    app=$out/Applications/PW-GUI.app
    mkdir -p $app/Contents/{MacOS,Resources}

    iconsDir=$(mktemp -d)
    for size in 16 32 128 256 512; do
      magick '${finalAttrs.icon}[0]' -background none -resize "$size"x"$size" \
        $iconsDir/icon_"$size"x"$size".png
    done
    png2icns $app/Contents/Resources/pw-gui.icns $iconsDir/icon_*.png

    cp ${finalAttrs.infoPlist} $app/Contents/Info.plist

    makeWrapper ${getExe jdk17} $app/Contents/MacOS/pw-gui \
      --add-flags "-Xdock:name=PW-GUI" \
      --add-flags "-Xdock:icon=$app/Contents/Resources/pw-gui.icns" \
      --add-flags "-jar $out/share/pw-gui/app.jar" \
      --prefix PATH : ${makeBinPath [ packwiz ]}

    ln -s $app/Contents/MacOS/pw-gui $out/bin/pw-gui

  ''
  + ''
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "pw-gui";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

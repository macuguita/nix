# default.nix
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  libicns,
  jdk17,
  packwiz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pw-gui";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/AmberIsFrozen/PW-GUI/releases/download/v${finalAttrs.version}/PW-GUI-${finalAttrs.version}-all.jar";
    hash = "sha256-oHCkqThiljZ7O2C2thHhJOCft33x03EBODlMCv4Td+I=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/AmberIsFrozen/PW-GUI/dev/assets/pwgui_icon.ico";
    hash = "sha256-1tlnuiPDJshRtQB5qjqGsw9r5XgtZyyqA4hghbR34Ow=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libicns ];

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
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
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for size in 16 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick ${finalAttrs.icon} -resize "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/pw-gui.png
    done

    makeWrapper ${lib.getExe jdk17} $out/bin/pw-gui \
      --add-flags "-jar $out/share/pw-gui/app.jar" \
      --prefix PATH : ${lib.makeBinPath [ packwiz ]}

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/PW-GUI.app/Contents/{MacOS,Resources}

    magick ${finalAttrs.icon} -background none -resize 16x16    /tmp/icon_16x16.png
    magick ${finalAttrs.icon} -background none -resize 32x32    /tmp/icon_16x16@2x.png
    magick ${finalAttrs.icon} -background none -resize 32x32    /tmp/icon_32x32.png
    magick ${finalAttrs.icon} -background none -resize 64x64    /tmp/icon_32x32@2x.png
    magick ${finalAttrs.icon} -background none -resize 128x128  /tmp/icon_128x128.png
    magick ${finalAttrs.icon} -background none -resize 256x256  /tmp/icon_128x128@2x.png
    magick ${finalAttrs.icon} -background none -resize 256x256  /tmp/icon_256x256.png
    magick ${finalAttrs.icon} -background none -resize 512x512  /tmp/icon_256x256@2x.png
    magick ${finalAttrs.icon} -background none -resize 512x512  /tmp/icon_512x512.png
    magick ${finalAttrs.icon} -background none -resize 1024x1024 /tmp/icon_512x512@2x.png
    png2icns $out/Applications/PW-GUI.app/Contents/Resources/pw-gui.icns \
      /tmp/icon_16x16.png /tmp/icon_32x32.png /tmp/icon_128x128.png \
      /tmp/icon_256x256.png /tmp/icon_512x512.png

    cat > $out/Applications/PW-GUI.app/Contents/Info.plist << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleName</key><string>PW-GUI</string>
      <key>CFBundleDisplayName</key><string>PW-GUI</string>
      <key>CFBundleIdentifier</key><string>com.amberisfrozen.pw-gui</string>
      <key>CFBundleVersion</key><string>${finalAttrs.version}</string>
      <key>CFBundleShortVersionString</key><string>${finalAttrs.version}</string>
      <key>CFBundlePackageType</key><string>APPL</string>
      <key>CFBundleExecutable</key><string>pw-gui</string>
      <key>CFBundleIconFile</key><string>pw-gui.icns</string>
      <key>NSHighResolutionCapable</key><true/>
    </dict>
    </plist>
    EOF

    makeWrapper ${lib.getExe jdk17} \
      $out/Applications/PW-GUI.app/Contents/MacOS/pw-gui \
      --add-flags "-Xdock:name=PW-GUI" \
      --add-flags "-Xdock:icon=$out/Applications/PW-GUI.app/Contents/Resources/pw-gui.icns" \
      --add-flags "-jar $out/share/pw-gui/app.jar" \
      --prefix PATH : ${lib.makeBinPath [ packwiz ]}

    ln -s $out/Applications/PW-GUI.app/Contents/MacOS/pw-gui $out/bin/pw-gui

  ''
  + ''
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "pw-gui";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

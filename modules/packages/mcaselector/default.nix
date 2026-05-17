{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  openjdk21,
  openjfx21,
  ...
}:

let
  jdkWithJFX = openjdk21.override (
    {
      enableJavaFX = true;
    }
    // lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      openjfx_jdk = openjfx21.override { withWebKit = true; };
    }
  );

  icon = fetchurl (
    if stdenvNoCC.isDarwin then
      {
        url = "https://github.com/Querz/mcaselector/raw/refs/heads/master/installer/macos/icon.icns";
        hash = "sha256-deaXGq7z7Z/DF/+ABkqTCkajGDTPZKQLDT4dGWsOVjk=";
      }
    else
      {
        url = "https://github.com/Querz/mcaselector/raw/refs/heads/master/installer/linux/icon.png";
        hash = "sha256-nUHTxFHKhp//AL3/B43iXPmp/gcCQPgrEqGAV23U/Vs=";
      }
  );

  desktopFile = fetchurl {
    url = "https://github.com/Querz/mcaselector/raw/refs/heads/master/installer/linux/mcaselector.desktop";
    hash = "sha256-cAsOcatOx+g0Rk0wUiqWfxXXVHOYmRon8bSHKL6VtIM=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "mcaselector";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${version}/mcaselector-${version}.jar";
    hash = "sha256-pdJIQmoZhIfvQAHMGy0+IjQviMjFOrNsI69PHLQ9WpE=";
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/mcaselector
    cp ${src} $out/share/mcaselector/app.jar

  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    cp ${icon} $out/share/mcaselector/icon.png

    makeWrapper ${lib.getExe jdkWithJFX} $out/bin/mcaselector \
      --add-flags "-jar $out/share/mcaselector/app.jar"

    install -Dm644 ${desktopFile} $out/share/applications/mcaselector.desktop
    sed -i \
      "s|Exec=.*|Exec=$out/bin/mcaselector|; \
       s|Icon=.*|Icon=$out/share/mcaselector/icon.png|" \
      $out/share/applications/mcaselector.desktop

  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/MCASelector.app/Contents/{MacOS,Resources}

    cp ${icon} $out/Applications/MCASelector.app/Contents/Resources/mcaselector.icns

    cat > $out/Applications/MCASelector.app/Contents/Info.plist << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>CFBundleName</key><string>MCASelector</string>
      <key>CFBundleDisplayName</key><string>MCASelector</string>
      <key>CFBundleIdentifier</key><string>net.querz.mcaselector</string>
      <key>CFBundleVersion</key><string>${version}</string>
      <key>CFBundleShortVersionString</key><string>${version}</string>
      <key>CFBundlePackageType</key><string>APPL</string>
      <key>CFBundleExecutable</key><string>mcaselector</string>
      <key>CFBundleIconFile</key><string>mcaselector.icns</string>
      <key>NSHighResolutionCapable</key><true/>
    </dict>
    </plist>
    EOF

    makeWrapper ${lib.getExe jdkWithJFX} \
      $out/Applications/MCASelector.app/Contents/MacOS/mcaselector \
      --add-flags "-Xdock:name=MCASelector" \
      --add-flags "-Xdock:icon=$out/Applications/MCASelector.app/Contents/Resources/mcaselector.icns" \
      --add-flags "-jar $out/share/mcaselector/app.jar"

    ln -s $out/Applications/MCASelector.app/Contents/MacOS/mcaselector $out/bin/mcaselector

  ''
  + ''
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "mcaselector";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}

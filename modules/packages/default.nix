{ ... }:
{
  nixpkgs.overlays = [
    (
      self: super:
      let
        pkgs = self.pkgs;
        lib = self.lib;
        inherit (self.stdenv.hostPlatform) isDarwin isLinux;
      in
      {
        screenshot = pkgs.callPackage ./screenshot { };
        changeVolume = pkgs.callPackage ./changeVolume { };
        record = pkgs.callPackage ./record { };
        pw-gui = pkgs.callPackage ./pw-gui { };
        mcaselector = pkgs.callPackage ./mcaselector { };
        vineflower = pkgs.callPackage ./vineflower { };
        ryubing-canary = pkgs.callPackage ./ryubing-canary { };

        # Upstream pandora-launcher-unwrapped doesn't produce a macOS .app.
        # Mirrors https://github.com/NixOS/nixpkgs/pull/557789, plus a rebased
        # https://github.com/Moulberry/PandoraLauncher/pull/551 for bwrap on NixOS.
        pandora-launcher-unwrapped = super.pandora-launcher-unwrapped.overrideAttrs (
          old:
          let
            infoPlist = lib.generators.toPlist { escape = true; } {
              CFBundleDevelopmentRegion = "en";
              CFBundleDisplayName = "Pandora Launcher";
              CFBundleExecutable = "pandora_launcher";
              CFBundleIconFile = "mac.icns";
              CFBundleIdentifier = "com.moulberry.pandoralauncher";
              CFBundleInfoDictionaryVersion = "6.0";
              CFBundleName = "Pandora Launcher";
              CFBundlePackageType = "APPL";
              CFBundleShortVersionString = old.version;
              CFBundleVersion = old.version;
              NSHighResolutionCapable = true;
              NSMicrophoneUsageDescription = "A Minecraft mod wants to access your microphone.";
            };
          in
          {
            patches = (old.patches or [ ]) ++ [ ./pandora-launcher/bwrap-nix.patch ];

            nativeBuildInputs =
              lib.filter (
                p:
                !(builtins.elem p [
                  super.copyDesktopItems
                  super.imagemagick
                  super.patchelf
                ])
              ) old.nativeBuildInputs
              ++ lib.optionals isLinux [
                super.copyDesktopItems
                super.imagemagick
                super.patchelf
              ];

            desktopItems = lib.optionals isLinux [
              (super.makeDesktopItem {
                name = "com.moulberry.pandoralauncher";
                desktopName = "Pandora Launcher";
                genericName = "Unofficial Minecraft Launcher";
                exec = "pandora_launcher";
                icon = "pandora_launcher";
              })
            ];

            inherit infoPlist;

            postInstall =
              lib.optionalString isDarwin ''
                mkdir -p $out/Applications/PandoraLauncher.app/Contents/{MacOS,Resources}
                cp package/mac.icns $out/Applications/PandoraLauncher.app/Contents/Resources/
                printf '%s' ${lib.escapeShellArg infoPlist} > $out/Applications/PandoraLauncher.app/Contents/Info.plist
                ln -s $out/bin/pandora_launcher $out/Applications/PandoraLauncher.app/Contents/MacOS/pandora_launcher
              ''
              + lib.optionalString isLinux ''
                for size in 16 24 32 48 64 128 256; do
                  geometry="$size"x"$size"
                  mkdir -p "$out/share/icons/hicolor/$geometry/apps"
                  magick -background none package/windows.svg -resize "$geometry" \
                    "$out/share/icons/hicolor/$geometry/apps/pandora_launcher.png"
                done
              '';
          }
        );

        # The wrapper is a symlinkJoin, so it copies the .app bundle above but
        # its executable still points at the unwrapped binary. Re-point it at
        # the wrapped one so Java/module envs are set.
        pandora-launcher = super.pandora-launcher.overrideAttrs (old: {
          buildCommand =
            (old.buildCommand or "")
            + lib.optionalString isDarwin ''
              if [ -d $out/Applications/PandoraLauncher.app ]; then
                rm -rf $out/Applications/PandoraLauncher.app
                mkdir -p $out/Applications/PandoraLauncher.app/Contents/MacOS
                ln -s ${builtins.head old.paths}/Applications/PandoraLauncher.app/Contents/Info.plist $out/Applications/PandoraLauncher.app/Contents/Info.plist
                ln -s ${builtins.head old.paths}/Applications/PandoraLauncher.app/Contents/Resources $out/Applications/PandoraLauncher.app/Contents/Resources
                ln -s $out/bin/pandora_launcher $out/Applications/PandoraLauncher.app/Contents/MacOS/pandora_launcher
              fi
            '';
        });

        # TODO: remove when it is updated upstream
        whatsapp-for-mac = super.whatsapp-for-mac.overrideAttrs (old: rec {
          version = "2.26.41.28";
          src = super.fetchzip {
            extension = "zip";
            name = "WhatsApp.app";
            url = "https://web.whatsapp.com/desktop/mac_native/release/?version=${version}&extension=zip&configuration=Release&branch=master";
            hash = "sha256-JyIXe5uU2KuDz2rCXuN2tcvo03bRuqmoWhxov8+/Se8=";
          };
        });

        # TODO: remove when it is fixed upstream
        # audacity = super.audacity.overrideAttrs (old: {
        #   cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        #     "-DQT_QML_NO_CACHEGEN=ON"
        #   ];
        # });

        # qbittorrent = super.qbittorrent.overrideAttrs (old: {
        #   postPatch = (old.postPatch or "") + ''
        #     substituteInPlace src/gui/log/loglistview.cpp \
        #       --replace-fail '#ifdef Q_OS_MAC' '#ifdef Q_OS_MACOS'

        #     substituteInPlace src/gui/optionsdialog.cpp \
        #       --replace-fail '#ifdef Q_OS_MAC' '#ifdef Q_OS_MACOS'
        #     '';
        # });
      }
    )
  ];
}

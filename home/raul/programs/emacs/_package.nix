{ pkgs, lib }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (lib.strings) getVersion;

  baseEmacs = if isLinux then pkgs.emacs31-pgtk else pkgs.emacs31;

  emacsPkg = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
    epkgs.treesit-grammars.with-all-grammars
    epkgs.vterm
  ]);

  # Shim the package's `emacs` binary to the Emacs.app one so the daemon gets a
  # real app identity (dock icon, menu bar, activatable via LaunchServices).
  emacsDaemonPkg =
    pkgs.runCommand "emacs-daemon-${getVersion emacsPkg}"
      {
        passthru.version = getVersion emacsPkg;
      }
      ''
        mkdir -p $out/bin
        ln -s '${emacsPkg}/Applications/Emacs.app/Contents/MacOS/Emacs' $out/bin/emacs
        ln -s '${emacsPkg}/bin/emacsclient' $out/bin/emacsclient
      '';

  # Bundle identifier shared by the daemon's Emacs.app; used to raise its frames
  # after forwarding a request.
  emacsBundleId = "org.gnu.Emacs";

  # Bundle identifier of the client .app.
  emacsClientBundleId = (import ../../default-apps/_associations.nix).apps.emacs.bundleId;

  # Info.plist for the client app; the whole bundle description lives here.
  emacsClientInfoPlist = pkgs.writeText "EmacsClient-Info.plist" (
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "English";
      CFBundleExecutable = "EmacsClient";
      CFBundleIdentifier = emacsClientBundleId;
      CFBundleInfoDictionaryVersion = "6.0";
      CFBundleName = "Emacs Client";
      CFBundleDisplayName = "Emacs Client";
      CFBundlePackageType = "APPL";
      CFBundleIconFile = "EmacsClient";
      CFBundleShortVersionString = getVersion emacsPkg;
      CFBundleVersion = getVersion emacsPkg;
      LSMinimumSystemVersion = "11.0";
      LSApplicationCategoryType = "public.app-category.productivity";
      # No Dock icon: it is a transient event forwarder, not a real app window.
      LSUIElement = true;
      NSHighResolutionCapable = true;
      CFBundleDocumentTypes = [
        {
          CFBundleTypeName = "Text";
          CFBundleTypeRole = "Editor";
          LSItemContentTypes = [
            "public.text"
            "public.plain-text"
            "public.source-code"
            "public.script"
            "public.shell-script"
            "public.data"
          ];
        }
      ];
      CFBundleURLTypes = [
        {
          CFBundleURLName = "org-protocol";
          CFBundleURLSchemes = [ "org-protocol" ];
        }
      ];
    }
  );

  # macOS-only .app that forwards Finder/Spotlight/Dock/URL requests to the
  # running daemon via emacsclient, then exits.
  emacsClientApp = pkgs.stdenv.mkDerivation {
    pname = "emacs-client-app";
    version = getVersion emacsPkg;

    dontUnpack = true;

    # Stripping after install would invalidate the ad-hoc bundle signature.
    dontStrip = true;

    buildInputs = [ pkgs.apple-sdk ];

    meta.mainProgram = "Emacs Client";
    passthru.pname = "Emacs Client";
    passthru.version = getVersion emacsPkg;

    buildPhase = ''
      runHook preBuild

      # The preprocessor needs the emacsclient store path as an ObjC string
      # literal, hence the nested quoting.
      $CC -fobjc-arc -O2 -Wno-deprecated-declarations \
        -framework Cocoa -framework AppKit -framework Foundation \
        -DEMACSCLIENT="@\"${emacsPkg}/bin/emacsclient\"" \
        -DEMACS_BUNDLE_ID="@\"${emacsBundleId}\"" \
        -o EmacsClient ${./emacsclient.m}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      app="$out/Applications/Emacs Client.app"
      mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"

      install -m755 EmacsClient "$app/Contents/MacOS/EmacsClient"
      install -m644 ${emacsClientInfoPlist} "$app/Contents/Info.plist"
      install -m644 \
        ${emacsPkg}/Applications/Emacs.app/Contents/Resources/Emacs.icns \
        "$app/Contents/Resources/EmacsClient.icns"

      # The linker already ad-hoc signs the Mach-O; sign the whole bundle too so
      # the signature also seals Info.plist and Resources. Best-effort: some
      # sandboxes don't expose codesign.
      if [ -x /usr/bin/codesign ]; then
        /usr/bin/codesign --force --deep --sign - "$app" >/dev/null 2>&1 || true
      fi

      runHook postInstall
    '';
  };
in
{
  inherit
    emacsPkg
    emacsBundleId
    emacsClientBundleId
    ;

  emacsDaemonPkg = if isDarwin then emacsDaemonPkg else emacsPkg;
  emacsClientApp = if isDarwin then emacsClientApp else null;
}

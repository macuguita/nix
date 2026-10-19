{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.hm.dag) entryAfter;
  inherit (lib.lists) optionals;
  inherit (lib.modules) mkIf;
  inherit (lib.strings)
    concatStringsSep
    getVersion
    ;

  baseEmacs = if pkgs.stdenv.hostPlatform.isLinux then pkgs.emacs31-pgtk else pkgs.emacs31;

  emacsPkg = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
    epkgs.treesit-grammars.with-all-grammars
    epkgs.vterm
  ]);

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # services.emacs hardcodes `${package}/bin/emacs --fg-daemon` for its launchd
  # agent; shim it so the daemon actually runs the Emacs.app binary and frames
  # get a real app identity (dock icon, menu bar, activatable via LaunchServices)
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

  # Info.plist for the client app; the whole bundle description lives here.
  emacsClientInfoPlist = pkgs.writeText "EmacsClient-Info.plist" (
    lib.generators.toPlist { escape = true; } {
      CFBundleDevelopmentRegion = "English";
      CFBundleExecutable = "EmacsClient";
      CFBundleIdentifier = "com.macuguita.emacs-client";
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
  # running daemon via emacsclient (see ./emacsclient.m), then exits.
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

  # Home Manager never restarts the daemon on switch (so it doesn't kill unsaved
  # buffers), which leaves it running the previous generation's binary and init.
  # Restart it here, saving file-visiting buffers first.
  restartEmacsDaemon =
    if isDarwin then
      ''
        label="org.nix-community.home.emacs"
        domain="gui/$(id -u)"

        if /bin/launchctl print "$domain/$label" >/dev/null 2>&1; then
          ${emacsPkg}/bin/emacsclient -e '(save-some-buffers t (lambda () t))' >/dev/null 2>&1 || true
          run /bin/launchctl kickstart -k "$domain/$label"
        fi
      ''
    else
      ''
        systemctl="${config.systemd.user.systemctlPath}"
        export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

        if "$systemctl" --user is-active --quiet emacs.service; then
          ${emacsPkg}/bin/emacsclient -e '(save-some-buffers t (lambda () t))' >/dev/null 2>&1 || true
          run "$systemctl" --user restart emacs.service
        fi
      '';
in
{
  programs.emacs = {
    enable = true;
    package = emacsPkg;
  };

  services.emacs = {
    enable = true;
    package = if isDarwin then emacsDaemonPkg else emacsPkg;
    startWithUserSession = !isDarwin;
  };

  # Runs after the platform service manager has been reloaded so the daemon
  # picks up the new generation.
  home.activation.restartEmacsDaemon = entryAfter [
    "reloadSystemd"
    "setupLaunchAgents"
  ] restartEmacsDaemon;

  # launchd agents get a minimal PATH (/usr/bin:/bin:...), which hides nix
  # packages from the daemon: dired fails on BSD ls (no --group-directories-first),
  # git/magit and friends misbehave. Give it the full system PATH.
  launchd.agents.emacs.config.EnvironmentVariables.PATH = mkIf isDarwin (
    [
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/run/current-system/sw/bin"
      "/run/current-system/sw/sbin"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ]
    |> concatStringsSep ":"
  );

  home.packages = optionals isDarwin [ emacsClientApp ];

  xdg = {
    configFile."emacs" = {
      source = ./.;
      recursive = true;
    };
    mimeApps = mkIf (!isDarwin) {
      enable = true;
      defaultApplications = {
        "text/plain" = "emacsclient.desktop";
        "text/markdown" = "emacsclient.desktop";
        "application/json" = "emacsclient.desktop";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a ''";
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
let
  baseEmacs = if pkgs.stdenv.hostPlatform.isLinux then pkgs.emacs31-pgtk else pkgs.emacs31;

  emacsPkg = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
    epkgs.treesit-grammars.with-all-grammars
    epkgs.vterm
  ]);

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # services.emacs hardcodes `${package}/bin/emacs --fg-daemon` for its launchd
  # agent; shim it so the daemon actually runs the Emacs.app binary and frames
  # get a real app identity (dock icon, menu bar, activatable via AppleScript)
  emacsDaemonPkg =
    pkgs.runCommand "emacs-daemon-${lib.getVersion emacsPkg}"
      {
        passthru.version = lib.getVersion emacsPkg;
      }
      ''
        mkdir -p $out/bin
        ln -s '${emacsPkg}/Applications/Emacs.app/Contents/MacOS/Emacs' $out/bin/emacs
        ln -s '${emacsPkg}/bin/emacsclient' $out/bin/emacsclient
      '';

  # macOS-only .app that talks to the daemon instead of spawning a second
  # standalone instance like the real Emacs.app does.
  #
  # Built with osacompile (like emacs-plus' Emacs Client.app) so it can receive
  # AppleEvents: `on run` from Spotlight/Dock, `on open` for Finder "Open
  # With"/drag & drop and `on open location` for org-protocol:// URLs.
  # Each handler activates Emacs afterwards so new frames take focus.
  emacsClientApp = pkgs.stdenv.mkDerivation {
    name = "emacs-client-app";

    dontUnpack = true;

    meta.mainProgram = "Emacs Client";
    passthru.pname = "Emacs Client";
    passthru.version = lib.getVersion emacsPkg;

    installPhase = ''
      app="$out/Applications/Emacs Client.app"
      mkdir -p "$out/Applications"

      cat > client.applescript <<ASEOF
      on run
        do shell script "${emacsPkg}/bin/emacsclient -c -a ''' -n"
        tell application "Emacs" to activate
      end run

      on open theDropped
        repeat with oneDrop in theDropped
          set dropPath to quoted form of POSIX path of oneDrop
          do shell script "${emacsPkg}/bin/emacsclient -c -a ''' -n " & dropPath
        end repeat
        tell application "Emacs" to activate
      end open

      on open location this_URL
        do shell script "${emacsPkg}/bin/emacsclient -n " & quoted form of this_URL
        tell application "Emacs" to activate
      end open location
      ASEOF

      /usr/bin/osacompile -o compiled.app client.applescript
      cp -R compiled.app "$app"

      res="$app/Contents/Resources"
      cp ${emacsPkg}/Applications/Emacs.app/Contents/Resources/Emacs.icns \
        "$res/applet.icns"
      rm -f "$res/droplet.icns" "$res/droplet.rsrc" "$res/Assets.car"

      plist="$app/Contents/Info.plist"
      /usr/bin/plutil -replace CFBundleIconFile -string applet "$plist"
      /usr/bin/plutil -replace CFBundleIdentifier -string com.macuguita.emacs-client "$plist"
      /usr/bin/plutil -replace CFBundleName -string "Emacs Client" "$plist"
      /usr/bin/plutil -replace CFBundleDisplayName -string "Emacs Client" "$plist"
      /usr/bin/plutil -remove LSApplicationCategoryType "$plist" 2>/dev/null || true
      /usr/bin/plutil -insert LSApplicationCategoryType \
        -string public.app-category.productivity "$plist"
      /usr/bin/plutil -remove CFBundleDocumentTypes "$plist" 2>/dev/null || true
      /usr/bin/plutil -insert CFBundleDocumentTypes -xml '<array>
        <dict>
          <key>CFBundleTypeName</key><string>Text</string>
          <key>CFBundleTypeRole</key><string>Editor</string>
          <key>LSItemContentTypes</key><array>
            <string>public.text</string>
            <string>public.plain-text</string>
            <string>public.source-code</string>
            <string>public.script</string>
            <string>public.shell-script</string>
            <string>public.data</string>
          </array>
        </dict>
      </array>' "$plist"
      /usr/bin/plutil -remove CFBundleURLTypes "$plist" 2>/dev/null || true
      /usr/bin/plutil -insert CFBundleURLTypes -xml '<array>
        <dict>
          <key>CFBundleURLName</key><string>org-protocol</string>
          <key>CFBundleURLSchemes</key><array>
            <string>org-protocol</string>
          </array>
        </dict>
      </array>' "$plist"
    '';
  };
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

  # launchd agents get a minimal PATH (/usr/bin:/bin:...), which hides nix
  # packages from the daemon: dired fails on BSD ls (no --group-directories-first),
  # git/magit and friends misbehave. Give it the full system PATH.
  launchd.agents.emacs.config.EnvironmentVariables.PATH = lib.mkIf isDarwin (
    lib.concatStringsSep ":" [
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/run/current-system/sw/bin"
      "/run/current-system/sw/sbin"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ]
  );

  home.packages = lib.optionals isDarwin [ emacsClientApp ];

  xdg = {
    configFile."emacs" = {
      source = ./.;
      recursive = true;
    };
    mimeApps = lib.mkIf (!isDarwin) {
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

{ inputs, ... }:
{
  dendritic.homeModules."home/raul/default-apps" = # Set the default file handlers: LaunchServices on macOS, XDG mimeapps on Linux.
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (lib.attrsets) attrValues;
      inherit (lib.hm.dag) entryAfter;
      inherit (lib.lists) concatMap optionals;
      inherit (lib.modules) mkIf;
      inherit (lib.strings) concatMapStringsSep;

      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;

      data = import ./_associations.nix;

      # One LaunchServices entry per UTI (LSHandlerContentType) or filename
      # extension (LSHandlerContentTag); extensions without a registered UTI can
      # only be associated the second way.
      macEntry =
        app: kind: value:
        {
          LSHandlerRoleAll = app.bundleId;
          LSHandlerPreferredVersions.LSHandlerRoleAll = "-";
          LSHandlerModificationDate = 0;
        }
        // (
          if kind == "type" then
            { LSHandlerContentType = value; }
          else
            {
              LSHandlerContentTag = value;
              LSHandlerContentTagClass = "public.filename-extension";
            }
        );

      macEntries = concatMap (
        app:
        map (macEntry app "type") (app.macUtis or [ ])
        ++ map (macEntry app "tag") (app.macExtensions or [ ])
      ) (attrValues data.apps);

      macEntriesJson = pkgs.writeText "default-apps-launchservices.json" (builtins.toJSON macEntries);

      # App bundle paths, registered with lsregister so the handler bundle ids
      # resolve on a fresh install.
      macAppsJson = pkgs.writeText "default-apps-launchservices-apps.json" (
        builtins.toJSON (
          map (app: "${config.home.homeDirectory}/Applications/Home Manager Apps/${app.macApp}") (
            builtins.filter (app: app ? macApp) (attrValues data.apps)
          )
        )
      );

      # MIME definitions for the extensions shared-mime-info doesn't ship.
      mimeXml = pkgs.writeText "default-apps.xml" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        ${concatMapStringsSep "\n" (entry: ''
            <mime-type type="${entry.mimeType}">
              <comment>${entry.comment}</comment>
          ${concatMapStringsSep "\n" (ext: ''<glob pattern="*.${ext}"/>'') entry.extensions}
            </mime-type>
        '') data.linuxExtraMime}
        </mime-info>
      '';

      customMime = pkgs.runCommand "default-apps-mime" { } ''
        mkdir -p $out/share/mime/packages
        cp ${mimeXml} $out/share/mime/packages/default-apps.xml
      '';

      # Map each MIME type to the owning app's desktop entry.
      linuxDefaults = lib.foldl' (acc: app: acc // lib.genAttrs app.linux (_: app.desktop)) { } (
        attrValues data.apps
      );
    in
    {
      home.activation.setDefaultApps = mkIf isDarwin (
        entryAfter [ "writeBoundary" ] ''
          ${pkgs.python3}/bin/python3 ${./set-mac-handlers.py} \
            "com.apple.LaunchServices/com.apple.launchservices.secure" \
            "${macEntriesJson}" \
            "${config.xdg.stateHome}/default-apps/launchservices.json" \
            "${macAppsJson}"
        ''
      );

      home.packages = optionals isLinux [ customMime ];

      xdg.mimeApps = mkIf isLinux {
        enable = true;
        defaultApplications = linuxDefaults;
      };
    };
}

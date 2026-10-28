{ inputs, ... }:
let
  data = import ./_associations.nix;
in
{
  dendritic.homeModules."home/raul/default-apps" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib.attrsets) attrValues;
      inherit (lib.lists) optionals;
      inherit (lib.modules) mkIf;
      inherit (lib.strings) concatMapStringsSep;

      isLinux = pkgs.stdenv.hostPlatform.isLinux;

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
      linuxDefaults = lib.foldl' (acc: app: acc // lib.genAttrs (app.linux or [ ]) (_: app.desktop)) { } (
        attrValues data.apps
      );
    in
    {
      packages = optionals isLinux [ customMime ];

      xdg.mime-apps.default-applications = mkIf isLinux linuxDefaults;
    };

  dendritic.darwinModules."darwin/default-apps" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib.attrsets) attrValues;
      inherit (lib.lists) concatMap;

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

      macAppsJson = pkgs.writeText "default-apps-launchservices-apps.json" (
        builtins.toJSON (
          map (app: "${config.users.users.raul.home}/Applications/Nix User Apps/${app.macApp}") (
            builtins.filter (app: app ? macApp) (attrValues data.apps)
          )
        )
      );
    in
    {
      system.activationScripts.postActivation.text = ''
        /usr/bin/sudo --set-home --user ${config.system.primaryUser} \
          ${pkgs.python3}/bin/python3 ${./set-mac-handlers.py} \
          "com.apple.LaunchServices/com.apple.launchservices.secure" \
          "${macEntriesJson}" \
          "${config.users.users.raul.home}/.local/state/default-apps/launchservices.json" \
          "${macAppsJson}"
      '';
    };
}
